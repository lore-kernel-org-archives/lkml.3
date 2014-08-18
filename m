Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbaHRARL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 20:17:11 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:34481 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaHRARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 20:17:08 -0400
Date: Sun, 17 Aug 2014 20:17:05 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Jason Cooper <jason@lakedaemon.net>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
In-Reply-To: <20140817214123.GY30401@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1408172005070.29347@knanqh.ubzr>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org> <20140817173236.GG12769@titan.lakedaemon.net> <20140817185522.GX30401@n2100.arm.linux.org.uk> <20140817190434.GJ12769@titan.lakedaemon.net> <20140817214123.GY30401@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2014, Russell King - ARM Linux wrote:

> On Sun, Aug 17, 2014 at 03:04:34PM -0400, Jason Cooper wrote:
> > Quoting Nico:
> > 
> > "Of course it would be good to clarify things wrt Russell's remark
> > independently from this patch."
> > 
> > I took 'independently' to mean "This patch is ok, *and* we need to
> > address Russell's concerns in a follow-up patch."
> > 
> > Nico's Reviewed-by with that comment was sent August 13th.  The most
> > recent activity on this thread was also August 13th.  After four days, I
> > reasoned there were no objections to his comment.
> 
> Right, during the merge window, and during merge windows, I tend to
> ignore almost all email now because people don't stop developing, and
> they don't take any notice where the mainline cycle is.  In fact, I go
> off and do non-kernel work during a merge window and only briefly scan
> for bug fixes.
> 
> However, I have other concerns with this patch, which I've yet to air.
> For example, I don't like this crappy conditional locking that people
> keep dreaming up - that kind of stuff makes the kernel much harder to
> statically check that everything is correct.  It's an anti-lockdep
> strategy.
> 
> Secondly, I don't like this:
> 
> +       raw_spin_lock(&gic_sgi_lock);
> +       /*
> +        * Ensure that the gic_cpu_map update above is seen in
> +        * gic_raise_softirq() before we redirect any pending SGIs that
> +        * may have been raised for the outgoing CPU (cur_cpu_id)
> +        */
> +       smp_mb__after_unlock_lock();
> +       raw_spin_unlock(&gic_sgi_lock);
> 
> That goes against the principle of locking, that you lock the data,
> not the code.

I admit I didn't understand the point of that construct on the first 
read.  Maybe I wouldn't be the only one.  Using Stephen's initial 
version for that hunk would be preferable as it is straight forward and 
would mean locking the data instead.

> I have no problem with changing gic_raise_softirq() to use a different
> lock, which gic_migrate_target(), and gic_set_affinity() can also use.
> There's no need for horrid locking here, because the only thing we're
> protecting is gic_map[] and the write to the register to trigger an
> IPI - and nothing using gic_arch_extn has any business knowing about
> SGIs.
> 
> No need for these crappy sgi_map_lock() macros and all the ifdeffery.

Those macros are there only to conditionalize the locking in 
gic_raise_softirq() because no locking what so ever is needed there when 
gic_migrate_target() is configured out.  I suggested the macros to cut 
down on the #ifdefery in the code.


Nicolas
