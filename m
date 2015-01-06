Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbbAFM5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:57:10 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:56547 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbbAFM5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:57:05 -0500
Message-ID: <54ABDB9E.3070400@cogentembedded.com>
Date: Tue, 06 Jan 2015 15:57:02 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        davem@davemloft.net
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: [PATCH_V3] dm9000: Add regulator and reset support to dm9000
References: <1420542916-30169-1-git-send-email-Zubair.Kakakhel@imgtec.com>
In-Reply-To: <1420542916-30169-1-git-send-email-Zubair.Kakakhel@imgtec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/6/2015 2:15 PM, Zubair Lutfullah Kakakhel wrote:

> In boards, the dm9000 chip's power and reset can be controlled by gpio.

> It makes sense to add them to the dm9000 driver and let dt be used to
> enable power and reset the phy.

> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
> Signed-off-by: Paul Burton <paul.burton@imgtec.com>

[...]

> diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
> index ef0bb58..246c89d 100644
> --- a/drivers/net/ethernet/davicom/dm9000.c
> +++ b/drivers/net/ethernet/davicom/dm9000.c
[...]
> @@ -1426,11 +1429,49 @@ dm9000_probe(struct platform_device *pdev)
>   	struct dm9000_plat_data *pdata = dev_get_platdata(&pdev->dev);
>   	struct board_info *db;	/* Point a board information structure */
>   	struct net_device *ndev;
> +	struct device *dev = &pdev->dev;
>   	const unsigned char *mac_src;
>   	int ret = 0;
>   	int iosize;
>   	int i;
>   	u32 id_val;
> +	int reset_gpios;
> +	enum of_gpio_flags flags;
> +	struct regulator *power;
> +
> +	power = devm_regulator_get(dev, "vcc");
> +	if (PTR_ERR(power) == -EPROBE_DEFER)
> +			return -EPROBE_DEFER;

    Line over-indented.

[...]
> +	reset_gpios = of_get_named_gpio_flags(dev->of_node, "reset-gpios", 0,
> +					      &flags);
> +	if (gpio_is_valid(reset_gpios)) {
> +		ret = devm_gpio_request_one(dev, reset_gpios, flags,
> +					    "dm9000_reset");
> +		if (ret) {
> +			dev_err(dev, "failed to request reset gpio %d: %d\n",
> +				reset_gpios, ret);
> +			return -ENODEV;
> +		}
> +
> +		gpio_direction_output(reset_gpios, 0);

    You could skip this call as devm_gpio_request_one() can handle that for you.

[...]

WBR, Sergei

