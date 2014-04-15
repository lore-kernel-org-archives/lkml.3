Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaDOSWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:22:45 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:57640 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaDOSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:16:15 -0400
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
Subject: [PATCH 4/5] ARM: pj4: fix cpu_is_pj4 check
Date: Tue, 15 Apr 2014 20:16:02 +0200
Message-Id: <1397585763-23482-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <20140414151236.75f8816d@skate>
 <1397585763-23482-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fdb487f5c961b94486a78fa61fa28b8eff1954ab
  ("ARM: 8015/1: Add cpu_is_pj4 to distinguish PJ4 because it
    has some differences with V7")
introduced a cpuid check for Marvell PJ4 processors to fix a
regression caused by adding PJ4 based Marvell Dove into
multi_v7.

Unfortunately, this check is too narrow to catch PJ4 used on
Dove itself and breaks iWMMXt support.

This patch therefore relaxes the cpuid mask to match both PJ4
and PJ4B. Also, rework the given comment about PJ4/PJ4B
modifications to be a little bit more specific about the
differences.

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
 arch/arm/include/asm/cputype.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/cputype.h b/arch/arm/include/asm/cputype.h
index c651e3b26ec7..4764344367d4 100644
--- a/arch/arm/include/asm/cputype.h
+++ b/arch/arm/include/asm/cputype.h
@@ -222,22 +222,22 @@ static inline int cpu_is_xsc3(void)
 #endif
 
 /*
- * Marvell's PJ4 core is based on V7 version. It has some modification
- * for coprocessor setting. For this reason, we need a way to distinguish
- * it.
+ * Marvell's PJ4 and PJ4B cores are based on V7 version,
+ * but require a specical sequence for enabling coprocessors.
+ * For this reason, we need a way to distinguish them.
  */
-#ifndef CONFIG_CPU_PJ4
-#define cpu_is_pj4()	0
-#else
+#if defined(CONFIG_CPU_PJ4) || defined(CONFIG_CPU_PJ4B)
 static inline int cpu_is_pj4(void)
 {
 	unsigned int id;
 
 	id = read_cpuid_id();
-	if ((id & 0xfffffff0) == 0x562f5840)
+	if ((id & 0xff0fff00) == 0x560f5800)
 		return 1;
 
 	return 0;
 }
+#else
+#define cpu_is_pj4()	0
 #endif
 #endif
-- 
1.9.1

