Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaBOVfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 16:35:01 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51937 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBOVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 16:34:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com>
Date: Sat, 15 Feb 2014 13:34:43 -0800
In-Reply-To: <87li281wx6.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Fri, 04 Oct 2013 15:41:25 -0700")
Message-ID: <87ob28kqks.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/H97Gj2ok0VDFsxfmEp8R7MBdOPWoBi0g=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0417]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 0/11] Detaching mounts on unlink
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The last round of this patchset the semantics of dropping mounts on
unlink were agreed upon so long as we preserve the current semantics in
a single mount namespace.

There are two big changes with this version of the patchset.
1) The test for a mount in the current mount namespace has been
   rewritten so that it is actually correct and is now a drop in
   replacement for d_mountpoint.  Removing the need for code changes
   that could cause unitended regressions.

2) This work has been comprehensivly extend to d_revalidate and
   d_invalidate allowing some long standing bugs to be fixed at the end
   of this patch series.

In net this should result in a kernel that is more comprehensible and
maintainble as well as fixing some possible mount leaks, and removing
the possibility of DOS attacks from evily placed mount points, in other
mount namespaces.

Eric W. Biederman (11):
      vfs: Document the effect of d_revalidate on d_find_alias
      vfs: More precise tests in d_invalidate
      vfs: Don't allow overwriting mounts in the current mount namespace
      vfs: Keep a list of mounts on a mount point
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
 fs/mount.h             |   13 +++++
 fs/namei.c             |   28 ++++++----
 fs/namespace.c         |   80 +++++++++++++++++++++++++++
 fs/nfs/dir.c           |    7 +--
 fs/proc/base.c         |   10 +---
 fs/proc/fd.c           |    2 -
 include/linux/dcache.h |    3 +-
 15 files changed, 167 insertions(+), 154 deletions(-)

Eric
