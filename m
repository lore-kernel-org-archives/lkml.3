Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbaJXIry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:47:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbaJXIru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:47:50 -0400
Date: Fri, 24 Oct 2014 10:47:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
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
Message-ID: <20141024084738.GU21513@worktop.programming.kicks-ass.net>
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com>
 <1413483040-58399-10-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413483040-58399-10-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 02:10:38PM -0400, Waiman Long wrote:
> +static inline void pv_init_node(struct mcs_spinlock *node)
> +{
> +	struct pv_qnode *pn = (struct pv_qnode *)node;
> +
> +	BUILD_BUG_ON(sizeof(struct pv_qnode) > 5*sizeof(struct mcs_spinlock));
> +
> +	if (!pv_enabled())
> +		return;
> +
> +	pn->cpustate = PV_CPU_ACTIVE;
> +	pn->mayhalt  = false;
> +	pn->mycpu    = smp_processor_id();
> +	pn->head     = PV_INVALID_HEAD;
> +}


> @@ -333,6 +393,7 @@ queue:
>  	node += idx;
>  	node->locked = 0;
>  	node->next = NULL;
> +	pv_init_node(node);
>  
>  	/*
>  	 * We touched a (possibly) cold cacheline in the per-cpu queue node;


So even if !pv_enabled() the compiler will still have to emit the code
for that inline, which will generate additional register pressure,
icache pressure and lovely stuff like that.

The patch I had used pv-ops for these things that would turn into NOPs
in the regular case and callee-saved function calls for the PV case.

That still does not entirely eliminate cost, but does reduce it
significant. Please consider using that.
