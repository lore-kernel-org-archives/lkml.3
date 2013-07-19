Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743Ab3GSP3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 11:29:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:50399 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3GSP3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 11:29:14 -0400
Date: Fri, 19 Jul 2013 17:29:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] irq: enable suspended EARLY_RESUME irqs forcefully if
 not resumed
In-Reply-To: <1373380343-10143-1-git-send-email-ldewangan@nvidia.com>
Message-ID: <alpine.DEB.2.02.1307191649080.4089@ionos.tec.linutronix.de>
References: <1373380343-10143-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jul 2013, Laxman Dewangan wrote:
> When system enters into suspend, it disable all irqs in single
> function call. This disables EARLY_RESUME irqs also along with
> normal irqs.
> 
> The EARLY_RESUME irqs get enabled in sys_core_ops->resume and
> non-EARLY_RESUME irqs get enabled in normal system resume path.
> 
> When suspend_noirq failed or suspend is aborted for any reason,
> the EARLY_RESUME irqs do not get enabled as sys_core_ops->resume()
> call did not happen. It only enables the non-EARLY_RESUME irqs in normal
> disable for remaining life of system.
> 
> Add checks on normal irq_resume() whether EARLY_RESUME irqs have been
> enabled or not and if not then enable it forcefully.
 
>  
> +static bool early_resume_irq_suspended;
> +

Instead of doing that status dance, we could simply reenable all
interrupts in irq_resume(). There's nothing wrong to unmask the few
IRQF_EARLY_RESUME interrupts again.

Just the XEN ones might be upset. Konrad ?

Thanks,

	tglx

Index: linux-2.6/kernel/irq/pm.c
===================================================================
--- linux-2.6.orig/kernel/irq/pm.c
+++ linux-2.6/kernel/irq/pm.c
@@ -50,7 +50,7 @@ static void resume_irqs(bool want_early)
 		bool is_early = desc->action &&
 			desc->action->flags & IRQF_EARLY_RESUME;
 
-		if (is_early != want_early)
+		if (!is_early && want_early)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
