Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaBFLlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:41:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62962 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755949AbaBFLlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:41:04 -0500
Date: Thu, 6 Feb 2014 11:41:02 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "paulus@samba.org" <paulus@samba.org>, "oleg@redhat.com" <oleg@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "walken@google.com" <walken@google.com>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 28/51] arm64, hw_breakpoint.c: Fix CPU hotplug callback
 registration
Message-ID: <20140206114102.GK26035@mudshark.cambridge.arm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220944.19080.26519.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205220944.19080.26519.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:09:45PM +0000, Srivatsa S. Bhat wrote:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:

[...]

> Fix the hw-breakpoint code in arm64 by using this latter form of callback
> registration.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  arch/arm64/kernel/hw_breakpoint.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
> index f17f581..24e88d0 100644
> --- a/arch/arm64/kernel/hw_breakpoint.c
> +++ b/arch/arm64/kernel/hw_breakpoint.c
> @@ -913,6 +913,8 @@ static int __init arch_hw_breakpoint_init(void)
>  	pr_info("found %d breakpoint and %d watchpoint registers.\n",
>  		core_num_brps, core_num_wrps);
>  
> +	cpu_maps_update_begin();
> +
>  	/*
>  	 * Reset the breakpoint resources. We assume that a halting
>  	 * debugger will leave the world in a nice state for us.
> @@ -927,7 +929,10 @@ static int __init arch_hw_breakpoint_init(void)
>  			      TRAP_HWBKPT, "hw-watchpoint handler");
>  
>  	/* Register hotplug notifier. */
> -	register_cpu_notifier(&hw_breakpoint_reset_nb);
> +	__register_cpu_notifier(&hw_breakpoint_reset_nb);
> +
> +	cpu_maps_update_done();
> +
>  	/* Register cpu_suspend hw breakpoint restore hook */
>  	cpu_suspend_set_dbg_restorer(hw_breakpoint_reset);

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
