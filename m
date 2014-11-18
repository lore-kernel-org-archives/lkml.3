Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaKRKCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:02:19 -0500
Received: from www.linutronix.de ([62.245.132.108]:37834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaKRKCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:02:16 -0500
Date: Tue, 18 Nov 2014 11:02:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 04/16] genirq: Introduce irq_chip.irq_compose_msi_msg()
 to support stacked irqchip
In-Reply-To: <546B10D2.4050300@huawei.com>
Message-ID: <alpine.DEB.2.11.1411181059090.3909@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134120.137871641@linutronix.de> <546B10D2.4050300@huawei.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
> On 2014/11/12 21:42, Thomas Gleixner wrote:
> > +int irq_chip_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
> > +{
> > +	struct irq_data *pos = NULL;
> > +
> > +#ifdef	CONFIG_IRQ_DOMAIN_HIERARCHY
> > +	for (; data; data = data->parent_data)
> > +#endif
> > +		if (data->chip && data->chip->irq_compose_msi_msg)
> > +			pos = data;
> > +	if (!pos)
> > +		return -ENOSYS;
> > +
> > +	pos->chip->irq_compose_msi_msg(pos, msg);
> > +
> > +	return 0;
> > +}
> 
> Adding message composing routine to struct irq_chip is OK to me, and it should
> be because it is interrupt controllers' duty to compose messages (so that they
> can parse the messages correctly without any pre-defined rules that endpoint
> devices absolutely need not to know).
> However a problem comes out when deciding which parameters should be passed to
> this routine. A message can associate with multiple interrupts, which makes me
> think composing messages for each interrupt is not that appropriate. And we
> can take a look at the new routine irq_chip_compose_msi_msg(). It is called by
> msi_domain_activate() which will be called by irq_domain_activate_irq() in
> irq_startup() for each interrupt descriptor, result in composing a message for
> each interrupt, right? (Unless requiring a judge on the parameter @data when
> implementing the irq_compose_msi_msg() callback that only compose message for
> the first entry of that message. But I really don't like that...)

No, that's not correct. You are looking at some random stale version
of this. The current state of affairs is in 

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/irqdomain

See also https://lkml.org/lkml/2014/11/17/764

In activate we write the message, which is the right point to do so.

Thanks,

	tglx
