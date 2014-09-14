Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaINL1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 07:27:35 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64368 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaINL1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 07:27:34 -0400
Message-ID: <54157BA0.2080800@linaro.org>
Date: Sun, 14 Sep 2014 12:27:28 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.17-rc4 v5 2/6] arm: fiq: Replace default FIQ handler
References: <1410272111-30516-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org> <20140912171404.GO12361@n2100.arm.linux.org.uk> <20140912171908.GP12361@n2100.arm.linux.org.uk> <20140912172337.GQ12361@n2100.arm.linux.org.uk>
In-Reply-To: <20140912172337.GQ12361@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 18:23, Russell King - ARM Linux wrote:
> On Fri, Sep 12, 2014 at 06:19:08PM +0100, Russell King - ARM Linux wrote:
>> On Fri, Sep 12, 2014 at 06:14:04PM +0100, Russell King - ARM Linux wrote:
>>> On Thu, Sep 11, 2014 at 12:31:14PM +0100, Daniel Thompson wrote:
>>>> This patch introduces a new default FIQ handler that is structured in a
>>>> similar way to the existing ARM exception handler and result in the FIQ
>>>> being handled by C code running on the SVC stack (despite this code run
>>>> in the FIQ handler is subject to severe limitations with respect to
>>>> locking making normal interaction with the kernel impossible).
>>>>
>>>> This default handler allows concepts that on x86 would be handled using
>>>> NMIs to be realized on ARM.
>>>
>>> Okay, lastly... I sent you my version of this change, which contained
>>> the changes I've detailed in the previous three emails, which are absent
>>> from your version.
>>>
>>> However, you've taken on board the "trace" thing to svc_entry, and
>>> renamed it to "call_trace".
>>>
>>> Now if I add this to usr_entry, "call_trace" doesn't make any sense,
>>> nor does the .if/.endif placement because it's not just trace_hardirqs_off
>>> which needs to be disabled there, but also ct_user_exit as well.
>>>
>>> I'm beginning to wonder why I tried to be nice here... it would've been
>>> a lot faster for me to take your patch, make my own changes and commit
>>> that instead.
>>>
>>> Frustrated.
>>
>> And another thing you're missing are the updates to arch/arm/kernel/fiq.c
>> to ensure that the FIQ registers are preserved when we restore this new
>> default FIQ handler.
> 
> Right, here's my remaining delta from your patch addressing all the points
> from the last five emails.  If you have any disagreements with any of these
> changes, then please discuss rather than choosing to ignore them.
> 
> 107e32b0b4ef5fa4191c9fc8415ca172b886e958
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index 0c70fee9a7c9..3f6293ce0f2d 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> <snip>
> @@ -736,13 +738,13 @@ ENDPROC(ret_from_exception)
>  
>  	.align	5
>  __fiq_usr:
> -	usr_entry
> +	usr_entry trace=0
>  	kuser_cmpxchg_check
>  	mov	r0, sp				@ struct pt_regs *regs
>  	bl	handle_fiq_as_nmi
>  	get_thread_info tsk
> -	mov	why, #0
> -	b	ret_to_user_from_irq
> +	restore_user_regs fast = 0, offset = 0
> + UNWIND(.cantunwind	)

.cantunwind is already provided by the usr_entry macro (also adding
.cantunwind here causes my assembler (2.24) to fail).


>   UNWIND(.fnend		)
>  ENDPROC(__fiq_usr)
>  
> diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
> index 918875d96d5d..1743049c433b 100644
> --- a/arch/arm/kernel/fiq.c
> +++ b/arch/arm/kernel/fiq.c
> @@ -53,6 +53,7 @@
>  	})
>  
>  static unsigned long no_fiq_insn;
> +static struct pt_regs def_fiq_regs;
>  
>  /* Default reacquire function
>   * - we always relinquish FIQ control
> @@ -60,8 +61,15 @@ static unsigned long no_fiq_insn;
>   */
>  static int fiq_def_op(void *ref, int relinquish)
>  {
> -	if (!relinquish)
> +	if (!relinquish) {
> +		/* Restore default handler and registers */
> +		local_fiq_disable();
> +		set_fiq_regs(&dfl_fiq_regs);
>  		set_fiq_handler(&no_fiq_insn, sizeof(no_fiq_insn));
> +		local_fiq_enable();
> +
> +		/* FIXME: notify irq controller to standard enable FIQs */
> +	}
>  
>  	return 0;
>  }
> @@ -151,5 +159,6 @@ void __init init_FIQ(int start)
>  {
>  	unsigned offset = FIQ_OFFSET;
>  	no_fiq_insn = *(unsigned long *)(0xffff0000 + offset);
> +	get_fiq_regs(&dfl_fiq_regs);
>  	fiq_start = start;
>  }
> 
> 

