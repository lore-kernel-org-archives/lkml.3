Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965359Ab3BMSEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:04:36 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52267 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965246Ab3BMSDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:03:00 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:08 -0800
Message-Id: <1360777934-5663-79-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18rc2rw0nbxF5QvyHI25KqrRPNC3jqS2H0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 79/85] cifs: Convert struct tcon_link to use a kuid.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/connect.c  |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index aea1eec..7993a7a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -837,7 +837,7 @@ struct cifs_tcon {
  */
 struct tcon_link {
 	struct rb_node		tl_rbnode;
-	uid_t			tl_uid;
+	kuid_t			tl_uid;
 	unsigned long		tl_flags;
 #define TCON_LINK_MASTER	0
 #define TCON_LINK_PENDING	1
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 17c3643..5411694 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3919,7 +3919,7 @@ cifs_set_vol_auth(struct smb_vol *vol, struct cifs_ses *ses)
 }
 
 static struct cifs_tcon *
-cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
+cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 {
 	int rc;
 	struct cifs_tcon *master_tcon = cifs_sb_master_tcon(cifs_sb);
@@ -3989,7 +3989,7 @@ cifs_sb_tcon_pending_wait(void *unused)
 
 /* find and return a tlink with given uid */
 static struct tcon_link *
-tlink_rb_search(struct rb_root *root, uid_t uid)
+tlink_rb_search(struct rb_root *root, kuid_t uid)
 {
 	struct rb_node *node = root->rb_node;
 	struct tcon_link *tlink;
@@ -3997,9 +3997,9 @@ tlink_rb_search(struct rb_root *root, uid_t uid)
 	while (node) {
 		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
 
-		if (tlink->tl_uid > uid)
+		if (uid_gt(tlink->tl_uid, uid))
 			node = node->rb_left;
-		else if (tlink->tl_uid < uid)
+		else if (uid_lt(tlink->tl_uid, uid))
 			node = node->rb_right;
 		else
 			return tlink;
@@ -4018,7 +4018,7 @@ tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink)
 		tlink = rb_entry(*new, struct tcon_link, tl_rbnode);
 		parent = *new;
 
-		if (tlink->tl_uid > new_tlink->tl_uid)
+		if (uid_gt(tlink->tl_uid, new_tlink->tl_uid))
 			new = &((*new)->rb_left);
 		else
 			new = &((*new)->rb_right);
@@ -4048,7 +4048,7 @@ struct tcon_link *
 cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 {
 	int ret;
-	uid_t fsuid = current_fsuid();
+	kuid_t fsuid = current_fsuid();
 	struct tcon_link *tlink, *newtlink;
 
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
-- 
1.7.5.4

