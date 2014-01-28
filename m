Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaA1Rqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:46:51 -0500
Received: from smtp.citrix.com ([66.165.176.89]:47086 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbaA1Rqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:46:50 -0500
X-IronPort-AV: E=Sophos;i="4.95,737,1384300800"; 
   d="scan'208";a="97355130"
Date: Tue, 28 Jan 2014 17:46:44 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@linaro.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "patches@linaro.org" <patches@linaro.org>,
        <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH] arm/xen: Initialize event channels earlier
In-Reply-To: <52E7EA78.5020305@linaro.org>
Message-ID: <alpine.DEB.2.02.1401281742080.4373@kaball.uk.xensource.com>
References: <1390920842-21886-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1401281651400.4373@kaball.uk.xensource.com> <52E7EA78.5020305@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Julien Grall wrote:
> >> +static int xen_cpu_notification(struct notifier_block *self,
> >> +				unsigned long action,
> >> +				void *hcpu)
> >> +{
> >> +	int cpu = (long)hcpu;
> >> +
> >> +	switch (action) {
> >> +	case CPU_UP_PREPARE:
> >> +		xen_percpu_init(cpu);
> >> +		break;
> >> +	case CPU_STARTING:
> >> +		xen_interrupt_init();
> >> +		break;
> > 
> > Is CPU_STARTING guaranteed to be called on the new cpu only?
> 
> Yes.
> 
> > If so, why not call both xen_percpu_init and xen_interrupt_init on
> > CPU_STARTING?
> 
> Just in case that xen_vcpu is used somewhere else by a cpu notifier
> callback CPU_STARTING. We don't know which callback is called first.

Could you please elaborate a bit more on the problem you are trying to
describe?


> > As it stands I think you introduced a subtle change (that might be OK
> > but I think is unintentional): xen_percpu_init might not be called from
> > the same cpu as its target anymore.
> 
> No, xen_percpu_init and xen_interrupt_init are called on the boot cpu at
> the end of xen_guest_init.
 
Is CPU_UP_PREPARE guaranteed to be called on the target cpu? I think
not, therefore you would be executing xen_percpu_init for cpu1 on cpu0.
