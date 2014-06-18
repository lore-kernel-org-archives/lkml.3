Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966311AbaFRMFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966020AbaFRMFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:05:20 -0400
Message-ID: <53A1804C.4070304@redhat.com>
Date: Wed, 18 Jun 2014 14:04:28 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Waiman.Long@hp.com,
        tglx@linutronix.de, mingo@kernel.org
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/11] qspinlock: Paravirt support
References: <20140615124657.264658593@chello.nl> <20140615130154.213923590@chello.nl>
In-Reply-To: <20140615130154.213923590@chello.nl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/06/2014 14:47, Peter Zijlstra ha scritto:
>
>
>  #if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
>
> -#define	queue_spin_unlock queue_spin_unlock
>  /**
>   * queue_spin_unlock - release a queue spinlock
>   * @lock : Pointer to queue spinlock structure
>   *
>   * An effective smp_store_release() on the least-significant byte.
>   */
> -static inline void queue_spin_unlock(struct qspinlock *lock)
> +static inline void native_queue_unlock(struct qspinlock *lock)
>  {
>  	barrier();
>  	ACCESS_ONCE(*(u8 *)lock) = 0;
>  }
>
> +#else
> +
> +static inline void native_queue_unlock(struct qspinlock *lock)
> +{
> +	atomic_dec(&lock->val);
> +}
> +
>  #endif /* !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE */


Should be (part of) an earlier patch?  Also, does it get wrong if 
(CONFIG_X86_OOSTORE || CONFIG_X86_PPRO_FENCE) && paravirt patches the 
unlock to a single movb?  Of course the paravirt spinlocks could simply 
depend on !CONFIG_X86_OOSTORE && !CONFIG_X86_PPRO_FENCE.

> +
> +#define INVALID_HEAD	-1
> +#define NO_HEAD		nr_cpu_ids
> +

-2, like Waiman said.

Paolo
