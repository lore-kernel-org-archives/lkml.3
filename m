Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759853Ab3JOUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:16:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39728 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759830Ab3JOUQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:16:56 -0400
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
	<87iowyxpci.fsf_-_@xmission.com>
Date: Tue, 15 Oct 2013 13:16:48 -0700
In-Reply-To: <87iowyxpci.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 15 Oct 2013 13:15:41 -0700")
Message-ID: <87d2n6xpan.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18g7dSXWleV5cz/4ILvbFr2naHep5VyXd4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4099]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 1/4] vfs: Don't allow overwriting mounts in the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In preparation for allowing mountpoints to be renamed and unlinked
in remote filesystems and in other mount namespaces test if on a dentry
there is a mount in the local mount namespace before allowing it to
be renamed or unlinked.

The primary motivation here are old versions of fusermount unmount
which is not safe if the a path can be renamed or unlinked while it is
verifying the mount is safe to unmount.  More recent versions are simpler
and safer by simply using UMOUNT_NOFOLLOW when unmounting a mount
in a directory owned by an arbitrary user.

Miklos Szeredi <miklos@szeredi.hu> reports this is approach is good
enough to remove concerns about new kernels mixed with old versions
of fusermount.

A secondary motivation for restrictions here is that it removing empty
directories that have non-empty mount points on them appears to
violate the rule that rmdir can not remove empty directories.  As
Linus Torvalds pointed out this is useful for programs (like git) that
test if a directory is empty with rmdir.

Therefore this patch arranges to enforce the existing mount point
semantics for local mount namespace.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namei.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 645268f23eb6..df7bd6e9c7b6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3547,6 +3547,20 @@ void dentry_unhash(struct dentry *dentry)
 	spin_unlock(&dentry->d_lock);
 }
 
+static bool covered(struct vfsmount *mnt, struct dentry *dentry)
+{
+	/* test to see if a dentry is covered with a mount in
+	 * the current mount namespace.
+	 */
+	bool is_covered;
+
+	rcu_read_lock();
+	is_covered = d_mountpoint(dentry) && __lookup_mnt(mnt, dentry, 1);
+	rcu_read_unlock();
+
+	return is_covered;
+}
+
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int error = may_delete(dir, dentry, 1);
@@ -3622,6 +3636,9 @@ retry:
 		error = -ENOENT;
 		goto exit3;
 	}
+	error = -EBUSY;
+	if (covered(nd.path.mnt, dentry))
+		goto exit3;
 	error = security_path_rmdir(&nd.path, dentry);
 	if (error)
 		goto exit3;
@@ -3716,6 +3733,9 @@ retry:
 		inode = dentry->d_inode;
 		if (!inode)
 			goto slashes;
+		error = -EBUSY;
+		if (covered(nd.path.mnt, dentry))
+			goto exit2;
 		ihold(inode);
 		error = security_path_unlink(&nd.path, dentry);
 		if (error)
@@ -4164,6 +4184,11 @@ retry:
 	error = -ENOTEMPTY;
 	if (new_dentry == trap)
 		goto exit5;
+	error = -EBUSY;
+	if (covered(oldnd.path.mnt, old_dentry))
+		goto exit5;
+	if (covered(newnd.path.mnt, new_dentry))
+		goto exit5;
 
 	error = security_path_rename(&oldnd.path, old_dentry,
 				     &newnd.path, new_dentry);
-- 
1.7.5.4

