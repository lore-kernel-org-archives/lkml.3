Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaJ2JUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:20:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:55024 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbaJ2JT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:19:57 -0400
Date: Wed, 29 Oct 2014 10:19:15 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, x86@kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: [Patch Part2 v3 15/24] x86, MSI: Use hierarchy irqdomain to
 manage MSI interrupts
In-Reply-To: <5450A9D8.108@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1410291017180.5308@nanos>
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com> <1414484803-10311-16-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1410282046120.5308@nanos> <5450A9D8.108@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Jiang Liu wrote:
> On 2014/10/29 5:37, Thomas Gleixner wrote:
> > On Tue, 28 Oct 2014, Jiang Liu wrote:
> >> +static int msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
> >> +			    bool force)
> >> +{
> >> +	struct irq_data *parent = data->parent_data;
> >> +	int ret;
> >>  
> >> -	msg.data &= ~MSI_DATA_VECTOR_MASK;
> >> -	msg.data |= MSI_DATA_VECTOR(cfg->vector);
> >> -	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
> >> -	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
> >> +	ret = parent->chip->irq_set_affinity(parent, mask, force);
> >> +	/* No need to reprogram MSI registers if interrupt is remapped */
> >> +	if (ret >= 0 && !msi_irq_remapped(data)) {
> >> +		struct msi_msg msg;
> >>  
> >> -	__write_msi_msg(data->msi_desc, &msg);
> >> +		__get_cached_msi_msg(data->msi_desc, &msg);
> >> +		msi_update_msg(&msg, data);
> >> +		__write_msi_msg(data->msi_desc, &msg);
> >> +	}
> > 
> > I'm not too happy about the msi_irq_remapped() conditional here. It
> > violates the whole concept of domain stacking somewhat.
> > 
> > A better separation would be to add a callback to the irq chip:
> > 
> >   	void (*irq_write_msi_msg)(struct irq_data *data, struct msi_desc *msi_desc, bool cached);
> > 
> > and change this code to:
> > 
> >     	if (ret >= 0)
> > 	   	parent->chip->irq_write_msi_msg(parent, data->msi-desc, true);
> >   
> Hi Thomas,
> 	Thanks for your great suggestion and I have worked out a draft
> patch to achieve what you want:)
> 	I have made following changes to irq core to get rid of remapped
> irq logic from msi.c:
> 1) Add IRQ_SET_MASK_OK_DONE in addition to IRQ_SET_MASK_OK and
> IRQ_SET_MASK_OK_NOCOPY. IRQ_SET_MASK_OK_DONE is the same as
> IRQ_SET_MASK_OK for irq core and indicates to stacked irqchip that
> parent irqchips have done all work and skip any handling in descendant
> irqchips.
> 2) Add int (*irq_compose_msi_msg)(struct irq_data *data, struct msi_msg
> *msg) into struct irq_chip. I'm still hesitating to return void or int
> here. By returning void, irq_chip_compose_msi_msg() will be simpler,
> but it loses flexibility.

void should be sufficient. If the chip advertises this function it
better can provide a proper msi msg :)
 
> With above changes to core, we could remove all knowledge of irq
> remapping from msi.c and the irq remapping interfaces get simpler too.
> Please refer to following patch for details. The patch passes basic
> booting tests with irq remapping enabled. If it's OK, I will fold
> it into the patch set.

Yes. That looks reasonable. 
 
> IOAPIC runs into the same situation, but I need some more time
> to find a solution:)

I'm sure you will!

Thanks,

	tglx
