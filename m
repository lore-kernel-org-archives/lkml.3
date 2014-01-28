Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaA1Sn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:43:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbaA1Sn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:43:26 -0500
Message-ID: <52E7FA3E.4000400@redhat.com>
Date: Tue, 28 Jan 2014 13:43:10 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2] x86, irq: get correct available vectors for cpu disable
References: <1390769416-2835-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1390769416-2835-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/26/2014 03:50 PM, Yinghai Lu wrote:
> assign_irq_vector will stop before first_system_vector.
> also it will not vector that is set in used_vectors.
> 
> used_vectors is used to track non per_cpu irq_vector in vector_irq.
> It include first 32 exception [0,1f) and system vector near 0xfe.
> and IA32_SYSCALL_VECTOR (0x80), IRQ_MOVE_CLEANUP_VECTOR (0x20).
> 
> So add checking for them for counting avaiable vectors.
> 

Yinghai, no objection to the patch ... but how about


used_vectors is a bitmap for global irqs; it tracks the non per_cpu
irq_vectors in vector_irq.  used_vectors contains information on the first 32
exceptions (0 to 0x1f), the system vectors near the first system vector
(0xfe), the IA32_SYSCALL_VECTOR (0x80), and the IRQ_MOVE_CLEANUP_VECTOR (0x20)

assign_irq_vectors() assigns vectors up to first_system_vector (0xfe) and
sets the used_vectors bit for each assigned vector.  Currently, the
IRQ checking code only scans from the FIRST_EXTERNAL_VECTOR to the end of
the vectors.  This patch modifies the code to scan to first_system_vector
and do a test on the used_vectors bitmap.


... and ...

> -v2: fix compiling problem.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/irq.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
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
> @@ -321,8 +322,19 @@ int check_irq_vectors_for_cpu_disable(vo
>  	for_each_online_cpu(cpu) {
>  		if (cpu == this_cpu)
>  			continue;
> -		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
> -		     vector++) {
> +
> +		/*
> +		 * assign_irq_vector() only use vector under
> +		 * first_system_vector and not set in used_vectors bitmask.
> +		 * used_vectors could have bits set for
> +		 *	IA32_SYSCALL_VECTOR (0x80)
> +		 *	IRQ_MOVE_CLEANUP_VECTOR (0x20)
> +		 */


+               /*
+                * assign_irq_vector() will only scan non per_cpu vectors from
+                * FIRST_EXTERNAL_VECTOR to first_system_vector (0xfe) and not
+                * set in used_vectors bitmask.  This takes into account
+                * the IA32_SYSCALL_VECTOR and the IRQ_MOVE_CLEANUP_VECTOR,
+                * which should not be counted.
+                */

... what do you think?

P.

> +		for (vector = FIRST_EXTERNAL_VECTOR;
> +		     vector < first_system_vector; vector++) {
> +			if (test_bit(vector, used_vectors))
> +				continue;
> +
>  			if (per_cpu(vector_irq, cpu)[vector] < 0)
>  				count++;
>  		}
