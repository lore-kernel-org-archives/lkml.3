Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaA1I4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 03:56:09 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49420 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbaA1I4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 03:56:07 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Manish Badarkhe <badarkhe.manish@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-omap@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH V2] regulator: fixed: update to devm_* API
Date: Tue, 28 Jan 2014 09:55:26 +0100
Message-ID: <1939430.3DVPas1i8V@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAKDJKT4jPLmtrm6Ngp+nT5vf0H4zXwwAM=oURDF-DSAJodVN6A@mail.gmail.com>
References: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com> <10462793.IYoAK2XtXv@phil> <CAKDJKT4jPLmtrm6Ngp+nT5vf0H4zXwwAM=oURDF-DSAJodVN6A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28. January 2014 14:16:39 Manish Badarkhe wrote:
> Hi Heiko
> 
> Thank you for your reply.
> 
> On Tue, Jan 28, 2014 at 1:08 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > On Tuesday, 28. January 2014 12:46:01 Manish Badarkhe wrote:
> >> Hi Dmitry,
> >> 
> >> Thank you for your review.
> >> 
> >> On Tue, Jan 28, 2014 at 12:03 PM, Dmitry Torokhov
> >> 
> >> <dmitry.torokhov@gmail.com> wrote:
> >> > Hi Manish,
> >> > 
> >> > On Tue, Jan 28, 2014 at 08:42:00AM +0530, Manish Badarkhe wrote:
> >> >> Update the code to use devm_* API so that driver core will manage
> >> >> resources.
> >> >> 
> >> >> Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> >> >> ---
> >> >> Changes since V1:
> >> >> 1. Updated driver to use "devm_kzalloc" to "kstrdup".
> >> >> 2. Updated commit message.
> >> >> 
> >> >> Not tested on any board.
> >> >> 
> >> >> :100644 100644 5ea64b9... e9763a4... M       
> >> >> :drivers/regulator/fixed.c
> >> >> :
> >> >>  drivers/regulator/fixed.c |   42
> >> >>  ++++++++++++------------------------------
> >> >>  1 file changed, 12 insertions(+), 30 deletions(-)
> >> >> 
> >> >> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> >> >> index 5ea64b9..e9763a4 100644
> >> >> --- a/drivers/regulator/fixed.c
> >> >> +++ b/drivers/regulator/fixed.c
> >> >> @@ -132,15 +132,15 @@ static int reg_fixed_voltage_probe(struct
> >> >> platform_device *pdev)>>
> >> >> 
> >> >>                              GFP_KERNEL);
> >> >>       
> >> >>       if (drvdata == NULL) {
> >> >>       
> >> >>               dev_err(&pdev->dev, "Failed to allocate device data\n");
> >> >> 
> >> >> -             ret = -ENOMEM;
> >> >> -             goto err;
> >> >> +             return -ENOMEM;
> >> >> 
> >> >>       }
> >> >> 
> >> >> -     drvdata->desc.name = kstrdup(config->supply_name, GFP_KERNEL);
> >> >> +     drvdata->desc.name = devm_kzalloc(&pdev->dev,
> >> >> +                                       strlen(config->supply_name) +
> >> >> 1,
> >> >> +                                       GFP_KERNEL);
> >> >> 
> >> >>       if (drvdata->desc.name == NULL) {
> >> >>       
> >> >>               dev_err(&pdev->dev, "Failed to allocate supply name\n");
> >> >> 
> >> >> -             ret = -ENOMEM;
> >> >> -             goto err;
> >> >> +             return -ENOMEM;
> >> >> 
> >> >>       }
> >> > 
> >> > Umm, I am fairly certain that devm_kzalloc() can't be used as a
> >> > substitute for kstrdup, at least not without accompanying memcpy.
> >> 
> >> Yes, I have provided allocation but it should be followed with
> >> assignment.
> >> Can I modify like this,
> >> 
> >> +     drvdata->desc.name = devm_kzalloc(&pdev->dev,
> >> +                                       strlen(config->supply_name) + 1,
> >> +                                       GFP_KERNEL);
> >> +     if (drvdata->desc.name)
> >> +     sprintf(drvdata->desc.name, "%s", config->supply_name);
> > 
> > hmm, so you replaced a general helper function by open coding the string-
> > duplication. Doesn't this defeat the target of simplifying the code?
> 
> Intention here, is to use devm_ API and to adopt this I have to do these
> modifications for "kstrdup" functions. I have seen in regulator folder
> almost all drivers adopted to "devm_" API. Hence same thing I am following
> to update this driver. Please let me know whether to go ahead with this
> patch or retain driver as it is.

I don't have a strong opinion on this and others are most likely more qualified 
to have a definitive answer, I just found it strange to exchange one open-coded 
pattern against another open-coded one.

So don't let me keep you from it ;-)

Heiko

