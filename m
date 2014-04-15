Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaDOSQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:16:15 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48999 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaDOSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:16:13 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: iwmmxt: explicitly check for supported architectures
Date: Tue, 15 Apr 2014 20:15:59 +0200
Message-Id: <1397585763-23482-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <20140414151236.75f8816d@skate>
 <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iwmmxt.S requires special treatment of coprocessor access registers
for PJ4 and XScale-based CPUs. It only checks for CPU_PJ4 and drops
down to XScale-based treatment on all other architectures.

As some PJ4B also come with iWMMXt and also need PJ4 treatment,
rework the corresponding preprocessor directives to explicitly
check for supported architectures and fail on unsupported ones.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Chao Xie <xiechao.mail@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/kernel/iwmmxt.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/iwmmxt.S b/arch/arm/kernel/iwmmxt.S
index a08783823b32..2452dd1bef53 100644
--- a/arch/arm/kernel/iwmmxt.S
+++ b/arch/arm/kernel/iwmmxt.S
@@ -19,12 +19,16 @@
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 
-#if defined(CONFIG_CPU_PJ4)
+#if defined(CONFIG_CPU_PJ4) || defined(CONFIG_CPU_PJ4B)
 #define PJ4(code...)		code
 #define XSC(code...)
-#else
+#elif defined(CONFIG_CPU_MOHAWK) || \
+	defined(CONFIG_CPU_XSC3) || \
+	defined(CONFIG_CPU_XSCALE)
 #define PJ4(code...)
 #define XSC(code...)		code
+#else
+#error "Unsupported iWMMXt architecture"
 #endif
 
 #define MMX_WR0		 	(0x00)
-- 
1.9.1

