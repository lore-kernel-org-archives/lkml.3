Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbaA1Hiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:38:54 -0500
Received: from gloria.sntech.de ([95.129.55.99]:48550 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaA1Hiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:38:51 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-omap@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH V2] regulator: fixed: update to devm_* API
Date: Tue, 28 Jan 2014 08:38:10 +0100
Message-ID: <10462793.IYoAK2XtXv@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAKDJKT5COnY=i4Dd-P8_eMoWBU+ShqVKVhoVGBk1qWxffe+wMg@mail.gmail.com>
References: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com> <20140128063308.GA5965@core.coreip.homeip.net> <CAKDJKT5COnY=i4Dd-P8_eMoWBU+ShqVKVhoVGBk1qWxffe+wMg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28. January 2014 12:46:01 Manish Badarkhe wrote:
> Hi Dmitry,
> 
> Thank you for your review.
> 
> On Tue, Jan 28, 2014 at 12:03 PM, Dmitry Torokhov
> 
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Manish,
> > 
> > On Tue, Jan 28, 2014 at 08:42:00AM +0530, Manish Badarkhe wrote:
> >> Update the code to use devm_* API so that driver core will manage
> >> resources.
> >> 
> >> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> >> ---
> >> Changes since V1:
> >> 1. Updated driver to use "devm_kzalloc" to "kstrdup".
> >> 2. Updated commit message.
> >> 
> >> Not tested on any board.
> >> 
> >> :100644 100644 5ea64b9... e9763a4... M        drivers/regulator/fixed.c
> >> :
> >>  drivers/regulator/fixed.c |   42
> >>  ++++++++++++------------------------------
> >>  1 file changed, 12 insertions(+), 30 deletions(-)
> >> 
> >> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> >> index 5ea64b9..e9763a4 100644
> >> --- a/drivers/regulator/fixed.c
> >> +++ b/drivers/regulator/fixed.c
> >> @@ -132,15 +132,15 @@ static int reg_fixed_voltage_probe(struct
> >> platform_device *pdev)>> 
> >>                              GFP_KERNEL);
> >>       
> >>       if (drvdata == NULL) {
> >>       
> >>               dev_err(&pdev->dev, "Failed to allocate device data\n");
> >> 
> >> -             ret = -ENOMEM;
> >> -             goto err;
> >> +             return -ENOMEM;
> >> 
> >>       }
> >> 
> >> -     drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
> >> +     drvdata->desc.name = devm_kzalloc(&pdev->dev,
> >> +                                       strlen(config->supply_name) + 1,
> >> +                                       GFP_KERNEL);
> >> 
> >>       if (drvdata->desc.name == NULL) {
> >>       
> >>               dev_err(&pdev->dev, "Failed to allocate supply name\n");
> >> 
> >> -             ret = -ENOMEM;
> >> -             goto err;
> >> +             return -ENOMEM;
> >> 
> >>       }
> > 
> > Umm, I am fairly certain that devm_kzalloc() can't be used as a
> > substitute for kstrdup, at least not without accompanying memcpy.
> 
> Yes, I have provided allocation but it should be followed with assignment.
> Can I modify like this,
> 
> +     drvdata->desc.name = devm_kzalloc(&pdev->dev,
> +                                       strlen(config->supply_name) + 1,
> +                                       GFP_KERNEL);
> +     if (drvdata->desc.name)
> +     sprintf(drvdata->desc.name, "%s", config->supply_name);

hmm, so you replaced a general helper function by open coding the string-
duplication. Doesn't this defeat the target of simplifying the code?


Heiko

