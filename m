Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbaKTJmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:42:02 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:46667 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751161AbaKTJl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:41:59 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v7 1/4] irqchip: gic: Support hierarchy irq domain.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux- arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1416455840.12869.17.camel@mtksdaap41>
References: <1416406451-4578-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1416406451-4578-2-git-send-email-yingjoe.chen@mediatek.com>
	 <87h9xvaz2p.fsf@approximate.cambridge.arm.com>
	 <1416455840.12869.17.camel@mtksdaap41>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Nov 2014 17:41:51 +0800
Message-ID: <1416476511.12869.24.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Marc,

On Thu, 2014-11-20 at 11:57 +0800, Yingjoe Chen wrote:
> On Wed, 2014-11-19 at 17:18 +0000, Marc Zyngier wrote:
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static const struct irq_domain_ops gic_irq_domain_hierarchy_ops = {
> > > +	.xlate = gic_irq_domain_xlate,
> > > +	.alloc = gic_irq_domain_alloc,
> > > +	.free = irq_domain_free_irqs_top,
> > 
> > I'm convinced that irq_domain_free_irqs_top is the wrong function to
> > call here, because you're calling it from the bottom, not the top-level
> > (it has no parent).
> 
> Base on the name, I though this is helper function for top level
> irq_domain?
> 
> > I cannot verify this with your code as I don't a working platform with
> > GICv2m, but if I enable something similar on GICv3, it dies a very
> > painful way:
> > 
> > Unable to handle kernel NULL pointer dereference at virtual address 00000018
> > pgd = ffffffc03d059000
> > [00000018] *pgd=0000000081356003, *pud=0000000081356003, *pmd=0000000000000000
> > Internal error: Oops: 96000006 [#1] SMP
> > Modules linked in:
> > CPU: 4 PID: 1052 Comm: sh Not tainted 3.18.0-rc4+ #3311
> > task: ffffffc03e320000 ti: ffffffc001390000 task.ti: ffffffc001390000
> > PC is at irq_domain_free_irqs_recursive+0x1c/0x80
> > LR is at irq_domain_free_irqs_common+0x88/0x9c
> > pc : [<ffffffc0000ed790>] lr : [<ffffffc0000ede20>] pstate: 60000145
> > [...]
> > [<ffffffc0000ed790>] irq_domain_free_irqs_recursive+0x1c/0x80
> > [<ffffffc0000ede1c>] irq_domain_free_irqs_common+0x84/0x9c
> > [<ffffffc0000ede98>] irq_domain_free_irqs_top+0x64/0x7c  <-- gic_domain.free()
> > [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
> > [<ffffffc0000ee468>] irq_domain_free_irqs_parent+0x14/0x20
> > [<ffffffc0003500b8>] its_irq_domain_free+0xc8/0x250
> > [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
> > [<ffffffc0000ede1c>] irq_domain_free_irqs_common+0x84/0x9c
> > [<ffffffc0000ede98>] irq_domain_free_irqs_top+0x64/0x7c
> > [<ffffffc0000ef518>] msi_domain_free+0x70/0x88
> > [<ffffffc0000ed798>] irq_domain_free_irqs_recursive+0x24/0x80
> > [<ffffffc0000ee3ac>] irq_domain_free_irqs+0x108/0x17c
> > [<ffffffc0000efb68>] msi_domain_free_irqs+0x28/0x4c
> > [<ffffffc000369cac>] free_msi_irqs+0xb4/0x1c0
> > [<ffffffc00036adec>] pci_disable_msix+0x3c/0x4c
> > [...]
> > 
> > and I cannot see how this could work on the standard GIC either.
> 
> I'm sorry, I just realize my testcase was too simple, irqs are populated
> by device tree and never got freed. I'll add that and test it again.

On a second thoughts, unlike the MSI cases, gic_irq_domain_hierarchy_ops
is only used when we use DT, so we probably will never use the free
function. Is it OK to remove the free support here?

Joe.C


