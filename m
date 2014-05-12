Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbaELNZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:25:22 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:35420 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249AbaELNZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:25:20 -0400
X-Nat-Received: from [202.181.97.72]:61257 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1399901110.24526
To: miklos@szeredi.hu, jmorris@namei.org, john.johansen@canonical.com,
        selinux@tycho.nsa.gov
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH (for 3.15) 4/5] TOMOYO: Handle the rename flags.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
	<201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>
	<201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>
	<201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
In-Reply-To: <201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
Message-Id: <201405122225.BED35990.LFQHFOFVJMStOO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 12 May 2014 22:25:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 12052014 #7893288, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b53f2feeb60fb11a0c2d3ee3021a057bd6d71eeb Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 12 May 2014 22:00:53 +0900
Subject: [PATCH (for 3.15) 4/5] TOMOYO: Handle the rename flags.

For TOMOYO, the RENAME_EXCHANGE flag means "check exchange permission once
rather than checking rename permission twice". This patch adds exchange
permission to TOMOYO.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/common.c |    1 +
 security/tomoyo/common.h |    5 ++++-
 security/tomoyo/file.c   |   10 +++++++++-
 security/tomoyo/tomoyo.c |    4 +++-
 security/tomoyo/util.c   |    1 +
 5 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 283862a..7892485 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -36,6 +36,7 @@ const char * const tomoyo_mac_keywords[TOMOYO_MAX_MAC_INDEX
 	[TOMOYO_MAC_FILE_MKCHAR]     = "mkchar",
 	[TOMOYO_MAC_FILE_LINK]       = "link",
 	[TOMOYO_MAC_FILE_RENAME]     = "rename",
+	[TOMOYO_MAC_FILE_EXCHANGE]   = "exchange",
 	[TOMOYO_MAC_FILE_CHMOD]      = "chmod",
 	[TOMOYO_MAC_FILE_CHOWN]      = "chown",
 	[TOMOYO_MAC_FILE_CHGRP]      = "chgrp",
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index b897d48..a167c5f 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -276,6 +276,7 @@ enum tomoyo_network_acl_index {
 enum tomoyo_path2_acl_index {
 	TOMOYO_TYPE_LINK,
 	TOMOYO_TYPE_RENAME,
+	TOMOYO_TYPE_EXCHANGE,
 	TOMOYO_TYPE_PIVOT_ROOT,
 	TOMOYO_MAX_PATH2_OPERATION
 };
@@ -335,6 +336,7 @@ enum tomoyo_mac_index {
 	TOMOYO_MAC_FILE_MKCHAR,
 	TOMOYO_MAC_FILE_LINK,
 	TOMOYO_MAC_FILE_RENAME,
+	TOMOYO_MAC_FILE_EXCHANGE,
 	TOMOYO_MAC_FILE_CHMOD,
 	TOMOYO_MAC_FILE_CHOWN,
 	TOMOYO_MAC_FILE_CHGRP,
@@ -730,7 +732,8 @@ struct tomoyo_mkdev_acl {
 };
 
 /*
- * Structure for "file rename", "file link" and "file pivot_root" directive.
+ * Structure for "file rename", "file exchange", "file link" and
+ * "file pivot_root" directive.
  */
 struct tomoyo_path2_acl {
 	struct tomoyo_acl_info head; /* type = TOMOYO_TYPE_PATH2_ACL */
diff --git a/security/tomoyo/file.c b/security/tomoyo/file.c
index 4003907..5f10b76 100644
--- a/security/tomoyo/file.c
+++ b/security/tomoyo/file.c
@@ -38,6 +38,7 @@ const u8 tomoyo_pnnn2mac[TOMOYO_MAX_MKDEV_OPERATION] = {
 const u8 tomoyo_pp2mac[TOMOYO_MAX_PATH2_OPERATION] = {
 	[TOMOYO_TYPE_LINK]       = TOMOYO_MAC_FILE_LINK,
 	[TOMOYO_TYPE_RENAME]     = TOMOYO_MAC_FILE_RENAME,
+	[TOMOYO_TYPE_EXCHANGE]   = TOMOYO_MAC_FILE_EXCHANGE,
 	[TOMOYO_TYPE_PIVOT_ROOT] = TOMOYO_MAC_FILE_PIVOT_ROOT,
 };
 
@@ -874,7 +875,7 @@ int tomoyo_mkdev_perm(const u8 operation, struct path *path,
 }
 
 /**
- * tomoyo_path2_perm - Check permission for "rename", "link" and "pivot_root".
+ * tomoyo_path2_perm - Check permission for "rename", "exchange", "link" and "pivot_root".
  *
  * @operation: Type of operation.
  * @path1:      Pointer to "struct path".
@@ -916,6 +917,13 @@ int tomoyo_path2_perm(const u8 operation, struct path *path1,
 		tomoyo_add_slash(&buf1);
 		tomoyo_add_slash(&buf2);
 		break;
+	case TOMOYO_TYPE_EXCHANGE:
+		/* Cross rename requires both inodes to exist. */
+		if (S_ISDIR(path1->dentry->d_inode->i_mode))
+			tomoyo_add_slash(&buf1);
+		if (S_ISDIR(path2->dentry->d_inode->i_mode))
+			tomoyo_add_slash(&buf2);
+		break;
 	}
 	r.obj = &obj;
 	r.param_type = TOMOYO_TYPE_PATH2_ACL;
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index ac7dd97..aa36259 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -299,7 +299,9 @@ static int tomoyo_path_rename(struct path *old_parent,
 {
 	struct path path1 = { old_parent->mnt, old_dentry };
 	struct path path2 = { new_parent->mnt, new_dentry };
-	return tomoyo_path2_perm(TOMOYO_TYPE_RENAME, &path1, &path2);
+	return tomoyo_path2_perm((flags & RENAME_EXCHANGE) ?
+				 TOMOYO_TYPE_EXCHANGE : TOMOYO_TYPE_RENAME,
+				 &path1, &path2);
 }
 
 /**
diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
index 2952ba5..649794b 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -34,6 +34,7 @@ const u8 tomoyo_index2category[TOMOYO_MAX_MAC_INDEX] = {
 	[TOMOYO_MAC_FILE_MKCHAR]     = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_LINK]       = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_RENAME]     = TOMOYO_MAC_CATEGORY_FILE,
+	[TOMOYO_MAC_FILE_EXCHANGE]   = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_CHMOD]      = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_CHOWN]      = TOMOYO_MAC_CATEGORY_FILE,
 	[TOMOYO_MAC_FILE_CHGRP]      = TOMOYO_MAC_CATEGORY_FILE,
-- 
1.7.1
