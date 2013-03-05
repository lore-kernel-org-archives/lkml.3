Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab3CENzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 08:55:47 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48575 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab3CENzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 08:55:46 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, ebiederm@xmission.com, nzimmer@sgi.com,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] procfs: missing rcu unlock in proc_reg_release
Date: Tue,  5 Mar 2013 08:55:47 -0500
Message-Id: <1362491747-25610-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "procfs: improve scaling in proc" forgot to unlock rcu read lock
if the proc file didn't have ops struct.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/proc/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 6cccc4d..d9292ac 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -400,6 +400,7 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	rcu_read_lock();
 	fops = rcu_dereference(pde->proc_fops);
 	if (!fops) {
+		rcu_read_unlock();
 		/*
 		 * Can't simply exit, __fput() will think that everything is OK,
 		 * and move on to freeing struct file. remove_proc_entry() will
-- 
1.8.1.4

