Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaJBQju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:39:50 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54077 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaJBQjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:39:48 -0400
Message-ID: <542D7FC9.4080205@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2014 22:09:37 +0530
From: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 2/3] powerpc/kvm/book3s_hv: Enable CPUs to run guest
 after waking up from fast-sleep
References: <1412149560-2953-1-git-send-email-shreyas@linux.vnet.ibm.com> <1412149560-2953-3-git-send-email-shreyas@linux.vnet.ibm.com>
In-Reply-To: <1412149560-2953-3-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100216-0009-0000-0000-000000614453
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing Rafael J. Wysocki and linux-pm@vger.kernel.org

On Wednesday 01 October 2014 01:15 PM, Shreyas B. Prabhu wrote:
> When guests have to be launched, the secondary threads which are offline
> are woken up to run the guests. Today these threads wake up from nap
> and check if they have to run guests. Now that the offline secondary
> threads can go to fastsleep or going ahead a deeper idle state such as winkle,
> add this check in the wakeup from any of the deep idle states path as well.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: linuxppc-dev@lists.ozlabs.org
> Suggested-by: "Srivatsa S. Bhat" <srivatsa@mit.edu>
> Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
> [ Changelog added by <preeti@linux.vnet.ibm.com> ]
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
>  arch/powerpc/kernel/exceptions-64s.S | 35 ++++++++++++++++-------------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index 050f79a..c64f3cc0 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -100,25 +100,8 @@ system_reset_pSeries:
>  	SET_SCRATCH0(r13)
>  #ifdef CONFIG_PPC_P7_NAP
>  BEGIN_FTR_SECTION
> -	/* Running native on arch 2.06 or later, check if we are
> -	 * waking up from nap. We only handle no state loss and
> -	 * supervisor state loss. We do -not- handle hypervisor
> -	 * state loss at this time.
> -	 */
> -	mfspr	r13,SPRN_SRR1
> -	rlwinm.	r13,r13,47-31,30,31
> -	beq	9f
> 
> -	/* waking up from powersave (nap) state */
> -	cmpwi	cr1,r13,2
> -	/* Total loss of HV state is fatal, we could try to use the
> -	 * PIR to locate a PACA, then use an emergency stack etc...
> -	 * OPAL v3 based powernv platforms have new idle states
> -	 * which fall in this catagory.
> -	 */
> -	bgt	cr1,8f
>  	GET_PACA(r13)
> -
>  #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
>  	li	r0,KVM_HWTHREAD_IN_KERNEL
>  	stb	r0,HSTATE_HWTHREAD_STATE(r13)
> @@ -131,13 +114,27 @@ BEGIN_FTR_SECTION
>  1:
>  #endif
> 
> +	/* Running native on arch 2.06 or later, check if we are
> +	 * waking up from nap. We only handle no state loss and
> +	 * supervisor state loss. We do -not- handle hypervisor
> +	 * state loss at this time.
> +	 */
> +	mfspr	r13,SPRN_SRR1
> +	rlwinm.	r13,r13,47-31,30,31
> +	beq	9f
> +
> +	/* waking up from powersave (nap) state */
> +	cmpwi	cr1,r13,2
> +	GET_PACA(r13)
> +
> +	bgt	cr1,8f
> +
>  	beq	cr1,2f
>  	b	power7_wakeup_noloss
>  2:	b	power7_wakeup_loss
> 
>  	/* Fast Sleep wakeup on PowerNV */
> -8:	GET_PACA(r13)
> -	b 	power7_wakeup_tb_loss
> +8:	b 	power7_wakeup_tb_loss
> 
>  9:
>  END_FTR_SECTION_IFSET(CPU_FTR_HVMODE | CPU_FTR_ARCH_206)
> 

