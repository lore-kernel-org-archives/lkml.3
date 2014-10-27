Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaJ0R1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:27:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaJ0R1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:27:34 -0400
Date: Mon, 27 Oct 2014 18:27:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v12 09/11] pvqspinlock, x86: Add para-virtualization
 support
Message-ID: <20141027172719.GK3337@twins.programming.kicks-ass.net>
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
 <1413483040-58399-10-git-send-email-Waiman.Long@hp.com>
 <20141024084738.GU21513@worktop.programming.kicks-ass.net>
 <544ABC47.2000700@hp.com>
 <20141024220423.GB10501@worktop.programming.kicks-ass.net>
 <544E7DC9.5020903@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544E7DC9.5020903@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 01:15:53PM -0400, Waiman Long wrote:
> On 10/24/2014 06:04 PM, Peter Zijlstra wrote:
> >On Fri, Oct 24, 2014 at 04:53:27PM -0400, Waiman Long wrote:
> >>The additional register pressure may just cause a few more register moves
> >>which should be negligible in the overall performance . The additional
> >>icache pressure, however, may have some impact on performance. I was trying
> >>to balance the performance of the pv and non-pv versions so that we won't
> >>penalize the pv code too much for a bit more performance in the non-pv code.
> >>Doing it your way will add a lot of function call and register
> >>saving/restoring to the pv code.
> >If people care about performance they should not be using virt crap :-)
> >
> >I only really care about bare metal.
> 
> Yes, I am aware of that. However, the whole point of doing PV spinlock is to
> improve performance in a virtual guest.

Anything that avoids the lock holder preemption nonsense is a _massive_
win for them, a few function calls should not even register on that
scale.

> +#ifdef _GEN_PV_LOCK_SLOWPATH
> +static void pv_queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
> +#else
>  void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
> +#endif

If you have two functions you might as well use the PV stuff to patch in
the right function call at the usage sites and avoid:

> +       if (pv_enabled()) {
> +               pv_queue_spin_lock_slowpath(lock, val);
> +               return;
> +       }

this alltogether.

>         this_cpu_dec(mcs_nodes[0].count);
>  }
>  EXPORT_SYMBOL(queue_spin_lock_slowpath);
> +
> +#if !defined(_GEN_PV_LOCK_SLOWPATH) && defined(CONFIG_PARAVIRT_SPINLOCKS)
> +/*
> + * Generate the PV version of the queue_spin_lock_slowpath function
> + */
> +#undef pv_init_node
> +#undef pv_wait_check
> +#undef pv_link_and_wait_node
> +#undef pv_wait_head
> +#undef EXPORT_SYMBOL
> +#undef in_pv_code
> +
> +#define _GEN_PV_LOCK_SLOWPATH
> +#define EXPORT_SYMBOL(x)
> +#define in_pv_code     return_true
> +#define pv_enabled     return_false
> +
> +#include "qspinlock.c"
> +
> +#endif

That's properly disgusting :-) But a lot better than actually
duplicating everything I suppose.
