Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3CFFmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:42:09 -0500
Received: from ozlabs.org ([203.10.76.45]:34588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3CFFmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:42:06 -0500
Date: Wed, 6 Mar 2013 16:42:03 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH 2/3] irq: Add hw continuous IRQs map to virtual
 continuous IRQs support
Message-ID: <20130306054203.GA13075@concordia>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
 <1358235536-32741-3-git-send-email-qiudayu@linux.vnet.ibm.com>
 <20130305022348.GB7656@concordia>
 <51359C9D.5030009@linux.vnet.ibm.com>
 <20130306035443.GB3493@concordia>
 <5136D582.80101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5136D582.80101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 01:34:58PM +0800, Mike Qiu wrote:
> 于 2013/3/6 11:54, Michael Ellerman 写道:
> >On Tue, Mar 05, 2013 at 03:19:57PM +0800, Mike Qiu wrote:
> >>于 2013/3/5 10:23, Michael Ellerman 写道:
> >>>On Tue, Jan 15, 2013 at 03:38:55PM +0800, Mike Qiu wrote:
> >>>>diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> >>>>index 96f3a1d..38648e6 100644
> >>>>--- a/kernel/irq/irqdomain.c
> >>>>+++ b/kernel/irq/irqdomain.c
> >>>>@@ -636,6 +636,67 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
> >>>>  }
> >>>>  EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
> >>>>+/**
> >>>>+ * irq_create_mapping_many - Map a range of hw IRQs to a range of virtual IRQs
> >>>>+ * @domain: domain owning the interrupt range
> >>>>+ * @hwirq_base: beginning of continuous hardware IRQ range
> >>>>+ * @count: Number of interrupts to map
> >>>For multiple-MSI the allocated interrupt numbers must be a power-of-2,
> >>>and must be naturally aligned. I don't /think/ that's a requirement for
> >>>the virtual numbers, but it's probably best that we do it anyway.
> >>>
> >>>So this API needs to specify that it will give you back a power-of-2
> >>>block that is naturally aligned - otherwise you can't use it for MSI.
> >>rtas_call will return the numbers of hardware interrupt, and it
> >>should be power-of-2, as this I think do not need to specify
> >You're confusing hardware interrupt numbers and virtual interrupt
> >numbers. My comment is about irq_create_mapping_many(), which returns
> >virtual interrupt numbers.
> >
> >As I said I don't think there is a requirement that the virtual
> >interrupt numbers are also a power-of-2 naturally aligned block, but we
> >should allocate them as one anyway, to avoid any issues in future.

> But for virtual interrupt numbersit should be a power-of-2 naturally
> aligned block, because it must be continuous, as the MSI-HOWTO.txt says:
> 
>     4.2.2 pci_enable_msi_block
>     int pci_enable_msi_block(struct pci_dev *dev, int count)
>     This variation on the above call allows a device driver to request
>     multiple MSIs.  The MSI specification only allows interrupts to be
>     allocated in powers of two, up to a maximum of 2^5 (32).
>     If this function returns 0, it has succeeded in allocating at least
>     as many interrupts as the driver requested
>     (it may have allocated more in order to satisfy the power-of-two
>     requirement). In this case, the function enables MSI on this device
>     and updates dev->irq to be the lowest of the new interrupts
>     assigned to it. The other interrupts assigned to the device are in
>     the range dev->irq to dev->irq + count - 1.
> 
> See the last line, that means for the virtual interrupts must be a
> continuous block.

In practice I think things could work if we didn't, because we are not
using the mask routines that assume that layout.

But you're right, we must implement the API as it's specified, so the
virtual interrupt numbers must be a naturally aligned power-of-2.

cheers
