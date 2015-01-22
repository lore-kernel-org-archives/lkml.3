Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbbAVPVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:21:40 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45053 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbAVPVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:21:32 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-ocores: add common clock support
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
	<20150122144522.GF3413@katana>
Date: Thu, 22 Jan 2015 16:21:27 +0100
In-Reply-To: <20150122144522.GF3413@katana> (Wolfram Sang's message of "Thu,
	22 Jan 2015 15:45:22 +0100")
Message-ID: <871tmm96yw.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Wolfram" == Wolfram Sang <wsa@the-dreams.de> writes:

 >> @@ -320,9 +322,23 @@ static int ocores_i2c_of_probe(struct platform_device *pdev,
 >> }
 >> 
 >> if (of_property_read_u32(np, "clock-frequency", &val)) {
 >> -		dev_err(&pdev->dev,
 >> -			"Missing required parameter 'clock-frequency'\n");
 >> -		return -ENODEV;
 >> +		struct clk *clk = devm_clk_get(&pdev->dev, NULL);
 >> +
 >> +		if (!IS_ERR(clk)) {
 >> +			int ret = clk_prepare_enable(clk);
 >> +
 >> +			if (ret) {
 >> +				dev_err(&pdev->dev,
 >> +					"clk_prepare_enable failed: %d\n", ret);
 >> +				return ret;
 >> +			}
 >> +			i2c->clk = clk;
 >> +			val = clk_get_rate(clk);
 >> +		} else {
 >> +			dev_err(&pdev->dev,
 >> +				"Missing required parameter 'clock-frequency'\n");
 >> +			return -ENODEV;
 >> +		}

 > Either NAK or I don't understand the logic here :) If a dts does NOT
 > have the bus-speed set by 'clock-frequency', then we take the value of
 > the clock assigned to this platform_device?

 > The usual thing to do when 'clock-frequency' is not set is to default to
 > 100kHz.

The confusion comes from the fact that the device tree bindings uses
clock-frequency for the clock frequency of the IP core and NOT for the
i2c bus frequency. This dates back to when the bindings where added
(049bb69d82e5f7f356) :/

The driver is currently hardcoded to use a 100KHz i2c bus clock (see
ocoores_init()).

-- 
Bye, Peter Korsgaard
