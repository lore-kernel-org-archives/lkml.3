Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515AbaELNYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:24:36 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:19570 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289AbaELNYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:24:35 -0400
X-Nat-Received: from [202.181.97.72]:57148 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1399901065.6206
To: miklos@szeredi.hu, jmorris@namei.org, john.johansen@canonical.com,
        selinux@tycho.nsa.gov
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH (for 3.15) 3/5] AppArmor: Handle the rename flags.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
	<201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>
	<201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>
	<201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
In-Reply-To: <201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
Message-Id: <201405122224.BJB51546.VJOtMSQOLOFFHF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 12 May 2014 22:24:25 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 12052014 #7893288, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 819e94ae3a6d9235196d137a39afa4e0bbd79770 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 12 May 2014 21:54:05 +0900
Subject: [PATCH (for 3.15) 3/5] AppArmor: Handle the rename flags.

For AppArmor, the RENAME_EXCHANGE flag means "check permissions with
reversed arguments" and "distinguish condition of source and target".
Future patches will stop re-calculating pathnames.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/apparmor/lsm.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index c0b4366..9f21296 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -331,7 +331,14 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
 		struct path_cond cond = { old_dentry->d_inode->i_uid,
 					  old_dentry->d_inode->i_mode
 		};
+		struct path_cond new_cond = cond;
 
+		if (flags & RENAME_EXCHANGE) {
+			/* Cross rename requires both inodes to exist. */
+			new_cond.uid = new_dentry->d_inode->i_uid;
+			new_cond.mode = new_dentry->d_inode->i_mode;
+		}
+retry:
 		error = aa_path_perm(OP_RENAME_SRC, profile, &old_path, 0,
 				     MAY_READ | AA_MAY_META_READ | MAY_WRITE |
 				     AA_MAY_META_WRITE | AA_MAY_DELETE,
@@ -339,7 +346,18 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
 		if (!error)
 			error = aa_path_perm(OP_RENAME_DEST, profile, &new_path,
 					     0, MAY_WRITE | AA_MAY_META_WRITE |
-					     AA_MAY_CREATE, &cond);
+					     AA_MAY_CREATE, &new_cond);
+		if (!error && (flags & RENAME_EXCHANGE)) {
+			struct path tmp_path = new_path;
+			struct path_cond tmp_cond = new_cond;
+
+			new_path = old_path;
+			old_path = tmp_path;
+			new_cond = cond;
+			cond = tmp_cond;
+			flags = 0;
+			goto retry;
+		}
 
 	}
 	return error;
-- 
1.7.1
