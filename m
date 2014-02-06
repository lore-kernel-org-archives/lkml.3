Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaBFTM6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:12:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbaBFTMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:12:53 -0500
Message-ID: <52F3DEA4.5090806@redhat.com>
Date: Thu, 06 Feb 2014 14:12:36 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, irq: get correct available vectors for cpu disable
References: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/28/2014 04:54 PM, Yinghai Lu wrote:
> used_vectors is a bitmap for vectors that are not tracked in per_cpu
> vector_irq.
> used_vectors contains information on the first 32 exceptions, the system vectors.
> the IA32_SYSCALL_VECTOR (0x80), and the IRQ_MOVE_CLEANUP_VECTOR (0x20).
> 
> assign_irq_vectors() assigns vectors up to first_system_vector and
> it will not use vectors that are set used_vectors.
> 
> This patch modifies the code to scan up to first_system_vector
> and do a test on the used_vectors bitmap.
> 
> So count avaiable vectors correctly.
> 
> -v2: fix compiling problem.
> -v3: update changelog and commets
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/irq.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/irq.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/irq.c
> +++ linux-2.6/arch/x86/kernel/irq.c
> @@ -17,6 +17,7 @@
>  #include <asm/idle.h>
>  #include <asm/mce.h>
>  #include <asm/hw_irq.h>
> +#include <asm/desc.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <asm/trace/irq_vectors.h>
> @@ -321,8 +322,21 @@ int check_irq_vectors_for_cpu_disable(vo
>  	for_each_online_cpu(cpu) {
>  		if (cpu == this_cpu)
>  			continue;
> -		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
> -		     vector++) {
> +
> +		/*
> +		 * assign_irq_vector() only scan per_cpu vectors from
> +		 * FIRST_EXTERNAL_VECTOR to first_system_vector.
> +		 * It aslo skip vectors that are set in used_vectors bitmask.

"also" ... but not a big deal IMO.

Reviewed-by: Prarit Bhargava <prarit@redhat.com>
Tested-by: Prarit Bhargava <prarit@redhat.com>

P.

> +		 * used_vectors could have bits set for
> +		 *	IA32_SYSCALL_VECTOR (0x80)
> +		 *	IRQ_MOVE_CLEANUP_VECTOR (0x20)
> +		 * Don't count those as available vectors.
> +		 */
> +		for (vector = FIRST_EXTERNAL_VECTOR;
> +		     vector < first_system_vector; vector++) {
> +			if (test_bit(vector, used_vectors))
> +				continue;
> +
>  			if (per_cpu(vector_irq, cpu)[vector] < 0)
>  				count++;
>  		}
