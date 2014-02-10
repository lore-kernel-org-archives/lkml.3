Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaBJLzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:55:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34058 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbaBJLzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:55:42 -0500
From: "Gupta, Pekon" <pekon@ti.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] mtd: add per NAND partition ECC config
Thread-Topic: [RFC PATCH] mtd: add per NAND partition ECC config
Thread-Index: AQHPJLho7dtwsDvqJE20hpqheFAS25quXmZA
Date: Mon, 10 Feb 2014 11:55:07 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EA6F1F0@DBDE04.ent.ti.com>
References: <1391855206-5974-1-git-send-email-b.brezillon.dev@gmail.com>
In-Reply-To: <1391855206-5974-1-git-send-email-b.brezillon.dev@gmail.com>
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

Hi Boris,

>From: Boris BREZILLON
>
>This patch aims to add per partition ECC config for NAND devices.
>It defines a new field in the mtd struct to store the mtd ECC config and
>thus each mtd partition device can store its config instead of using the
>default NAND chip config.
>
>This feature is needed to support the sunxi boot0 paritition case:
>Allwinner boot code (BROM) requires a specific HW ECC for its boot code
>that may not fit the HW NAND requirements for the entire NAND chip.
>
>Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>---
>Hello,
>
>This patch is just a draft that implement per partition ECC config.
>It's currently not properly splitted (it should be separated in several
>patches) and not documented either.
>
>There's at least one point that bother me in the current implementation:
>I introduced DT notions in the nand core code by the mean of the get_ecc_ctrl
>callback, and so far this was kept out of mtd/nand core code (I guess it was
>on purpose).
>
>Please let me know if you see other drawbacks.
>
>If you think per partition ECC should not be implemented, could you help me
>find a way to handle sunxi specific case decribed above ?
>
There was a discussion on having per partition based ECC earlier [1].
Though I was not in favor of supporting it earlier, but your proposal looks good.
However, I still feel there are more caveats here, to explore..

[...]

>@@ -364,7 +367,13 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
> 	slave->mtd.writesize = master->writesize;
> 	slave->mtd.writebufsize = master->writebufsize;
> 	slave->mtd.oobsize = master->oobsize;
>-	slave->mtd.oobavail = master->oobavail;
>+	if (part->eccctrl) {
>+		slave->mtd.eccctrl = part->eccctrl;
>+		slave->mtd.oobavail = part->eccctrl->layout->oobavail;
>+	} else {
>+		slave->mtd.eccctrl = master->eccctrl;
>+		slave->mtd.oobavail = master->oobavail;
>+	}
> 	slave->mtd.subpage_sft = master->subpage_sft;
>
> 	slave->mtd.name = name;
>@@ -515,9 +524,15 @@ static struct mtd_part *allocate_partition(struct mtd_info *master,
> 			part->name);
> 	}
>
>-	slave->mtd.ecclayout = master->ecclayout;
>-	slave->mtd.ecc_step_size = master->ecc_step_size;
>-	slave->mtd.ecc_strength = master->ecc_strength;
>+	if (part->eccctrl) {
>+		slave->mtd.ecclayout = part->eccctrl->layout;
>+		slave->mtd.ecc_step_size = part->eccctrl->size;
>+		slave->mtd.ecc_strength = part->eccctrl->strength;

You have to replicate 'struct nand_ecc_ctrl' from 'nand_chip' to 'mtd_info'
because each ECC algorithm may have its own callback for hwctl(), calculate(), and correct().
How do you plan to populate those ?  In driver probe ?

>+	} else {
>+		slave->mtd.ecclayout = master->ecclayout;
>+		slave->mtd.ecc_step_size = master->ecc_step_size;
>+		slave->mtd.ecc_strength = master->ecc_strength;
>+	}
> 	slave->mtd.bitflip_threshold = master->bitflip_threshold;
>
> 	if (master->_block_isbad) {

[...]

>+const struct nand_ecc_ctrl *nand_get_ecc_ctrl(struct mtd_info *mtd,
>+					      nand_ecc_modes_t mode,
>+					      struct device_node *np)
>+{
>+	struct nand_chip *chip = mtd->priv;
>+	struct nand_ecc_ctrl *ecc;
>+	u32 ecc_step, ecc_strength;
>+	int ret;
>+
>+	if (mode != NAND_ECC_NONE && mode != NAND_ECC_SOFT &&
>+	    mode != NAND_ECC_SOFT_BCH)
>+		return ERR_PTR(-EINVAL);
>+
>+	ecc = kzalloc(sizeof(*ecc), GFP_KERNEL);
>+	if (!ecc)
>+		return ERR_PTR(-ENOMEM);
>+
>+	ecc->size = chip->ecc_step_ds;
>+	ecc->strength = chip->ecc_strength_ds;
>+	if (!of_get_nand_ecc_level(np, &ecc_strength, &ecc_step)) {
>+		ecc->size = ecc_step;
>+		ecc->strength = ecc_strength;
>+	}
>+

Here we may need to ecc_strength for each partition.
Example: for OMAP3 ROM supports only HAM1 (1-bit hamming),
      but kernel may support up-to BCH8 (8-bit BCH) ECC schemes.
But, anyways that's specific to OMAP platforms..

>+	switch (mode) {
>+	case NAND_ECC_NONE:
>+		break;
>+	case NAND_ECC_SOFT:
>+		break;
>+	case NAND_ECC_SOFT_BCH:
>+		ecc->bytes = ((ecc->strength * fls(8 * ecc->size)) + 7) / 8;
>+		break;
>+	default:
>+		ret = -EINVAL;
>+		goto err;
>+	}
>+
>+	ecc->mode = mode;
>+	ret = nand_ecc_ctrl_init(mtd, ecc);
>+	if (ret)
>+		goto err;
>+
>+	ecc->release = nand_release_ecc_ctrl;
>+
>+	return ecc;
>+
>+err:
>+	kfree(ecc);
>+	return ERR_PTR(ret);
>+}
>+EXPORT_SYMBOL(nand_get_ecc_ctrl);
>+

I'll be happy to extend and test this, if you plan a complete version.

[1] http://comments.gmane.org/gmane.linux.ports.arm.omap/108083
(you can skip initial discussion about OMAP3, and jump to Thomas Petazzoni | 2 Dec 17:19 2013)


with regards, pekon
