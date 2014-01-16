Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaAPVu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 16:50:27 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:41539 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbaAPVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 16:50:24 -0500
Message-ID: <52D854A3.5090109@metafoo.de>
Date: Thu, 16 Jan 2014 22:52:35 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: core: Use devm_kzalloc() instead kzalloc()
References: <1389861887-32721-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1389861887-32721-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2014 09:44 AM, Xiubo Li wrote:
> Makes the code slightly shorter
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

I don't like this. I don't think it is a good design pattern to call devm 
function from within (especial non-devm) library functions. It creates an 
asymmetric API. The memory is allocated when snd_dmaengine_pcm_register() is 
called, but it is not freed when  snd_dmaengine_pcm_unregister() is called. 
This goes against the principle of least surprise.

- Lars

> ---
>   sound/soc/soc-generic-dmaengine-pcm.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/sound/soc/soc-generic-dmaengine-pcm.c b/sound/soc/soc-generic-dmaengine-pcm.c
> index 5bace12..bfb012f 100644
> --- a/sound/soc/soc-generic-dmaengine-pcm.c
> +++ b/sound/soc/soc-generic-dmaengine-pcm.c
> @@ -388,7 +388,7 @@ int snd_dmaengine_pcm_register(struct device *dev,
>   	struct dmaengine_pcm *pcm;
>   	int ret;
>
> -	pcm = kzalloc(sizeof(*pcm), GFP_KERNEL);
> +	pcm = devm_kzalloc(dev, sizeof(*pcm), GFP_KERNEL);
>   	if (!pcm)
>   		return -ENOMEM;
>
> @@ -408,7 +408,6 @@ int snd_dmaengine_pcm_register(struct device *dev,
>
>   err_free_dma:
>   	dmaengine_pcm_release_chan(pcm);
> -	kfree(pcm);
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_register);
> @@ -433,7 +432,6 @@ void snd_dmaengine_pcm_unregister(struct device *dev)
>
>   	snd_soc_remove_platform(platform);
>   	dmaengine_pcm_release_chan(pcm);
> -	kfree(pcm);
>   }
>   EXPORT_SYMBOL_GPL(snd_dmaengine_pcm_unregister);
>
>

