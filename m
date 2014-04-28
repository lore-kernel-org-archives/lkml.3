Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaD1MvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:51:01 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:55440 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbaD1Mu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:50:59 -0400
Date: Mon, 28 Apr 2014 13:50:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: sameo@linux.intel.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: twl6040: Optional clk32k clock handling
Message-ID: <20140428125052.GK21279@lee--X1>
References: <1396522482-32036-1-git-send-email-peter.ujfalusi@ti.com>
 <20140428103629.GI21279@lee--X1>
 <535E319A.9050104@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <535E319A.9050104@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014, Peter Ujfalusi wrote:

> On 04/28/2014 01:36 PM, Lee Jones wrote:
> >> In certain boards the source for the clk32k clock can be gated. In these
> >> boards the clk32k clock can be provided to the driver and it is going to be
> >> enabled/disabled when it is needed.
> >> If the clk32k clock is not provided the driver will assume that it is always
> >> running.
> >>
> >> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >> ---
> >>  Documentation/devicetree/bindings/mfd/twl6040.txt |  2 ++
> >>  drivers/mfd/twl6040.c                             | 10 ++++++++++
> >>  include/linux/mfd/twl6040.h                       |  2 ++
> >>  3 files changed, 14 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/mfd/twl6040.txt b/Documentation/devicetree/bindings/mfd/twl6040.txt
> >> index 0f5dd709d752..a41157b5d930 100644
> >> --- a/Documentation/devicetree/bindings/mfd/twl6040.txt
> >> +++ b/Documentation/devicetree/bindings/mfd/twl6040.txt
> >> @@ -19,6 +19,8 @@ Required properties:
> >>  
> >>  Optional properties, nodes:
> >>  - enable-active-high: To power on the twl6040 during boot.
> >> +- clocks: phandle to the clk32k clock provider
> >> +- clock-names: Must be "clk32k"
> >>  
> >>  Vibra functionality
> >>  Required properties:
> >> diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
> >> index 2e6504a8e1e3..12b314ea48dc 100644
> >> --- a/drivers/mfd/twl6040.c
> >> +++ b/drivers/mfd/twl6040.c
> >> @@ -291,6 +291,8 @@ int twl6040_power(struct twl6040 *twl6040, int on)
> >>  		if (twl6040->power_count++)
> >>  			goto out;
> >>  
> >> +		clk_prepare_enable(twl6040->clk32k);
> >> +
> >>  		/* Allow writes to the chip */
> >>  		regcache_cache_only(twl6040->regmap, false);
> >>  
> >> @@ -346,6 +348,8 @@ int twl6040_power(struct twl6040 *twl6040, int on)
> >>  
> >>  		twl6040->sysclk = 0;
> >>  		twl6040->mclk = 0;
> >> +
> >> +		clk_disable_unprepare(twl6040->clk32k);
> >>  	}
> >>  
> >>  out:
> >> @@ -644,6 +648,12 @@ static int twl6040_probe(struct i2c_client *client,
> >>  
> >>  	i2c_set_clientdata(client, twl6040);
> >>  
> >> +	twl6040->clk32k = devm_clk_get(&client->dev, "clk32k");
> >> +	if (IS_ERR(twl6040->clk32k)) {
> >> +		dev_info(&client->dev, "clk32k is not handled\n");
> >> +		twl6040->clk32k = NULL;
> > 
> > So what happens if you pass a NULL clk reference to clk_prepare_enable()?
> 
> We have checks for !clk in all cases within the clk_* API. If we pass NULL,
> nothing will happen and from the calling driver point of view it will look
> like a success.
> AFAIK this is the way to handle non esential/optional clocks without if()s in
> the driver code around the clock handling.

Okay, so long as those checks are there, we're all good.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
