Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3JUXNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:13:14 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:47831 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3JUXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <20131017141309.GG24056@e106331-lin.cambridge.arm.com>
References: <1381960030-1640-1-git-send-email-tim.kryger@linaro.org>
	<1381960030-1640-7-git-send-email-tim.kryger@linaro.org>
	<20131017141309.GG24056@e106331-lin.cambridge.arm.com>
Date: Mon, 21 Oct 2013 16:13:10 -0700
Message-ID: <CAAYSxhorTkuMHU=mqWG5WsNYE1c2dh9-44yLhT6DGhEpgWSZxw@mail.gmail.com>
Subject: Re: [RESEND PATCH v2 6/6] mmc: sdhci-bcm-kona: Add basic use of clocks
From: Tim Kryger <tim.kryger@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Christian Daudt <bcm@fixthebug.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 7:13 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Oct 16, 2013 at 10:47:10PM +0100, Tim Kryger wrote:
>> Enable the external clock needed by the host controller during the
>> probe and disable it during the remove.
>
> This requires a biding document update.

The current best practice for declaring the association of a clock
with a consumer device is to embed the common clock bindings 'clocks'
property inside its node but this is not the only way it may be done.

Given that clk_get() still works for clocks found using string
matching, is it appropriate to mandate that all drivers that uses the
clk api mention the common clock bindings 'clocks' property in the
documentation for their device's binding?

> I note that the binding is already incomplete (it does not describe the
> interrupts or reg).

The current document reflects the standard for
Documentation/devicetree/bindings/mmc where normal properties are
described in mmc.txt and only the deviations described in vendor
specific files.

>>
>> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
>> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>> ---
>>  drivers/mmc/host/sdhci-bcm-kona.c | 30 ++++++++++++++++++++++++++++--
>>  1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
>> index 85472d3..91db099 100644
>> --- a/drivers/mmc/host/sdhci-bcm-kona.c
>> +++ b/drivers/mmc/host/sdhci-bcm-kona.c
>> @@ -54,6 +54,7 @@
>>
>>  struct sdhci_bcm_kona_dev {
>>       struct mutex    write_lock; /* protect back to back writes */
>> +     struct clk      *external_clk;
>
> Is this the only clock input the unit has?

The SDHCI block only receives one clock.

> Are there any other external resources the device needs (e.g. gpios,
> regulators)?

Yes but the cd-gpio and vmmc/vqmmc regulators are handled by the
common SDHCI driver.

>
>>  };
>>
>>
>> @@ -252,11 +253,29 @@ static int sdhci_bcm_kona_probe(struct platform_device *pdev)
>>       mmc_of_parse(host->mmc);
>>
>>       if (!host->mmc->f_max) {
>> -             dev_err(&pdev->dev, "Missing max-freq for SDHCI cfg\n");
>> +             dev_err(dev, "Missing max-freq for SDHCI cfg\n");
>
> This seems like an unrelated change.

Agreed.  I will remove this change.

>>               ret = -ENXIO;
>>               goto err_pltfm_free;
>>       }
>>
>> +     /* Get and enable the external clock */
>> +     kona_dev->external_clk = devm_clk_get(dev, NULL);
>> +     if (IS_ERR(kona_dev->external_clk)) {
>> +             dev_err(dev, "Failed to get external clock\n");
>> +             ret = PTR_ERR(kona_dev->external_clk);
>> +             goto err_pltfm_free;
>
> This seems like a pretty clear breakage of existing DTBs.
>
> Why?

The defconfig that builds this driver and DTBs currently sets
CONFIG_ARM_APPENDED_DTB=y so there isn't any actual breakage risk.
