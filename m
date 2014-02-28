Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaB1G6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:58:12 -0500
Received: from smtp-out-127.synserver.de ([212.40.185.127]:1055 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751334AbaB1G6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:58:10 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 9354
Message-ID: <53103399.5070202@metafoo.de>
Date: Fri, 28 Feb 2014 07:58:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: broonie@kernel.org, lgirdwood@gmail.com, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: cache: Do the codec->reg_cache zero
 pionter check
References: <1393555699-12752-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1393555699-12752-1-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 03:48 AM, Xiubo Li wrote:
> For the snd_soc_cache_init(), the reg_size maybe zero and then the value
> of codec->reg_cache, which is alloced via kzalloc, maybe equal to
> ZERO_SIZE_PTR. If the reg parameter of snd_soc_cache_write() is large enough,
> the cache[idx] = val maybe cause the kernel crash...
>

There are actually no users of snd_soc_cache_{read,write}() left. Since all 
drivers using snd_soc_set_cache_io() are now using native regmap the path in 
hw_{read,write} that does call snd_soc_cache_{read,write}() is never hit.

If you want to avoid this theoretical issue just remove the functions.

> So this patch fix this via doing the zero pionter check of it.
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>   sound/soc/soc-cache.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/sound/soc/soc-cache.c b/sound/soc/soc-cache.c
> index 375dc6d..bfed3e4 100644
> --- a/sound/soc/soc-cache.c
> +++ b/sound/soc/soc-cache.c
> @@ -96,8 +96,7 @@ int snd_soc_cache_exit(struct snd_soc_codec *codec)
>   {
>   	dev_dbg(codec->dev, "ASoC: Destroying cache for %s codec\n",
>   			codec->name);
> -	if (!codec->reg_cache)
> -		return 0;
> +
>   	kfree(codec->reg_cache);
>   	codec->reg_cache = NULL;
>   	return 0;
> @@ -117,8 +116,9 @@ int snd_soc_cache_read(struct snd_soc_codec *codec,
>   		return -EINVAL;
>
>   	mutex_lock(&codec->cache_rw_mutex);
> -	*value = snd_soc_get_cache_val(codec->reg_cache, reg,
> -				       codec->driver->reg_word_size);
> +	if (!ZERO_OR_NULL_PTR(codec->reg_cache))
> +		*value = snd_soc_get_cache_val(codec->reg_cache, reg,
> +					       codec->driver->reg_word_size);
>   	mutex_unlock(&codec->cache_rw_mutex);
>
>   	return 0;
> @@ -136,8 +136,9 @@ int snd_soc_cache_write(struct snd_soc_codec *codec,
>   			unsigned int reg, unsigned int value)
>   {
>   	mutex_lock(&codec->cache_rw_mutex);
> -	snd_soc_set_cache_val(codec->reg_cache, reg, value,
> -			      codec->driver->reg_word_size);
> +	if (!ZERO_OR_NULL_PTR(codec->reg_cache))
> +		snd_soc_set_cache_val(codec->reg_cache, reg, value,
> +				      codec->driver->reg_word_size);
>   	mutex_unlock(&codec->cache_rw_mutex);
>
>   	return 0;
>

