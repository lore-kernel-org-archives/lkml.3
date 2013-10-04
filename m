Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3JDTvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:51:38 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:45553 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab3JDTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:51:36 -0400
Date: Fri, 4 Oct 2013 15:51:31 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Ben Dooks <ben-linux@fluff.org>, Tarek Dakhran <t.dakhran@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 3/6] ARM: EXYNOS: add Exynos Dual Cluster Support
In-Reply-To: <20131002125458.GA3407@localhost.localdomain>
Message-ID: <alpine.LFD.2.03.1310041543090.3023@syhkavp.arg>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com> <1380644227-12244-4-git-send-email-v.tyrtov@samsung.com> <20131002125458.GA3407@localhost.localdomain>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Oct 2013, Dave Martin wrote:

> On Tue, Oct 01, 2013 at 08:17:04PM +0400, Vyacheslav Tyrtov wrote:
> > +static int exynos_power_up(unsigned int cpu, unsigned int cluster)
> > +{
> > +     int ret;
> > +     local_irq_disable();
> 
> Should there be a local_fiq_disable() here also?

No.  In fact this is paired with

> > +     arch_spin_lock(&exynos_lock);

to create the equivalent of a arch_spin_lock_irq().  And the reason is:

/*
 * We can't use regular spinlocks. In the switcher case, it is possible
 * for an outbound CPU to call power_down() after its inbound counterpart
 * is already live using the same logical CPU number which trips lockdep
 * debugging.
 */

Otherwise we simply would have used spin_lock_irq().

No FIQs are supposed to ever race with this code.


Nicolas
