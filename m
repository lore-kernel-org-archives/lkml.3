Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaFDXWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaFDXWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 172/228] genirq: Provide irq_force_affinity fallback for non-SMP
Date: Wed,  4 Jun 2014 16:23:21 -0700
Message-Id: <20140604232353.550893788@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/interrupt.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -271,6 +271,11 @@ static inline int irq_set_affinity(unsig
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


