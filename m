Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab3HNHT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:19:29 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31684 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757886Ab3HNHT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:19:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Arpit Goel <B44344@freescale.com>
To: <linux@arm.linux.org.uk>, <takata@linux-m32r.org>, <philb@gnu.org>,
        <geert@linux-m68k.org>
CC: <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
        <linux390@de.ibm.com>, <davem@davemloft.net>,
        <rob.herring@calxeda.com>, <arnd@arndb.de>, <swarren@nvidia.com>,
        <john.stultz@linaro.org>, <jesper.nilsson@axis.com>,
        <gregkh@linuxfoundation.org>, <sam@ravnborg.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-m32r@ml.linux-m32r.org>, <linux-m32r-ja@ml.linux-m32r.org>,
        <linux-m68k@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, <mattw@codeaurora.org>, <timur@tabi.org>,
        <sboyd@codeaurora.org>, <akpm@linux-foundation.org>,
        Arpit Goel <B44344@freescale.com>
Subject: [PATCH v2 2/2] Convert PowerPC macro spin_event_timeout() to architecture independent macro
Date: Wed, 14 Aug 2013 12:33:55 +0530
Message-ID: <1376463835-13040-3-git-send-email-B44344@freescale.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376463835-13040-1-git-send-email-B44344@freescale.com>
References: <1376463835-13040-1-git-send-email-B44344@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ports PowerPC implementation of spin_event_timeout() for generic
use. Architecture specific implementation can be added to asm/delay.h, which
will override the generic linux implementation.

Signed-off-by: Arpit Goel <B44344@freescale.com>
---
 include/linux/delay.h | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index a6ecb34..2ee7fa8 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -52,4 +52,44 @@ static inline void ssleep(unsigned int seconds)
 	msleep(seconds * 1000);
 }
 
+#ifndef spin_event_timeout
+/**
+ * spin_event_timeout - spin until a condition gets true or a timeout elapses
+ * @condition: a C expression to evalate
+ * @timeout: timeout, in microseconds
+ * @delay: the number of microseconds to delay between each evaluation of
+ *         @condition
+ *
+ * The process spins until the condition evaluates to true (non-zero) or the
+ * timeout elapses.  The return value of this macro is the value of
+ * @condition when the loop terminates. This allows you to determine the cause
+ * of the loop terminates.  If the return value is zero, then you know a
+ * timeout has occurred.
+ *
+ * This primary purpose of this macro is to poll on a hardware register
+ * until a status bit changes.  The timeout ensures that the loop still
+ * terminates even if the bit never changes.  The delay is for devices that
+ * need a delay in between successive reads.
+ *
+ * gcc will optimize out the if-statement if @delay is a constant.
+ *
+ * This is copied from PowerPC based spin_event_timeout() implementation
+ * and modified for generic usecase.
+ */
+#define spin_event_timeout(condition, timeout, delay)		\
+({								\
+	typeof(condition) __ret;				\
+	unsigned long __loops = usecs_to_jiffies(timeout);	\
+	unsigned long __start = jiffies;			\
+	while (!(__ret = (condition)) &&			\
+		time_before(jiffies, __start + __loops + 1))	\
+		if (delay)					\
+			udelay(delay);				\
+		else						\
+			schedule();				\
+	if (!__ret)						\
+		__ret = (condition);				\
+	__ret;							\
+})
+#endif
 #endif /* defined(_LINUX_DELAY_H) */
-- 
1.8.1.4


