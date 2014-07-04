Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaGDHSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:18:55 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43054 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGDHSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:18:53 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-e0-53b6555a8b95
Message-id: <53B6541B.6000702@samsung.com>
Date: Fri, 04 Jul 2014 11:13:31 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: get rid of hardcoded assumptions about kernel stack
 size
References: <1403099422-850-1-git-send-email-a.ryabinin@samsung.com>
 <201407032224.28386.arnd@arndb.de>
In-reply-to: <201407032224.28386.arnd@arndb.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7pRoduCDf5u07L4O+kYu8X7ZT2M
	FpseX2O1uLxrDpvF7cu8FtOP/WWzePnxBIsDu8eaeWsYPVqae9g8fv+axOhx59oeNo/NS+o9
	Pm+SC2CL4rJJSc3JLEst0rdL4Mpo+r2SuWC9a8Xu/c3sDYxfTLsYOTkkBEwkTrX8YoKwxSQu
	3FvP1sXIxSEksJRRYtL3p8wQTjOTxL+urWwgVbwCWhIvO6YzgtgsAqoSjW8msoDYbAJ6Ev9m
	bQerERWIkDjQ94wVol5Q4sfke2A1IgLuEuumz2MFGcossItRYn/LBrCEsECIxJPbK8BsIYFM
	iWPbb4MN4hTQl7i87Q/YIGYBHYn9rdPYIGx5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUomlqa
	XFCclJ5rpFecmFtcmpeul5yfu4kREu5fdzAuPWZ1iFGAg1GJh/eF/qZgIdbEsuLK3EOMEhzM
	SiK8VUrbgoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwHj6lVJIT9bk4zNbtCXeu1GkrX45d2zZy
	e74OZD9Yc6O2u0aM4825FvXvHMJOlyqWpblkb9SLcrDbsPDnoo+XPuZGPGdJ1Ci3W9rP21Qp
	sa/YzKxn4zL2ft/Eze2ci+a1rw5YzOvHK5r8mOGw3TNzDe+DagK1hvfu9GQ8XvRsh9P386/D
	478osRRnJBpqMRcVJwIAq1T0OlUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/14 00:24, Arnd Bergmann wrote:
> On Wednesday 18 June 2014, Andrey Ryabinin wrote:
>> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
>> index f989d7c..f85d2b0 100644
>> --- a/arch/arm/include/asm/thread_info.h
>> +++ b/arch/arm/include/asm/thread_info.h
>> @@ -14,9 +14,10 @@
>>  
>>  #include <linux/compiler.h>
>>  #include <asm/fpstate.h>
>> +#include <asm/page.h>
>>  
>>  #define THREAD_SIZE_ORDER      1
>> -#define THREAD_SIZE            8192
>> +#define THREAD_SIZE            (PAGE_SIZE << THREAD_SIZE_ORDER)
>>  #define THREAD_START_SP                (THREAD_SIZE - 8)
>>  
>>  #ifndef __ASSEMBLY__
> 
> The extra #include has caused recursive inclusion on the iop13xx platform, as you
> can see below. I've been able to work around it using this small patch:
> 

Right, I've got report about this from kbuild test robot, and I was going to send the same fix as yours,
but you come first.



> diff --git a/arch/arm/mach-iop13xx/include/mach/iop13xx.h b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
> index 17b4027..e851f5c 100644
> --- a/arch/arm/mach-iop13xx/include/mach/iop13xx.h
> +++ b/arch/arm/mach-iop13xx/include/mach/iop13xx.h
> @@ -3,8 +3,6 @@
>  
>  #ifndef __ASSEMBLY__
>  
> -#include <linux/reboot.h>
> -
>  /* The ATU offsets can change based on the strapping */
>  extern u32 iop13xx_atux_pmmr_offset;
>  extern u32 iop13xx_atue_pmmr_offset;
> @@ -14,6 +12,7 @@ void iop13xx_map_io(void);
>  void iop13xx_platform_init(void);
>  void iop13xx_add_tpmi_devices(void);
>  void iop13xx_init_irq(void);
> +enum reboot_mode;
>  void iop13xx_restart(enum reboot_mode, const char *);
>  
>  /* CPUID CP6 R0 Page 0 */
> diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
> index bca96f43..53c316f 100644
> --- a/arch/arm/mach-iop13xx/setup.c
> +++ b/arch/arm/mach-iop13xx/setup.c
> @@ -20,6 +20,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/serial_8250.h>
>  #include <linux/io.h>
> +#include <linux/reboot.h>
>  #ifdef CONFIG_MTD_PHYSMAP
>  #include <linux/mtd/physmap.h>
>  #endif
> 
> 
> but I wonder if there is a way to avoid the extra include here, as it might also
> cause a general slowdown because of asm/memory.h getting pulled into more .c
> files. Would it be reasonable to hardcode PAGE_SIZE here?
> 

IMO it's a bug of iop13xx platform, that it includes "higlevel" linux/reboot.h
from a very "lowlevel" header mach/iop13xx.h. I think it should be fixed with a patch above.
Slowing down of kernel build for a few more seconds is not good enough reason for me to
hardcode PAGE_SIZE here.



