Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbaJaOCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:02:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:41334 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060AbaJaOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:02:10 -0400
Date: Fri, 31 Oct 2014 15:00:50 +0100 (CET)
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
In-Reply-To: <54537AC7.90409@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1410311340000.5308@nanos>
References: <1414484803-10311-1-git-send-email-jiang.liu@linux.intel.com> <1414484803-10311-16-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1410282046120.5308@nanos> <54537AC7.90409@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Jiang Liu wrote:
> On 2014/10/29 5:37, Thomas Gleixner wrote:
> > Then it calls down the domain allocation chain. x86_msi_domain would
> > simply hand down to the parent domain. That would either be the remap
> > domain or the vector domain.
> The issue here is that, the hierarchy irqdomain maintains a tree
> topology and every irqdomain only supports one parent.
> 
> In case of irq remapping, we need to build one irqdomain for each IOMMU
> unit to support hotplug and simplify the implementation. So we need to
> build one MSI irqdomain for each IOMMU unit too instead of using a
> common MSI irqdomain.

That makes indeed a difference.
 
> Current design is that, a common MSI irqdomain to support all MSI when
> irq remapping is disabled, and one MSI irqdomain for each IOMMU unit
> when irq remapping is enabled.

> So we have the code below to choose the correct irqdomain for MSI.
>         domain = irq_remapping_get_irq_domain(&info);
>         if (domain == NULL)
>                 domain = msi_default_domain;
>         if (domain == NULL)
>                 return -ENOSYS;

Right. I guess we need to keep it that way for now.

But looking at the code makes me wonder why we actually need to call
into the remap code and do a list walk to figure the domain out. The
association of device and iommu should be known at startup/hotplug
time already. That's out of the scope of this work, but should be
fixed eventually.

Thanks,

	tglx




