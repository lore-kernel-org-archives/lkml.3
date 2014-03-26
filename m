Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaCZKRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:17:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46651 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbaCZKRu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:17:50 -0400
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
Subject: RE: [RFC 23/47] mtd: nand: stm_nand_bch: read and write page (BCH)
Thread-Topic: [RFC 23/47] mtd: nand: stm_nand_bch: read and write page (BCH)
Thread-Index: AQHPSAMr05odAmsliUqmk9LWSNZ4qprzJb7Q
Date: Wed, 26 Mar 2014 10:17:08 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAB5CAC@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-24-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1395735604-26706-24-git-send-email-lee.jones@linaro.org>
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
>
>Use DMA to read and/or write a single page of data.
>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
> drivers/mtd/nand/stm_nand_bch.c | 119 ++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 119 insertions(+)
>
>diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
>index 7874d85..6323590 100644
>--- a/drivers/mtd/nand/stm_nand_bch.c
>+++ b/drivers/mtd/nand/stm_nand_bch.c
>@@ -21,6 +21,7 @@
> #include <linux/interrupt.h>
> #include <linux/device.h>
> #include <linux/platform_device.h>
>+#include <linux/dma-mapping.h>
> #include <linux/completion.h>
> #include <linux/mtd/nand.h>
> #include <linux/mtd/stm_nand.h>
>@@ -345,6 +346,124 @@ static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
> 	return zeros;
> }
>
>+/* Returns the number of ECC errors, or '-1' for uncorrectable error */
>+static int bch_read_page(struct nandi_controller *nandi,
>+			 loff_t offs,
>+			 uint8_t *buf)
>+{
>+	struct bch_prog *prog = &bch_prog_read_page;
>+	uint32_t page_size = nandi->info.mtd.writesize;
>+	unsigned long list_phys;
>+	unsigned long buf_phys;
>+	uint32_t ecc_err;
>+	int ret = 0;
>+
>+	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
>+
>+	BUG_ON((unsigned long)buf & (NANDI_BCH_DMA_ALIGNMENT - 1));
>+	BUG_ON(offs & (NANDI_BCH_DMA_ALIGNMENT - 1));
>+
>+	emiss_nandi_select(STM_NANDI_BCH);
>+
>+	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
>+	reinit_completion(&nandi->seq_completed);
>+
>+	/* Reset ECC stats */
>+	writel(CFG_RESET_ECC_ALL | CFG_ENABLE_AFM,
>+	       nandi->base + NANDBCH_CONTROLLER_CFG);
>+	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
>+
>+	prog->addr = (uint32_t)((offs >> (nandi->page_shift - 8)) & 0xffffff00);
>+
>+	buf_phys = dma_map_single(NULL, buf, page_size, DMA_FROM_DEVICE);
>+
>+	memset(nandi->buf_list, 0x00, NANDI_BCH_BUF_LIST_SIZE);
>+	nandi->buf_list[0] = buf_phys | (nandi->sectors_per_page - 1);
>+
>+	list_phys = dma_map_single(NULL, nandi->buf_list,
>+				   NANDI_BCH_BUF_LIST_SIZE, DMA_TO_DEVICE);
>+
>+	writel(list_phys, nandi->base + NANDBCH_BUFFER_LIST_PTR);
>+
>+	bch_load_prog_cpu(nandi, prog);
>+
>+	bch_wait_seq(nandi);
>+
>+	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
>+
>+	dma_unmap_single(NULL, list_phys, NANDI_BCH_BUF_LIST_SIZE,
>+			 DMA_TO_DEVICE);
>+	dma_unmap_single(NULL, buf_phys, page_size, DMA_FROM_DEVICE);
>+
>+	/* Use the maximum per-sector ECC count! */

Firstly, this ecc checking and correction should not be part of bch_read_page().
This should be part of chip->ecc.correct().
But, I don't see your driver using nand_chip->ecc interfaces.
Why do you want to break away from generic driver flow ? any controller limitation ?

I think much of the code in below patch can be reused from nand_base.c
	[RFC 43/47] mtd: nand: stm_nand_bch: read and write functions (BCH)


>+	ecc_err = readl(nandi->base + NANDBCH_ECC_SCORE_REG_A) & 0xff;
>+	if (ecc_err == 0xff) {
>+		/*
>+		 * Downgrade uncorrectable ECC error for an erased page,
>+		 * tolerating 'sectors_per_page' bits at zero.
>+		 */
>+		ret = check_erased_page(buf, page_size,
>+					nandi->sectors_per_page);

This is also not correct. Here 'max_zeros' should be ecc.strength


>+		if (ret >= 0)
>+			dev_dbg(nandi->dev,
>+				"%s: erased page detected: \n"
>+				"  downgrading uncorrectable ECC error.\n",
>+				__func__);
>+	} else {
>+		ret = (int)ecc_err;
>+	}
>+
>+	return ret;
>+}
>+

with regards, pekon
