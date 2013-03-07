Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3CGHVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 02:21:35 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60682 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab3CGHVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 02:21:34 -0500
Subject: [PATCH linux-next] procfs: fix rcu-lock/unlock in proc_reg_open() and
 proc_reg_release()
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nathan Zimmer <nzimmer@sgi.com>
Date: Thu, 07 Mar 2013 11:21:29 +0400
Message-ID: <20130307072129.17719.81530.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix for a21813be23329e2788164eab532e79cb0e513cfc (linux-next)
"procfs: improve scaling in proc"

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 6cccc4d..073846c 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -352,7 +352,7 @@ static int proc_reg_open(struct inode *inode, struct file *file)
 	atomic_inc(&pde->pde_users);
 	open = fops->open;
 	release = fops->release;
-	rcu_read_lock();
+	rcu_read_unlock();
 
 	if (open)
 		rv = open(inode, file);
@@ -400,6 +400,7 @@ static int proc_reg_release(struct inode *inode, struct file *file)
 	rcu_read_lock();
 	fops = rcu_dereference(pde->proc_fops);
 	if (!fops) {
+		rcu_read_unlock();
 		/*
 		 * Can't simply exit, __fput() will think that everything is OK,
 		 * and move on to freeing struct file. remove_proc_entry() will

