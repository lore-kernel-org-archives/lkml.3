Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaDXLX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:23:28 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:28025 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbaDXLXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:23:25 -0400
X-Nat-Received: from [202.181.97.72]:38702 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1398338601.9748
To: linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        miklos@szeredi.hu
Subject: [PATCH (for 3.15) 2/5] SELinux: Handle the rename flags.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
	<53523D16.9020101@gmail.com>
	<201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
	<CAJfpeguus=9GuvEKua4U-VF=nonzLgU5VFHqt8xRTTYU7RL-zQ@mail.gmail.com>
	<201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
In-Reply-To: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
Message-Id: <201404242023.IFI57350.VFFSOMOQOFtJLH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 24 Apr 2014 20:23:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24042014 #7805673, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d095d350fda528b993226752102caeda2d95af46 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 24 Apr 2014 20:06:45 +0900
Subject: [PATCH (for 3.15) 2/5] SELinux: Handle the rename flags.

For SELinux, the RENAME_EXCHANGE flag means "check permissions with
reversed arguments".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/selinux/hooks.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index d4913d1..b2847cb 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2752,7 +2752,10 @@ static int selinux_inode_rename(struct inode *old_inode, struct dentry *old_dent
 				struct inode *new_inode, struct dentry *new_dentry,
 				unsigned int flags)
 {
-	return may_rename(old_inode, old_dentry, new_inode, new_dentry);
+	int err = may_rename(old_inode, old_dentry, new_inode, new_dentry);
+	if (!err && (flags & RENAME_EXCHANGE))
+		err = may_rename(new_inode, new_dentry, old_inode, old_dentry);
+	return err;
 }
 
 static int selinux_inode_readlink(struct dentry *dentry)
-- 
1.7.9.5
