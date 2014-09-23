Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaIWIUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:20:13 -0400
Received: from ozlabs.org ([103.22.144.67]:59863 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbaIWIUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:20:10 -0400
Date: Tue, 23 Sep 2014 18:20:07 +1000
From: Anton Blanchard <anton@samba.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/iommu/ddw: Fix endianness
Message-ID: <20140923182007.5d682c11@kryten>
In-Reply-To: <1411437529-6126-1-git-send-email-aik@ozlabs.ru>
References: <1411437529-6126-1-git-send-email-aik@ozlabs.ru>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Alexey,

> ddw_avail is a pointer to the "ibm,ddw-applicable" property which
> contains 3 cells which are big-endian as it is a device tree.
> rtas_call() accepts a RTAS token in CPU-endian. This converts RTAS
> tokens from big-endian to CPU-endian. Since every token is used once
> till guest is rebooted, there is no much sense in caching RTAS tokens
> in CPU-endian.

I see a few sparse endian warnings with this. This patch (that applies
on top of yours) uses of_property_read_u32_array to byte swap and avoid
the need for a number of be32_to_cpu calls.

Can you verify this works and then fold it into yours? Also mark it for
inclusion in stable v3.13+.

You can add:

Reviewed-by: Anton Blanchard <anton@samba.org>

Thanks!
Anton

Index: b/arch/powerpc/platforms/pseries/iommu.c
===================================================================
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -725,16 +725,18 @@ static void remove_ddw(struct device_nod
 {
 	struct dynamic_dma_window_prop *dwp;
 	struct property *win64;
-	const u32 *ddw_avail;
+	u32 ddw_avail[3];
 	u64 liobn;
-	int len, ret = 0;
+	int ret = 0;
+
+	ret = of_property_read_u32_array(np, "ibm,ddw-applicable",
+					 &ddw_avail[0], 3);
 
-	ddw_avail = of_get_property(np, "ibm,ddw-applicable", &len);
 	win64 = of_find_property(np, DIRECT64_PROPNAME, NULL);
 	if (!win64)
 		return;
 
-	if (!ddw_avail || len < 3 * sizeof(u32) || win64->length < sizeof(*dwp))
+	if (ret || win64->length < sizeof(*dwp))
 		goto delprop;
 
 	dwp = win64->value;
@@ -750,7 +752,7 @@ static void remove_ddw(struct device_nod
 		pr_debug("%s successfully cleared tces in window.\n",
 			 np->full_name);
 
-	ret = rtas_call(be32_to_cpu(ddw_avail[2]), 1, 1, NULL, liobn);
+	ret = rtas_call(ddw_avail[2], 1, 1, NULL, liobn);
 	if (ret)
 		pr_warning("%s: failed to remove direct window: rtas returned "
 			"%d to ibm,remove-pe-dma-window(%x) %llx\n",
@@ -841,7 +843,7 @@ static int query_ddw(struct pci_dev *dev
 		cfg_addr = edev->pe_config_addr;
 	buid = edev->phb->buid;
 
-	ret = rtas_call(be32_to_cpu(ddw_avail[0]), 3, 5, (u32 *)query,
+	ret = rtas_call(ddw_avail[0], 3, 5, (u32 *)query,
 		  cfg_addr, BUID_HI(buid), BUID_LO(buid));
 	dev_info(&dev->dev, "ibm,query-pe-dma-windows(%x) %x %x %x"
 		" returned %d\n", ddw_avail[0], cfg_addr, BUID_HI(buid),
@@ -872,7 +874,7 @@ static int create_ddw(struct pci_dev *de
 
 	do {
 		/* extra outputs are LIOBN and dma-addr (hi, lo) */
-		ret = rtas_call(be32_to_cpu(ddw_avail[1]), 5, 4, (u32 *)create,
+		ret = rtas_call(ddw_avail[1], 5, 4, (u32 *)create,
 				cfg_addr, BUID_HI(buid), BUID_LO(buid),
 				page_shift, window_shift);
 	} while (rtas_busy_delay(ret));
@@ -911,7 +913,7 @@ static u64 enable_ddw(struct pci_dev *de
 	int page_shift;
 	u64 dma_addr, max_addr;
 	struct device_node *dn;
-	const u32 *uninitialized_var(ddw_avail);
+	u32 ddw_avail[3];
 	struct direct_window *window;
 	struct property *win64;
 	struct dynamic_dma_window_prop *ddwprop;
@@ -943,8 +945,9 @@ static u64 enable_ddw(struct pci_dev *de
 	 * for the given node in that order.
 	 * the property is actually in the parent, not the PE
 	 */
-	ddw_avail = of_get_property(pdn, "ibm,ddw-applicable", &len);
-	if (!ddw_avail || len < 3 * sizeof(u32))
+	ret = of_property_read_u32_array(pdn, "ibm,ddw-applicable",
+					 &ddw_avail[0], 3);
+	if (ret)
 		goto out_failed;
 
        /*
