Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaBYJeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:34:07 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:34270 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaBYJeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:34:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
Date: Tue, 25 Feb 2014 01:33:49 -0800
In-Reply-To: <87ob28kqks.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Sat, 15 Feb 2014 13:34:43 -0800")
Message-ID: <874n3n7czm.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19yVKHefqHphHMu1yN5y4hpHHKoCZMN6BU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0023]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 0/12] Detaching mounts on unlink (for 3.15 v2)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After an interesting set of review comments this patchset is back with
very modest changes.

I spent quite a bit of timing trying to see if I could understand and
possibly reproduce the poor issues reported by Fengguang Wu.  Ultimately
I wound up running dbench and will-it-scale/unlink2 on a ramfs
filesystem with a fixed clock speed so I could get enough jitter out of
the benchmark numbers to that I could make some sense of the results.
On my bitty box I could not find any problems with dbench,
will-it-scale/unlink2 I measured a small loss of performance because
detach_mounts was silly and took the lock before testing d_mountpoint.
With that fixed I can not see any performance differences between my
code and unmodified 3.14-rcX.  Nor can I see any reason to suspect
there might be.  The core vfs changes are quite modest.

Now I did not benchark d_invalidate, but check_submounts_and_drop is
what any sane distributed filesystem is doing today, and as discussed in
the review the actual changes are very modest even in d_invalidate.

In the first round of this patchset the semantics of dropping mounts on
unlink were agreed to so long as we preserve the current semantics in
a single mount namespace.

The are really only two changes in this version of the patchset.
1) is_local_mountpoint now returns a bool.
2) detach_mounts was simplified/cleanup and made more performant.

In net this should result in a kernel that is more comprehensible and
maintainble as well as fixing some possible mount leaks, and removing
the possibility of DOS attacks from evily placed mount points, in other
mount namespaces.

For people who prefer git trees these changes are available at:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git vfs-detach-mounts3

Eric W. Biederman (12):
      vfs: Document the effect of d_revalidate on d_find_alias
      vfs: More precise tests in d_invalidate
      vfs: Don't allow overwriting mounts in the current mount namespace
      vfs: Keep a list of mounts on a mount point
      vfs: factor out lookup_mountpoint from new_mountpoint
      vfs: Add a function to lazily unmount all mounts from any dentry.
      vfs: Lazily remove mounts on unlinked files and directories.
      vfs: Remove unnecessary calls of check_submounts_and_drop
      vfs: Merge check_submounts_and_drop and d_invalidate
      vfs: Make d_invalidate return void
      vfs: Remove d_drop calls from d_revalidate implementations
      proc: Update proc_flush_task_mnt to use d_invalidate

 fs/afs/dir.c           |    5 --
 fs/btrfs/ioctl.c       |    5 +--
 fs/ceph/dir.c          |    1 -
 fs/cifs/readdir.c      |    6 +--
 fs/dcache.c            |  140 +++++++++++++++++-------------------------------
 fs/fuse/dir.c          |    7 +--
 fs/gfs2/dentry.c       |    3 -
 fs/kernfs/dir.c        |   11 ----
 fs/mount.h             |   20 +++++++
 fs/namei.c             |   28 ++++++----
 fs/namespace.c         |   87 +++++++++++++++++++++++++++++-
 fs/nfs/dir.c           |    7 +--
 fs/proc/base.c         |   10 +---
 fs/proc/fd.c           |    2 -
 include/linux/dcache.h |    3 +-
 15 files changed, 178 insertions(+), 157 deletions(-)

Eric
