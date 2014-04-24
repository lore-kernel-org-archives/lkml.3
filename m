Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbaDXP6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:58:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbaDXP63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:58:29 -0400
Message-ID: <1398355101.2708.5.camel@adam.happyassassin.net>
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
Date: Thu, 24 Apr 2014 08:58:21 -0700
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
> 
> On 2014/4/23 20:23, Mika Westerberg wrote:
> > On Wed, Apr 23, 2014 at 11:34:30AM +0300, Mika Westerberg wrote:
> >> On Tue, Apr 22, 2014 at 10:16:50PM -0700, Adam Williamson wrote:
> >>> Well, I can't actually concur. See my results in
> >>> https://bugzilla.kernel.org/show_bug.cgi?id=68291#c44 .
> >>>
> >>> 1. A kernel with neither patch applied (and no hid-rmi driver) results
> >>> in a working touchscreen.
> >>> 2. A kernel with only v3 of Doug's patch from
> >>> https://bugzilla.kernel.org/show_bug.cgi?id=67921 results in a working
> >>> touchscreen.
> >>> 3. A kernel with both v3 of Doug's patch and this IRQ descriptor
> >>> conflict "fix" results in a broken touchscreen.
> >>>
> >>> Seems to me there really is some kind of problem with this patch...
> >>
> >> Can you try so that you have both patches applied and then this one? I'm
> >> suspecting that the ACPI GPIO operation region support might do something
> >> unexpected in this case.
> > 
> > I'm able to reproduce this problem here now and it seems not related to the
> > ACPI GPIO operation regions.
> > 
> > This patch changes call to irq_domain_add_linear() to
> > irq_domain_add_simple() and somehow that changes the behaviour so that I
> > get non-working touchscreen:
> > 
> > ...
> > [   37.434998] i2c_hid i2c-ATML1000:00: failed to reset device.
> > [   37.435009] i2c_hid i2c-ATML1000:00: i2c_hid_set_power
> > [   37.435021] i2c_hid i2c-ATML1000:00: __i2c_hid_command: cmd=fb 00 01 08
> > [   38.439897] i2c_hid i2c-ATML1000:00: can't add hid device: -61
> > [   38.440749] i2c_hid: probe of i2c-ATML1000:00 failed with error -61
> > 
> > It never gets an interrupt when the device reset is ready.
> > 
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

Grmph. Well, I'm almost sure that my test with only v3 of Doug's patch
included both of those changes - and for me, that resulted in a working
touchscreen - but it's just vaguely possible I'd dropped one of them
(the two patches both try and add INT33FC to pinctrl-baytrail.c , so I
have to keep jiggling that chunk between the patches depending on which
combination I'm trying to apply to the build I'm doing). I can try and
do yet another test build today...

I don't know if you're building from upstream or basing on the Fedora
Rawhide kernel, but if you're doing the latter, you need to use a very
recent build or revert the patch that adds the hid-rmi driver that's
queued for 3.16 upstream, or else you'll run into a *different* bug that
breaks the touchscreen, btw. I kinda assumed I'm the only one building
modified Fedora kernels and everyone else is just building the upstream
code directly, but maybe not.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

