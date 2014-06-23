Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaFWNEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:04:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36985 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbaFWNEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 49/93] genirq: Provide irq_force_affinity fallback for non-SMP
Date: Mon, 23 Jun 2014 14:02:28 +0100
Message-Id: <1403528592-2163-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/interrupt.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e8401d092732..6de0f2c14ec0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -308,6 +308,11 @@ static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
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

