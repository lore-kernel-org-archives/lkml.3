Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaCNRTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:19:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38542 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbaCNRTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:19:35 -0400
Date: Fri, 14 Mar 2014 17:19:22 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 2/6] pci: OF: Fix the conversion of IO ranges into IO
 resources.
Message-ID: <20140314171921.GY6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-3-git-send-email-Liviu.Dudau@arm.com>
 <201403141805.29204.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201403141805.29204.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 14 Mar 2014 17:19:33.0859 (UTC) FILETIME=[91685330:01CF3FA9]
X-MC-Unique: 114031417193207201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 05:05:28PM +0000, Arnd Bergmann wrote:
> On Friday 14 March 2014, Liviu Dudau wrote:
> > +int of_pci_range_to_resource(struct of_pci_range *range,
> > +       struct device_node *np, struct resource *res)
> > +{
> > +       res->flags = range->flags;
> > +       if (res->flags & IORESOURCE_IO) {
> > +               unsigned long port = -1;
> > +               int err = pci_register_io_range(range->cpu_addr, range->size);
> > +               if (err)
> > +                       return err;
> > +               port = pci_address_to_pio(range->cpu_addr);
> > +               if (port == (unsigned long)-1) {
> > +                       res->start = (resource_size_t)OF_BAD_ADDR;
> > +                       res->end = (resource_size_t)OF_BAD_ADDR;
> > +                       return -EINVAL;
> > +               }
> 
> The error handling is inconsistent here: in one case you set the resource
> to OF_BAD_ADDR, in the other one you don't.
> 
> 	Arnd
> 

You are right, that was lazy of me. What about this version?

8<----------------------------------------------------

>From acfd63b5c48b4a9066ab0b373633c5bb4feaadf5 Mon Sep 17 00:00:00 2001
From: Liviu Dudau <Liviu.Dudau@arm.com>
Date: Fri, 28 Feb 2014 12:40:46 +0000
Subject: [PATCH v7 2/6] pci: OF: Fix the conversion of IO ranges into IO
 resources.

The ranges property for a host bridge controller in DT describes
the mapping between the PCI bus address and the CPU physical address.
The resources framework however expects that the IO resources start
at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
The conversion from pci ranges to resources failed to take that into account.

In the process move the function into drivers/of/address.c as it now
depends on pci_address_to_pio() code and make it return an error message.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Tested-by: Tanmay Inamdar <tinamdar@apm.com>
---
 drivers/of/address.c       | 45 ++++++++++++++++++++++++++++++++++++
 include/linux/of_address.h | 13 ++---------
 2 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index be958ed..673c050 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -728,3 +728,48 @@ void __iomem *of_iomap(struct device_node *np, int index)
 	return ioremap(res.start, resource_size(&res));
 }
 EXPORT_SYMBOL(of_iomap);
+
+/**
+ * of_pci_range_to_resource - Create a resource from an of_pci_range
+ * @range:	the PCI range that describes the resource
+ * @np:		device node where the range belongs to
+ * @res:	pointer to a valid resource that will be updated to
+ *              reflect the values contained in the range.
+ *
+ * Returns EINVAL if the range cannot be converted to resource.
+ *
+ * Note that if the range is an IO range, the resource will be converted
+ * using pci_address_to_pio() which can fail if it is called too early or
+ * if the range cannot be matched to any host bridge IO space (our case here).
+ * To guard against that we try to register the IO range first.
+ * If that fails we know that pci_address_to_pio() will do too.
+ */
+int of_pci_range_to_resource(struct of_pci_range *range,
+	struct device_node *np, struct resource *res)
+{
+	res->flags = range->flags;
+	res->parent = res->child = res->sibling = NULL;
+	res->name = np->full_name;
+
+	if (res->flags & IORESOURCE_IO) {
+		unsigned long port = -1;
+		int err = pci_register_io_range(range->cpu_addr, range->size);
+		if (err)
+			goto invalid_range;
+		port = pci_address_to_pio(range->cpu_addr);
+		if (port == (unsigned long)-1) {
+			err = -EINVAL;
+			goto invalid_range;
+		}
+		res->start = port;
+	} else {
+		res->start = range->cpu_addr;
+	}
+	res->end = res->start + range->size - 1;
+	return 0;
+
+invalid_range:
+	res->start = (resource_size_t)OF_BAD_ADDR;
+	res->end = (resource_size_t)OF_BAD_ADDR;
+	return err;
+}
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 40c418d..a4b400d 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -23,17 +23,8 @@ struct of_pci_range {
 #define for_each_of_pci_range(parser, range) \
 	for (; of_pci_range_parser_one(parser, range);)
 
-static inline void of_pci_range_to_resource(struct of_pci_range *range,
-					    struct device_node *np,
-					    struct resource *res)
-{
-	res->flags = range->flags;
-	res->start = range->cpu_addr;
-	res->end = range->cpu_addr + range->size - 1;
-	res->parent = res->child = res->sibling = NULL;
-	res->name = np->full_name;
-}
-
+extern int of_pci_range_to_resource(struct of_pci_range *range,
+		struct device_node *np, struct resource *res);
 /* Translate a DMA address from device space to CPU space */
 extern u64 of_translate_dma_address(struct device_node *dev,
 				    const __be32 *in_addr);
-- 
1.9.0

>8--------------------------------------------------------

Best regards,
Liviu


-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

