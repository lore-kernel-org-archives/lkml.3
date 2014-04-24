Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbaDXLYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:24:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:25182 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaDXLYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:24:21 -0400
X-Nat-Received: from [202.181.97.72]:45582 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1398338657.13287
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        miklos@szeredi.hu
Subject: [PATCH (for 3.15) 3/5] AppArmor: Handle the rename flags.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
	<53523D16.9020101@gmail.com>
	<201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
	<CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
	<201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
In-Reply-To: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
Message-Id: <201404242024.EEI28166.MVOHFtJFFSOLQO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 24 Apr 2014 20:24:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24042014 #7805673, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3bce55d24ef7a55613d748182aac1f3986c144da Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 24 Apr 2014 20:07:58 +0900
Subject: [PATCH (for 3.15) 3/5] AppArmor: Handle the rename flags.

For AppArmor, the RENAME_EXCHANGE flag means "check permissions with
reversed arguments". Future patches will stop re-calculating pathnames.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/apparmor/lsm.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index c0b4366..b04218a 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -332,6 +332,7 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
 					  old_dentry->d_inode->i_mode
 		};
 
+retry:
 		error = aa_path_perm(OP_RENAME_SRC, profile, &old_path, 0,
 				     MAY_READ | AA_MAY_META_READ | MAY_WRITE |
 				     AA_MAY_META_WRITE | AA_MAY_DELETE,
@@ -340,6 +341,17 @@ static int apparmor_path_rename(struct path *old_dir, struct dentry *old_dentry,
 			error = aa_path_perm(OP_RENAME_DEST, profile, &new_path,
 					     0, MAY_WRITE | AA_MAY_META_WRITE |
 					     AA_MAY_CREATE, &cond);
+		if (!error && (flags & RENAME_EXCHANGE)) {
+			/* Cross rename requires both inodes to exist. */
+			old_path.mnt = new_dir->mnt;
+			old_path.dentry = new_dentry;
+			new_path.mnt = old_dir->mnt;
+			new_path.dentry = old_dentry;
+			cond.uid = new_dentry->d_inode->i_uid;
+			cond.mode = new_dentry->d_inode->i_mode;
+			flags = 0;
+			goto retry;
+		}
 
 	}
 	return error;
-- 
1.7.9.5
