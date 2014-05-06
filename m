Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935038AbaEFLJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:09:01 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:51958 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934798AbaEFLI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:08:58 -0400
Date: Tue, 6 May 2014 07:08:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: lkml <linux-kernel@vger.kernel.org>, x86-ml <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.com>,
        Mike Galbraith <mgalbraith@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Slow down stupid pounders
Message-ID: <20140506070854.757fd3ea@gandalf.local.home>
In-Reply-To: <20140506102924.GA25013@pd.tnic>
References: <20140506102924.GA25013@pd.tnic>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 12:29:24 +0200
Borislav Petkov <bp@alien8.de> wrote:

> Hi,
> 
> so I'm getting sick'n'tired of all those bug reports of people pounding
> cpu hotplug with stupid scripts.
> 
> * We know cpu hotplug is fragile/buggy/crap/needs proper rewrite.
> 
> * Stupid hotplugging script doesn't resemble any real use case - go use
> a real benchmark/stress test to trigger bugs.
> 
> So if we can't make pounders stop jerking off, let's make it
> uninterestingly slow. Stupid patch below, it might be completely idiotic
> to do it this way but at least starts the discussion about this being a
> really annoying issue which needs some sort of dealing with.

Hey, I'm one of those that jerk off to CPU hotplug stress test scripts!

> 
> I dunno, we can make it configurable (which will probably defeat its
> purpose partially), we can do some more fancy ratelimiting, per cpu,
> whatever... we'll see.
> 
> Opinions, flames?

We were just bitching about this yesterday, but -rt related. As
anything crap in mainline just becomes exponentially more crap in -rt.
The CPU hotplug case becomes a mountain of crap that we just dig
tunnels through to get by.

A while ago Thomas had a proof of concept patch I believe that was
suppose to pick up traction but unfortunately never went anywhere, even
after being told it would.

The real option is to rewrite cpu hotplug.

-- Steve


> 
> ---
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 006b1bc5297d..615c7af767ed 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -40,6 +40,11 @@ static void change_cpu_under_node(struct cpu *cpu,
>  	cpu->node_id = to_nid;
>  }
>  
> +static void delay_hotplug(void)
> +{
> +	schedule_timeout_uninterruptible(msecs_to_jiffies(MSEC_PER_SEC));
> +}
> +
>  static int __ref cpu_subsys_online(struct device *dev)
>  {
>  	struct cpu *cpu = container_of(dev, struct cpu, dev);
> @@ -47,6 +52,8 @@ static int __ref cpu_subsys_online(struct device *dev)
>  	int from_nid, to_nid;
>  	int ret;
>  
> +	delay_hotplug();
> +
>  	from_nid = cpu_to_node(cpuid);
>  	if (from_nid == NUMA_NO_NODE)
>  		return -ENODEV;
> @@ -65,6 +72,8 @@ static int __ref cpu_subsys_online(struct device *dev)
>  
>  static int cpu_subsys_offline(struct device *dev)
>  {
> +	delay_hotplug();
> +
>  	return cpu_down(dev->id);
>  }
>  
> 

