Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaDYJda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:33:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:33420 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbaDYJd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:33:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,926,1389772800"; 
   d="scan'208";a="519587045"
Date: Fri, 25 Apr 2014 12:40:38 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Jin, Yao" <yao.jin@linux.intel.com>
Cc: Adam Williamson <awilliam@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        aubrey.li@intel.com
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
Message-ID: <20140425094038.GK30677@intel.com>
References: <1398007690.2674.0.camel@adam.happyassassin.net>
 <5354BA59.2000008@linux.intel.com>
 <53551D0F.40906@linux.intel.com>
 <CAN+gG=H2X9cUWMixCQakiWz45AOpDAJyEULB0Z9d2jyxy9hUNA@mail.gmail.com>
 <1398230210.2704.8.camel@adam.happyassassin.net>
 <20140423083430.GV30677@intel.com>
 <20140423122344.GX30677@intel.com>
 <5359120E.2030007@linux.intel.com>
 <1398375234.2708.122.camel@adam.happyassassin.net>
 <535A0E6E.7000900@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535A0E6E.7000900@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+Aubrey]

On Fri, Apr 25, 2014 at 03:27:42PM +0800, Jin, Yao wrote:
> 
> 
> On 2014/4/25 5:33, Adam Williamson wrote:
> > On Thu, 2014-04-24 at 21:30 +0800, Jin, Yao wrote:
> > 
> >>> Jin, do you have any idea what is going on?
> >>>
> >>
> >> Maybe neither the patch (http://dougvj.net/baytrail_gpio_quirk_v3.patch)
> >> nor my patch breaks the touch screen.
> >>
> >> I have tried the clean 3.15-rc2 with following patch which just adds
> >> back the ACPIID "INT33FC", but the touch screen still doesn't work (To
> >> avoid the i915 crash issue, I use with the boot option "nomodeset" in test).
> >>
> >> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> >> index 69e29f4..d79c6d7 100644
> >> --- a/drivers/acpi/acpi_lpss.c
> >> +++ b/drivers/acpi/acpi_lpss.c
> >> @@ -180,6 +180,7 @@ static const struct acpi_device_id
> >> acpi_lpss_device_ids[] = {
> >>         { "80860F14", (unsigned long)&byt_sdio_dev_desc },
> >>         { "80860F41", (unsigned long)&byt_i2c_dev_desc },
> >>         { "INT33B2", },
> >> +       { "INT33FC", },
> >>
> >>         { "INT3430", (unsigned long)&lpt_dev_desc },
> >>         { "INT3431", (unsigned long)&lpt_dev_desc },
> >> diff --git a/drivers/pinctrl/pinctrl-baytrail.c
> >> b/drivers/pinctrl/pinctrl-baytrail.c
> >> index 6e8301f..447f1dc 100644
> >> --- a/drivers/pinctrl/pinctrl-baytrail.c
> >> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> >> @@ -572,6 +572,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
> >>
> >>  static const struct acpi_device_id byt_gpio_acpi_match[] = {
> >>         { "INT33B2", 0 },
> >> +       { "INT33FC", 0 },
> >>         { }
> >>  };
> >>  MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
> >>
> >> Since the clean 3.15-rc2 doesn't contain "INT33FC", so the baytrail gpio
> >> doesn't actually go into effect.
> > 
> > Well, I just ran another test too. I built a kernel (3.15rc2) with both
> > v3 of Doug's SDIO device enumeration patch -
> > http://dougvj.net/baytrail_gpio_quirk_v3.patch - and the new patch for
> > the IRQ allocation issue by Thomas Gleixner,
> > https://patchwork.kernel.org/patch/4051581/ . That kernel gives me a
> > working touchscreen. Note that
> > http://dougvj.net/baytrail_gpio_quirk_v3.patch includes both the blocks
> > you mention (i.e. it adds INT33FC in both places).
> > 
> > So, it really seems like for me at least, it's the combination of Doug's
> > patch and your approach to fixing the IRQ allocation issue that breaks
> > the touchscreen. Thomas' approach, even combined with Doug's patch,
> > seems to work fine.
> > 
> 
> I'm trying the clean upstream 3.15-rc2 with the patch by Thomas Gleixner
> (https://patchwork.kernel.org/patch/4051581/) and the patch as following
> which only adds INT33FC, the touch screen doesn't work. I didn't add
> Doug's SDIO device enumeration patch in this test.
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 69e29f4..d79c6d7 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -180,6 +180,7 @@ static const struct acpi_device_id
> acpi_lpss_device_ids[] = {
>         { "80860F14", (unsigned long)&byt_sdio_dev_desc },
>         { "80860F41", (unsigned long)&byt_i2c_dev_desc },
>         { "INT33B2", },
> +       { "INT33FC", },
> 
>         { "INT3430", (unsigned long)&lpt_dev_desc },
>         { "INT3431", (unsigned long)&lpt_dev_desc },
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c
> b/drivers/pinctrl/pinctrl-baytrail.c
> index 6e8301f..447f1dc 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -572,6 +572,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
> 
>  static const struct acpi_device_id byt_gpio_acpi_match[] = {
>         { "INT33B2", 0 },
> +       { "INT33FC", 0 },
>         { }
>  };
>  MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
> 
> It's still not clear to me why the touch screen doesn't work. As above
> test, my patch is not added in.

With patch from Thomas and below patch, I got working touchscreen. Note
that you need to disable runtime PM from SDHCI (or from some other LPSS
driver) so that the LPSS stays functional. Once all devices are powered
off, the block doesn't wake up anymore. Aubrey is investigating that.

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 69e29f409d4c..d79c6d7f598e 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -180,6 +180,7 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
 	{ "80860F14", (unsigned long)&byt_sdio_dev_desc },
 	{ "80860F41", (unsigned long)&byt_i2c_dev_desc },
 	{ "INT33B2", },
+	{ "INT33FC", },
 
 	{ "INT3430", (unsigned long)&lpt_dev_desc },
 	{ "INT3431", (unsigned long)&lpt_dev_desc },
diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
index ebb3f392b589..c5d4185380b1 100644
--- a/drivers/mmc/host/sdhci-acpi.c
+++ b/drivers/mmc/host/sdhci-acpi.c
@@ -130,8 +130,7 @@ static const struct sdhci_acpi_slot sdhci_acpi_slot_int_sdio = {
 };
 
 static const struct sdhci_acpi_slot sdhci_acpi_slot_int_sd = {
-	.flags   = SDHCI_ACPI_SD_CD | SDHCI_ACPI_SD_CD_OVERRIDE_LEVEL |
-		   SDHCI_ACPI_RUNTIME_PM,
+	.flags   = SDHCI_ACPI_SD_CD | SDHCI_ACPI_SD_CD_OVERRIDE_LEVEL,
 	.quirks2 = SDHCI_QUIRK2_CARD_ON_NEEDS_BUS_ON,
 };
 
diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 6e8301f77187..7c65c9dab215 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -527,12 +527,6 @@ static int byt_gpio_probe(struct platform_device *pdev)
 	gc->can_sleep = false;
 	gc->dev = dev;
 
-	ret = gpiochip_add(gc);
-	if (ret) {
-		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
-		return ret;
-	}
-
 	/* set up interrupts  */
 	irq_rc = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (irq_rc && irq_rc->start) {
@@ -550,6 +544,12 @@ static int byt_gpio_probe(struct platform_device *pdev)
 		irq_set_chained_handler(hwirq, byt_gpio_irq_handler);
 	}
 
+	ret = gpiochip_add(gc);
+	if (ret) {
+		dev_err(&pdev->dev, "failed adding byt-gpio chip\n");
+		return ret;
+	}
+
 	pm_runtime_enable(dev);
 
 	return 0;
@@ -572,6 +572,7 @@ static const struct dev_pm_ops byt_gpio_pm_ops = {
 
 static const struct acpi_device_id byt_gpio_acpi_match[] = {
 	{ "INT33B2", 0 },
+	{ "INT33FC", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, byt_gpio_acpi_match);
