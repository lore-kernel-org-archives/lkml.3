Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3J3UQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:16:00 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44121 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3J3UP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:15:58 -0400
Date: Wed, 30 Oct 2013 13:15:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        gleb@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
Message-ID: <20131030201552.GP4126@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131030190929.GA7153@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030190929.GA7153@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103020-9332-0000-0000-000001FB4BA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 09:09:29PM +0200, Michael S. Tsirkin wrote:
> I noticed that srcu_read_lock/unlock both have a memory barrier,
> so just by moving srcu_read_unlock earlier we can get rid of
> one call to smp_mb().
> 
> Unsurprisingly, the gain is small but measureable using the unit test
> microbenchmark:
> before
> 	vmcall 1407
> after
> 	vmcall 1357
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> --
> 
> I didn't stress test this yet, sending out for early review/flames.
> 
> Paul, could you review this patch please?
> Documentation/memory-barriers.txt says that unlock has a weaker
> uni-directional barrier, but in practice srcu_read_unlock calls
> smp_mb().
> 
> Is it OK to rely on this? If not, can I add
> smp_mb__after_srcu_read_unlock (making it an empty macro for now)
> so we can avoid an actual extra smp_mb()?

Please use smp_mb__after_srcu_read_unlock().  After all, it was not
that long ago that srcu_read_unlock() contained no memory barriers,
and perhaps some day it won't need to once again.

							Thanx, Paul

> Thanks.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8617c9d..a48fb36 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5949,8 +5949,10 @@ restore:
> 
>  	/* We should set ->mode before check ->requests,
>  	 * see the comment in make_all_cpus_request.
> +	 *
> +	 * srcu_read_unlock below acts as a memory barrier.
>  	 */
> -	smp_mb();
> +	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> 
>  	local_irq_disable();
> 
> @@ -5960,12 +5962,11 @@ restore:
>  		smp_wmb();
>  		local_irq_enable();
>  		preempt_enable();
> +		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
>  		r = 1;
>  		goto cancel_injection;
>  	}
> 
> -	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> -
>  	if (req_immediate_exit)
>  		smp_send_reschedule(vcpu->cpu);
> 
> 
> -- 
> MST
> 

