Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbaLJP5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:57:10 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:56981 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401AbaLJPxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:15 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 04/12] powerpc: use {cpu|node}mask pr_cont and seq output functions
Date: Wed, 10 Dec 2014 10:52:46 -0500
Message-Id: <1418226774-30215-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing user of cpu{mask|list}_scnprintf() and
node{mask|list}_scnprintf() which use them just to printk or
seq_printf() the resulting buffer to use the following functions
instead respectively.

* For printk: cpu{mask|list}_pr_cont() and node{mask|list}_pr_cont().

* For seq_file: seq_cpumask[_list]() and seq_nodemask[_list]().

Because these conversions usually break up a single output function
call into multiple, the reduction is LOC isn't too big but it removes
unnecessary complexity and/or arbitrary limit on the length printed.

This patch is dependent on the previous patch ("bitmap, cpumask,
nodemask: implement pr_cont variants of formatting functions") which
is planned to go through -mm.  It'd be the easiest to route this
together.  If this should go through the subsystem tree, please wait
till the forementioned patch is merged to mainline.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/sysdev/xics/ics-opal.c | 7 +++----
 arch/powerpc/sysdev/xics/ics-rtas.c | 8 +++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/sysdev/xics/ics-opal.c b/arch/powerpc/sysdev/xics/ics-opal.c
index 4ba554e..0c200e8 100644
--- a/arch/powerpc/sysdev/xics/ics-opal.c
+++ b/arch/powerpc/sysdev/xics/ics-opal.c
@@ -131,10 +131,9 @@ static int ics_opal_set_affinity(struct irq_data *d,
 
 	wanted_server = xics_get_irq_server(d->irq, cpumask, 1);
 	if (wanted_server < 0) {
-		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
-		pr_warning("%s: No online cpus in the mask %s for irq %d\n",
-			   __func__, cpulist, d->irq);
+		pr_warning("%s: No online cpus in the mask ", __func__);
+		cpumask_pr_cont(cpumask);
+		pr_cont(" for irq %d\n", d->irq);
 		return -1;
 	}
 	server = ics_opal_mangle_server(wanted_server);
diff --git a/arch/powerpc/sysdev/xics/ics-rtas.c b/arch/powerpc/sysdev/xics/ics-rtas.c
index bc81335b..1e2f562 100644
--- a/arch/powerpc/sysdev/xics/ics-rtas.c
+++ b/arch/powerpc/sysdev/xics/ics-rtas.c
@@ -140,11 +140,9 @@ static int ics_rtas_set_affinity(struct irq_data *d,
 
 	irq_server = xics_get_irq_server(d->irq, cpumask, 1);
 	if (irq_server == -1) {
-		char cpulist[128];
-		cpumask_scnprintf(cpulist, sizeof(cpulist), cpumask);
-		printk(KERN_WARNING
-			"%s: No online cpus in the mask %s for irq %d\n",
-			__func__, cpulist, d->irq);
+		pr_warning("%s: No online cpus in the mask ", __func__);
+		cpumask_pr_cont(cpumask);
+		pr_cont(" for irq %d\n", d->irq);
 		return -1;
 	}
 
-- 
2.1.0

