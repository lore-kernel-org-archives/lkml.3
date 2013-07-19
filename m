Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277Ab3GSKyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:54:01 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27464 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GSKx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:53:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19vBcYyfH93I4/U3XKJAUWT
Date: Fri, 19 Jul 2013 03:53:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-omap@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: Regression 3.11-rc1: omap4panda: no usb and consequently no
 ethernet
Message-ID: <20130719105356.GG7656@atomide.com>
References: <51E7AA24.6080600@broadcom.com>
 <20130718085951.GT7656@atomide.com>
 <51E916C0.8080206@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E916C0.8080206@broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arend van Spriel <arend@broadcom.com> [130719 03:43]:
> On 07/18/2013 10:59 AM, Tony Lindgren wrote:
> >Then for the SDIO with device tree, take a look at the following
> >patches:
> >
> >[PATCH 0/3] WLAN support for omap4 when booted with devicetree
> >http://comments.gmane.org/gmane.linux.ports.arm.omap/97522#
> 
> I have been looking at the pandaboard patch in the series above and
> I do have a question. Among other things the patch adds these dt
> entries.
> 
> +			0x108 0x118	/* sdmmc5_clk.sdmmc5_clk INPUT_PULLUP | MODE0 */
> +			0x10a 0x118	/* sdmmc5_cmd.sdmmc5_cmd INPUT_PULLUP | MODE0 */
> 
> If I look at the similar names in the deceased board-omap4panda.c:
> 
> board-omap4panda.c:	OMAP4_MUX(SDMMC5_CMD, OMAP_MUX_MODE0 |
> OMAP_PIN_INPUT_PULLUP),
> board-omap4panda.c:	OMAP4_MUX(SDMMC5_CLK, OMAP_MUX_MODE0 |
> OMAP_PIN_INPUT_PULLUP),
> 
> and in mux44xx.h:
> 
> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CLK_OFFSET	0x0148
> mux44xx.h:#define OMAP4_CTRL_MODULE_PAD_SDMMC5_CMD_OFFSET	0x014a
> 
> So how did 0x0148 get 0x0108 in DT and 0x014a get 0x010a. There is
> probably an explanation to it and it would help my understanding to
> know where this difference comes from. Hope you can help me out
> here.

That's pretty confusing I agree.. The reason is that we have multiple
instances of the pinctrl-single: one for core domain and one for wkup
domain. Those instances cover the padconf registers. Then further
instances of pinctrl-single,bits will be used for the various other
SCM registers.

Felipe suggested adding a macro like OMAP4_PAD(offset, value) to
make it less confusing, but for omap4 core padconf area the difference
is 0x40, and 0x30 for omap3 if I remember correctly.
 
> Below are the definitions that I need to move into a dts.
> 
> 	/* MMC2 Mux for extension board */
> 	/* MMC2 CMD */
> 	OMAP4_MUX(GPMC_NWE, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
> 	/* MMC2 CLK */
> 	OMAP4_MUX(GPMC_NOE, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
> 	/* MMC2 DAT 0-7 */
> 	OMAP4_MUX(GPMC_AD0, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
> 	OMAP4_MUX(GPMC_AD1, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
> 	OMAP4_MUX(GPMC_AD2, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),
> 	OMAP4_MUX(GPMC_AD3, OMAP_MUX_MODE1 | OMAP_PIN_INPUT_PULLUP),

Assuming these are all in the core padconf area, just take the TRM
register offset and subtract 0x40.

Regards,

Tony
 
