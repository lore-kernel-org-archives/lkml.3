Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbaFIIzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:55:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58583 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932231AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 113/146] genirq: Provide irq_force_affinity fallback for non-SMP
Date: Mon,  9 Jun 2014 10:50:48 +0200
Message-Id: <f2f4ab7e067f06212627d282611130b8ebb2e4a8.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/interrupt.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e7777c940972..623ab2d787d9 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -267,6 +267,11 @@ static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
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
1.9.3

