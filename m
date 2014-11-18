Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbaKRKTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:19:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:37912 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaKRKTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:19:12 -0500
Date: Tue, 18 Nov 2014 11:19:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 08/16] genirq: Introduce callback
 irq_chip.irq_write_msi_msg
In-Reply-To: <546B10DF.7020807@huawei.com>
Message-ID: <alpine.DEB.2.11.1411181103360.3909@nanos>
References: <20141112133941.647950773@linutronix.de> <20141112134120.474411359@linutronix.de> <546B10DF.7020807@huawei.com>
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
> On 2014/11/12 21:43, Thomas Gleixner wrote:
> >  struct irq_chip {
> > @@ -359,6 +360,7 @@ struct irq_chip {
> >  	void		(*irq_release_resources)(struct irq_data *data);
> >  
> >  	void		(*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg *msg);
> > +	void		(*irq_write_msi_msg)(struct irq_data *data, struct msi_msg *msg);
> 
> Hmm... It's really weird.
> I don't think it's the interrupt controllers' responsibility to write messages
> for all the endpoint devices since the methods of configuring message registers
> may different between these devices. And theoretically, the endpoint devices
> themselves should take the responsibility to configure their message registers.
> To say the least, the write_msg callback here still need to call some certain
> interfaces provided by the corresponding device.
>
> There would be lots of ARM new devices capable of sending message
> based interrupts to interrupt controllers, does all the drivers of
> the devices need to expose a write_msg callback to interrupt
> controllers?

Well, writing the message _IS_ part of the interrupt controller.

So in order to enable non PCI based MSI we want to have generic
infrastructure with minimal per device/device class callbacks and of
course you need to provide that callback for your special device.

We already have non PCI based MSI controllers in x86 today and we need
to handle the whole stuff with tons of copied coded extra for each of
those. So consolidating it into common infrastructure allows us to get
rid of the pointless copied code and reduce the per device effort to
the relevant hardware specific callbacks. irq_write_msi_msg being one
of those.

Thanks,

	tglx







