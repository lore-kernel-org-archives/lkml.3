Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaJTRWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:22:22 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:46133 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJTRWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:22:19 -0400
Date: Mon, 20 Oct 2014 18:22:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] arm64: Fix compile error seen in non-SMP builds
Message-ID: <20141020172208.GL23751@e104818-lin.cambridge.arm.com>
References: <1412990134-31186-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412990134-31186-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 02:15:34AM +0100, Guenter Roeck wrote:
> Fix:
> 
> In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
>         from include/linux/irq_work.h:46,
>         from include/linux/perf_event.h:49,
>         from include/linux/ftrace_event.h:9,
>         from include/trace/syscall.h:6,
>         from include/linux/syscalls.h:81,
>         from init/main.c:18:
> ./arch/arm64/include/asm/smp.h:24:3:
> 	error: #error "<asm/smp.h> included in non-SMP build"
>  # error "<asm/smp.h> included in non-SMP build"
>    ^
> ./arch/arm64/include/asm/smp.h:27:0: warning: "raw_smp_processor_id" redefined
>  #define raw_smp_processor_id() (current_thread_info()->cpu)
>  ^
> 
> and:
> 
> In file included from ./arch/arm64/include/asm/irq_work.h:4:0,
>         from include/linux/irq_work.h:46,
>         from kernel/irq_work.c:11:
> ./arch/arm64/include/asm/smp_plat.h:56:30:
>         error: ‘NR_CPUS’ undeclared here (not in a function)
>         extern u64 __cpu_logical_map[NR_CPUS];
> 
> by providing a helper function in smp_plat.h, similar to the arm implementation,
> and by removing NR_CPUS from smp_plat.h.
> 
> Fixes: 3631073659d0 ("arm64: Tell irq work about self IPI support")
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Isn't something like this simpler:

diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
index 8e24ef3f7c82..b4f6b19a8a68 100644
--- a/arch/arm64/include/asm/irq_work.h
+++ b/arch/arm64/include/asm/irq_work.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_IRQ_WORK_H
 #define __ASM_IRQ_WORK_H
 
+#ifdef CONFIG_SMP
+
 #include <asm/smp.h>
 
 static inline bool arch_irq_work_has_interrupt(void)
@@ -8,4 +10,13 @@ static inline bool arch_irq_work_has_interrupt(void)
 	return !!__smp_cross_call;
 }
 
+#else
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return false;
+}
+
+#endif
+
 #endif /* __ASM_IRQ_WORK_H */
