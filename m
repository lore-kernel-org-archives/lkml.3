Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3JBNHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:07:17 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52366 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753507Ab3JBNHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:07:12 -0400
Date: Wed, 2 Oct 2013 14:05:50 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 3/6] ARM: EXYNOS: add Exynos Dual Cluster Support
Message-ID: <20131002130550.GB3407@localhost.localdomain>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
 <1380644227-12244-4-git-send-email-v.tyrtov@samsung.com>
 <alpine.LFD.2.03.1310011451390.21228@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1310011451390.21228@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 03:55:24PM -0400, Nicolas Pitre wrote:
> On Tue, 1 Oct 2013, Vyacheslav Tyrtov wrote:
> 
> > From: Tarek Dakhran <t.dakhran@samsung.com>

[...]

> > +	kfs_use_count[cpu][cluster]++;
> > +	if (kfs_use_count[cpu][cluster] == 1) {
> > +		++core_count[cluster];
> > +		if (core_count[cluster] == 1) {
> > +			ret = exynos_cluster_power_up(cluster);
> > +			if (ret) {
> > +				pr_err("%s: cluster %u power up error\n",
> > +					__func__, cluster);
> > +				return ret;
> > +			}
> > +			__cci_control_port_by_index(MAX_NR_CLUSTERS
> > +					 - cluster, true);
> 
> This is wrong and very racy.  The state machine implemented in 
> mcpm-head.S is there already to handle proper synchronization for you.  

Maybe this issue didn't make itself obvious yet due to the lack of
suspend support.

Moving the CCI maintenance to power_up_setup() is essential for suspend/
resume to work, because then CPUs can power up randomly in response to
interrupts -- exynos_lock is not sufficient protection in that case.

The TC2 code should provide a good example of what to do.

[...]

Cheers
---Dave
