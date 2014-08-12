Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaHLMqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:46:22 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46146 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaHLMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:46:20 -0400
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: gong.chen@linux.intel.com, andi@firstfloor.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, MCE: support raising machine check poll for software MCE injection in IRQ context
Date: Tue, 12 Aug 2014 20:45:44 +0800
Message-Id: <1407847544-13224-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present MCJ_NMI_BROADCAST(same for raise_local) supports both raise_exception()
and raise_poll(), but MCJ_IRQ_BROADCAST only supports raise_exception(). The goal
of this patch is that MCJ_IRQ_BROADCAST can support raising machine check poll.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 5ac2d1f..97e4f7a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -99,11 +99,13 @@ static void mce_irq_ipi(void *info)
 	int cpu = smp_processor_id();
 	struct mce *m = &__get_cpu_var(injectm);
 
-	if (cpumask_test_cpu(cpu, mce_inject_cpumask) &&
-			m->inject_flags & MCJ_EXCEPTION) {
-		cpumask_clear_cpu(cpu, mce_inject_cpumask);
+	if (!cpumask_test_cpu(cpu, mce_inject_cpumask))
+		return;
+	cpumask_clear_cpu(cpu, mce_inject_cpumask);
+	if (m->inject_flags & MCJ_EXCEPTION)
 		raise_exception(m, NULL);
-	}
+	else if (m->status)
+		raise_poll(m);
 }
 
 /* Inject mce on current CPU */
-- 
1.7.10.4

