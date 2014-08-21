Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaHUJsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:48:14 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:56488 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753444AbaHUJsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:48:11 -0400
Date: Thu, 21 Aug 2014 10:47:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v5] irqchip: gic: Allow gic_arch_extn hooks to call
	into scheduler
Message-ID: <20140821094759.GK30401@n2100.arm.linux.org.uk>
References: <1408562561-10424-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408562561-10424-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 12:22:41PM -0700, Stephen Boyd wrote:
> @@ -605,7 +615,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	int cpu;
>  	unsigned long flags, map = 0;
>  
> -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
> +	sgi_map_lock(flags);
>  
>  	/* Convert our logical CPU mask into a physical one. */
>  	for_each_cpu(cpu, mask)
> @@ -620,7 +630,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	/* this always happens on GIC0 */
>  	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
>  
> -	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
> +	sgi_map_unlock(flags);

What would make more sense is if this were a read-write lock, then
gic_raise_softirq() could run concurrently on several CPUs without
interfering with each other, yet still be safe with gic_migrate_target().

I'd then argue that we wouldn't need the ifdeffery, we might as well
keep the locking in place - it's overhead is likely small (when lockdep
is disabled) when compared to everything else which goes on in this
path.

> @@ -690,6 +700,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
>  	ror_val = (cur_cpu_id - new_cpu_id) & 31;
>  
>  	raw_spin_lock(&irq_controller_lock);
> +	raw_spin_lock(&gic_sgi_lock);
>  
>  	/* Update the target interface for this logical CPU */
>  	gic_cpu_map[cpu] = 1 << new_cpu_id;
> @@ -709,6 +720,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
>  		}
>  	}
>  
> +	raw_spin_unlock(&gic_sgi_lock);
>  	raw_spin_unlock(&irq_controller_lock);

I would actually suggest we go a bit further.  Use gic_sgi_lock to only
lock gic_cpu_map[] itself, and not have it beneath any other lock.
That's an advantage because right now, lockdep learns from the above that
there's a dependency between irq_controller_lock and gic_sgi_lock.
Reasonably keeping lock dependencies to a minimum is always a good idea.

The places where gic_cpu_map[] is used are:

static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
                            bool force)
{
...
        raw_spin_lock(&irq_controller_lock);
        mask = 0xff << shift;
        bit = gic_cpu_map[cpu] << shift;
        val = readl_relaxed(reg) & ~mask;
        writel_relaxed(val | bit, reg);
        raw_spin_unlock(&irq_controller_lock);

So, we can move:

        mask = 0xff << shift;
        bit = gic_cpu_map[cpu] << shift;

out from under irq_controller_lock and put it under gic_sgi_lock.  The
"mask" bit doesn't need to be under any lock at all.

There's gic_cpu_init():

        cpu_mask = gic_get_cpumask(gic);
        gic_cpu_map[cpu] = cpu_mask;

        /*
         * Clear our mask from the other map entries in case they're
         * still undefined.
         */
        for (i = 0; i < NR_GIC_CPU_IF; i++)
                if (i != cpu)
                        gic_cpu_map[i] &= ~cpu_mask;

which better had be stable after boot - if not, this needs locking.
Remember that the above will be called on hotplug too.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
