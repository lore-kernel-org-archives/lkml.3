Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbaGDKvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:51:17 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31941 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaGDKvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:51:14 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-2e-53b6871fd0e2
Content-transfer-encoding: 8BIT
Message-id: <1404471072.14069.0.camel@AMDC1943>
Subject: Re: [PATCH v6 02/23] mfd: max77686: Add power management support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 04 Jul 2014 12:51:12 +0200
In-reply-to: <1404467722-26687-3-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
 <1404467722-26687-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e/4FV359m3BBi9OcFssuXiV3aJ5U7HF
	1IdP2CzmHznHanF22UE2i6O/Cyx6F1xls7j/9SijxbcrHUwWmx5fY7W4vGsOm8WM8/uYLJ5O
	uMhmcer6ZzaLvrWX2Cw2TN7NbjH3dyOrg6DH7IaLLB5/n19n8dhxdwmjx85Zd9k9Nq3qZPO4
	c20Pm8fmJfUeV040sXr0bVnF6LH5dLXH9Hk/mTw+b5IL4InisklJzcksSy3St0vgynjS84Wt
	YLZQRcfvj8wNjJf4uhg5OSQETCQ+77/IBGGLSVy4t54NxBYSWMooMeuxC4jNKyAo8WPyPZYu
	Rg4OZgF5iSOXskHCzALqEpPmLWKGKP/MKLHmUA1Eub7E52mXWEFsYQFPiUvnfrGD2GwCxhKb
	ly8BGy8iYCdxY/VDoF4uoDm3WCR+Ld8E1sAioCrxfeJfsCJOgQCJXZ+WsoIUCQlMZZSY9GkD
	I8ShyhLz9h9jmsAoMAvJfbMQ7puF5L4FjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKi
	8MsOxsXHrA4xCnAwKvHwNq7YECzEmlhWXJl7iFGCg1lJhPd3/bZgId6UxMqq1KL8+KLSnNTi
	Q4xMHJxSDYyV/x86mr2Uf5U9/UDhM77jrMwWEjJT5gbt9HPMvPb/xOtnl1PZD2UXHfu30ajG
	6ONphe+7zypUtPbF1O6cHcpc+tPe2ujLvr3a/vNZa5vjr/xiVrcKMjj0MUH8y1mZ6ExGXY2r
	L94/uRDuJMK7NkH0N1NEloMB88HmstCk5udXimJYDixd5KPEUpyRaKjFXFScCAD74EP+oAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-07-04 at 11:55 +0200, Javier Martinez Canillas wrote:
> The driver doesn't have PM operations defined so add a suspend
> and resume function handlers to allow the PMIC IRQ to wakeup
> the system when it is put into a sleep state.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/mfd/max77686.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 3cb41d0..a38e9ee 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -240,10 +240,50 @@ static const struct i2c_device_id max77686_i2c_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, max77686_i2c_id);
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int max77686_suspend(struct device *dev)
> +{
> +	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> +	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
> +
> +	if (device_may_wakeup(dev))
> +		enable_irq_wake(max77686->irq);
> +
> +	/*
> +	 * IRQ must be disabled during suspend because if it happens
> +	 * while suspended it will be handled before resuming I2C.
> +	 *
> +	 * When device is woken up from suspend (e.g. by RTC wake alarm),
> +	 * an interrupt occurs before resuming I2C bus controller.
> +	 * Interrupt handler tries to read registers but this read
> +	 * will fail because I2C is still suspended.
> +	 */
> +	disable_irq(max77686->irq);
> +
> +	return 0;
> +}
> +
> +static int max77686_resume(struct device *dev)
> +{
> +	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> +	struct max77686_dev *max77686 = i2c_get_clientdata(i2c);
> +
> +	if (device_may_wakeup(dev))
> +		disable_irq_wake(max77686->irq);
> +
> +	enable_irq(max77686->irq);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static SIMPLE_DEV_PM_OPS(max77686_pm, max77686_suspend, max77686_resume);
> +
>  static struct i2c_driver max77686_i2c_driver = {
>  	.driver = {
>  		   .name = "max77686",
>  		   .owner = THIS_MODULE,
> +		   .pm = &max77686_pm,
>  		   .of_match_table = of_match_ptr(max77686_pmic_dt_match),
>  	},
>  	.probe = max77686_i2c_probe,

