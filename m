Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaDWMtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:49:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:54644 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbaDWMta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:49:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH] provide irq_force_affinity fallback for non-SMP
Date: Wed, 23 Apr 2014 14:49:17 +0200
Message-ID: <5619084.0zmrrIUZLV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:I557attGddVVe9xKYzXGWmqbf83J6b4G8UePEWaMFl2
 QpyUgexwuR2HDlPGpXzoPqEEcHeoW63ftFYGKuJ8g7O9zlVNoM
 P9olpZj9EKV7tRMb8DP4fBBVgxyEyLeyN0A4VPdzy19aNVbdk4
 GZrYoY0ZleVdJscB+P/QQELhLQkLScca5rT/zjo5b3KWAtfmS/
 y8sI8yIfvIOrygyQejNwnaJ5o4TggDi6qx507xBkZ6GpIH8USZ
 o5UVOlAl7x8L3CbUxPuDpAsi5MmOPYCE8J9gEB0INecptuSr1n
 mJnZs8CgiEMJouynKydXQMOg/TUvSIT/Mk9CWpasQfxd8YVaIH
 6+fdT+lplqY4rpz+2F5w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 0e6b23f..b72a643 100644
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

