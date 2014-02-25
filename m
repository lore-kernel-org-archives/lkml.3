Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBYJhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:37:03 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:35094 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaBYJg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:36:58 -0500
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
	<874n3n7czm.fsf_-_@xmission.com>
Date: Tue, 25 Feb 2014 01:36:50 -0800
In-Reply-To: <874n3n7czm.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 25 Feb 2014 01:33:49 -0800")
Message-ID: <87ha7n5ya5.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+V8HoZrBdcHEraZ4fNVKdD2VD84UiQo1Y=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0129]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH 04/12] vfs: Keep a list of mounts on a mount point
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To spot any possible problems call BUG if a mountpoint
is put when it's list of mounts is not empty.

Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>
---
 fs/mount.h     |    2 ++
 fs/namespace.c |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index 18511835dc28..5375da0dc570 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -21,6 +21,7 @@ struct mnt_pcp {
 struct mountpoint {
 	struct list_head m_hash;
 	struct dentry *m_dentry;
+	struct list_head m_list;
 	int m_count;
 };
 
@@ -48,6 +49,7 @@ struct mount {
 	struct mount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	struct mountpoint *mnt_mp;	/* where is it mounted */
+	struct list_head mnt_mp_list;	/* list mounts with the same mountpoint */
 #ifdef CONFIG_FSNOTIFY
 	struct hlist_head mnt_fsnotify_marks;
 	__u32 mnt_fsnotify_mask;
diff --git a/fs/namespace.c b/fs/namespace.c
index abe2f56efaea..32d380eabdac 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -195,6 +195,7 @@ static struct mount *alloc_vfsmnt(const char *name)
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
+		INIT_LIST_HEAD(&mnt->mnt_mp_list);
 #ifdef CONFIG_FSNOTIFY
 		INIT_HLIST_HEAD(&mnt->mnt_fsnotify_marks);
 #endif
@@ -695,6 +696,7 @@ static struct mountpoint *new_mountpoint(struct dentry *dentry)
 	mp->m_dentry = dentry;
 	mp->m_count = 1;
 	list_add(&mp->m_hash, chain);
+	INIT_LIST_HEAD(&mp->m_list);
 	return mp;
 }
 
@@ -702,6 +704,7 @@ static void put_mountpoint(struct mountpoint *mp)
 {
 	if (!--mp->m_count) {
 		struct dentry *dentry = mp->m_dentry;
+		BUG_ON(!list_empty(&mp->m_list));
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags &= ~DCACHE_MOUNTED;
 		spin_unlock(&dentry->d_lock);
@@ -748,6 +751,7 @@ static void detach_mnt(struct mount *mnt, struct path *old_path)
 	mnt->mnt_mountpoint = mnt->mnt.mnt_root;
 	list_del_init(&mnt->mnt_child);
 	list_del_init(&mnt->mnt_hash);
+	list_del_init(&mnt->mnt_mp_list);
 	put_mountpoint(mnt->mnt_mp);
 	mnt->mnt_mp = NULL;
 }
@@ -764,6 +768,7 @@ void mnt_set_mountpoint(struct mount *mnt,
 	child_mnt->mnt_mountpoint = dget(mp->m_dentry);
 	child_mnt->mnt_parent = mnt;
 	child_mnt->mnt_mp = mp;
+	list_add_tail(&child_mnt->mnt_mp_list, &mp->m_list);
 }
 
 /*
@@ -1246,6 +1251,7 @@ void umount_tree(struct mount *mnt, int how)
 			p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
 		list_del_init(&p->mnt_child);
 		if (mnt_has_parent(p)) {
+			list_del_init(&p->mnt_mp_list);
 			put_mountpoint(p->mnt_mp);
 			/* move the reference to mountpoint into ->mnt_ex_mountpoint */
 			p->mnt_ex_mountpoint.dentry = p->mnt_mountpoint;
-- 
1.7.5.4
