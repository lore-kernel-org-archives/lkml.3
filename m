Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3FXOmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:42:09 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:50392 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3FXOmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130624142826.AA34E3E0A89@localhost>
References: <51c3565e.4pKZ3AC1Ra7xI3K/%fengguang.wu@intel.com>
 <20130621014637.GB16693@localhost> <CACRpkdYfNe0av3-U7KEiqOQNCkM=YTrgHTwq4oMkoCXQ1Y0Dgw@mail.gmail.com>
 <20130624142826.AA34E3E0A89@localhost>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 24 Jun 2013 15:41:46 +0100
X-Google-Sender-Auth: Ig6tyyVFXegsnhYQcJ2FNiDruE8
Message-ID: <CACxGe6tHb4BKKi4XccM3RaJoippHygKtMyB4gf+p79Reg572pw@mail.gmail.com>
Subject: Re: warning: PINCTRL_BAYTRAIL etc. selects IRQ_DOMAIN which has unmet
 direct dependencies (HAVE_GENERIC_HARDIRQS)
To: Linus Walleij <linus.walleij@linaro.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, kbuild-all@01.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 3:28 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, 24 Jun 2013 13:44:34 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Fri, Jun 21, 2013 at 3:46 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>>
>> config: make ARCH=s390 allmodconfig
>> (...)
>> > warning: (ARM_GIC && ARM_VIC && ORION_IRQCHIP && RENESAS_INTC_IRQPIN && RENESAS_IRQC && VERSATILE_FPGA_IRQ && REGMAP && PINCTRL_BAYTRAIL && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS)
>>
>> Hm I wonder how you actually fix this...
>>
>> This must be the offending Kconfig fragment:
>>
>> config PINCTRL_BAYTRAIL
>>         bool "Intel Baytrail GPIO pin control"
>>         depends on GPIOLIB && ACPI && X86
>>         select IRQ_DOMAIN
>
> I get that warning on gpio/next which doesn't have the PINCTRL_BAYTRAIL
> defined. I don't think this is caused by that hunk. The problem exists
> in mainline (v3.10-rc7) also.
>
> g.

It bisects down to the following commit, but reverting it doesn't
solve the problem. I haven't looked deeper, but I expect that further
patches have done something similar of pulling in IRQ_DOMAIN, quite
possibly other MFD drivers, but not necessarily.

g.

commit 5a324acfce6f7f05ab2a044f7d0ece5f44e812c6
Author: David Rientjes <rientjes@google.com>
Date:   Thu Mar 21 12:08:33 2013 -0700

    mfd: cros_ec: Add MFD_CORE dependency

    CONFIG_MFD_CROS_EC requires CONFIG_MFD_CORE for a couple of functions that
    are declared but not defined:

        ERROR: "mfd_remove_devices" [drivers/mfd/cros_ec.ko] undefined!
        ERROR: "mfd_add_devices" [drivers/mfd/cros_ec.ko] undefined!

    Fix it by selecting CONFIG_MFD_CORE anytime CONFIG_MFD_CROS_EC is enabled.

    Signed-off-by: David Rientjes <rientjes@google.com>
    Acked-by: Simon Glass <sjg@chromium.org>
    Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 94b4547..67e56dc 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -23,6 +23,7 @@ config MFD_88PM860X

 config MFD_CROS_EC
        tristate "Support ChromeOS Embedded Controller"
+       select MFD_CORE
        help
          If you say Y here you get support for the ChromeOS Embedded
          Controller (EC) providing keyboard, battery and power services.
