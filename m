Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab3F1BYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:24:06 -0400
Received: from intranet.asianux.com ([58.214.24.6]:57809 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3F1BYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:24:02 -0400
X-Spam-Score: -100.9
Message-ID: <51CCE57C.5000901@asianux.com>
Date: Fri, 28 Jun 2013 09:23:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paul.mckenney@linaro.org, josh@joshtriplett.org,
        Ben Hutchings <bhutchings@solarflare.com>, decot@googlers.com
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] include/linux/interrupt.h: add dummy irq_set_irq_wake() for
 "!GENERIC_HARDIRQS"
References: <51C8F685.6000209@asianux.com> <20130625064832.GA4999@osiris> <51C94599.1020707@asianux.com> <20130625090928.GA8981@osiris> <51CBA6B6.1010809@asianux.com> <20130627081845.GA3824@osiris> <51CC046F.2050009@asianux.com>
In-Reply-To: <51CC046F.2050009@asianux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since irq_set_irq_wake() has already declared in header file, when
GENERIC_HARDIRQS enabled.

Recommend to define the dummy one for GENERIC_HARDIRQS disabled, and
also let the other related "static inline" functions are independent
from GENERIC_HARDIRQS.

So can avoid the compiling error below, and also let the code simpler
and clearer.

The related compiling error (ARCH=s390 allmodconfig):

  sound/soc/codecs/wm0010.c: In function ‘wm0010_spi_probe’:
  sound/soc/codecs/wm0010.c:976:2: error: implicit declaration of function ‘irq_set_irq_wake’ [-Werror=implicit-function-declaration]


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/interrupt.h |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5fa5afe..1a311e0 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -344,16 +344,6 @@ static inline void enable_irq_lockdep_irqrestore(unsigned int irq, unsigned long
 /* IRQ wakeup (PM) control: */
 extern int irq_set_irq_wake(unsigned int irq, unsigned int on);
 
-static inline int enable_irq_wake(unsigned int irq)
-{
-	return irq_set_irq_wake(irq, 1);
-}
-
-static inline int disable_irq_wake(unsigned int irq)
-{
-	return irq_set_irq_wake(irq, 0);
-}
-
 #else /* !CONFIG_GENERIC_HARDIRQS */
 /*
  * NOTE: non-genirq architectures, if they want to support the lock
@@ -370,16 +360,23 @@ static inline int disable_irq_wake(unsigned int irq)
 						enable_irq(irq)
 # endif
 
-static inline int enable_irq_wake(unsigned int irq)
+/* IRQ wakeup (PM) control: */
+static inline int irq_set_irq_wake(unsigned int irq, unsigned int on)
 {
 	return 0;
 }
 
+#endif /* CONFIG_GENERIC_HARDIRQS */
+
+static inline int enable_irq_wake(unsigned int irq)
+{
+	return irq_set_irq_wake(irq, 1);
+}
+
 static inline int disable_irq_wake(unsigned int irq)
 {
-	return 0;
+	return irq_set_irq_wake(irq, 0);
 }
-#endif /* CONFIG_GENERIC_HARDIRQS */
 
 
 #ifdef CONFIG_IRQ_FORCED_THREADING
-- 
1.7.7.6
