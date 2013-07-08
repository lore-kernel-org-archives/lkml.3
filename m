Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab3GHIvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:51:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:12534 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3GHIvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:51:19 -0400
X-Spam-Score: -100.8
Message-ID: <51DA7D50.8010209@asianux.com>
Date: Mon, 08 Jul 2013 16:50:24 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>, lig.fnst@cn.fujitsu.com,
        chuansheng.liu@intel.com, Wang YanQing <udknight@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/smp.c: free related resources when failure occurs
 in hotplug_cfd()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When failure occurs in hotplug_cfd(), need release related resources,
or will cause memory leak.

Also beautify the related code.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/smp.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 02a885d..c264623 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -45,15 +45,20 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
-				cpu_to_node(cpu)))
+		if (!zalloc_cpumask_var_node(&cfd->cpumask,
+						GFP_KERNEL, cpu_to_node(cpu)))
 			return notifier_from_errno(-ENOMEM);
-		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
-				cpu_to_node(cpu)))
+
+		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi,
+						GFP_KERNEL, cpu_to_node(cpu))) {
+			free_cpumask_var(cfd->cpumask);
 			return notifier_from_errno(-ENOMEM);
+		}
+
 		cfd->csd = alloc_percpu(struct call_single_data);
 		if (!cfd->csd) {
 			free_cpumask_var(cfd->cpumask);
+			free_cpumask_var(cfd->cpumask_ipi);
 			return notifier_from_errno(-ENOMEM);
 		}
 		break;
-- 
1.7.7.6
