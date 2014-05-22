Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaEVSFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:05:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50079 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbaEVSFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:05:34 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>
Subject: RE: [PATCH 04/47] mtd: nand: adding ST's BCH NAND Controller driver
Thread-Topic: [PATCH 04/47] mtd: nand: adding ST's BCH NAND Controller driver
Thread-Index: Ac916FY8LxdTVO2nQxaGJSNVNO8KzQ==
Date: Thu, 22 May 2014 18:04:59 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAD8267@DBDE04.ent.ti.com>
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

>From: Lee Jones
>
>First introduction of the driver. Includes the basic device struct
>(some functionality isn't utilised as of yet) and supplies some of the
>important resources required for basic running of the Controller.
>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
>--- /dev/null
>+++ b/drivers/mtd/nand/stm_nand_bch.c
[...]
>+
>+	uint32_t		page_shift;	/* Some working variables */
>+	uint32_t		block_shift;

I think you don't really need these variables for 2 reasons:
(1) Wherever you are using these variables, you can derive
    struct *nand_chip and instead directly use
	chip->page_shift;
	chip->phys_erase_shift;

(2) Difference chip-selects might be connected to different
 NAND devices having different  page-size and erase-size.
 I'm not sure how that is handled in current generic NAND
 framework (nand_base.c). But having different types of
 NAND devices connected to different chip-selects is possible.


>+	uint32_t		blocks_per_device;
>+	uint32_t		sectors_per_page;
>+
>+	uint8_t			*buf;		/* Some buffers to use */
>+	uint8_t			*page_buf;
>+	uint8_t			*oob_buf;
>+	uint32_t		*buf_list;
>+
>+	int			cached_page;	/* page number of page in */
>+						/* 'page_buf'             */
>+};
>+
>+static int remap_named_resource(struct platform_device *pdev,
>+				char *name,
>+				void __iomem **io_ptr)
>+{
>+	struct resource *res, *mem;
>+	resource_size_t size;
>+	void __iomem *p;
>+
>+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
>+	if (!res)
>+		return -ENXIO;
>+
>+	size = resource_size(res);
>+
>+	mem = devm_request_mem_region(&pdev->dev, res->start, size, name);
>+	if (!mem)
>+		return -EBUSY;
>+
>+	p = devm_ioremap_nocache(&pdev->dev, res->start, size);
>+	if (!p)
>+		return -ENOMEM;
>+
>+	*io_ptr = p;
>+
>+	return 0;
>+}
>+
>+static struct nandi_controller *
>+nandi_init_resources(struct platform_device *pdev)
>+{
>+	struct nandi_controller *nandi;
>+	int err;
>+
>+	nandi = devm_kzalloc(&pdev->dev, sizeof(*nandi), GFP_KERNEL);
>+	if (!nandi) {
>+		dev_err(&pdev->dev,
>+			"failed to allocate NANDi controller data\n");

Jingoo Han <jg1.han@samsung.com> has been cleaning these driver
specific OOM messages. So please drop dev_err(..) here. Refer
	[Patch] mtd: xxxx: Remove unnecessary OOM messages
	The site-specific OOM messages are unnecessary, because they
	duplicate the MM subsystem generic OOM message.

>+		return ERR_PTR(-ENOMEM);
>+	}
>+
>+	nandi->dev = &pdev->dev;
>+
>+	err = remap_named_resource(pdev, "nand_mem", &nandi->base);
>+	if (err)
>+		return ERR_PTR(err);
>+
>+	err = remap_named_resource(pdev, "nand_dma", &nandi->dma);
>+	if (err)
>+		return ERR_PTR(err);
>+
>+	platform_set_drvdata(pdev, nandi);
>+
>+	return nandi;
>+}

[...]

>+
>+struct stm_plat_nand_bch_data {
>+	struct stm_nand_bank_data *bank;
>+	enum stm_nand_bch_ecc_config bch_ecc_cfg;
>+
>+	/* The threshold at which the number of corrected bit-flips per sector
>+	 * is deemed to have reached an excessive level (triggers '-EUCLEAN' to
>+	 * be returned to the caller).  The value should be in the range 1 to
>+	 * <ecc-strength> where <ecc-strength> is 18 or 30, depending on the BCH
>+	 * ECC mode in operation.  A value of 0 is interpreted by the driver as
>+	 * <ecc-strength>.
>+	 */
>+	unsigned int bch_bitflip_threshold;

As discussed in other thread, this is incorrect interpretation for
bitflip_threshold. As per MTD sub-system bitflips_threshold == 0
means ECC correction is not implemented.
@@drivers/mtd/mtdcore.c: mtd_read()
		return ret_code >= mtd->bitflip_threshold ? -EUCLEAN : 0;

>+	bool flashss;

I could not find the use of this member I current series.
In your earlier version of patch this was used for DT binding "st,nand-flashss"
Am I missing something ?


with regards, pekon
