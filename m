Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbaCYUEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:04:08 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:6126 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaCYUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:04:06 -0400
Date: Tue, 25 Mar 2014 14:03:52 -0600
From: Linn Crosetto <linn@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86, irq: get correct available vectors for cpu
 disable
Message-ID: <20140325200352.GU31785@oranje.fc.hp.com>
References: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390946045-2769-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch.

On Tue, Jan 28, 2014 at 01:54:05PM -0800, Yinghai Lu wrote:
> used_vectors is a bitmap for vectors that are not tracked in per_cpu
> vector_irq.

I feel like this comment (also in the code) could be misleading because vectors
above first_system_vector are effectively not tracked in per_cpu vector_irq, but
also may not have the bit set in used_vectors. For example, used_vectors from a
system that I am looking at now:

first_system_vector
                239                  255
                  |                  |
                  10 01000 11111 11111

test_bit(240, used_vectors) does not return the correct answer to the question
about whether the vector is tracked in per_cpu vector_irq. This leads to two
meanings for the bitmap; for vectors less than first_system_vector whether or
not they are tracked in per_cpu vector_irq, and for vectors above
first_system_vector, whether or not they are in use:

static inline int is_per_cpu_vector(int vector) {
	return !test_bit(vector, used_vectors) &&
			vector < first_system_vector;
}

Thanks,
Linn

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
