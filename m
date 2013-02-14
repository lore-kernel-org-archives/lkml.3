Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405Ab3BNNtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:49:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51705 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965196Ab3BNNtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: [PATCH 09/11] ARM: mvebu: allow selecting mvebu without Armada XP
Date: Thu, 14 Feb 2013 14:49:25 +0100
Message-Id: <1360849767-1463135-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:O1GxLGfVS4e12sJJg9RS9LJBECK19SRPqtTxqbuYeun
 1EYc+rvMJnhWec/TWSRgftgSW4kOfolHYPot3FYGIufGMCI8Wv
 rqmE3MX5zrKSL6b1f+zzlOsGxZqWuOKk+ZZ14WWEo+qbUTmpNB
 teZ7NEHgYM/aTRECIlzJsx+vuDAN0DoVIkkKPmiGi6DTeXd/3i
 JJyWJ7D8BLs2/SoIue5QLw+RrrfRi8c6sUW5ZB+a9I0nrV5kL2
 ujXhys723H4LyRPhEb10QC/gYTVPwbVEwlP41/xkAwpRQrRGNa
 fGXqo30+Ew0kKK+DhqoOHe6gWLXgT3VjMeJYjCBNNosk36zK2X
 flFd8Y7Fg8UR3q62etzSJJkT93aM6nKvM5Ilz5hI2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selecting only CONFIG_ARCH_MVEBU but not the respective
options for Armada 370 or Armada XP results in these
link errors:

arch/arm/mach-mvebu/built-in.o: In function `armada_xp_smp_init_cpus':
arch/arm/mach-mvebu/platsmp.c:91: undefined reference to `coherency_get_cpu_count'
arch/arm/mach-mvebu/platsmp.c:104: undefined reference to `armada_mpic_send_doorbell'
arch/arm/mach-mvebu/built-in.o: In function `armada_xp_smp_prepare_cpus':
arch/arm/mach-mvebu/platsmp.c:111: undefined reference to `set_cpu_coherent'
arch/arm/mach-mvebu/built-in.o: In function `armada_xp_boot_secondary':
arch/arm/mach-mvebu/platsmp.c:83: undefined reference to `armada_xp_boot_cpu'
arch/arm/mach-mvebu/built-in.o: In function `armada_xp_secondary_init':
arch/arm/mach-mvebu/platsmp.c:75: undefined reference to `armada_xp_mpic_smp_cpu_init'
arch/arm/mach-mvebu/built-in.o: In function `armada_xp_secondary_startup':
arch/arm/mach-mvebu/headsmp.S:46: undefined reference to `ll_set_cpu_coherent'

We can solve this by enabling all common MVEBU files that are
referenced by the SMP files. This means we enable code that
is not going to be used without a machine descriptor referencing
it, but only if the kernel is configured specifically for this
case.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 arch/arm/mach-mvebu/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mvebu/Makefile b/arch/arm/mach-mvebu/Makefile
index 99df4df..da93bcb 100644
--- a/arch/arm/mach-mvebu/Makefile
+++ b/arch/arm/mach-mvebu/Makefile
@@ -3,7 +3,8 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include \
 
 AFLAGS_coherency_ll.o		:= -Wa,-march=armv7-a
 
-obj-y += system-controller.o
-obj-$(CONFIG_MACH_ARMADA_370_XP) += armada-370-xp.o irq-armada-370-xp.o addr-map.o coherency.o coherency_ll.o pmsu.o
+obj-y				 += system-controller.o
+obj-$(CONFIG_MACH_ARMADA_370_XP) += armada-370-xp.o
+obj-$(CONFIG_ARCH_MVEBU)	 += addr-map.o coherency.o coherency_ll.o pmsu.o irq-armada-370-xp.o 
 obj-$(CONFIG_SMP)                += platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)        += hotplug.o
-- 
1.8.1.2

