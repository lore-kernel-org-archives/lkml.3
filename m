Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab3JECfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 22:35:03 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34496 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3JECfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 22:35:01 -0400
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
	<87li281wx6.fsf_-_@xmission.com>
Date: Fri, 04 Oct 2013 19:34:49 -0700
In-Reply-To: <87li281wx6.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Fri, 04 Oct 2013 15:41:25 -0700")
Message-ID: <87a9ioo37a.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/7w52f2bl+gVasbqTcZdV7iUygF+3KkFQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0039]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: [RFC][PATCH 4/3] vfs: Allow rmdir to remove mounts in all but the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Programs have been known to test for empty directories by attempting
to remove them.  To keep from violating the principle of least
surprise don't let directories the caller can see with someting
mounted on them be deleted.

With a little luck this may prevent commands stupid commands
like rm -rf from eating your system.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namei.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b18b017c946b..b9cae480ac27 100644
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
@@ -3619,6 +3633,9 @@ retry:
 		error = -ENOENT;
 		goto exit3;
 	}
+	error = -EBUSY;
+	if (covered(nd.path.mnt, dentry))
+		goto exit3;
 	error = security_path_rmdir(&nd.path, dentry);
 	if (error)
 		goto exit3;
@@ -4155,6 +4172,10 @@ retry:
 	error = -ENOTEMPTY;
 	if (new_dentry == trap)
 		goto exit5;
+	error = -EBUSY;
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode) &&
+	    covered(newnd.path.mnt, new_dentry))
+		goto exit5;
 
 	error = security_path_rename(&oldnd.path, old_dentry,
 				     &newnd.path, new_dentry);
-- 
1.7.5.4

