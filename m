Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaKRA7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:59:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:36575 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaKRA7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:59:41 -0500
Date: Tue, 18 Nov 2014 01:59:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Patch V3 0/9] Refine generic/PCI MSI irqodmian interfaces
In-Reply-To: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411180133130.3909@nanos>
References: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Jiang Liu wrote:
> This patch set is based on tip/irq/irqdomain and tries to refine
> interfaces to support irqdomain for generic MSI and PCI MSI.

So to make progress on that matter I picked that up along with a few
other patches which affect the core code (more stacked irq callbacks
and Marcs workaround for the handler assignment issue).

I rebased the whole lot on Bjorns pci/msi branch as discussed in this
thread: https://lkml.org/lkml/2014/11/16/292

After that I spent quite some time to reorder and fold back patches so
we have no obvious wreckage, but at the same time preserve at least
some of the development process for this.

Finally I added docbook comments where missing (please provide them
next time yourself).

Marc ran an initial smoketest on an early iteration which did not fall
into bits and pieces right away.

The only major change is that I got rid of the ugly

#ifndef msi_alloc_info_t

trickery by moving the generic version into include/asm-generic/msi.h

So if you want to use the generic version, you need to create your
arch/xxx/include/asm/msi.h file which includes asm-generic/msi.h.

For the ones who want to override it, create
arch/xxx/include/asm/msi.h, include whatever it takes and provide the
proper typedef.

I'll send that patch (7bde31a7969f) out tomorrow morning as I want to
have Arnds blessing for that.

That all is available in

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/irqdomain

Note, that the branch has been rebased and is still not considered to
be immutable.

So while I sorted out the pci related process with Bjorn, here is the
process for this and the depending arch/xxx bits and pieces:

1) If the current content of the irq/irqdomain branch in tip does not
   raise eyebrows and does not require any conceptual fixups within 24
   hrs from now, then I'm going to declare it immutable, merge it
   into next and let the arch folks depend on it.

2) If after that any updates to the core irq/pci/msi code are required
   they need to go through that branch first unless they are agreed on
   to be arch/xxx specific and can go through a different tree which
   is the only one which requires that.

I really rely on your cooperation here, as I don't want to end up with
an unexplainable mess when the stuff hits Linus tree and he starts
rumaging for his diving harpune ....

Find below the commit list based on commit c167caf8d174: PCI/MSI:
Remove useless bus->msi assignment in Bjorns pci/msi branch.

Thanks,

	tglx
---
2d294376193f: PCI/MSI: Allow an msi_chip to be associated to an irq domain
4888af47f51a: PCI/MSI: Provide mechanism to alloc/free MSI/MSIX interrupt from irqdomain
f15c6d33c218: PCI/MSI: Enhance core to support hierarchy irqdomain
1a91b4fb79a2: PCI/MSI: Move cached entry functions to irq core
c0b4a8942b6c: genirq: Provide default callbacks for msi_domain_ops
473e759918d2: genirq: Introduce msi_domain_alloc/free_irqs()
7bde31a7969f: asm-generic: Add msi.h
8c507b885ec3: genirq: Add generic msi irq domain support
f49d8e21319f: genirq: Introduce callback irq_chip.irq_write_msi_msg
0ac68de4f9c7: genirq: Work around __irq_set_handler vs stacked domains ordering issues
153a2674ebe9: irqdomain: Introduce helper function irq_domain_add_hierarchy()
5b15d50cfaa8: irqdomain: Implement a method to automatically call parent domains alloc/free
de81049f177d: genirq: Introduce helper irq_domain_set_info() to reduce duplicated code
5447cf75ebba: genirq: Split out flow handler typedefs into seperate header file
5d7a3e203c54: genirq: Add IRQ_SET_MASK_OK_DONE to support stacked irqchip
fb3577cf30b4: genirq: Introduce irq_chip.irq_compose_msi_msg() to support stacked irqchip
61454f3977d2: genirq: Add more helper functions to support stacked irq_chip
79d4a9783265: genirq: Introduce helper functions to support stacked irq_chip
df333db2e20a: irqdomain: Do irq_find_mapping and set_type for hierarchy irqdomain in case OF
3f4cac0a4ea8: irqdomain: Introduce new interfaces to support hierarchy irqdomains
f9e2d8740075: PCI/MSI: Introduce helpers to hide struct msi_desc implementation details
33190dab3a59: PCI/MSI: Rename write_msi_msg() to pci_write_msi_msg()
1da7e00b1f73: PCI/MSI: Rename __read_msi_msg() to __pci_read_msi_msg()
b9191cbef61f: PCI/MSI: Kill redundant call of irq_set_msi_desc() for MSI-X interrupts
dbcb4c926ece: PCI/MSI: Simplify PCI MSI code by initializing msi_desc.nvec_used earlier
6cf585318fde: PCI/MSI: Remove unnecessary braces around single statements
