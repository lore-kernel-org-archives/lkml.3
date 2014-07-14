Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaGNL5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:57:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:44499 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaGNL5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:57:23 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-2e-53c3c59b23b2
Message-id: <53C3C59B.20306@samsung.com>
Date: Mon, 14 Jul 2014 13:57:15 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Joonyoung Shim <jy0922.shim@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, broonie@linaro.org, tobetter@gmail.com
Subject: Re: [PATCH 1/2] usb: usb3503: add PM functions
References: <1404969755-30555-1-git-send-email-jy0922.shim@samsung.com>
In-reply-to: <1404969755-30555-1-git-send-email-jy0922.shim@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xa7qzjx4ONnh839pi0/XrrBbNi9ez
	Wby4d5HF4vKuOWwWi5a1Mlvse7yG2YHNY+esu+wed67tYfPYP3cNu0ffllWMHp83yQWwRnHZ
	pKTmZJalFunbJXBldB76ylbwWbBi+fIJrA2M6/m6GDk5JARMJK43b2eHsMUkLtxbz9bFyMUh
	JLCUUWLStEZWkISQwCdGic53NiA2r4CGxIVFPWwgNouAqsTF/zvAbDYBQ4mut11gtqhAjMSZ
	3s/MEPWCEj8m32MBsUUE0iWe/9sJtIyDg1nATeLUFS2QsLCAucSu/z3sEKvcJb5P+s8EYnMK
	eEi87ZnPCGIzC5hJPGpZxwxhy0tsXvOWeQKjwCwkG2YhKZuFpGwBI/MqRtHU0uSC4qT0XCO9
	4sTc4tK8dL3k/NxNjJDA/rqDcekxq0OMAhyMSjy8BfyHg4VYE8uKK3MPMUpwMCuJ8IYfBArx
	piRWVqUW5ccXleakFh9iZOLglGpg5OBM4NI9++KTQLook9Wa9lvaXPs9HPapnJy0/KX379pc
	9fDLPY6BdX7HJn6adelu2nb5ndJu3BvnzjdeLCjxZNV9EbZ7JecnLg1f3RWzqeKIa/dHGYb9
	IixLnnM5VGaeOLpyStR3kUJXtq3RosFZJ34fWGVeOPfslhOcAht9b02Wvrlqz3lubyWW4oxE
	Qy3mouJEAIeIKW1KAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-10 07:22, Joonyoung Shim wrote:
> The usb3503 needs to switch to standby mode while suspending and should
> switch to hub mode when resumed. Also we can control clock on PM
> function.
>
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/usb/misc/usb3503.c | 34 ++++++++++++++++++++++++++++++++--
>   1 file changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/misc/usb3503.c b/drivers/usb/misc/usb3503.c
> index 652855b..47cb143 100644
> --- a/drivers/usb/misc/usb3503.c
> +++ b/drivers/usb/misc/usb3503.c
> @@ -149,8 +149,6 @@ static int usb3503_switch_mode(struct usb3503 *hub, enum usb3503_mode mode)
>   
>   	case USB3503_MODE_STANDBY:
>   		usb3503_reset(hub, 0);
> -
> -		hub->mode = mode;
>   		dev_info(dev, "switched to STANDBY mode\n");
>   		break;
>   
> @@ -347,6 +345,37 @@ static int usb3503_platform_probe(struct platform_device *pdev)
>   	return usb3503_probe(hub);
>   }
>   
> +#ifdef CONFIG_PM_SLEEP
> +static int usb3503_i2c_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct usb3503 *hub = i2c_get_clientdata(client);
> +
> +	usb3503_switch_mode(hub, USB3503_MODE_STANDBY);
> +
> +	if (hub->clk)
> +		clk_disable_unprepare(hub->clk);
> +
> +	return 0;
> +}
> +
> +static int usb3503_i2c_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct usb3503 *hub = i2c_get_clientdata(client);
> +
> +	if (hub->clk)
> +		clk_prepare_enable(hub->clk);
> +
> +	usb3503_switch_mode(hub, hub->mode);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(usb3503_i2c_pm_ops, usb3503_i2c_suspend,
> +		usb3503_i2c_resume);
> +
>   static const struct i2c_device_id usb3503_id[] = {
>   	{ USB3503_I2C_NAME, 0 },
>   	{ }
> @@ -365,6 +394,7 @@ MODULE_DEVICE_TABLE(of, usb3503_of_match);
>   static struct i2c_driver usb3503_i2c_driver = {
>   	.driver = {
>   		.name = USB3503_I2C_NAME,
> +		.pm = &usb3503_i2c_pm_ops,
>   		.of_match_table = of_match_ptr(usb3503_of_match),
>   	},
>   	.probe		= usb3503_i2c_probe,

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

