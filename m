Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaFYKFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:05:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62748 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaFYKFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:05:47 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-78-53aa9ef86beb
Message-id: <1403690742.22107.7.camel@AMDC1943>
Subject: Re: [PATCH v3 02/14] mfd: max77686: Allow the max77686 rtc to wakeup
 the system
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 12:05:42 +0200
In-reply-to: <1403202040-12641-3-git-send-email-javier.martinez@collabora.co.uk>
References: <1403202040-12641-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403202040-12641-3-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Nd0f81YFG0zoZLNYcvEqu8XUh0/Y
	LDb1b2W3mH/kHKvF2WUH2SyO/i6w6F1wlc3i/tejjBbfrnQwWWx6fI3V4vKuOWwWM87vY7J4
	OuEim8Wp65/ZLE53s1pMP/6W1aJv7SU2B0GP2Q0XWTz+Pr/O4rHj7hJGj52z7rJ7bFrVyeZx
	59oeNo95JwM9Ni+p97hyoonVo2/LKkaP6fN+Mnl83iQXwBPFZZOSmpNZllqkb5fAlTHvrXtB
	K39F35cbrA2Mu3i6GDk4JARMJB6dYe5i5AQyxSQu3FvP1sXIxSEksJRR4mbfVGYI5zOjxJZt
	K9hBqngF9CWetMxhBGkWFoiSmP9YHyTMJmAssXn5EjYQW0TATuLG6odgvcwCj1gkHm35wwiS
	YBFQlVh+/h0LiM0pECCxftU7VogFUxklFk+YCLaAWUBdYtK8RVAnKUvM23+MCWKxoMSPyfdY
	IGrkJTavecs8gVFgFpKWWUjKZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJA6/
	7mBceszqEKMAB6MSD28Az6pgIdbEsuLK3EOMEhzMSiK8jnOAQrwpiZVVqUX58UWlOanFhxiZ
	ODilGhjvJD2SfdyVOa166lYfNgb/Dt2HWnm/Lyi1Xfnr/EZQkKG1mOnZcdNy8cJfGmujopL2
	T0+8Zrrqc+G2U04vUxl4/3euzvnzbFbrou7XyrNMrn94Gdt1rYftXZ7g3WNqdxiaOzJD+lwS
	tvMvzuXQu3/yjHWTzX41fc1T3Fs2rlM6syx5bYH58hdKLMUZiYZazEXFiQDKqH4qoQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-06-19 at 20:20 +0200, Javier Martinez Canillas wrote:
> From: Doug Anderson <dianders@chromium.org>
> 
> The max77686 includes an RTC that keeps power during suspend.  It's
> convenient to be able to use it as a wakeup source.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/rtc/rtc-max77686.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
> index d20a7f0..c1c6055 100644
> --- a/drivers/rtc/rtc-max77686.c
> +++ b/drivers/rtc/rtc-max77686.c
> @@ -583,6 +583,33 @@ static void max77686_rtc_shutdown(struct platform_device *pdev)
>  #endif /* MAX77686_RTC_WTSR_SMPL */
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int max77686_rtc_suspend(struct device *dev)
> +{
> +	if (device_may_wakeup(dev)) {
> +		struct max77686_rtc_info *info = dev_get_drvdata(dev);
> +
> +		return enable_irq_wake(info->virq);
> +	}
> +
> +	return 0;
> +}
> +
> +static int max77686_rtc_resume(struct device *dev)
> +{
> +	if (device_may_wakeup(dev)) {
> +		struct max77686_rtc_info *info = dev_get_drvdata(dev);
> +
> +		return disable_irq_wake(info->virq);
> +	}
> +
> +	return 0;
> +}
> +#endif

Haven't you noticed un-acked interrupts after first resume? Does the
alarm IRQ works after first suspend-resume?

This happens quite often (at least on boards with max14577, max77836 and
s2m/s5m). The drivers implementing own irq_chip often just call irq
worker thread (see max77693_irq_resume [1]). With regmap_irq_chip you
can disable/enable the IRQ [2][3].


P.S. Sorry for late reply. I was on holidays.


[1] http://lxr.free-electrons.com/source/drivers/mfd/max77693-irq.c#L233
[2] http://lxr.free-electrons.com/source/drivers/mfd/max14577.c#L181
[2] http://lxr.free-electrons.com/source/drivers/mfd/sec-core.c#L444

Best regards,
Krzysztof



