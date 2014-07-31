Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaGaRpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:45:51 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54924 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaGaRpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:45:49 -0400
Message-ID: <53DA80C8.90002@gmail.com>
Date: Thu, 31 Jul 2014 20:45:44 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>, pbonzini@redhat.com
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Remove redundant and incorrect cpl check on
 task-switch
References: <1406703436-9920-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1406703436-9920-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing the kvm mailing list that was mistakenly omitted.

On 7/30/14 9:57 AM, Nadav Amit wrote:
> Task-switch emulation checks the privilage level prior to performing the
> task-switch.  This check is incorrect in the case of task-gates, in which the
> tss.dpl is ignored, and can cause superfluous exceptions.  Moreover this check
> is unnecassary, since the CPU checks the privilage levels prior to exiting.
> Intel SDM 25.4.2 says "If CALL or JMP accesses a TSS descriptor directly
> outside IA-32e mode, privilege levels are checked on the TSS descriptor" prior
> to exiting.  AMD 15.14.1 says "The intercept is checked before the task switch
> takes place but after the incoming TSS and task gate (if one was involved) have
> been checked for correctness."
> 
> This patch removes the CPL checks for CALL and JMP.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/emulate.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 56657b0..a9b2bd6 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2698,7 +2698,8 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
>  	 *
>  	 * 1. jmp/call/int to task gate: Check against DPL of the task gate
>  	 * 2. Exception/IRQ/iret: No check is performed
> -	 * 3. jmp/call to TSS: Check against DPL of the TSS
> +	 * 3. jmp/call to TSS/task-gate: No check is performed since the
> +	 *    hardware checks it before exiting.
>  	 */
>  	if (reason == TASK_SWITCH_GATE) {
>  		if (idt_index != -1) {
> @@ -2715,13 +2716,8 @@ static int emulator_do_task_switch(struct x86_emulate_ctxt *ctxt,
>  			if ((tss_selector & 3) > dpl || ops->cpl(ctxt) > dpl)
>  				return emulate_gp(ctxt, (idt_index << 3) | 0x2);
>  		}
> -	} else if (reason != TASK_SWITCH_IRET) {
> -		int dpl = next_tss_desc.dpl;
> -		if ((tss_selector & 3) > dpl || ops->cpl(ctxt) > dpl)
> -			return emulate_gp(ctxt, tss_selector);
>  	}
>  
> -
>  	desc_limit = desc_limit_scaled(&next_tss_desc);
>  	if (!next_tss_desc.p ||
>  	    ((desc_limit < 0x67 && (next_tss_desc.type & 8)) ||
> 
