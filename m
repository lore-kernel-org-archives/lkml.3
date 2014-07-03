Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbaGCUYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:24:46 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64181 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaGCUYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:24:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: get rid of hardcoded assumptions about kernel stack size
Date: Thu, 3 Jul 2014 22:24:28 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
References: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407032224.28386.arnd@arndb.de>
X-Provags-ID: V02:K0:radFTZlvYKWtSZY4tt01kOXfRB4A9xob0P1tPl69Tpn
 7c2E7uvPNc8RGZVp0ch35ilQpdbHYPcN0k661nAiXnIdAuCz5q
 opXT9lgqJXgWCQEepBscopgx5oYqxALzT4NIEZvpdred+GRoEb
 s9avMbPVSeK3/aGtkDi0XzvDrKwGw5rohyVfnp2qV8DLq3zx1m
 X+Zex+LlogXp04wR0bZNiQqhxWh4yeiNOi4WvkcBPpElVcXVhR
 83/kX9xsD/vxZGyLOnEBM44MTts7wpWp1QavRq7I/QPNz5LnGg
 ztaGK8XtZwajrdIsxrao/6joQYUPjzFhMYecjyDMyG+XDOX7zT
 xMd/Xd7U63kOuFueyOdg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2014, Andrey Ryabinin wrote:
> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
> index f989d7c..f85d2b0 100644
> --- a/arch/arm/include/asm/thread_info.h
> +++ b/arch/arm/include/asm/thread_info.h
> @@ -14,9 +14,10 @@
>  
>  #include <linux/compiler.h>
>  #include <asm/fpstate.h>
> +#include <asm/page.h>
>  
>  #define THREAD_SIZE_ORDER      1
> -#define THREAD_SIZE            8192
> +#define THREAD_SIZE            (PAGE_SIZE << THREAD_SIZE_ORDER)
>  #define THREAD_START_SP                (THREAD_SIZE - 8)
>  
>  #ifndef __ASSEMBLY__

The extra #include has caused recursive inclusion on the iop13xx platform, as you
can see below. I've been able to work around it using this small patch:

diff --git a/arch/arm/mach-iop13xx/include/mach/iop13xx.h b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
index 17b4027..e851f5c 100644
--- a/arch/arm/mach-iop13xx/include/mach/iop13xx.h
+++ b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
@@ -3,8 +3,6 @@
 
 #ifndef __ASSEMBLY__
 
-#include <linux/reboot.h>
-
 /* The ATU offsets can change based on the strapping */
 extern u32 iop13xx_atux_pmmr_offset;
 extern u32 iop13xx_atue_pmmr_offset;
@@ -14,6 +12,7 @@ void iop13xx_map_io(void);
 void iop13xx_platform_init(void);
 void iop13xx_add_tpmi_devices(void);
 void iop13xx_init_irq(void);
+enum reboot_mode;
 void iop13xx_restart(enum reboot_mode, const char *);
 
 /* CPUID CP6 R0 Page 0 */
diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index bca96f43..53c316f 100644
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


but I wonder if there is a way to avoid the extra include here, as it might also
cause a general slowdown because of asm/memory.h getting pulled into more .c
files. Would it be reasonable to hardcode PAGE_SIZE here?

	Arnd

----
In file included from /git/arm-soc/include/linux/srcu.h:33:0,
                 from /git/arm-soc/include/linux/notifier.h:15,
                 from /git/arm-soc/include/linux/reboot.h:5,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/iop13xx.h:6,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/hardware.h:14,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/memory.h:4,
                 from /git/arm-soc/arch/arm/include/asm/memory.h:24,
                 from /git/arm-soc/arch/arm/include/asm/page.h:163,
                 from /git/arm-soc/arch/arm/include/asm/thread_info.h:17,
                 from /git/arm-soc/include/linux/thread_info.h:54,
                 from /git/arm-soc/include/asm-generic/preempt.h:4,
                 from arch/arm/include/generated/asm/preempt.h:1,
                 from /git/arm-soc/include/linux/preempt.h:18,
                 from /git/arm-soc/include/linux/spinlock.h:50,
                 from /git/arm-soc/include/linux/seqlock.h:35,
                 from /git/arm-soc/include/linux/time.h:5,
                 from /git/arm-soc/include/uapi/linux/timex.h:56,
                 from /git/arm-soc/include/linux/timex.h:56,
                 from /git/arm-soc/include/linux/sched.h:19,
                 from /git/arm-soc/arch/arm/kernel/asm-offsets.c:13:
