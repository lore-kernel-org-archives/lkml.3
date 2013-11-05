Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3KEUPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:15:34 -0500
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:57700 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754403Ab3KEUPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:15:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3867:3873:4250:4321:4559:5007:6119:6691:7652:7903:8957:10004
X-HE-Tag: corn84_4cea8fe6b684f
X-Filterd-Recvd-Size: 3090
Message-ID: <1383682529.4387.37.camel@joe-AO722>
Subject: Re: [PATCH V2 1/3] thermal: bcm281xx: Add Temperature Monitor driver
From: Joe Perches <joe@perches.com>
To: Wendy Ng <wendy.ng@broadcom.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Christian Daudt <bcm@fixthebug.org>,
        Markus Mayer <mmayer@broadcom.com>, Tim Kryger <tim.kryger@linaro.org>,
        Matt Porter <matt.porter@linaro.org>
Date: Tue, 05 Nov 2013 12:15:29 -0800
In-Reply-To: <1383681284-17643-2-git-send-email-wendy.ng@broadcom.com>
References: <1383681284-17643-1-git-send-email-wendy.ng@broadcom.com>
	 <1383681284-17643-2-git-send-email-wendy.ng@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 11:54 -0800, Wendy Ng wrote:
> This adds the support for Temperature Monitor (TMON) driver for
> Broadcom bcm281xx SoCs. This driver plugs into the Thermal Framework.

trivia:

> diff --git a/drivers/thermal/bcm_kona_tmon.c b/drivers/thermal/bcm_kona_tmon.c

Please add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #include to prefix the pr_<level> dmesg output.

If you _really_ want __func__ with each output, you could use
#define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
though I think __func__ isn't particularly useful.

> +#include <linux/clk.h>
> +#include <linux/err.h>
[]
> +static int bcm_get_temp(void *sensor_data, long *temp)
> +{
> +	u32 raw;
> +	long mcelsius;
> +	struct bcm_tmon_data_priv *priv = sensor_data;
> +
> +	if (!priv) {
> +		pr_err("%s: input sensor_data not initialized.\n", __func__);

then this could become
		pr_err("input sensor_data not initialized\n");

Also, there's no real need to terminate messages with sentence
ending ".".  dmesg output generally isn't a sentence.

> +		return -EINVAL;
> +	}
> +
> +	raw = (readl(priv->base + TMON_TEMP_VAL_OFFSET)
> +		& TMON_TEMP_VAL_TEMP_VAL_MASK) >> TMON_TEMP_VAL_TEMP_VAL_SHIFT;
> +
> +	pr_debug("%s: raw temp 0x%x\n", __func__, raw);

also consider:

	pr_debug("raw temp: %#x\n", raw);


> +static int bcm_kona_tmon_probe(struct platform_device *pdev)
> +{
[]
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv) {
> +		dev_err(&pdev->dev, "Failed to malloc priv.\n");
> +		return -ENOMEM;
> +	}

Generic OOM messages are already emitted by devm_kzalloc.
This could be written as:

	priv = devm_kzalloc(etc...)
	if (!priv)
		return -ENOMEM;


