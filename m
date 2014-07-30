Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaG3OWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:22:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:63786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbaG3OWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:22:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="scan'208";a="551310201"
Message-ID: <53D8FF76.7090707@linux.intel.com>
Date: Wed, 30 Jul 2014 17:21:42 +0300
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: jianqun <xjq@rock-chips.com>, broonie@kernel.org, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, tbleung@chromium.org,
        dgreid@chromium.org, kevin.strasser@intel.com, swarren@nvidia.com,
        ralph.birt@maximintegrated.com
CC: alsa-devel@alsa-project.org, heiko@sntech.de, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: max98090 add irq valid check
References: <1406685010-25108-1-git-send-email-xjq@rock-chips.com> <1406710457-6195-1-git-send-email-xjq@rock-chips.com>
In-Reply-To: <1406710457-6195-1-git-send-email-xjq@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 07/30/2014 11:54 AM, jianqun wrote:
> From: Jianqun <xjq@rock-chips.com>
>
> Since IRQ pin from max98090 may NC, the irq number will be zero, that is
> invalid for request_threaded_irq, so just add irq valid check there.
>
> Since hardware may not MUST to use IRQ pin of max98090 as jack detect, the
> driver can work well without it, can report jack trigger to CPU by a GPIO.
>
> But here driver will register fail caused by failed to request irq.
>
> Signed-off-by: Jianqun <xjq@rock-chips.com>
> ---
>   sound/soc/codecs/max98090.c |   14 ++++++++------
>   1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
> index 566919c..9dc0e8c 100644
> --- a/sound/soc/codecs/max98090.c
> +++ b/sound/soc/codecs/max98090.c
> @@ -2478,12 +2478,14 @@ static int max98090_probe(struct snd_soc_codec *codec)
>   	/* Register for interrupts */
>   	dev_dbg(codec->dev, "irq = %d\n", max98090->irq);
>   
> -	ret = request_threaded_irq(max98090->irq, NULL,
> -		max98090_interrupt, IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> -		"max98090_interrupt", codec);
> -	if (ret < 0) {
> -		dev_err(codec->dev, "request_irq failed: %d\n",
> -			ret);
> +	if (max98090->irq) {
> +		ret = request_threaded_irq(max98090->irq, NULL,
> +			max98090_interrupt, IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> +			"max98090_interrupt", codec);
> +		if (ret < 0) {
> +			dev_err(codec->dev, "request_irq failed: %d\n",
> +				ret);
> +		}
>   	}
>   
Remember to add also "return ret;" at the end of if () {} in case 
request_threaded_irq() fails since code should not continue probing now 
after adding a test for valid irq.

Should the if (max98090->irq) test be >0? I'm not sure is there 
possibility that can i2c->irq actually pass both -1 and 0 depending how 
struct i2c_board_info etc are initialized?

I forgot that I have a fix changing request_threaded_irq() to 
devm_request_threaded_irq() so you should redo your patch on top of 
for-next branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git.

-- 
Jarkko
