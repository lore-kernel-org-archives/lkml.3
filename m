Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaCONid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 09:38:33 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33804 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbaCONib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 09:38:31 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <joe@perches.com>, <gang.chen@asianux.com>,
        <gerald.schaefer@de.ibm.com>, <linux390@de.ibm.com>,
        <heiko.carstens@de.ibm.com>, <schwidefsky@de.ibm.com>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH] s390: correct misuses of module_put in appldata_generic_handler.
Date: Sat, 15 Mar 2014 21:35:40 +0800
Message-Id: <1394890540-2435-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

correct misuses of module_put in  appldata_generic_handler

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/s390/appldata/appldata_base.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 47c8630..683e0282 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -343,7 +343,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
 		// protect work queue callback
 		if (!try_module_get(ops->owner)) {
 			mutex_unlock(&appldata_ops_mutex);
-			module_put(ops->owner);
 			return -ENODEV;
 		}
 		ops->callback(ops->data);	// init record
@@ -354,7 +353,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
 		if (rc != 0) {
 			pr_err("Starting the data collection for %s "
 			       "failed with rc=%d\n", ops->name, rc);
-			module_put(ops->owner);
 		} else
 			ops->active = 1;
 	} else if ((buf[0] == '0') && (ops->active == 1)) {
@@ -365,7 +363,6 @@ appldata_generic_handler(struct ctl_table *ctl, int write,
 		if (rc != 0)
 			pr_err("Stopping the data collection for %s "
 			       "failed with rc=%d\n", ops->name, rc);
-		module_put(ops->owner);
 	}
 	mutex_unlock(&appldata_ops_mutex);
 out:
-- 
1.8.1.2

