Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaEFWqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:46:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEFWqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:46:39 -0400
Date: Tue, 6 May 2014 15:46:02 -0700
From: tip-bot for Arnd Bergmann <tipbot@zytor.com>
Message-ID: <tip-4c88d7f9b0d5fb0588c3386be62115cc2eaa8f9f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, hpa@zytor.com,
        mingo@kernel.org, k.kozlowski@samsung.com, tglx@linutronix.de,
        kgene.kim@samsung.com
Reply-To: mingo@kernel.org, hpa@zytor.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, k.kozlowski@samsung.com,
        tglx@linutronix.de, kgene.kim@samsung.com
In-Reply-To: <5619084.0zmrrIUZLV@wuerfel>
References: <5619084.0zmrrIUZLV@wuerfel>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq:
  Provide irq_force_affinity fallback for non-SMP
Git-Commit-ID: 4c88d7f9b0d5fb0588c3386be62115cc2eaa8f9f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c88d7f9b0d5fb0588c3386be62115cc2eaa8f9f
Gitweb:     http://git.kernel.org/tip/4c88d7f9b0d5fb0588c3386be62115cc2eaa8f9f
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Wed, 23 Apr 2014 14:49:17 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 7 May 2014 00:42:09 +0200

genirq: Provide irq_force_affinity fallback for non-SMP

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/5619084.0zmrrIUZLV@wuerfel
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 97ac926..051c850 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -272,6 +272,11 @@ static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
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
