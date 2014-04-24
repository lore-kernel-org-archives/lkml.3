Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaDXVeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:34:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbaDXVeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:34:04 -0400
Message-ID: <1398375234.2708.122.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
From: Adam Williamson <awilliam@redhat.com>
To: "Jin, Yao" <yao.jin@linux.intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 24 Apr 2014 14:33:54 -0700
In-Reply-To: <5359120E.2030007@linux.intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
	 <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
	 <5353A1F6.60602@linux.intel.com> <5353B8A4.1080900@linux.intel.com>
	 <1398007690.2674.0.camel@adam.happyassassin.net>
	 <5354BA59.2000008@linux.intel.com> <53551D0F.40906@linux.intel.com>
	 <CAN+gG=H2X9cUWMixCQakiWz45AOpDAJyEULB0Z9d2jyxy9hUNA@mail.gmail.com>
	 <1398230210.2704.8.camel@adam.happyassassin.net>
	 <20140423083430.GV30677@intel.com> <20140423122344.GX30677@intel.com>
	 <5359120E.2030007@linux.intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 21:30 +0800, Jin, Yao wrote:

> > Jin, do you have any idea what is going on?
> > 
> 
> Maybe neither the patch (http://dougvj.net/baytrail_gpio_quirk_v3.patch)
> nor my patch breaks the touch screen.
> 
> I have tried the clean 3.15-rc2 with following patch which just adds
> back the ACPIID "INT33FC", but the touch screen still doesn't work (To
> avoid the i915 crash issue, I use with the boot option "nomodeset" in test).
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
> Since the clean 3.15-rc2 doesn't contain "INT33FC", so the baytrail gpio
> doesn't actually go into effect.

Well, I just ran another test too. I built a kernel (3.15rc2) with both
v3 of Doug's SDIO device enumeration patch -
http://dougvj.net/baytrail_gpio_quirk_v3.patch - and the new patch for
the IRQ allocation issue by Thomas Gleixner,
https://patchwork.kernel.org/patch/4051581/ . That kernel gives me a
working touchscreen. Note that
http://dougvj.net/baytrail_gpio_quirk_v3.patch includes both the blocks
you mention (i.e. it adds INT33FC in both places).

So, it really seems like for me at least, it's the combination of Doug's
patch and your approach to fixing the IRQ allocation issue that breaks
the touchscreen. Thomas' approach, even combined with Doug's patch,
seems to work fine.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

