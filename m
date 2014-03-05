Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaCEDr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:47:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49117 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaCEDrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:47:55 -0500
Date: Wed, 5 Mar 2014 03:47:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCHES][RFC][CFT] scalability fixes for shitloads of mounts
Message-ID: <20140305034751.GW18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Looks like people had finally started to use setups with serious
amounts of mounts.  And that has uncovered some downright embarrassing
bottlenecks.  Below is more or less the catch from the last couple of weeks.
Kudos to Stephen and Jeremy for testing and profiling that stuff.

	1) percpu_alloc()/percpu_free() doesn't scale well, to put it
_very_ mildly.  The time complexity of N small allocations is O(N^2).
Yes, really.  Freeing is the same.  Fortunately, there are several
low-hanging fruits in there and dealing with those helps quite a bit.
First of all, the information about splitup of chunk into areas is
kept in the following form: an array of +-length.  Sign is used to
distinguish free from in-use.  It's much better to use offset | (0 or 1),
with the lowest bit indicating free vs. in-use.  For starters, that
allows freeing to use binary search in that array.  Another thing is
that we can easily maintain the "I know that first N areas are all
in use" hint, so that sequential allocation does *not* have to add up
the lengths of already allocated areas just to find the candidate
offset.  It could be improved further, but these two already kick
the damn thing from the top of profiles on "lots of mount/umount"
loads.  Note that all this work is done with IRQs disabled, so in
mainline excessive time spent there easily leads to softlockups.
Another benefitiary is aio - io_setup(2) does a couple of 4-byte
allocations (alloc_vfsmnt() does one 8-byte percpu_alloc()), so a load
with a bunch of aio contexts created in parallel on the same box suffers
from the same bottleneck.  That's first couple of patches (1 and 2 out
of 5)
	2) propagate_mnt() tried to save the complexity in the case
when some nodes in propagation graph are rejected, since they do not
contain the counterparts of our mountpoint dentry.  It's much simpler
to create a copy for each node, set propagation between them parallel
to that on what they are mounted on and then kill the ones that shouldn't
survive.  IIRC, we recognized the problem, but decided to go for simpler
logics unless and until somebody runs into situations where it creates
a lot of copies only to tear almost all of them down.  Well, it turns
out that it's *very* easy to trigger the worst-case behaviour - have
N mount --bind create O(N^2) vfsmounts and tear down all but O(N) of them.
Just
	mkdir /tmp/blah
	mount --bind /tmp/blah /tmp/blah
	mount --make-shared /tmp/blah
	cd /tmp/blah
	touch foo
	for i in `seq 4000`; do touch $i; mount --bind foo $i; done
will step into it - that loop adds 4000 vfsmounts, but allocates about
two million more of them, never seen by userland and freed in the
same mount(2) call that has allocated them.
	Turns out, it *is* possible to avoid the excessive allocations,
with a slightly different order of creating the copies and a bit of a trick
to find which copy will end up the master of given one.  See the commit
message for more details.  That's patch 3 of 5.
	3) reading /proc/mounts end-to-end (e.g. cat /proc/mounts) turns
out to be (embarrassingly) quadratic by the size of said /proc/mounts.
The reason is that read() will need to find out the next vfsmount to
return, and that's done by walking the list.  From the beginning.  Even
if no changes have happened, which we *can* detect - namespace has event
counter.  Solution is trivial - cache that + the last vfsmount we'd been
looking at for that one + the index it had been at.  And if the event
counter matches, have m_start() skip the search from the beginning of
the list.  In fact, all we really need is a couple of cases - last index
we looked at and last index plus one.  Taking care of that reduces the
time needed to read the damn thing from O(mounts^2) to O(mounts).  The
same goes for /proc/self/mountinfo, and e.g. umount(8) does read it
end-to-end.  So does the Lennart's horror.  Without that patch (and with
previous stupidities taken care of) we had seq_start_list() fairly high
in the profiles; with it it's pretty much gone.  That's patch 4 of 5.
	4) mount hash is ridiculously small.  256 hash chains is not
enough when you might get thousands of elements in that hash and when
hash lookups happen on fairly hot paths.  Solved by switch to
alloc_large_system_hash(), hopefully with sane order (less than it used
to be way back).  That may need tuning, but I think that this variant is
tolerable.

	Folks, please review.  It survives pretty heavy testing and most
of that stuff is pretty straightforward, but I would rather have it
discussed on fsdevel before I push that pile to Linus.  Patches follow;
if there are any questions and/or objections - please, yell.
