Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3EMNEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:04:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:47477 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3EMNEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:04:01 -0400
Date: Mon, 13 May 2013 15:03:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robin Holt <holt@sgi.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Full dynticks needs evtdesc set before marking cpu online.
In-Reply-To: <20130513125514.GE3658@sgi.com>
Message-ID: <alpine.LFD.2.02.1305131501210.2863@ionos>
References: <20130508235736.GT3658@sgi.com> <alpine.LFD.2.02.1305131119180.2863@ionos> <20130513125514.GE3658@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Robin Holt wrote:

> On Mon, May 13, 2013 at 11:21:00AM +0200, Thomas Gleixner wrote:
> > On Wed, 8 May 2013, Robin Holt wrote:
> > 
> > > Thomas,
> > > 
> > > We are seeing failures booting medium sized machines which I think is
> > > a change in expectations that dyntick put on x86's start_secondary.
> > > 
> > > During boot of cpus, we see an occassional panic in tick_do_broadcast at
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/1305.0/01818.html
> > 
> > Will hit Linus tree soon.
> 
> I think this is really due to a sequence in start_secondary.  The cpu
> has been marked as online, but its evtdesc has not been initialized.
> I sent a followup to this with a hack/patch.

No, the real issue is that I messed up the cpumask conversion in the
broadcast code, i.e. using alloc instead of zalloc, which allocated
nonzeroed memory for the cpumasks, so any random bit set will crash
the machine. Your patch is just papering over the issue.

 
> It was essentially:
> --- linux.orig/arch/x86/kernel/smpboot.c
> +++ linux/arch/x86/kernel/smpboot.c
> @@ -264,6 +264,8 @@ notrace static void __cpuinit start_seco
>          */
>         check_tsc_sync_target();
>  
> +       x86_cpuinit.setup_percpu_clockev();
> +
>         /*
>          * We need to hold vector_lock so there the set of online cpus
>          * does not change while we are assigning vectors to cpus.  Holding
> @@ -281,8 +283,6 @@ notrace static void __cpuinit start_seco
>         /* to prevent fake stack check failure in clock setup */
>         boot_init_stack_canary();
>  
> -       x86_cpuinit.setup_percpu_clockev();
> -
>         wmb();
>         cpu_startup_entry(CPUHP_ONLINE);
>  }
> 
> 
> Robin
> 