> 	Arnd
> 
> ----
> In file included from /git/arm-soc/include/linux/srcu.h:33:0,
>                  from /git/arm-soc/include/linux/notifier.h:15,
>                  from /git/arm-soc/include/linux/reboot.h:5,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/iop13xx.h:6,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/hardware.h:14,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/memory.h:4,
>                  from /git/arm-soc/arch/arm/include/asm/memory.h:24,
>                  from /git/arm-soc/arch/arm/include/asm/page.h:163,
>                  from /git/arm-soc/arch/arm/include/asm/thread_info.h:17,
>                  from /git/arm-soc/include/linux/thread_info.h:54,
>                  from /git/arm-soc/include/asm-generic/preempt.h:4,
>                  from arch/arm/include/generated/asm/preempt.h:1,
>                  from /git/arm-soc/include/linux/preempt.h:18,
>                  from /git/arm-soc/include/linux/spinlock.h:50,
>                  from /git/arm-soc/include/linux/seqlock.h:35,
>                  from /git/arm-soc/include/linux/time.h:5,
>                  from /git/arm-soc/include/uapi/linux/timex.h:56,
>                  from /git/arm-soc/include/linux/timex.h:56,
>                  from /git/arm-soc/include/linux/sched.h:19,
>                  from /git/arm-soc/arch/arm/kernel/asm-offsets.c:13:
> /git/arm-soc/include/linux/rcupdate.h: In function '__rcu_read_lock':
> /git/arm-soc/include/linux/rcupdate.h:219:2: error: implicit declaration of function 'preempt_disable' [-Werror=implicit-function-declaration]
>   preempt_disable();
>   ^
> /git/arm-soc/include/linux/rcupdate.h: In function '__rcu_read_unlock':
> /git/arm-soc/include/linux/rcupdate.h:224:2: error: implicit declaration of function 'preempt_enable' [-Werror=implicit-function-declaration]
>   preempt_enable();
>   ^
> In file included from /git/arm-soc/include/linux/srcu.h:33:0,
>                  from /git/arm-soc/include/linux/notifier.h:15,
>                  from /git/arm-soc/include/linux/reboot.h:5,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/iop13xx.h:6,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/hardware.h:14,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/memory.h:4,
>                  from /git/arm-soc/arch/arm/include/asm/memory.h:24,
>                  from /git/arm-soc/arch/arm/include/asm/page.h:163,
>                  from /git/arm-soc/arch/arm/include/asm/thread_info.h:17,
>                  from /git/arm-soc/include/linux/thread_info.h:54,
>                  from /git/arm-soc/include/asm-generic/preempt.h:4,
>                  from arch/arm/include/generated/asm/preempt.h:1,
>                  from /git/arm-soc/include/linux/preempt.h:18,
>                  from /git/arm-soc/include/linux/spinlock.h:50,
>                  from /git/arm-soc/include/linux/seqlock.h:35,
>                  from /git/arm-soc/include/linux/time.h:5,
>                  from /git/arm-soc/include/uapi/linux/timex.h:56,
>                  from /git/arm-soc/include/linux/timex.h:56,
>                  from /git/arm-soc/include/linux/sched.h:19,
>                  from /git/arm-soc/arch/arm/kernel/asm-offsets.c:13:
> /git/arm-soc/include/linux/rcupdate.h: In function 'rcu_read_lock_bh':
> /git/arm-soc/include/linux/rcupdate.h:928:2: error: implicit declaration of function 'local_bh_disable' [-Werror=implicit-function-declaration]
>   local_bh_disable();
>   ^
> /git/arm-soc/include/linux/rcupdate.h: In function 'rcu_read_unlock_bh':
> /git/arm-soc/include/linux/rcupdate.h:942:2: error: implicit declaration of function 'local_bh_enable' [-Werror=implicit-function-declaration]
>   local_bh_enable();
>   ^
> /git/arm-soc/include/linux/rcupdate.h: In function 'rcu_read_lock_sched_notrace':
> /git/arm-soc/include/linux/rcupdate.h:968:2: error: implicit declaration of function 'preempt_disable_notrace' [-Werror=implicit-function-declaration]
>   preempt_disable_notrace();
>   ^
> /git/arm-soc/include/linux/rcupdate.h: In function 'rcu_read_unlock_sched_notrace':
> /git/arm-soc/include/linux/rcupdate.h:988:2: error: implicit declaration of function 'preempt_enable_notrace' [-Werror=implicit-function-declaration]
>   preempt_enable_notrace();
>   ^
> In file included from /git/arm-soc/include/linux/ktime.h:25:0,
>                  from /git/arm-soc/include/linux/timer.h:5,
>                  from /git/arm-soc/include/linux/workqueue.h:8,
>                  from /git/arm-soc/include/linux/srcu.h:34,
>                  from /git/arm-soc/include/linux/notifier.h:15,
>                  from /git/arm-soc/include/linux/reboot.h:5,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/iop13xx.h:6,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/hardware.h:14,
>                  from /git/arm-soc/arch/arm/mach-iop13xx/include/mach/memory.h:4,
>                  from /git/arm-soc/arch/arm/include/asm/memory.h:24,
>                  from /git/arm-soc/arch/arm/include/asm/page.h:163,
>                  from /git/arm-soc/arch/arm/include/asm/thread_info.h:17,
>                  from /git/arm-soc/include/linux/thread_info.h:54,
>                  from /git/arm-soc/include/asm-generic/preempt.h:4,
>                  from arch/arm/include/generated/asm/preempt.h:1,
>                  from /git/arm-soc/include/linux/preempt.h:18,
>                  from /git/arm-soc/include/linux/spinlock.h:50,
>                  from /git/arm-soc/include/linux/seqlock.h:35,
>                  from /git/arm-soc/include/linux/time.h:5,
>                  from /git/arm-soc/include/uapi/linux/timex.h:56,
>                  from /git/arm-soc/include/linux/timex.h:56,
>                  from /git/arm-soc/include/linux/sched.h:19,
>                  from /git/arm-soc/arch/arm/kernel/asm-offsets.c:13:
> /git/arm-soc/include/linux/jiffies.h: At top level:
> /git/arm-soc/include/linux/jiffies.h:256:10: warning: "NSEC_PER_SEC" is not defined [-Wundef]
> ... many more...
> 

