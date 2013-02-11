Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3BKGTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:19:52 -0500
Received: from ozlabs.org ([203.10.76.45]:53411 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3BKGTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:19:50 -0500
Date: Mon, 11 Feb 2013 17:19:49 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        grant.likely@secretlab.ca
Subject: Re: [BUG] irq_dispose_mapping after irq request failure
Message-ID: <20130211061949.GA5561@concordia>
References: <20130211053100.GB18462@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211053100.GB18462@sapphire.tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 07:31:00AM +0200, Baruch Siach wrote:
> Hi lkml,

Hi Baruch,

> The drivers/edac/mpc85xx_edac.c driver contains the following (abbreviated)
> code snippet it its .probe:

You dropped an important detail which is the preceeding line:

	pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);

> 		res = devm_request_irq(&op->dev, pdata->irq,
> 				       mpc85xx_pci_isr, IRQF_DISABLED,
> 				       "[EDAC] PCI err", pci);
> 		if (res < 0) {
> 			irq_dispose_mapping(pdata->irq);
> 			goto err2;
> 		}
> 
> Now, since the requested irq is already in use, and IRQF_SHARED is not set,
> devm_request_irq errors() out, which is OK. Less OK is the
> irq_dispose_mapping() call, which gives me this:
> 
> EDAC PCI1: Giving out device to module 'MPC85xx_edac' controller 'mpc85xx_pci_err': DEV 'ffe0a000.pcie' (INTERRUPT)
> genirq: Flags mismatch irq 16. 00000020 ([EDAC] PCI err) vs. 00000020 ([EDAC] PCI err)

The hint here is to notice which other irq you're clashing with          ^^
ie. yourself. Which is odd, that is the root of the problem.

The badness you're getting from irq_dispose_mapping() is caused because you're
disposing of that mapping which is currently still in use, by the same interrupt.

That is caused by a "feature" in the irq mapping code, where if you ask to map an
already mapped hwirq, it will give you back the same virq. So in your case when
you called irq_of_parse_and_map() it noticed that someone had already mapped
that hwirq, and gave you back an existing (in use) virq.

> mpc85xx_pci_err_probe: Unable to requiest irq 16 for MPC85xx PCI err
                                       ^
While you're there, can you fix the typo :)


> So, is irq_dispose_mapping() the right thing to do when irq request fails?

It's the right thing to do to undo the effect of irq_create_mapping(), or in your case irq_of_parse_and_map().

It just falls down in this case, because you're inadvertently disposing of something that's still in use.

> A simple grep shows that irq_dispose_mapping() calls are mostly limited to
> powerpc code. Is there a reason for that?

That's because the irq domain code began life as powerpc specific code. It's now become generic and will start to appear in more places.

cheers
