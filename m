Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbaGNQ6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:58:05 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39822 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbaGNQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:57:57 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ba-53c40bfe734e
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, kbuild-all@01.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH] arm: mach-iop13xx: fix possible build failure
Date: Mon, 14 Jul 2014 20:50:30 +0400
Message-id: <1405356630-2411-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <20140714102903.GN21766@n2100.arm.linux.org.uk>
References: <20140714102903.GN21766@n2100.arm.linux.org.uk>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7r/uI8EG3zfbW6x7dcjNou/k46x
	W7x/vp7Z4tj1icwWmx5fY7W4vGsOm8Xty7wO7B7397J7tDT3sHn8/jWJ0WPxnpdMHpuX1Hv0
	bVnF6PF5k1wAexSXTUpqTmZZapG+XQJXxtYP79kKfktUdB06xtrAOEG4i5GTQ0LARKLz3AZ2
	CFtM4sK99WwgtpDAUkaJ2Z16XYxcQHYfk8TkHf8ZQRJsAnoS/2ZtBysSEdCUOLX4IjNIEbPA
	PkaJ9vc3wBLCAnYSc9p/gTWwCKhKtP9+wARi8wq4SjTvOQe1TUFi2fKZrCA2p4CNROvuLqjN
	1hLbGyeyTGDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJMi+7GBcfMzqEKMAB6MS
	D2+F2OFgIdbEsuLK3EOMEhzMSiK8Rz8AhXhTEiurUovy44tKc1KLDzEycXBKNTAyRH/SbhZL
	6/P+WTKV52bJ00ueMvfqtl+o0xS9/4Z5hk9XZOCBXl8RizaO3ibfR1teBjTmPpW27W66Lie4
	oTKKZcYmNj2+UN6cSS/WqHuzLH+8ecdrbnHxl9vLmfUKV2yyW3moVEzNavbZ5889WnVibh/h
	0K2dIPuRk6FZ66TN5dc6DalN/UosxRmJhlrMRcWJAPSl55QQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

After applying patch:
	"ARM: 8078/1: get rid of hardcoded assumptions about kernel stack size"

following build failure happens on iop13xx platform:

   In file included from include/linux/srcu.h:33:0,
                    from include/linux/notifier.h:15,
                    from include/linux/reboot.h:5,
                    from arch/arm/mach-iop13xx/include/mach/iop13xx.h:6,
                    from arch/arm/mach-iop13xx/include/mach/hardware.h:14,
                    from arch/arm/mach-iop13xx/include/mach/memory.h:4,
                    from arch/arm/include/asm/memory.h:24,
                    from arch/arm/include/asm/page.h:163,
                    from arch/arm/include/asm/thread_info.h:17,
                    from include/linux/thread_info.h:54,
                    from include/asm-generic/preempt.h:4,
                    from arch/arm/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:18,
                    from include/linux/spinlock.h:50,
                    from include/linux/seqlock.h:35,
                    from include/linux/time.h:5,
                    from include/uapi/linux/timex.h:56,
                    from include/linux/timex.h:56,
                    from include/linux/sched.h:19,
                    from arch/arm/kernel/asm-offsets.c:13:
   include/linux/rcupdate.h: In function '__rcu_read_lock':
>> include/linux/rcupdate.h:220:2: error: implicit declaration of function 'preempt_disable' [-Werror=implicit-function-declaration]
     preempt_disable();

The problem here is recursive header inclusion which could be avoided by
removing linux/reboot.h from mach/iop13xxx.h.
linux/reboot.h in include/mach/iop13xx.h is needed only for enum reboot_mode,
so header it could be replaced with a enum declaration.

Whatever patch "ARM: 8078/1: get rid of hardcoded assumptions about kernel stack size"
does, I think it's good to avoid unnecessary header inclusion here in any case.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/mach-iop13xx/include/mach/iop13xx.h | 2 +-
 arch/arm/mach-iop13xx/setup.c                | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-iop13xx/include/mach/iop13xx.h b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
index 17b4027..9311ee2 100644
--- a/arch/arm/mach-iop13xx/include/mach/iop13xx.h
+++ b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
@@ -3,7 +3,7 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/reboot.h>
+enum reboot_mode;
 
 /* The ATU offsets can change based on the strapping */
 extern u32 iop13xx_atux_pmmr_offset;
diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index bca96f4..53c316f 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -20,6 +20,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/serial_8250.h>
 #include <linux/io.h>
+#include <linux/reboot.h>
 #ifdef CONFIG_MTD_PHYSMAP
 #include <linux/mtd/physmap.h>
 #endif
-- 
1.8.5.5

