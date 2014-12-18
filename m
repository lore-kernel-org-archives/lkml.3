Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaLRXoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 18:44:02 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:1634 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbaLRXn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 18:43:59 -0500
From: Bjorn <bjorn@sonymobile.com>
Date: Thu, 18 Dec 2014 15:43:53 -0800
To: Bryan Wu <cooloney@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@linaro.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 2/2] leds: add Qualcomm PM8941 WLED driver
Message-ID: <20141218234352.GE19036@sonymobile.com>
References: <1418084551-28946-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1418084551-28946-2-git-send-email-bjorn.andersson@sonymobile.com>
 <CAK5ve-LujSrARfyi6nvO1EDLyz_cqso93H2irUf9NPbke1XPdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK5ve-LujSrARfyi6nvO1EDLyz_cqso93H2irUf9NPbke1XPdQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16 Dec 16:54 PST 2014, Bryan Wu wrote:

> On Mon, Dec 8, 2014 at 4:22 PM, Bjorn Andersson

[..]

> > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig

[..]

> > +config LEDS_PM8941_WLED
> > +       tristate "LED support for the Qualcomm PM8941 WLED block"
> > +       depends on LEDS_CLASS
> > +       depends on REGMAP
> Here should be "select REGMAP"
> 

Thanks
> > +       help
> > +         This option enables support for the 'White' LED block
> > +         on Qualcomm PM8941 PMICs.
> > +

[..]

> > diff --git a/drivers/leds/leds-pm8941-wled.c b/drivers/leds/leds-pm8941-wled.c

[..]

> > +
> > +struct pm8941_wled_context {
> > +       struct pm8941_wled wled;
> > +       struct regmap *regmap;
> > +};
> > +
> 
> I think you can just add *regmap into pm8941_wled struct and
> pm8941_wled_context is redundant to me.
> 

Looks like a development leftover, I will fold it in.

[..]

> > +
> > +static int pm8941_wled_probe(struct platform_device *pdev)
> > +{
> > +       struct pm8941_wled_context *ctx;
> > +       struct regmap *regmap;
> > +       int rc;
> > +
> > +       regmap = dev_get_regmap(pdev->dev.parent, NULL);
> > +       if (!regmap) {
> > +               dev_err(&pdev->dev, "Unable to get regmap\n");
> > +               return -EINVAL;
> > +       }
> > +
> 
> Is this regmap mmio registers or i2c registers? Will the regmap
> operation sleep?
> 

It's a spmi regmap, in it's current configuration it's marked as "fast" i.e. it
will not sleep.

I discussed this with Courtney before sending the patch out and as this is used
for backlight we don't see a reason calling set_brightness() in atomic context.
If this changes I would send out a follow up patch.

> > +       ctx = devm_kzalloc(&pdev->dev, sizeof(*ctx), GFP_KERNEL);
> > +       if (ctx == NULL)
> > +               return -ENOMEM;
> > +
> > +       ctx->regmap = regmap;
> > +
> > +       rc = pm8941_wled_configure(&ctx->wled, &pdev->dev);
> > +       if (rc)
> > +               return rc;
> > +
> > +       rc = pm8941_wled_setup(&ctx->wled);
> > +       if (rc)
> > +               return rc;
> > +
> > +       ctx->wled.cdev.brightness_set = pm8941_wled_set_brightness;
> > +
> > +       rc = led_classdev_register(&pdev->dev, &ctx->wled.cdev);
> > +       if (rc)
> > +               return rc;
> > +
> > +       platform_set_drvdata(pdev, ctx);
> > +       dev_info(&pdev->dev, "registered led \"%s\"\n", ctx->wled.cdev.name);
> > +
> > +       return 0;
> > +};
> > +

[..]

> > +MODULE_DESCRIPTION("pm8941 wled driver");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_ALIAS("platform: pm8941-wled");
> No space after ":"
> 

Oops.

Regards,
Bjorn
