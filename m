Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3AWAsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:48:39 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:51605 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3AWAsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:48:36 -0500
X-ASG-Debug-ID: 1358902115-0421b532750a720001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Tue, 22 Jan 2013 19:48:33 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20130123004833.GA30526@shiny>
X-ASG-Orig-Subj: [GIT PULL] Btrfs fixes
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1358902115
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.120626
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My for-linus branch has our batch of btrfs fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

We've been hammering away at a crc corruption as well, which I was
really hoping to get into this pull.  It isn't nailed down yet, but we
were finally able to get a solid way to reproduce.  The only good
news is it isn't a recent regression.

The most important batch of fixes in here come from Ilya.  They address
a regression Liu Bo found in the balance ioctls for pausing and resuming
a running balance across drives.

Josef's orphan truncate patch fixes an obscure corruption we'd see
during xfstests.

Arne's patches address problems with subvolume quotas.  If the user
destroys quota groups incorrectly the FS will refuse to mount.

The rest are smaller fixes and plugs for memory leaks.

Ilya Dryomov (6) commits (+94/-32):
    Btrfs: reorder locks and sanity checks in btrfs_ioctl_defrag (+9/-8)
    Btrfs: fix "mutually exclusive op is running" error code (+4/-4)
    Btrfs: fix a regression in balance usage filter (+8/-1)
    Btrfs: bring back balance pause/resume logic (+71/-17)
    Btrfs: fix unlock order in btrfs_ioctl_rm_dev (+1/-1)
    Btrfs: fix unlock order in btrfs_ioctl_resize (+1/-1)

Liu Bo (4) commits (+18/-7):
    Btrfs: fix a bug when llseek for delalloc bytes behind prealloc extents (+14/-6)
    Btrfs: let allocation start from the right raid type (+1/-1)
    Btrfs: reset path lock state to zero (+2/-0)
    Btrfs: fix off-by-one in lseek (+1/-0)

Miao Xie (4) commits (+15/-7):
    Btrfs: fix missing write access release in btrfs_ioctl_resize() (+1/-0)
    Btrfs: do not delete a subvolume which is in a R/O subvolume (+5/-5)
    Btrfs: fix resize a readonly device (+4/-2)
    Btrfs: disable qgroup id 0 (+5/-0)

Arne Jansen (2) commits (+19/-1):
    Btrfs: prevent qgroup destroy when there are still relations (+12/-1)
    Btrfs: ignore orphan qgroup relations (+7/-0)

Josef Bacik (2) commits (+39/-16):
    Btrfs: add orphan before truncating pagecache (+38/-15)
    Btrfs: set flushing if we're limited flushing (+1/-1)

Zach Brown (1) commits (+1/-0):
    btrfs: fix btrfs_cont_expand() freeing IS_ERR em

Lukas Czerner (1) commits (+1/-1):
    btrfs: get the device in write mode when deleting it

Eric Sandeen (1) commits (+14/-3):
    btrfs: update timestamps on truncate()

Tsutomu Itoh (1) commits (+3/-1):
    Btrfs: fix memory leak in name_cache_insert()

Total: (22) commits

 fs/btrfs/extent-tree.c |   6 ++-
 fs/btrfs/file.c        |  10 ++--
 fs/btrfs/inode.c       |  82 +++++++++++++++++++++++--------
 fs/btrfs/ioctl.c       | 129 +++++++++++++++++++++++++++++++++++--------------
 fs/btrfs/qgroup.c      |  20 +++++++-
 fs/btrfs/send.c        |   4 +-
 fs/btrfs/volumes.c     |  21 ++++++--
 7 files changed, 204 insertions(+), 68 deletions(-)
