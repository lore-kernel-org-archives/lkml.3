Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaCZK0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:26:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38368 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaCZK0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:26:33 -0400
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
Subject: RE: [RFC 07/47] mtd: nand: stm_nand_bch: initialise the BCH
 Controller
Thread-Topic: [RFC 07/47] mtd: nand: stm_nand_bch: initialise the BCH
 Controller
Thread-Index: AQHPSAMZxGz7oQGsEk27seq0WSyPipry1aNA
Date: Wed, 26 Mar 2014 10:25:52 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAB5CB7@DBDE04.ent.ti.com>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-8-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1395735604-26706-8-git-send-email-lee.jones@linaro.org>
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
missing commit log :-)
Though $subject is self-explanatory, but you can add more description about
assumption and hardware caveats about the controller, and its use.

>
>Signed-off-by: Lee Jones <lee.jones@linaro.org>
>---
> drivers/mtd/nand/stm_nand_bch.c | 56 +++++++++++++++++++++++++++++++++++++++++
> include/linux/mtd/stm_nand.h    | 20 +++++++++++++++
> 2 files changed, 76 insertions(+)
>
>diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
>index 76a0d02..1a93f8d 100644
>--- a/drivers/mtd/nand/stm_nand_bch.c
>+++ b/drivers/mtd/nand/stm_nand_bch.c
>@@ -14,6 +14,7 @@
>
> #include <linux/kernel.h>
> #include <linux/module.h>
>+#include <linux/delay.h>
> #include <linux/io.h>
> #include <linux/interrupt.h>
> #include <linux/device.h>
>@@ -102,6 +103,56 @@ static void nandi_disable_interrupts(struct nandi_controller *nandi,
> 	writel(val, nandi->base + NANDBCH_INT_EN);
> }
>
>+static void nandi_init_bch(struct nandi_controller *nandi, int emi_bank)
>+{
>+	dev_dbg(nandi->dev, "%s\n", __func__);
>+
>+	/* Initialise BCH Controller */
>+	emiss_nandi_select(STM_NANDI_BCH);
>+
>+	/* Reset and disable boot-mode controller */
>+	writel(BOOT_CFG_RESET, nandi->base + NANDBCH_BOOTBANK_CFG);
>+	udelay(1);
>+	writel(0x00000000, nandi->base + NANDBCH_BOOTBANK_CFG);

Why using 'udelay' ?
Isn't there any status register which tells you that controller is reset / initialized ?
Or may be polling on NANDBCH_BOOTBANK_CFG may itself give you status.

>+
>+	/* Reset AFM controller */
>+	writel(CFG_RESET, nandi->base + NANDBCH_CONTROLLER_CFG);
>+	udelay(1);
>+	writel(0x00000000, nandi->base + NANDBCH_CONTROLLER_CFG);
>+
>+	/* Set EMI Bank */
>+	writel(0x1 << emi_bank, nandi->base + NANDBCH_FLEX_MUXCTRL);
>+
>+	/* Reset ECC stats */
>+	writel(0x7f0, nandi->base + NANDBCH_CONTROLLER_CFG);
>+	udelay(1);
>+
"0x7f0" ?? please use Macro instead.


with regards, pekon
