Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3CFDyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 22:54:47 -0500
Received: from ozlabs.org ([203.10.76.45]:36191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3CFDyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 22:54:45 -0500
Date: Wed, 6 Mar 2013 14:54:43 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH 2/3] irq: Add hw continuous IRQs map to virtual
 continuous IRQs support
Message-ID: <20130306035443.GB3493@concordia>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
 <1358235536-32741-3-git-send-email-qiudayu@linux.vnet.ibm.com>
 <20130305022348.GB7656@concordia>
 <51359C9D.5030009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51359C9D.5030009@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 03:19:57PM +0800, Mike Qiu wrote:
> 于 2013/3/5 10:23, Michael Ellerman 写道:
> >On Tue, Jan 15, 2013 at 03:38:55PM +0800, Mike Qiu wrote:
> >>Adding a function irq_create_mapping_many() which can associate
> >>multiple MSIs to a continous irq mapping.
> >>
> >>This is needed to enable multiple MSI support for pSeries.
> >>
> >>Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
> >>---
> >>  include/linux/irq.h       |    2 +
> >>  include/linux/irqdomain.h |    3 ++
> >>  kernel/irq/irqdomain.c    |   61 +++++++++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 66 insertions(+), 0 deletions(-)
> >>
> >>diff --git a/include/linux/irq.h b/include/linux/irq.h
> >>index 60ef45b..e00a7ec 100644
> >>--- a/include/linux/irq.h
> >>+++ b/include/linux/irq.h
> >>@@ -592,6 +592,8 @@ int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
> >>  #define irq_alloc_desc_from(from, node)		\
> >>  	irq_alloc_descs(-1, from, 1, node)
> >>+#define irq_alloc_desc_n(nevc, node)		\
> >>+	irq_alloc_descs(-1, 0, nevc, node)
> >This has been superseeded by irq_alloc_descs_from(), which is the right
> >way to do it.

> Yes, but irq_alloc_descs_from() just for 1 irq

No it's not, look again.

#define irq_alloc_descs_from(from, cnt, node)   \
	irq_alloc_descs(-1, from, cnt, node)


> >>diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> >>index 96f3a1d..38648e6 100644
> >>--- a/kernel/irq/irqdomain.c
> >>+++ b/kernel/irq/irqdomain.c
> >>@@ -636,6 +636,67 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
> >>  }
> >>  EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
> >>+/**
> >>+ * irq_create_mapping_many - Map a range of hw IRQs to a range of virtual IRQs
> >>+ * @domain: domain owning the interrupt range
> >>+ * @hwirq_base: beginning of continuous hardware IRQ range
> >>+ * @count: Number of interrupts to map

> >For multiple-MSI the allocated interrupt numbers must be a power-of-2,
> >and must be naturally aligned. I don't /think/ that's a requirement for
> >the virtual numbers, but it's probably best that we do it anyway.
> >
> >So this API needs to specify that it will give you back a power-of-2
> >block that is naturally aligned - otherwise you can't use it for MSI.

> rtas_call will return the numbers of hardware interrupt, and it
> should be power-of-2, as this I think do not need to specify

You're confusing hardware interrupt numbers and virtual interrupt
numbers. My comment is about irq_create_mapping_many(), which returns
virtual interrupt numbers.

As I said I don't think there is a requirement that the virtual
interrupt numbers are also a power-of-2 naturally aligned block, but we
should allocate them as one anyway, to avoid any issues in future.

And so this API, which returns virtual interrupt numbers, must satisfy
that specification.

> >>+	/* Look for default domain if nececssary */
> >>+	if (!domain)
> >>+		domain = irq_default_domain;
> >>+	if (!domain) {
> >>+		pr_warn("irq_create_mapping called for NULL domain, hwirq=%lx\n"
> >>+			, hwirq_base);
> >>+		WARN_ON(1);
> >>+		return 0;
> >>+	}
> >>+	pr_debug("-> using domain @%p\n", domain);
> >>+
> >>+	/* For IRQ_DOMAIN_MAP_LEGACY, get the first virtual interrupt number */
> >>+	if (domain->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
> >>+		return irq_domain_legacy_revmap(domain, hwirq_base);
> >The above doesn't work.
> Why it doesn't work ?

Because irq_domain_legacy_revmap() only allocates a single interrupt
number.

> >>+	/* Check if mapping already exists */
> >>+	for (i = 0; i < count; i++) {
> >>+		virq = irq_find_mapping(domain, hwirq_base+i);
> >>+		if (virq) {
> >>+			pr_debug("existing mapping on virq %d,"
> >>+					" now dispose it first\n", virq);
> >>+			irq_dispose_mapping(virq);

> >You might have just disposed of someone elses mapping, we shouldn't do
> >that. It should be an error to the caller.

> It's a good question. If the interrupt used for someone elses, why I
> can apply it from the system?

I agree, that would be a bug. But disposing of someone elses mapping is
not OK.

> So it may someone else forget to dispose mapping, and it never be
> used for others as I have got the interrupt I think.

Perhaps, but that is a bug that needs to be fixed in the code that
forgets to dispose of the mapping.

cheers
