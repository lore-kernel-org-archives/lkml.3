Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbaELNXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:23:47 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:38044 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbaELNXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:23:46 -0400
X-Nat-Received: from [202.181.97.72]:12962 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1399901016.5559
To: miklos@szeredi.hu, jmorris@namei.org, john.johansen@canonical.com,
        selinux@tycho.nsa.gov
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH (for 3.15) 2/5] SELinux: Handle the rename flags.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201404242020.FJD18726.LOOJtOQMFVFFSH@I-love.SAKURA.ne.jp>
	<201405012058.JEG30273.LJFHOOFMtOFQVS@I-love.SAKURA.ne.jp>
	<201405051449.GAE81222.LOOFtFJMQFOSVH@I-love.SAKURA.ne.jp>
	<201405120053.HJG95368.HFLQSFMOOtOVJF@I-love.SAKURA.ne.jp>
	<201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
In-Reply-To: <201405122221.DBG43278.LOQtJSOFVFFOHM@I-love.SAKURA.ne.jp>
Message-Id: <201405122223.BDG04510.tVFSQJOMFOOHFL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 12 May 2014 22:23:36 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 12052014 #7893288, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 39e4aea3b42b53d844c87f6c7e54f0a9837ebbfd Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 12 May 2014 21:34:36 +0900
Subject: [PATCH (for 3.15) 2/5] SELinux: Handle the rename flags.

For SELinux, the RENAME_EXCHANGE flag means "check permissions with
reversed arguments".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/selinux/hooks.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 33f6f56..64d8497 100644
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
1.7.1
