Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaK0VpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:45:08 -0500
Received: from www.linutronix.de ([62.245.132.108]:58954 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaK0VpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:45:07 -0500
Date: Thu, 27 Nov 2014 22:45:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3.18-rc4 v11 3/6] irqchip: gic: Make gic_raise_softirq
 FIQ-safe
In-Reply-To: <1417119024-22844-4-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.DEB.2.11.1411272238190.3961@nanos>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1417119024-22844-1-git-send-email-daniel.thompson@linaro.org> <1417119024-22844-4-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Daniel Thompson wrote:
> It is currently possible for FIQ handlers to re-enter gic_raise_softirq()
> and lock up.
> 
>     	gic_raise_softirq()
> 	   lock(x);
> -~-> FIQ
>         handle_fiq()
> 	   gic_raise_softirq()
> 	      lock(x);		<-- Lockup
> 
> Calling printk() from a FIQ handler can trigger this problem because
> printk() raises an IPI when it needs to wake_up_klogd(). More generally,
> IPIs are the only means for FIQ handlers to safely defer work to less
> restrictive calling context so the function to raise them really needs
> to be FIQ-safe.

That's not really true. irq_work can be used from FIQ/NMI context and
it was specifically designed for that purpose.
 
Now printk is a different issue, but there is work in progress to make
printk safe from FIQ/NMI context as well. This is not an ARM specific
issue. Any architecture which has NMI like facilities has the problem
of doing printk from that context. Steven is working on a mitigation
for that. https://lkml.org/lkml/2014/11/18/1146

Thanks,

	tglx


