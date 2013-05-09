Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab3EIFDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:03:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60408 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3EIFDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:03:45 -0400
Date: Thu, 9 May 2013 06:03:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC] next cycle fun: ->release() API change
Message-ID: <20130509050343.GD25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This is going to be a major PITA, but surprisingly it seems to be
more or less feasible.  Background: ->release() method in file_operations
has wrong prototype.
	0.96a: void (*release)(struct inode *, struct file *) introduced
as abstraction for minix_release (same type).  Called by sys_close().
	0.97.1: call site moved to close_fp() (modern filp_close())
	2.0.14: we'd got void {__fput,fput}(struct inode *, struct file *)
as wrappers for ->release(), still called by close_fp()
	2.1.31: mistake - ->release() started to return int, along with
fput()/__fput().  Practically all instances always return 0.  The main
reason seems to have been NFS - it didn't get ->release() until the next
version, but that happened very soon.
	2.1.45pre4: fput() and __fput() are switched to taking just the
struct file * (happened while introducing dcache).
	2.1.118: ->flush() introduced; close_fp() calls it before
fput() and uses its return value.  fput() and __fput() are returning
void now; ->release() is _still_ returning int.  NFS has promptly added
->flush() and in 2.2.early dropped ->release().

	From that point on the return value of ->release() had been completely
lost.  Most of the instances are still returning 0 (some - via several layers
of methods in subsystems/subsubsystems/drivers/etc.).  Exceptions tend to
point to confusion in the best case, outright broken drivers in the worst.
And people _do_ get confused by that thing.  A couple of months ago one
such case happened, getting two replies: mine along the lines of "->release()
type is a mistake, too painful to fix by now" and Linus' "we should just make
->release return void", both with similar explanations of the reasons
why void would be the right return type.

	OK, so I decided to check just how painful would it be to fix that.
Diff had grown well past anything even remotely reasonable for a single
commit (443 files changed, 814 insertions(+), 1843 deletions(-) for the
last snapshot I've taken, just before going to LSFS; about one third of
megabyte worth of diff, roughly a quarter of drivers/* remaining to be
converted).  And, naturally enough, a bunch of bugfixes kept calving off
from it.  That was a flagday approach - ->release() switched to
void (*release)(struct file *) (struct inode * is both redundant and
unused by the majority of instances; ones that do use it can simply use
file_inode(file)).  Originally I planned to ask Linus to merge that monster
as an after-rc1 special, but it was obviously far too large for that.

	The next plan was to make the thing splittable.  I.e. start with
adding replacement method (I ended up calling it ->close(), suggestions for
better names are welcome), teach the (very few) call sites of ->release()
to try that if available, then convert the users of widely used instances
to new method (seq_release and friends, mostly), then go driver by driver
converting them.  The current variant (still growing - most of the drivers/
and arch/ is yet to be converted) is in vfs.git#close and at the moment it's
at 45 commits, with 618 files changed, 1428 insertions(+), 1872 deletions(-),
Amount of churn is greater that way, of course ;-/ The final commit once it's
done will be removal of ->release().

	As far as I can see, it's survivable, it kills a lot of boilerplate
code and result makes more sense.  So it might make sense to do that
conversion.  Sure, it hurts binary modules.  So what?

	_If_ we go for that, the question is how to do the merge.  Even split
into smaller chunks (and even if I get it finished by Monday), it obviously
will not be in shape for just-after-rc1 one-time merge.  AFAICS, there are
two variants:
	1) beginning of that series gets pushed into mainline - new method
introduction + seq_file-related tree-wide stuff.  The rest sits in a branch
in vfs.git.  Maintainers of other trees are welcome to cherry-pick the stuff
relevant to their trees whenever they wish and tell me to drop the duplicate
from that queue.  Or do the conversion themselves in whatever way they prefer,
and tell me to drop my variant.  Or just tell me which commits they might
want, so that I would put them into a never-rebased branch for them to pull,
etc.
	2) beginning of that series is left in vfs.git in never-rebased
branch, with folks being welcome to merge it into their trees.  The rest
as in (1).

	I thought of doing it the way I'd done kernel_thread transition, but
I don't think I can pull that off - there are far more affected trees than
twenty-odd involved there, and it had been hard enough even back then ;-/
Hell knows...

	Any comments and suggestions are welcome.
