Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaDONjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 09:39:52 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:44228 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbaDONjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 09:39:49 -0400
Message-ID: <534D3681.3010200@st.com>
Date: Tue, 15 Apr 2014 19:09:13 +0530
From: Rajeev kumar <rajeev-dlh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Sebastian Reichel <sre@ring0.de>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [alsa-devel] [PATCH 1/5] ASoC: omap: rx51: Use devm_snd_soc_register_card
References: <1396733753-9820-1-git-send-email-sre@kernel.org> <1396733753-9820-2-git-send-email-sre@kernel.org>
In-Reply-To: <1396733753-9820-2-git-send-email-sre@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-14_01:2014-04-14,2014-04-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/2014 3:05 AM, Sebastian Reichel wrote:
> From: Pali Rohár <pali.rohar@gmail.com>
>
> This patch converts the rx51 ASoC module to use
> devm_snd_soc_register_card. It also adds module alias
> to support driver autoloading.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Signed-off-by: Sebastian Reichel <sre@kernel.org>
> ---
>   sound/soc/omap/rx51.c | 48 ++++++++++++++++++++++++++++--------------------
>   1 file changed, 28 insertions(+), 20 deletions(-)
>
> diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
> index 7fb3d4b..58f5e12 100644
> --- a/sound/soc/omap/rx51.c
> +++ b/sound/soc/omap/rx51.c
> @@ -394,10 +394,9 @@ static struct snd_soc_card rx51_sound_card = {
>   	.num_configs = ARRAY_SIZE(rx51_codec_conf),
>   };
>
> -static struct platform_device *rx51_snd_device;
> -
> -static int __init rx51_soc_init(void)
> +static int rx51_soc_probe(struct platform_device *pdev)
>   {
> +	struct snd_soc_card *card = &rx51_sound_card;
>   	int err;
>
>   	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
> @@ -412,22 +411,17 @@ static int __init rx51_soc_init(void)
>   	if (err)
>   		goto err_gpio_eci_sw;
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
> +	err = devm_snd_soc_register_card(card->dev, card);
> +	if (err) {
> +		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", err);
> +		goto err_snd;
> +	}
>
>   	return 0;
> -err2:
> -	platform_device_put(rx51_snd_device);
> -err1:
> +err_snd:
> +	card->dev = NULL;

Why this is required???

~Rajeev

>   	gpio_free(RX51_ECI_SW_GPIO);
>   err_gpio_eci_sw:
>   	gpio_free(RX51_TVOUT_SEL_GPIO);
> @@ -436,19 +430,33 @@ err_gpio_tvout_sel:
>   	return err;
>   }
>
> -static void __exit rx51_soc_exit(void)
> +static int rx51_soc_remove(struct platform_device *pdev)
>   {
> +	struct snd_soc_card *card = platform_get_drvdata(pdev);
> +
>   	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
>   				rx51_av_jack_gpios);
>
> -	platform_device_unregister(rx51_snd_device);
> +	card->dev = NULL;
> +
>   	gpio_free(RX51_ECI_SW_GPIO);
>   	gpio_free(RX51_TVOUT_SEL_GPIO);
> +
> +	return 0;
>   }
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
>   MODULE_AUTHOR("Nokia Corporation");
>   MODULE_DESCRIPTION("ALSA SoC Nokia RX-51");
>   MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:rx51-audio");
>

