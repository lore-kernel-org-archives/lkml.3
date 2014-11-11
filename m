Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaKKHmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:42:51 -0500
Received: from ozlabs.org ([103.22.144.67]:55008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaKKHmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:42:49 -0500
Message-ID: <1415691766.9757.1.camel@concordia>
Subject: Re: [PATCH v6 41/48] powerpc: Register with kernel power-off handler
From: Michael Ellerman <mpe@ellerman.id.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alexander Graf <agraf@suse.de>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>
Date: Tue, 11 Nov 2014 18:42:46 +1100
In-Reply-To: <1415583785-6980-42-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
	 <1415583785-6980-42-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-09 at 17:42 -0800, Guenter Roeck wrote:
> Register with kernel power-off handler instead of setting pm_power_off
> directly.
> 
> If there is an indication that there can be more than one power-off handler,
> use register_power_off_handler, otherwise use register_power_off_handler_simple
> to register the power-off handler.
> 
> If the power-off handler only resets or stops the system, select the fallback
> priority to indicate that the power-off handler is one of last resort.
> If the power-off handler powers off the system, select the default priority,
> unless the power-off handler installation code suggests that there can be
> more than one power-off handler and the new handler is only installed
> conditionally. In this case, install the handler with low priority.
> 
> Cc: Alexander Graf <agraf@suse.de>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Can you fold in the patch below. I know pm.h is included by device.h, so most
things will already have it, but I'd rather be explicit.

With that you can add my:

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers



diff --git a/arch/powerpc/platforms/44x/ppc476.c b/arch/powerpc/platforms/44x/ppc476.c
index 590d31fbbfc0..adbf36d8c5d9 100644
--- a/arch/powerpc/platforms/44x/ppc476.c
+++ b/arch/powerpc/platforms/44x/ppc476.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/pm.h>
 #include <linux/rtc.h>
 
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/52xx/efika.c b/arch/powerpc/platforms/52xx/efika.c
index 321a7a76eb80..7bdf4e8f7b99 100644
--- a/arch/powerpc/platforms/52xx/efika.c
+++ b/arch/powerpc/platforms/52xx/efika.c
@@ -13,6 +13,7 @@
 #include <generated/utsrelease.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <linux/pm.h>
 #include <asm/dma.h>
 #include <asm/prom.h>
 #include <asm/time.h>
diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
index f0c4b5106103..4892491969ab 100644
--- a/arch/powerpc/platforms/85xx/corenet_generic.c
+++ b/arch/powerpc/platforms/85xx/corenet_generic.c
@@ -16,6 +16,7 @@
 #include <linux/kdev_t.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/pm.h>
 
 #include <asm/time.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/cell/celleb_setup.c b/arch/powerpc/platforms/cell/celleb_setup.c
index e301b1ae9c2d..1e14047f98d6 100644
--- a/arch/powerpc/platforms/cell/celleb_setup.c
+++ b/arch/powerpc/platforms/cell/celleb_setup.c
@@ -42,6 +42,7 @@
 #include <linux/root_dev.h>
 #include <linux/console.h>
 #include <linux/of_platform.h>
+#include <linux/pm.h>
 
 #include <asm/mmu.h>
 #include <asm/processor.h>
diff --git a/arch/powerpc/platforms/cell/qpace_setup.c b/arch/powerpc/platforms/cell/qpace_setup.c
index 223d40a73130..429fefd30e4e 100644
--- a/arch/powerpc/platforms/cell/qpace_setup.c
+++ b/arch/powerpc/platforms/cell/qpace_setup.c
@@ -22,6 +22,7 @@
 #include <linux/irq.h>
 #include <linux/console.h>
 #include <linux/of_platform.h>
+#include <linux/pm.h>
 
 #include <asm/mmu.h>
 #include <asm/processor.h>
diff --git a/arch/powerpc/platforms/cell/setup.c b/arch/powerpc/platforms/cell/setup.c
index ea5460c0b8e7..1203a9d6cd53 100644
--- a/arch/powerpc/platforms/cell/setup.c
+++ b/arch/powerpc/platforms/cell/setup.c
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
 #include <linux/of_platform.h>
+#include <linux/pm.h>
 
 #include <asm/mmu.h>
 #include <asm/processor.h>
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 0c0288ed0c3b..910bd8b45fae 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -31,6 +31,7 @@
 #include <linux/root_dev.h>
 #include <linux/initrd.h>
 #include <linux/timer.h>
+#include <linux/pm.h>
 
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/platforms/embedded6xx/gamecube.c b/arch/powerpc/platforms/embedded6xx/gamecube.c
index af40f0fc2579..c90caff045bb 100644
--- a/arch/powerpc/platforms/embedded6xx/gamecube.c
+++ b/arch/powerpc/platforms/embedded6xx/gamecube.c
@@ -18,6 +18,7 @@
 #include <linux/kexec.h>
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
+#include <linux/pm.h>
 
 #include <asm/io.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index 0c4dcf86fc7b..e1aec530f0ad 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/initrd.h>
 #include <linux/of_platform.h>
+#include <linux/pm.h>
 
 #include <asm/time.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index eea88245a9de..8c93b95bcc29 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -20,6 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 #include <linux/memblock.h>
+#include <linux/pm.h>
 #include <mm/mmu_decl.h>
 
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 73c3988202d8..962e4968d967 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -43,6 +43,7 @@
 #include <linux/bitops.h>
 #include <linux/of_device.h>
 #include <linux/memblock.h>
+#include <linux/pm.h>
 
 #include <asm/processor.h>
 #include <asm/sections.h>
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 6496ae41a51d..52f2e965200a 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -53,6 +53,7 @@
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/memblock.h>
+#include <linux/pm.h>
 
 #include <asm/reg.h>
 #include <asm/sections.h>
diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index a03c41bcfed1..9b124ddcddf5 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -28,6 +28,7 @@
 #include <linux/bug.h>
 #include <linux/pci.h>
 #include <linux/cpufreq.h>
+#include <linux/pm.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
diff --git a/arch/powerpc/platforms/ps3/setup.c b/arch/powerpc/platforms/ps3/setup.c
index 77e0dea2590b..63ed88e25f3e 100644
--- a/arch/powerpc/platforms/ps3/setup.c
+++ b/arch/powerpc/platforms/ps3/setup.c
@@ -25,6 +25,7 @@
 #include <linux/console.h>
 #include <linux/export.h>
 #include <linux/bootmem.h>
+#include <linux/pm.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index b3c85bb90e34..d5c944e42612 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -41,6 +41,7 @@
 #include <linux/root_dev.h>
 #include <linux/of.h>
 #include <linux/kexec.h>
+#include <linux/pm.h>
 
 #include <asm/mmu.h>
 #include <asm/processor.h>


