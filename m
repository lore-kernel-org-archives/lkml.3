Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaHAINe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:13:34 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:62403 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbaHAIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:13:26 -0400
Date: Fri, 1 Aug 2014 09:13:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thor Thayer <tthayer@opensource.altera.com>
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, atull@altera.com, delicious.quinoa@gmail.com,
        dinguyen@altera.com, dougthompson@xmission.com,
        grant.likely@linaro.org, bp@alien8.de, sameo@linux.intel.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tthayer.linux@gmail.com,
        Alan Tull <atull@opensource.altera.com>
Subject: Re: [PATCHv9 1/3] mfd: altera: Add Altera SDRAM Controller
Message-ID: <20140801081317.GL9030@lee--X1>
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com>
 <1406744573-609-2-git-send-email-tthayer@opensource.altera.com>
 <20140731082637.GH9030@lee--X1>
 <53DAA072.4010902@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53DAA072.4010902@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Thor Thayer wrote:
> On 07/31/2014 03:26 AM, Lee Jones wrote:
> >On Wed, 30 Jul 2014, tthayer@opensource.altera.com wrote:
> >
> >>From: Thor Thayer <tthayer@opensource.altera.com>
> >>
> >>Add a simple MFD for the Altera SDRAM Controller.
> >>
> >>Signed-off-by: Alan Tull <atull@opensource.altera.com>
> >>Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> >>---
> >>v1-8: The MFD implementation was not included in the original series.
> >>
> >>v9: New MFD implementation.
> >>---
> >>  MAINTAINERS                    |    5 ++
> >>  drivers/mfd/Kconfig            |    7 ++
> >>  drivers/mfd/Makefile           |    1 +
> >>  drivers/mfd/altera-sdr.c       |  162 ++++++++++++++++++++++++++++++++++++++++
> >>  include/linux/mfd/altera-sdr.h |  102 +++++++++++++++++++++++++
> >>  5 files changed, 277 insertions(+)
> >>  create mode 100644 drivers/mfd/altera-sdr.c
> >>  create mode 100644 include/linux/mfd/altera-sdr.h

[...]

