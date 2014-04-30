Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaD3LTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:19:43 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52244 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbaD3LTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:19:40 -0400
Date: Wed, 30 Apr 2014 12:19:33 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "angus.clark@st.com" <angus.clark@st.com>
Subject: Re: [RFC 23/47] mtd: nand: stm_nand_bch: read and write page (BCH)
Message-ID: <20140430111933.GL29462@lee--X1>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-24-git-send-email-lee.jones@linaro.org>
 <20980858CB6D3A4BAE95CA194937D5E73EAB5CAC@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAB5CAC@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >From: Lee Jones [mailto:lee.jones@linaro.org]
> >
> >Use DMA to read and/or write a single page of data.
> >
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >---
> > drivers/mtd/nand/stm_nand_bch.c | 119 ++++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 119 insertions(+)
> >
> >diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
> >index 7874d85..6323590 100644
> >--- a/drivers/mtd/nand/stm_nand_bch.c
> >+++ b/drivers/mtd/nand/stm_nand_bch.c
> >@@ -21,6 +21,7 @@

[...]

> >+/* Returns the number of ECC errors, or '-1' for uncorrectable error */
> >+static int bch_read_page(struct nandi_controller *nandi,
> >+			 loff_t offs,
> >+			 uint8_t *buf)
> >+{

[...]

> >+	/* Use the maximum per-sector ECC count! */
> 
> Firstly, this ecc checking and correction should not be part of bch_read_page().
> This should be part of chip->ecc.correct().

I'm not sure that's true.  The functionality below isn't correcting
any data.  I believe it's preventing a false-positive error return.
All calculate() and correct() behaviour is dealt with internally by
h/w.  There should be no intervention from s/w, hence the lack of
call-back functions of the same name.

> But, I don't see your driver using nand_chip->ecc interfaces.
> Why do you want to break away from generic driver flow ? any controller limitation ?

When this driver was written, a great deal of the framework was not
present.  I believe the author also wanted to prevent any changes in
the framework from adversely affecting the leaf driver.  It was
considered that if there is no intention to upstream, it would be much
better to hack around the framework and have full control of the
driver.

Things are different now, as upstreaming is considered necessary.
It's my job to make this driver acceptable so it can be Mainlined.
This includes a 'port' to ensure the driver is using the correct
interfaces provided by the framework.

> I think much of the code in below patch can be reused from nand_base.c
> 	[RFC 43/47] mtd: nand: stm_nand_bch: read and write functions (BCH)

I agree and have taken care of this now.

> >+	ecc_err = readl(nandi->base + NANDBCH_ECC_SCORE_REG_A) & 0xff;
> >+	if (ecc_err == 0xff) {
> >+		/*
> >+		 * Downgrade uncorrectable ECC error for an erased page,
> >+		 * tolerating 'sectors_per_page' bits at zero.
> >+		 */
> >+		ret = check_erased_page(buf, page_size,
> >+					nandi->sectors_per_page);
> 
> This is also not correct. Here 'max_zeros' should be ecc.strength

I need to check this with the original author, but I'm inclined to
agree with you.  I'll make the changes before re-submitting.

> >+		if (ret >= 0)
> >+			dev_dbg(nandi->dev,
> >+				"%s: erased page detected: \n"
> >+				"  downgrading uncorrectable ECC error.\n",
> >+				__func__);
> >+	} else {
> >+		ret = (int)ecc_err;
> >+	}
> >+
> >+	return ret;
> >+}
> >+
> 
> with regards, pekon

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
