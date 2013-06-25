Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3FYCIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 22:08:47 -0400
Received: from ozlabs.org ([203.10.76.45]:56329 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab3FYCIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 22:08:45 -0400
Date: Tue, 25 Jun 2013 12:08:42 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Ian Munsie <imunsie@au1.ibm.com>
Subject: Re: [PATCH 40/45] powerpc, irq: Use GFP_ATOMIC allocations in atomic
 context
Message-ID: <20130625020842.GD14051@concordia>
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com>
 <20130623134657.19094.93687.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623134657.19094.93687.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 07:17:00PM +0530, Srivatsa S. Bhat wrote:
> The function migrate_irqs() is called with interrupts disabled
> and hence its not safe to do GFP_KERNEL allocations inside it,
> because they can sleep. So change the gfp mask to GFP_ATOMIC.

OK so it gets there via:
  __stop_machine()
    take_cpu_down()
      __cpu_disable()
        smp_ops->cpu_disable()
          generic_cpu_disable()
            migrate_irqs()

> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index ea185e0..ca39bac 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -412,7 +412,7 @@ void migrate_irqs(void)
>  	cpumask_var_t mask;
>  	const struct cpumask *map = cpu_online_mask;
>  
> -	alloc_cpumask_var(&mask, GFP_KERNEL);
> +	alloc_cpumask_var(&mask, GFP_ATOMIC);

We're not checking for allocation failure, which we should be.

But this code is only used on powermac and 85xx, so it should probably
just be a TODO to fix this up to handle the failure.

cheers
