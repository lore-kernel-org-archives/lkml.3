Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbaF3KcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:32:20 -0400
Received: from ozlabs.org ([103.22.144.67]:37895 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbaF3KbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:31:10 -0400
Date: Mon, 30 Jun 2014 20:30:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Hannes Reinecke <hare@suse.de>, Vladimir Davydov <vdavydov@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Regression in 3.15 on POWER8 with multipath SCSI
Message-ID: <20140630103058.GA17747@iris.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a machine on which 3.15 usually fails to boot, and 3.14 boots
every time.  The machine is a POWER8 2-socket server with 20 cores
(thus 160 CPUs), 128GB of RAM, and 7 SCSI disks connected via a
hardware-RAID-capable adapter which appears as two IPR controllers
which are both connected to each disk.  I am booting from a disk that
has Fedora 20 installed on it.

After over two weeks of bisections, I can finally point to the commits
that cause the problems.  The culprits are:

3e9f1be1 dm mpath: remove process_queued_ios()
e8099177 dm mpath: push back requests instead of queueing
bcccff93 kobject: don't block for each kobject_uevent

The interesting thing is that neither e8099177 nor bcccff93 cause
failures on their own, but with both commits in there are failures
where the system will fail to find /home on some occasions.

With 3e9f1be1 included, the system appears to be prone to a deadlock
condition which typically causes the boot process to hang with this
message showing:

A start job is running for Monitoring of LVM2 mirror...rogress polling

(with a [***     ] thing before it where the asterisks move back and
forth).

If I revert 63d832c3 ("dm mpath: really fix lockdep warning") ,
4cdd2ad7 ("dm mpath: fix lock order inconsistency in
multipath_ioctl"), 3e9f1be1 and bcccff93, in that order, I get a
kernel that will boot every time.  The first two are later commits
that fix some problems with 3e9f1be1 (though not the problems I am
seeing).

Can anyone see any reason why e8099177 and bcccff93 would interfere
with each other?

-----

The rest of this email outlines the steps I took to identify these
commits.  I first identified that 3.15-rc1 would sometimes fail to
boot, and did a bisection between 3.15 and 3.15-rc1 that identified
3e9f1be1 as the bad commit.  I then took 3.15-rc8 and reverted
63d832c3, 4cdd2ad7 and 3e9f1be1, and tested that.  That didn't fail
with the deadlock, but was still prone to fail to find root or /home
and thus fail to boot.

To debug this second problem, I tested the commit before Linus merged
in the dm modifications: 3f583bc2 ("Merge tag 'iommu-updates-v3.15' of
git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu").  It was
fine.  I then took 0596661f ("dm cache: fix a lock-inversion"), which
is what Linus merged in during the 3.15 merge window, reverted
3e9f1be1 on top of that, and tested that, and it also was fine.
The ID of that revert commit was 9cfd3fe8 (that ID doesn't appear in
any public tree, of course).

Interestingly, the merge of 3f583bc2 with 9cfd3fe8 was bad.  To track
this down, I first rebased the commits from the dm-3.15-changes branch
except for 3e9f1be1 on top of 3f583bc2, and bisected between 3f583bc2
and the tip of that branch.  That bisection pointed to e8099177.  I
tried reverting that from 3.15-rc8, but it doesn't revert cleanly, and
was too complex for me to work out how to manually revert it.

Next I did a git bisection between 3.14 and 3f583bc2, merging in
9cfd3fe8 at each point before testing.  That identified bcccff93 as
the first bad commit, and indeed 3.15 with bcccff93 reverted was not
prone to failing to find root or /home.

Paul.
