Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab3JDWlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:41:53 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:34812 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3JDWlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:41:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
Date: Fri, 04 Oct 2013 15:41:25 -0700
In-Reply-To: <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	(Miklos Szeredi's message of "Thu, 15 Aug 2013 11:29:01 +0200")
Message-ID: <87li281wx6.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX189TVy6A3xdJcHgx3vU1gutgNNuzal6hqg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0020]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is an attempt to address two problems:
1) Not all modifications to the filesystems happen through the vfs and
   since the vfs can not cope with a mount point being unlinked or
   renamed filesystems whose modifications that do not come through the
   vfs are required to lie.

2) Through an oversight it is now possible for one unprivileged user to
   mount something on another unprivileged users dentry and make it
   impossible for the other user to unlink or rename that dentry.

It is now technically possible to easily lift the restriction on
unlinking and renaming files with mount points on them, with a
corresponding reduction in complexity of the vfs semantics and a small
code side reduction.

After thinking about it removing the restrictions on mount points
appears safe, because it is just plain dumb to have a mount point
in a directory that is not restricted to root only modifications.

This is a change in user visible semantics, so I want to be very careful
about this.  Are there any reasons to not make this change?

All of this happens under a full pile of vfs locks so this shouldn't
affect the vfs scalabilitiy work that is on-going.

Eric W. Biederman (3):
      vfs: Keep a list of mounts on a mount point
      vfs: Add a function to lazily unmount all mounts from any dentry.
      vfs: Lazily remove mounts on unlinked files and directories.

 fs/afs/dir.c           |    3 +-
 fs/dcache.c            |   80 ++++++++++++++++++++----------------------------
 fs/fuse/dir.c          |    3 +-
 fs/gfs2/dentry.c       |    4 +--
 fs/mount.h             |    3 ++
 fs/namei.c             |   31 ++++++------------
 fs/namespace.c         |   29 +++++++++++++++++
 fs/nfs/dir.c           |    5 +--
 fs/sysfs/dir.c         |    9 +-----
 include/linux/dcache.h |    3 +-
 10 files changed, 83 insertions(+), 87 deletions(-)
