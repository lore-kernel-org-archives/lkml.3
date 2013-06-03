Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3FCNSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:18:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab3FCNSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:18:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@linaro.org>, Dave Martin <dave.martin@linaro.org>
Subject: [PATCH] drivers/bus: arm-cci: fix combined ARMv6+v7 build
Date: Mon, 03 Jun 2013 15:18:46 +0200
Message-ID: <2485806.Uv8bUctxav@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ub/L+Qba5xwJt9e+M95biyq7pQPLu2EoVoLSVHSE972
 gdmCyOIH+qCUHc63+Lo4viFvHxmAFgprNh64UPbRGQIeLPxRCF
 zd0BdZzwzlCqN0peq745pkbVicCiIV/a1IUwHkxv6uuuUv5Zrv
 q62OhgZqWS1q2HqF9NNBgaziQvvVUZzMAumy6kAZsPdAYY0rxS
 TX7Zx+3JNdnl6uJWW3EZnO4kaZnBGqojhZJT5TzeJ6ByJRqVvF
 a35cOz4P3/tb32vBj9uT6XHZ6ADoaX7FWhrJpKF0cV+eXmlFH+
 Aw0swVlGLQoVMbc9uFV03m9UNhatc4oXBGUbhHA1isneLRf+6K
 DO0rhD1ilaYo74CTkQDo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we build a kernel with support for both ARMv6 and ARMv7,
gas is trying to be helpful by pointing out that the arm-cci
driver would not work on ARMv6:

/tmp/ccu1LDeU.s: Assembler messages:
/tmp/ccu1LDeU.s:450: Error: selected processor does not support ARM mode `wfi '
/tmp/ccu1LDeU.s:451: Error: selected processor does not support ARM mode `wfe '
make[4]: *** [drivers/bus/arm-cci.o] Error 1

We know that the driver will only be used on ARMv7, hence we
can annotate the inline assembly listing to allow those instructions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Dave Martin <dave.martin@linaro.org>

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index 380319e..7332889 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -253,7 +253,7 @@ EXPORT_SYMBOL_GPL(cci_disable_port_by_cpu);
 asmlinkage void __naked cci_enable_port_for_self(void)
 {
 	asm volatile ("\n"
-
+"	.arch armv7-a\n"
 "	mrc	p15, 0, r0, c0, c0, 5	@ get MPIDR value \n"
 "	and	r0, r0, #"__stringify(MPIDR_HWID_BITMASK)" \n"
 "	adr	r1, 5f \n"

