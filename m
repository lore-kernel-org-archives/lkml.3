Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3F1Pg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:36:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14743 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3F1Pg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:36:57 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F6bfKC6atTwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4o3xqwvaRjkA:10 a=hrrNYUl_T8G5a7gl5QgA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372433814.18733.335.camel@gandalf.local.home>
Subject: Re: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 28 Jun 2013 11:36:54 -0400
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443E0FE25@USINDEM103.corp.hds.com>
References: <51C8AA31.3070208@hds.com>
	 <1372429303.18733.325.camel@gandalf.local.home>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D443E0FE25@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 15:13 +0000, Seiji Aguchi wrote:

> OK.
> So,  ack_APIC_irq() and irq_enter() are needed.
> It can be shared with smp_call_function() and smp_call_function_single() like this.
> I will update the patch.
> 
> arch/x86/kernel/smp.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index f4fe0b8..732b618 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -265,23 +265,24 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
>  	 */
>  }
>  
> -void smp_trace_reschedule_interrupt(struct pt_regs *regs)
> +static inline void smp_entering_irq(void)
>  {
>  	ack_APIC_irq();
> +	irq_enter();
> +}
> +
> +void smp_trace_reschedule_interrupt(struct pt_regs *regs)
> +{

Sure, but we should probably add a comment here to why
smp_trace_reschedule_interrupt() is different than
smp_reschedule_interrupt().

	/*
	 * Need to call irq_enter() before calling the trace point.
	 * __smp_reschedule_interrupt() calls irq_enter/exit() too (in
	 * scheduler_ipi(). This is OK, since those functions are allowed
	 * to nest.
	 */

-- Steve

> +	smp_entering_irq();
>  	trace_reschedule_entry(RESCHEDULE_VECTOR);
>  	__smp_reschedule_interrupt();
>  	trace_reschedule_exit(RESCHEDULE_VECTOR);
> +	exiting_irq();
>  	/*
>  	 * KVM uses this interrupt to force a cpu out of guest mode
>  	 */
>  }
>  
> -static inline void call_function_entering_irq(void)
> -{
> -	ack_APIC_irq();
> -	irq_enter();
> -}
> -
>  static inline void __smp_call_function_interrupt(void)
>  {
>  	generic_smp_call_function_interrupt();
> @@ -290,14 +291,14 @@ static inline void __smp_call_function_interrupt(void)
>  
>  void smp_call_function_interrupt(struct pt_regs *regs)
>  {
> -	call_function_entering_irq();
> +	smp_entering_irq();
>  	__smp_call_function_interrupt();
>  	exiting_irq();
>  }
>  
>  void smp_trace_call_function_interrupt(struct pt_regs *regs)
>  {
> -	call_function_entering_irq();
> +	smp_entering_irq();
>  	trace_call_function_entry(CALL_FUNCTION_VECTOR);
>  	__smp_call_function_interrupt();
>  	trace_call_function_exit(CALL_FUNCTION_VECTOR);
> @@ -312,14 +313,14 @@ static inline void __smp_call_function_single_interrupt(void)
>  
>  void smp_call_function_single_interrupt(struct pt_regs *regs)
>  {
> -	call_function_entering_irq();
> +	smp_entering_irq();
>  	__smp_call_function_single_interrupt();
>  	exiting_irq();
>  }
>  
>  void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
>  {
> -	call_function_entering_irq();
> +	smp_entering_irq();
>  	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
>  	__smp_call_function_single_interrupt();
>  	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);


