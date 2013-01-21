Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3AUIrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:47:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51828 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab3AUIrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:47:35 -0500
Message-ID: <50FD0098.4070407@ti.com>
Date: Mon, 21 Jan 2013 09:47:20 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Jarkko Nikula <jarkko.nikula@bitmer.com>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: omap: rx51: Use snd_soc_register_card and add
 module alias for autoloading driver
References: <1358651070-30029-1-git-send-email-pali.rohar@gmail.com> <1358651070-30029-2-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1358651070-30029-2-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/20/2013 04:04 AM, Pali Rohár wrote:
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

This is really welcome.
It would be even better if we would have commit message...
Also for ASoC patches please CC alsa-devel and the maintainers so they will
also have a chance to review.

There are still couple of things which can improve the rx51 machine driver:
- Switch to use devm_gpio_request_one() so we can remove the failure handling.
- I would introduce platform data for this driver to pass the GPIO numbers.
This is especially important for the RX51_SPEAKER_AMP_TWL_GPIO since it is in
twl4030 and the GPIO range now allocated dynamically so the (192 + 7) might
not be valid anymore.

-- 
Péter

> ---
>  sound/soc/omap/rx51.c |   50 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 20 deletions(-)
> 
> diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
> index d921ddb..82e3aae 100644
> --- a/sound/soc/omap/rx51.c
> +++ b/sound/soc/omap/rx51.c
> @@ -391,10 +391,9 @@ static struct snd_soc_card rx51_sound_card = {
>  	.num_configs = ARRAY_SIZE(rx51_codec_conf),
>  };
>  
> -static struct platform_device *rx51_snd_device;
> -
> -static int __init rx51_soc_init(void)
> +static int rx51_soc_probe(struct platform_device *pdev)
>  {
> +	struct snd_soc_card *card = &rx51_sound_card;
>  	int err;
>  
>  	if (!machine_is_nokia_rx51())
> @@ -409,22 +408,18 @@ static int __init rx51_soc_init(void)
>  	if (err)
>  		goto err_gpio_eci_sw;
>  
> -	rx51_snd_device = platform_device_alloc("soc-audio", -1);
> -	if (!rx51_snd_device) {
> -		err = -ENOMEM;
> -		goto err1;
> -	}
> -
> -	platform_set_drvdata(rx51_snd_device, &rx51_sound_card);
> +	card->dev = &pdev->dev;
>  
> -	err = platform_device_add(rx51_snd_device);
> -	if (err)
> -		goto err2;
> +	err = snd_soc_register_card(card);
> +	if (err) {
> +		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", err);
> +		goto err_snd;
> +	}
>  
>  	return 0;
> -err2:
> -	platform_device_put(rx51_snd_device);
> -err1:
> +
> +err_snd:
> +	card->dev = NULL;
>  	gpio_free(RX51_ECI_SW_GPIO);
>  err_gpio_eci_sw:
>  	gpio_free(RX51_TVOUT_SEL_GPIO);
> @@ -433,19 +428,34 @@ err_gpio_tvout_sel:
>  	return err;
>  }
>  
> -static void __exit rx51_soc_exit(void)
> +static int rx51_soc_remove(struct platform_device *pdev)
>  {
> +	struct snd_soc_card *card = platform_get_drvdata(pdev);
> +
>  	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
>  				rx51_av_jack_gpios);
>  
> -	platform_device_unregister(rx51_snd_device);
> +	snd_soc_unregister_card(card);
> +	card->dev = NULL;
> +
>  	gpio_free(RX51_ECI_SW_GPIO);
>  	gpio_free(RX51_TVOUT_SEL_GPIO);
> +
> +	return 0;
>  }
>  
> -module_init(rx51_soc_init);
> -module_exit(rx51_soc_exit);
> +static struct platform_driver rx51_soc_driver = {
> +	.driver = {
> +		.name = "rx51-audio",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = rx51_soc_probe,
> +	.remove = rx51_soc_remove,
> +};
> +
> +module_platform_driver(rx51_soc_driver);
>  
>  MODULE_AUTHOR("Nokia Corporation");
>  MODULE_DESCRIPTION("ALSA SoC Nokia RX-51");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:rx51-audio");
> 


