Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaBJHht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:37:49 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24827 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaBJHhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:37:46 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-09-52f881c7c33d
Message-id: <1392017862.4594.3.camel@AMDC1943>
Subject: Re: [PATCH v2] mfd: MAX6650/6651 support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Laszlo Papp <lpapp@kde.org>
Cc: lee.jones@linaro.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 08:37:42 +0100
In-reply-to: <1391859219-3102-1-git-send-email-lpapp@kde.org>
References: <1391859219-3102-1-git-send-email-lpapp@kde.org>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t/xy7rHG38EGaw4r2Jx/+tRRospf5Yz
	WVzeNYfNYt1LJwcWj9lPF7F43Lm2h83j8ya5AOYoLpuU1JzMstQifbsErowX2/pZC64IVHy8
	/5y9gbGft4uRk0NCwERi+obTzBC2mMSFe+vZuhi5OIQEljJKPDl6kQXC+cwoseLnavYuRg4O
	XgE9ifv/wkAahAUMJc4u7ANrZhMwlti8fAkbiC0iIC+xc1EbE4jNLBAgsf/ZNbA4i4CqxK7O
	q2BxTgFbiYd/VrKC2EICNhIrfzUxQ9SrS0yatwjqICWJ3e2d7BBxeYnNa96CxXkFBCV+TL7H
	MoFRYBaSlllIymYhKVvAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyRgv+xgXHzM6hCj
	AAejEg/vzj/fg4RYE8uKK3MPMUpwMCuJ8DaX/AgS4k1JrKxKLcqPLyrNSS0+xMjEwSnVwJhm
	UPZ90wq+4FbPfM9Qq+1LL+TM14uenBh08cbOM/Vhws55J61fpM1RNsr/df9nZXF/V+jpFdZz
	LL9eYfE4M8nnd8eRd/vSi5qu3+AIt7WWWJT1WvlvUcdJZpMPprsbXzwuO3pLablY5cXHbm8v
	RuwOPPShQ+JO3JMy18m3Fn56mdZ15MGEgi1KLMUZiYZazEXFiQCgOjVXNgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2014-02-08 at 11:33 +0000, Laszlo Papp wrote:
> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
> chip includes fan-speed regulators and monitors, GPIO, and alarm.
> 
> This patch is an initial release of a MAX6650/6651 MFD driver that
> supports to enable the chip with its primary I2C bus that will connect
> the hwmon, and then the gpio devices for now.
> 
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/mfd/Kconfig                 | 11 +++++
>  drivers/mfd/Makefile                |  1 +
>  drivers/mfd/max665x.c               | 88 +++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max665x-private.h | 42 ++++++++++++++++++
>  4 files changed, 142 insertions(+)
>  create mode 100644 drivers/mfd/max665x.c
>  create mode 100644 include/linux/mfd/max665x-private.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 49bb445..e25be62 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -368,6 +368,17 @@ config MFD_MAX8907
>  	  accessing the device; additional drivers must be enabled in order
>  	  to use the functionality of the device.
>  
> +config MFD_MAX665X
> +	bool "Maxim Semiconductor MAX6650/MAX6651 Support"
> +	select MFD_CORE
> +	depends on I2C
> +	select REGMAP_I2C
> +	help
> +	  Say yes here to support for Maxim Semiconductor MAX6650/MAX6651. This is
> +	  a fan speed regulator and monitor IC. This driver provies common support

s/provies/provides/

(...)


> +const struct regmap_config max665x_regmap_config = {
> +	.reg_bits = 5,
> +};
> +
> +static int max665x_probe(struct i2c_client *i2c,
> +			    const struct i2c_device_id *id)
> +{
> +	struct max665x_dev *max665x;
> +	int ret;
> +
> +	max665x = devm_kzalloc(&i2c->dev, sizeof(*max665x), GFP_KERNEL);
> +	if (!max665x)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, max665x);
> +	max665x->dev = &i2c->dev;
> +	max665x->i2c = i2c;
> +	max665x->map = regmap_init_i2c(i2c, &max665x_regmap_config);

Use devm_regmap_init_i2c() (or add missing regmap_exit()).


Best regards,
Krzysztof


