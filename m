Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab3JOUPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:15:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59146 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122Ab3JOUPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:15:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87a9ioo37a.fsf_-_@xmission.com>
	<20131007043919.GB10284@mail.hallyn.com> <87vc191sf2.fsf@xmission.com>
	<CALCETrUaubASZyeoNZcYxn5-GJO68=Ng=GYmas7K_OBsjM7f0Q@mail.gmail.com>
	<87d2ngyb02.fsf@xmission.com>
	<20131008160601.GJ14242@tucsk.piliscsaba.szeredi.hu>
	<CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
	<20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
	<87li23trll.fsf@tw-ebiederman.twitter.com>
	<CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
	<87vc15mjuw.fsf@xmission.com>
	<CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
	<87iox38fkv.fsf@xmission.com> <87d2nb8dxy.fsf@xmission.com>
Date: Tue, 15 Oct 2013 13:15:41 -0700
In-Reply-To: <87d2nb8dxy.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 11 Oct 2013 18:39:53 -0700")
Message-ID: <87iowyxpci.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+bLZHJ2N2sIbvGXUjZWJuHbJsm463DKNk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0573]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 0/4] vfs: Detach mounts on unlink
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset is an addresses two problems:
1) Not all modifications to the filesystems happen through the vfs and
   since the vfs can not cope with a mount point being unlinked or
   renamed filesystems whose modifications that do not come through the
   vfs are required to lie.

2) Through an oversight it is now possible for one unprivileged user to
   mount something on another unprivileged users dentry and make it
   impossible for the other user to unlink or rename that dentry.

It is now technically possible to easily lift the restriction on
unlinking and renaming files with mount points on them, with a
corresponding reduction in complexity of the vfs semantics.

After review it seems that there are no objections to this approach as
long as we retain the -EBUSY semantics for rmdir, unlink, and rename of
mount points in the current mount namespace.  The first patch in this
series now adds those local mount namespace restrictions.

All of the review comments should now be addressed and folded in, and
I have take a careful look and it appears what I have is now correct
and complete.  So I am posting this for one last round of review.

Al if you want to take this through the vfs tree, point me at a branch
and I will give you versions of these patches that apply cleanly there.
Otherwise I will push these patches to my userns tree as soon as all of
these patches pass review.

Eric W. Biederman (4):
      vfs: Don't allow overwriting mounts in the current mount namespace
      vfs: Keep a list of mounts on a mount point
      vfs: Add a function to lazily unmount all mounts from any dentry. v3
      vfs: Lazily remove mounts on unlinked files and directories. v2

 fs/afs/dir.c           |    3 +-
 fs/dcache.c            |   80 ++++++++++++++++++++----------------------------
 fs/fuse/dir.c          |    3 +-
 fs/gfs2/dentry.c       |    4 +--
 fs/mount.h             |    3 ++
 fs/namei.c             |   55 +++++++++++++++++++++------------
 fs/namespace.c         |   30 ++++++++++++++++++
 fs/nfs/dir.c           |    5 +--
 fs/sysfs/dir.c         |    9 +-----
 include/linux/dcache.h |    3 +-
 10 files changed, 108 insertions(+), 87 deletions(-)
