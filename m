Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaCZHL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:11:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58256 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZHL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:11:56 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>
Subject: RE: [RFC 05/47] mtd: nand: stm_nand_bch: IRQ support for ST's BCH
 NAND Controller driver
Thread-Topic: [RFC 05/47] mtd: nand: stm_nand_bch: IRQ support for ST's BCH
 NAND Controller driver
Thread-Index: AQHPSAMXz0TwojICU0CUtaHDU/t8B5rxrI3w
Date: Wed, 26 Mar 2014 07:10:58 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAB5BCE@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-6-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1395735604-26706-6-git-send-email-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

>From: Lee Jones [mailto:lee.jones@linaro.org]
>Obtain IRQ number and request IRQ resource via the usual methods. We're
>also registering an IRQ handler to inform us of any completed tasks.
>Notice that we're starting to make use of the device struct that we
>defined before. In keeping with the subject of the patch, we're also
>adding the related local enable_irq() and disable_irq() methods. Again,
>these will be utilised in a greater capacity in latter commits.
>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
> drivers/mtd/nand/stm_nand_bch.c | 62 +++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 62 insertions(+)
>
>diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
>index bd11070..76a0d02 100644
>--- a/drivers/mtd/nand/stm_nand_bch.c
>+++ b/drivers/mtd/nand/stm_nand_bch.c
>@@ -15,11 +15,14 @@
> #include <linux/kernel.h>
> #include <linux/module.h>
> #include <linux/io.h>
>+#include <linux/interrupt.h>
> #include <linux/device.h>
> #include <linux/platform_device.h>
> #include <linux/completion.h>
> #include <linux/mtd/stm_nand.h>
>
>+#include "stm_nand_regs.h"
>+
> /* NANDi Controller (Hamming/BCH) */
> struct nandi_controller {
> 	void __iomem		*base;		/* Controller base*/
>@@ -54,6 +57,51 @@ struct nandi_controller {
> 						/* 'page_buf'             */
> };
>
>+/*
>+ * NANDi Interrupts (shared by Hamming and BCH controllers)
>+ */
>+static irqreturn_t nandi_irq_handler(int irq, void *dev)
>+{
>+	struct nandi_controller *nandi = dev;
>+	unsigned int status;
>+
>+	status = readl(nandi->base + NANDBCH_INT_STA);
>+
>+	if (status & NANDBCH_INT_SEQNODESOVER) {

You should also check, if BCH ECC mode is actually set to 
	struct nandi_controller *nandi = dev;
	if (nandi->bch_ecc_mode && (status & NANDBCH_INT_SEQNODESOVER)) {
>+		/* BCH */
>+		writel(NANDBCH_INT_CLR_SEQNODESOVER,
>+		       nandi->base + NANDBCH_INT_CLR);
>+		complete(&nandi->seq_completed);

At a given time only one of the two controllers (HAM/BCH) would be active. right ?
So, do don't need to check for both interrupts. you can return if either one is successful.
		return IRQ_HANDLED;  /* BCH ECC IRQ handles successfully */
>+	}

>+	if (status & NAND_INT_RBN) {
>+		/* Hamming */
>+		writel(NAND_INT_CLR_RBN, nandi->base + NANDHAM_INT_CLR);
>+		complete(&nandi->rbn_completed);
 -- same for this --
		return IRQ_HANDLED;   /* HAM ECC IRQ handled successfully */
>+	}
>+
>+	return IRQ_HANDLED;

And if no valid source is found then
	return IRQ_NONE;  /* spurious interrupt */

>+}
>+


with regards, pekon
