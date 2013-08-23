Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3HWLMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:12:45 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab3HWLMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:12:44 -0400
From: Richard Weinberger <richard@nod.at>
To: steffen.klassert@secunet.com
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, gang.chen@asianux.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] kernel/padata.c: Register hotcpu notifier after initialization
Date: Fri, 23 Aug 2013 13:12:33 +0200
Message-Id: <1377256353-7979-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

padata_cpu_callback() takes pinst->lock, to avoid taking
an uninitialized lock, register the notifier after it's
initialization.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 kernel/padata.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 072f4ee..8e1bf9d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1086,18 +1086,18 @@ struct padata_instance *padata_alloc(struct workqueue_struct *wq,
 
 	pinst->flags = 0;
 
-#ifdef CONFIG_HOTPLUG_CPU
-	pinst->cpu_notifier.notifier_call = padata_cpu_callback;
-	pinst->cpu_notifier.priority = 0;
-	register_hotcpu_notifier(&pinst->cpu_notifier);
-#endif
-
 	put_online_cpus();
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&pinst->cpumask_change_notifier);
 	kobject_init(&pinst->kobj, &padata_attr_type);
 	mutex_init(&pinst->lock);
 
+#ifdef CONFIG_HOTPLUG_CPU
+	pinst->cpu_notifier.notifier_call = padata_cpu_callback;
+	pinst->cpu_notifier.priority = 0;
+	register_hotcpu_notifier(&pinst->cpu_notifier);
+#endif
+
 	return pinst;
 
 err_free_masks:
-- 
1.8.3.1

