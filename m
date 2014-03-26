Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaCZHQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 03:16:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58449 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaCZHQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 03:16:29 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>,
        "Ezequiel Garcia (ezequiel.garcia@free-electrons.com)" 
	<ezequiel.garcia@free-electrons.com>
Subject: RE: [RFC 08/47] mtd: nand: stm_nand_bch: supply clock support
Thread-Topic: [RFC 08/47] mtd: nand: stm_nand_bch: supply clock support
Thread-Index: AQHPSAMaz1eiBWBtWUe2uuNiryMQw5ry2D1g
Date: Wed, 26 Mar 2014 07:15:55 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAB5BD9@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-9-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1395735604-26706-9-git-send-email-lee.jones@linaro.org>
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

>From: Lee Jones [mailto:lee.jones@linaro.org]
>
>Add support for clocks when, and only when, they are supplied. It is
>not yet compulsory to provide the BCH and EMI clocks, as Common Clk isn't
>supported Mainline yet. Until an implementation lands upstream all clocks
>located on STM boards default to always-on.
>
Good to put this information in comments tagged with "FixMe" at relevant place in the code.

>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
> drivers/mtd/nand/stm_nand_bch.c | 49 +++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 49 insertions(+)
>
>diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
>index 1a93f8d..cc0159e 100644
>--- a/drivers/mtd/nand/stm_nand_bch.c
>+++ b/drivers/mtd/nand/stm_nand_bch.c
>@@ -16,6 +16,7 @@
> #include <linux/module.h>
> #include <linux/delay.h>
> #include <linux/io.h>
>+#include <linux/clk.h>
> #include <linux/interrupt.h>
> #include <linux/device.h>
> #include <linux/platform_device.h>
>@@ -28,6 +29,9 @@
> struct nandi_controller {
> 	void __iomem		*base;		/* Controller base*/
> 	void __iomem		*dma;		/* DMA control base */
>+
>+	struct clk		*bch_clk;
>+	struct clk		*emi_clk;
> 						/* IRQ-triggered Completions: */
> 	struct completion	seq_completed;	/*   SEQ Over */
> 	struct completion	rbn_completed;	/*   RBn */
>@@ -103,6 +107,44 @@ static void nandi_disable_interrupts(struct nandi_controller *nandi,
> 	writel(val, nandi->base + NANDBCH_INT_EN);
> }
>
>+static void nandi_clk_enable(struct nandi_controller *nandi)
>+{
>+	if (nandi->emi_clk)
>+		clk_prepare_enable(nandi->emi_clk);
>+	if (nandi->bch_clk)
>+		clk_prepare_enable(nandi->bch_clk);
>+}
>+
You are using nandi_clk_enable() only in your PM patch.
So better introduce above functions there ..
	[RFC 11/47] mtd: nand: stm_nand_bch: add Power Management

Also, you have some un-related comment changes for nandi_clk_enable()
in below patch. All that can be merges into single one.
	[RFC 14/47] mtd: nand: stm_nand_bch: configure BCH and FLEX by ONFI timing mode


>+static void nandi_clk_disable(struct nandi_controller *nandi)
>+{
>+	if (nandi->emi_clk)
>+		clk_disable_unprepare(nandi->emi_clk);
>+	if (nandi->bch_clk)
>+		clk_disable_unprepare(nandi->bch_clk);
>+}
>+
same, please move this to
	[RFC 11/47] mtd: nand: stm_nand_bch: add Power Management

Also as Ezequiel suggested.
You can trim down the number of patches by submitting only the main portion
of driver first. PM other features can be added as separate patch-set.


with regards, pekon
