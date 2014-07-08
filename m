Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbaGHAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:16:59 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36722 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbaGHAQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:16:56 -0400
Date: Mon, 7 Jul 2014 17:16:51 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140708001651.GD7537@ld-irv-0074>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20980858CB6D3A4BAE95CA194937D5E73EAFAFF1@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAFAFF1@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee, Pekon,

A few additions/corrections to Pekon's comments.

On Thu, Jul 03, 2014 at 09:09:27AM +0000, Pekon Gupta wrote:
> >From: Brian Norris [mailto:computersforpeace@gmail.com]
> >On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:
> >> diff --git a/arch/arm/boot/dts/stih41x-b2020.dtsi b/arch/arm/boot/dts/stih41x-b2020.dtsi
> >> index bc5818d..7a6a6e8 100644
> >> --- a/arch/arm/boot/dts/stih41x-b2020.dtsi
> >> +++ b/arch/arm/boot/dts/stih41x-b2020.dtsi
> >> @@ -52,5 +52,45 @@
> >>  			pinctrl-0	= <&pinctrl_rgmii1>;
> >>  		};
> >>
> >> +		nandbch: nand-bch {
> >
> >Shouldn't this be named 'nand@xxxxxxxx', 'flash@xxxxxxxx', or similar?
> >
> >> +			compatible = "st,nand-bch";
> >> +			reg = <0xfe901000 0x1000>, <0xfef00800 0x0800>;
> >> +			reg-names = "nand_mem", "nand_dma";
> >> +			interrupts = <0 139 0x0>;
> >> +			interrupt-names = "nand_irq";
> >> +			st,nand-banks = <&nand_banks>;
> >> +			nand-ecc-strength = <0xFF>;
> 
> nit-pick to save yourself from another patch re-spin, Please use lower-case hex :-)

Or in this case, drop the property altogether. I believe
nand-ecc-strength = 255 is a misuse of the binding, as Lee intended it
to mean "automatic". (It makes more sense to say that a missing
"nand-ecc-strength" property means Linux can 'automatically' choose.)

> >> +
> >> +			status = "okay";
> >> +		};
> >> +
...

> >> +static void bch_wait_seq(struct nandi_controller *nandi)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = wait_for_completion_timeout(&nandi->seq_completed, HZ/2);
> 
> Are you sure you want to use same timeout value for all operations
> like ERASE, READ, WRITE ? because
> (1) There is wide variance between:
> - BLOCK_ERASE:  max(tBER) = 10ms) for MT29F4G08 Micron NAND
> - PAGE_ERASE: max(tPROG) = 600usec for same Micron part.
> 
> (2) The value of HZ varies across kernel versions and hardware platforms.

Lee's use of HZ is correct. HZ represents one second, and it is useful
for giving an (approximate) timeout that is independent of timer tick
rate. It is equivalent to msecs_to_jiffies(1000), for example.

> I suggest you pass the timeout value in call to bch_wait_seq().
> And this timeout value should be like 2x of typical value of which you found
> during ONFI parsing, or from DT

I'm not sure it's very important to get a precise timeout value. It's
especially not worth a DT binding. Timeouts should be the exception, not
the rule, and should not be relied on (for example) for good performance.

> >> +	if (!ret)
> >> +		dev_err(nandi->dev, "BCH Seq timeout\n");
> >> +}
> >> +
...
> >> +	/* Load last page of block */
> >> +	offs = (loff_t)block << chip->phys_erase_shift;
> >> +	offs += mtd->erasesize - mtd->writesize;
> >> +	if (bch_read_page(nandi, offs, buf) < 0) {
> 
> *Important*: You shouldn't call internal functions directly here..
> Instead use chip->_read() OR mtd-read() that will:

Probably looking for mtd_read()?

> - keep this code independent of ECC modes added in your driver in future.
> - implicitly handle updating mtd->ecc_stat (like ecc_failed, bits_corrected).
> - implicitly take care of address alignments checks and offset calculations.
> 
> <Same applies to other places where you have directly used bch_read_page())

I agree. And this would help with my request that you separate your ST
BBT code from the rest of your driver.

> >> +struct stm_plat_nand_bch_data {
> >> +	struct stm_nand_bank_data *bank;
> >> +	enum stm_nand_bch_ecc_config bch_ecc_cfg;
> >> +
> >> +	/* The threshold at which the number of corrected bit-flips per sector
> >> +	 * is deemed to have reached an excessive level (triggers '-EUCLEAN' to
> >> +	 * be returned to the caller).  The value should be in the range 1 to
> >> +	 * <ecc-strength> where <ecc-strength> is 18 or 30, depending on the BCH
> >> +	 * ECC mode in operation.  A value of 0 is interpreted by the driver as
> >> +	 * <ecc-strength>.
> >> +	 */
> >> +	unsigned int bch_bitflip_threshold;
> >
> >This field is never set or used...
> >
> >> +	bool flashss;
> >
> >Ditto.
> >
> Probably answered in [2]

OK, then mark it with a FIXME or TODO comment. Don't let every reader
come across this driver with the same questions.

> Please re-send the next version in similar squashed format, as its easy for review.

Yes.

> And once Brian is okay, may be then you can re-send individual patches.

I don't see any need to send individual sub-patches for the driver (you
do, however, need to split out the DTS and Documentation/ portions as
separate patches). If you want to include the splitting, just link to a
git tree where patches can be found.

Brian
