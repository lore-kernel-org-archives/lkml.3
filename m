Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaHDIlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:41:36 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:63734 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaHDIle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:41:34 -0400
Date: Mon, 4 Aug 2014 09:41:26 +0100
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
Message-ID: <20140804084126.GD3935@lee--X1>
References: <1406744573-609-1-git-send-email-tthayer@opensource.altera.com>
 <1406744573-609-2-git-send-email-tthayer@opensource.altera.com>
 <20140731082637.GH9030@lee--X1>
 <53DAA072.4010902@opensource.altera.com>
 <20140801081317.GL9030@lee--X1>
 <53DC146D.1070504@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53DC146D.1070504@opensource.altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Aug 2014, Thor Thayer wrote:
> On 08/01/2014 03:13 AM, Lee Jones wrote:
> >On Thu, 31 Jul 2014, Thor Thayer wrote:
> >>On 07/31/2014 03:26 AM, Lee Jones wrote:
> >>>On Wed, 30 Jul 2014, tthayer@opensource.altera.com wrote:
> >>>
> >>>>From: Thor Thayer <tthayer@opensource.altera.com>
> >>>>
> >>>>Add a simple MFD for the Altera SDRAM Controller.
> >>>>
> >>>>Signed-off-by: Alan Tull <atull@opensource.altera.com>
> >>>>Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>
> >>>>---
> >>>>v1-8: The MFD implementation was not included in the original series.
> >>>>
> >>>>v9: New MFD implementation.
> >>>>---
> >>>>  MAINTAINERS                    |    5 ++
> >>>>  drivers/mfd/Kconfig            |    7 ++
> >>>>  drivers/mfd/Makefile           |    1 +
> >>>>  drivers/mfd/altera-sdr.c       |  162 ++++++++++++++++++++++++++++++++++++++++
> >>>>  include/linux/mfd/altera-sdr.h |  102 +++++++++++++++++++++++++
> >>>>  5 files changed, 277 insertions(+)
> >>>>  create mode 100644 drivers/mfd/altera-sdr.c
> >>>>  create mode 100644 include/linux/mfd/altera-sdr.h

[...]

> >>>>+	return readl(sdr->reg_base + reg_offset);
> >>>>+}
> >>>>+EXPORT_SYMBOL_GPL(altera_sdr_readl);
> >>>>+
> >>>>+void altera_sdr_writel(struct altera_sdr *sdr, u32 reg_offset, u32 value)
> >>>>+{
> >>>>+	writel(value, sdr->reg_base + reg_offset);
> >>>>+}
> >>>>+EXPORT_SYMBOL_GPL(altera_sdr_writel);
> >>>Why are you abstracting these?

You still didn't answer this?

> >>>Might be better to use Regmap even.
> >>regmap seems unnecessarily complex for what we're doing which is why
> >>this method was chosen.
> >>
> >>Future drivers will access different sets of registers in the
> >>device. These drivers won't share bitfields in the same register so
> >>the MFD seemed like the best solution. Originally we implemented
> >>this using syscon but that seems to be frowned upon so we changed to
> >>using a MFD.
> >Why was the use of syscon frowned upon?  Can you link me to the
> >thread?  Writing directly to the registers sounds to me a lot worse
> >than using infrastructure which was designed for these kinds of
> >accesses.
> >
> >If you do choose to fiddle with the registers in this manner, is there
> >any reason why you're calling back into here, rather than using
> >readl() and writel() directly?
> >
> We'd prefer to use syscon and that is what we started with. If you'd
> like to be our advocate, I will return to that because it was pretty
> clean. My primary concern is to get it upstreamed and if it is MFD
> then I'll make the changes.
> 
> Here are the threads.
> http://marc.info/?l=linux-kernel&m=140128791902800&w=2
> and
> http://article.gmane.org/gmane.linux.kernel/1679601

Syscon looks the most appropriate to me.

[...]

> >>>>+EXPORT_SYMBOL_GPL(altera_sdr_mem_size);
> >>>Should this really be done in here?  Isn't this an SDRAM function?
> >>>
> >>This register is part of the SDRAM controller and size information
> >>may be required by the other drivers that share this memory
> >>area/need SDRAM information.
> >Then export a function from the SDRAM driver, not from here.
> We don't have an SDRAM driver.  Although I could put this in the
> EDAC driver it would be lost to anyone else wanting this
> functionality so this seemed to be the logical place.

Why can't you export it from the EDAC driver?

[...]

> >>>>+static int __init altera_sdr_init(void)
> >>>>+{
> >>>>+	return platform_driver_register(&altera_sdr_driver);
> >>>>+}
> >>>>+postcore_initcall(altera_sdr_init);
> >>>Why was this chosen?
> >>We want this to happen pretty early.
> >If you _need_ this is happen early, core_initcall() is more commonly
> >used, but _why_ do you need it to happen this early?
> The syscon driver used this designation. After talking with Alan,
> this could be changed to a core_initcall(). However, it could also
> be a subsys_initcall which seems to be more common in the MFD
> drivers.

That doesn't answer my question still. 

What is the reason, requirement, need for this driver to be probed so
early during the boot process?

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