> >>+++ b/drivers/mfd/altera-sdr.c
> >>@@ -0,0 +1,162 @@
> >>+/*
> >>+ * SDRAM Controller (SDR) MFD
> >>+ *
> >>+ * Copyright (C) 2014 Altera Corporation
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or modify it
> >>+ * under the terms and conditions of the GNU General Public License,
> >>+ * version 2, as published by the Free Software Foundation.
> >>+ *
> >>+ * This program is distributed in the hope it will be useful, but WITHOUT
> >>+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> >>+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> >>+ * more details.
> >>+ *
> >>+ * You should have received a copy of the GNU General Public License along with
> >>+ * this program.  If not, see <http://www.gnu.org/licenses/>.
> >Can you use the shorter version of the licence?
> Hi. This seems to be the shorter version of the license agreement
> and is fairly common in the kernel, right?

This is the long(ish) version.  Many programs have the Copyright line
and the "This program is free software;" line.  It'll also be a good
idea to keep the link to the full licence.

[...]

> >>+	{
> >>+		.name = "altr_sdram_edac",
> >>+		.of_compatible = "altr,sdram-edac",
> >What other devices will there be?
> >
> There will be an FPGA bridge and a power control driver that will
> need access to the SDR Controller registers.

Okay.  Do you know when they'll be upstreamed?

> >>+u32 altera_sdr_readl(struct altera_sdr *sdr, u32 reg_offset)
> >>+{
> >>+	return readl(sdr->reg_base + reg_offset);
> >>+}
> >>+EXPORT_SYMBOL_GPL(altera_sdr_readl);
> >>+
> >>+void altera_sdr_writel(struct altera_sdr *sdr, u32 reg_offset, u32 value)
> >>+{
> >>+	writel(value, sdr->reg_base + reg_offset);
> >>+}
> >>+EXPORT_SYMBOL_GPL(altera_sdr_writel);
> >Why are you abstracting these?
> >
> >Might be better to use Regmap even.
> regmap seems unnecessarily complex for what we're doing which is why
> this method was chosen.
> 
> Future drivers will access different sets of registers in the
> device. These drivers won't share bitfields in the same register so
> the MFD seemed like the best solution. Originally we implemented
> this using syscon but that seems to be frowned upon so we changed to
> using a MFD.

Why was the use of syscon frowned upon?  Can you link me to the
thread?  Writing directly to the registers sounds to me a lot worse
than using infrastructure which was designed for these kinds of
accesses.

If you do choose to fiddle with the registers in this manner, is there
any reason why you're calling back into here, rather than using
readl() and writel() directly?

> >>+u32 altera_sdr_mem_size(struct altera_sdr *sdr)
> >>+{
> >>+	u32 size;
> >>+	u32 read_reg, row, bank, col, cs, width;
> >Weird that size is on its own.  Either place on a single line or
> >separate them all.
> OK. I will change this.
> >>+	read_reg = altera_sdr_readl(sdr, SDR_DRAMADDRW_OFST);
> >>+	if (read_reg < 0)
> >>+		return 0;
> >>+
> >>+	width = altera_sdr_readl(sdr, SDR_DRAMIFWIDTH_OFST);
> >>+	if (width < 0)
> >>+		return 0;

u32s cant be < 0.  The 'u' means 'unsigned'.

> >>+	col = (read_reg & SDR_DRAMADDRW_COLBITS_MASK) >>
> >>+		SDR_DRAMADDRW_COLBITS_LSB;
> >>+	row = (read_reg & SDR_DRAMADDRW_ROWBITS_MASK) >>
> >>+		SDR_DRAMADDRW_ROWBITS_LSB;
> >>+	bank = (read_reg & SDR_DRAMADDRW_BANKBITS_MASK) >>
> >>+		SDR_DRAMADDRW_BANKBITS_LSB;
> >>+	cs = (read_reg & SDR_DRAMADDRW_CSBITS_MASK) >>
> >>+		SDR_DRAMADDRW_CSBITS_LSB;
> >These would probably be better as macros.
> >
> OK. I will fix this.
> >>+	/* Correct for ECC as its not addressible */
> >>+	if (width == SDR_DRAMIFWIDTH_32B_ECC)
> >>+		width = 32;
> >>+	if (width == SDR_DRAMIFWIDTH_16B_ECC)
> >>+		width = 16;
> >>+
> >>+	/* calculate the SDRAM size base on this info */
> >>+	size = 1 << (row + bank + col);
> >>+	size = size * cs * (width / 8);
> >>+	return size;
> >>+}
> >>+EXPORT_SYMBOL_GPL(altera_sdr_mem_size);
> >Should this really be done in here?  Isn't this an SDRAM function?
> >
> This register is part of the SDRAM controller and size information
> may be required by the other drivers that share this memory
> area/need SDRAM information.

Then export a function from the SDRAM driver, not from here.

[...]

> >>+static const struct platform_device_id altera_sdr_ids[] = {
> >>+	{ "altera_sdr", },
> >>+	{ }
> >>+};
> >What's this for?
> We don't strictly need it because we are driven by the device tree.
> It can be removed it if is a problem but I'm not clear why it is a
> problem.

It's a problem because it's unused, superfluous bumph. :)

[...]

> >>+static int __init altera_sdr_init(void)
> >>+{
> >>+	return platform_driver_register(&altera_sdr_driver);
> >>+}
> >>+postcore_initcall(altera_sdr_init);
> >Why was this chosen?
> We want this to happen pretty early.

If you _need_ this is happen early, core_initcall() is more commonly
used, but _why_ do you need it to happen this early?

> >>+/*
> >>+ * Copyright (C) 2014 Altera Corporation
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or modify it
> >>+ * under the terms and conditions of the GNU General Public License,
> >>+ * version 2, as published by the Free Software Foundation.
> >>+ *
> >>+ * This program is distributed in the hope it will be useful, but WITHOUT
> >>+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> >>+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> >>+ * more details.
> >>+ *
> >>+ * You should have received a copy of the GNU General Public License along with
> >>+ * this program.  If not, see <http://www.gnu.org/licenses/>.
> >Use the short version.
> Same as above. This is the shorter version that we've been using at Altera.

If you read COPYING, you only require the Copyright line and a link to
the full licence.  In this case I'll be happy if you left in the "This
program is free software;" line as well, but remove the paragraph
below it.

[...]

> >>+/* Register access API */
> >>+u32 altera_sdr_readl(struct altera_sdr *sdr, u32 reg_offset);
> >>+void altera_sdr_writel(struct altera_sdr *sdr, u32 reg_offset, u32 value);
> >Regmap?
> Same as above. This seems to be more complex than we need.

I'm not sure I believe that.  Regmap is as complex or as simple as you
need.

> Thanks for your comments and for reviewing!
> 
> Thor

You're welcome.  OOI, do you own a hammer? ;)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
