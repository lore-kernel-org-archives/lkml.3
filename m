Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3FFS0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:26:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3FFS0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:26:16 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=pfG7SM-LSxcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=hKTq1750SWgA:10 a=8e4ATIvWVOZOZawKBZoA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370543173.9844.37.camel@gandalf.local.home>
Subject: Re: [PATCH v14 2/3] trace,x86: Introduce entering/exiting_irq()
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@elte.hu, bp@alien8.de, linux-edac@vger.kernel.org,
        tony.luck@intel.com, dle-develop@lists.sourceforge.net,
        tomoki.sekiyama@hds.com
Date: Thu, 06 Jun 2013 14:26:13 -0400
In-Reply-To: <51B0A965.3070806@hds.com>
References: <51B0A90F.7030309@hds.com> <51B0A965.3070806@hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 11:23 -0400, Seiji Aguchi wrote:
> ---
>  arch/x86/include/asm/apic.h |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 3388034..f8119b5 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -12,6 +12,7 @@
>  #include <asm/fixmap.h>
>  #include <asm/mpspec.h>
>  #include <asm/msr.h>
> +#include <asm/idle.h>
>  
>  #define ARCH_APICTIMER_STOPS_ON_C3	1
>  
> @@ -687,5 +688,31 @@ extern int default_check_phys_apicid_present(int phys_apicid);
>  #endif
>  
>  #endif /* CONFIG_X86_LOCAL_APIC */
> +extern void irq_enter(void);
> +extern void irq_exit(void);
> +
> +static inline void entering_irq(void)
> +{
> +	irq_enter();
> +	exit_idle();
> +}
> +
> +static inline void entering_ack_irq(void)
> +{
> +	ack_APIC_irq();
> +	entering_irq();
> +}
> +
> +static inline void exiting_irq(void)
> +{
> +	irq_exit();
> +}
> +
> +static inline void exiting_ack_irq(void)
> +{
> +	irq_exit();
> +	/* Ack only at the end to avoid potential reentry */
> +	ack_APIC_irq();
> +}
>  
>  #endif /* _ASM_X86_APIC_H */

I think it also makes sense to use these in this patch as well. That is,
go ahead and make the changes likes this:

@@ -919,17 +919,14 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	/*
 	 * NOTE! We'd better ACK the irq immediately,
 	 * because timer handling can be slow.
-	 */
-	ack_APIC_irq();
-	/*
+	 *
 	 * update_process_times() expects us to have done irq_enter().
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-	irq_enter();
-	exit_idle();
+	entering_ack_irq();
 	local_apic_timer_interrupt();
-	irq_exit();
+	exiting_irq();
 
 	set_irq_regs(old_regs);
 }

And do that with all the interrupts.

I think this is getting close for adding to 3.11 queue.

-- Steve


