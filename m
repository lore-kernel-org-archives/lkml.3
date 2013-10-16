Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760279Ab3JPIie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:38:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48681 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3JPIic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:38:32 -0400
Date: Wed, 16 Oct 2013 10:38:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH 3/6] mm: Use raw_cpu ops for determining current NUMA node
Message-ID: <20131016083813.GQ10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
 <20131015174746.244538146@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015174746.244538146@linux.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 12:47:25PM -0500, Christoph Lameter wrote:
> Index: linux/include/linux/topology.h
> ===================================================================
> --- linux.orig/include/linux/topology.h	2013-09-24 11:29:51.000000000 -0500
> +++ linux/include/linux/topology.h	2013-09-24 11:30:18.893831971 -0500
> @@ -182,7 +182,7 @@ DECLARE_PER_CPU(int, numa_node);
>  /* Returns the number of the current Node. */
>  static inline int numa_node_id(void)
>  {
> -	return __this_cpu_read(numa_node);
> +	return raw_cpu_read(numa_node);
>  }
>  #endif
>  
> @@ -239,7 +239,7 @@ static inline void set_numa_mem(int node
>  /* Returns the number of the nearest Node with memory */
>  static inline int numa_mem_id(void)
>  {
> -	return __this_cpu_read(_numa_mem_);
> +	return raw_cpu_read(_numa_mem_);
>  }
>  #endif

NAK; smp_processor_id() has the preemption checks; for consistently
numa_node_id() should have them too, for the very same reason. Who's to
say the node id is still valid when you return from this function? If
we're preemptable we could've just been migrated away to another node.

So please introduce raw_numa_node_id() and use that; all fully analogous
to smp_processor_id().