/git/arm-soc/include/linux/rcupdate.h: In function '__rcu_read_lock':
/git/arm-soc/include/linux/rcupdate.h:219:2: error: implicit declaration of function 'preempt_disable' [-Werror=implicit-function-declaration]
  preempt_disable();
  ^
/git/arm-soc/include/linux/rcupdate.h: In function '__rcu_read_unlock':
/git/arm-soc/include/linux/rcupdate.h:224:2: error: implicit declaration of function 'preempt_enable' [-Werror=implicit-function-declaration]
  preempt_enable();
  ^
In file included from /git/arm-soc/include/linux/srcu.h:33:0,
                 from /git/arm-soc/include/linux/notifier.h:15,
                 from /git/arm-soc/include/linux/reboot.h:5,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/iop13xx.h:6,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/hardware.h:14,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/memory.h:4,
                 from /git/arm-soc/arch/arm/include/asm/memory.h:24,
                 from /git/arm-soc/arch/arm/include/asm/page.h:163,
                 from /git/arm-soc/arch/arm/include/asm/thread_info.h:17,
                 from /git/arm-soc/include/linux/thread_info.h:54,
                 from /git/arm-soc/include/asm-generic/preempt.h:4,
                 from arch/arm/include/generated/asm/preempt.h:1,
                 from /git/arm-soc/include/linux/preempt.h:18,
                 from /git/arm-soc/include/linux/spinlock.h:50,
                 from /git/arm-soc/include/linux/seqlock.h:35,
                 from /git/arm-soc/include/linux/time.h:5,
                 from /git/arm-soc/include/uapi/linux/timex.h:56,
                 from /git/arm-soc/include/linux/timex.h:56,
                 from /git/arm-soc/include/linux/sched.h:19,
                 from /git/arm-soc/arch/arm/kernel/asm-offsets.c:13:
/git/arm-soc/include/linux/rcupdate.h: In function 'rcu_read_lock_bh':
/git/arm-soc/include/linux/rcupdate.h:928:2: error: implicit declaration of function 'local_bh_disable' [-Werror=implicit-function-declaration]
  local_bh_disable();
  ^
/git/arm-soc/include/linux/rcupdate.h: In function 'rcu_read_unlock_bh':
/git/arm-soc/include/linux/rcupdate.h:942:2: error: implicit declaration of function 'local_bh_enable' [-Werror=implicit-function-declaration]
  local_bh_enable();
  ^
/git/arm-soc/include/linux/rcupdate.h: In function 'rcu_read_lock_sched_notrace':
/git/arm-soc/include/linux/rcupdate.h:968:2: error: implicit declaration of function 'preempt_disable_notrace' [-Werror=implicit-function-declaration]
  preempt_disable_notrace();
  ^
/git/arm-soc/include/linux/rcupdate.h: In function 'rcu_read_unlock_sched_notrace':
/git/arm-soc/include/linux/rcupdate.h:988:2: error: implicit declaration of function 'preempt_enable_notrace' [-Werror=implicit-function-declaration]
  preempt_enable_notrace();
  ^
In file included from /git/arm-soc/include/linux/ktime.h:25:0,
                 from /git/arm-soc/include/linux/timer.h:5,
                 from /git/arm-soc/include/linux/workqueue.h:8,
                 from /git/arm-soc/include/linux/srcu.h:34,
                 from /git/arm-soc/include/linux/notifier.h:15,
                 from /git/arm-soc/include/linux/reboot.h:5,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/iop13xx.h:6,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/hardware.h:14,
                 from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/memory.h:4,
                 from /git/arm-soc/arch/arm/include/asm/memory.h:24,
                 from /git/arm-soc/arch/arm/include/asm/page.h:163,
                 from /git/arm-soc/arch/arm/include/asm/thread_info.h:17,
                 from /git/arm-soc/include/linux/thread_info.h:54,
                 from /git/arm-soc/include/asm-generic/preempt.h:4,
                 from arch/arm/include/generated/asm/preempt.h:1,
                 from /git/arm-soc/include/linux/preempt.h:18,
                 from /git/arm-soc/include/linux/spinlock.h:50,
                 from /git/arm-soc/include/linux/seqlock.h:35,
                 from /git/arm-soc/include/linux/time.h:5,
                 from /git/arm-soc/include/uapi/linux/timex.h:56,
                 from /git/arm-soc/include/linux/timex.h:56,
                 from /git/arm-soc/include/linux/sched.h:19,
                 from /git/arm-soc/arch/arm/kernel/asm-offsets.c:13:
/git/arm-soc/include/linux/jiffies.h: At top level:
/git/arm-soc/include/linux/jiffies.h:256:10: warning: "NSEC_PER_SEC" is not defined [-Wundef]
... many more...
