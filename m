Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966101AbaFQVsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53938 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966078AbaFQVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 094/212] genirq: Provide irq_force_affinity fallback for non-SMP
Date: Tue, 17 Jun 2014 14:43:08 -0700
Message-Id: <1403041506-13646-95-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 4c88d7f9b0d5fb0588c3386be62115cc2eaa8f9f upstream.

Patch 01f8fa4f01d "genirq: Allow forcing cpu affinity of interrupts" added
an irq_force_affinity() function, and 30ccf03b4a6 "clocksource: Exynos_mct:
Use irq_force_affinity() in cpu bringup" subsequently uses it. However, the
driver can be used with CONFIG_SMP disabled, but the function declaration
is only available for CONFIG_SMP, leading to this build error:

drivers/clocksource/exynos_mct.c:431:3: error: implicit declaration of function 'irq_force_affinity' [-Werror=implicit-function-declaration]
   irq_force_affinity(mct_irqs[MCT_L0_IRQ + cpu], cpumask_of(cpu));

This patch introduces a dummy helper function for the non-SMP case
that always returns success, to get rid of the build error.
Since the patches causing the problem are marked for stable backports,
this one should be as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Link: http://lkml.kernel.org/r/5619084.0zmrrIUZLV@wuerfel
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/interrupt.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index c88e76c..402db89 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -266,6 +266,11 @@ static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
 	return -EINVAL;
 }
 
+static inline int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
+{
+	return 0;
+}
+
 static inline int irq_can_set_affinity(unsigned int irq)
 {
 	return 0;
-- 
1.9.1

