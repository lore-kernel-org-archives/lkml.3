Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3HTUZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:25:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57308 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3HTUZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:25:12 -0400
Message-ID: <5213D0A5.7000504@wwwdotorg.org>
Date: Tue, 20 Aug 2013 14:25:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: utils : add support to pass config type
 in generic util APIs
References: <1377000758-3795-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1377000758-3795-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 06:12 AM, Laxman Dewangan wrote:
> Add support to pass the config type like GROUP or PIN when using
> the utils or generic pin configuration APIs. This will make the
> APIs more generic.

I think passing in the type parameter to the *_to_map APIs makes sense,
but I don't think you need to have separate free functions; the way to
free any kind of map entry is always known, so you don't have to limit
the code to only freeing one type.

> diff --git a/drivers/pinctrl/pinctrl-utils.c b/drivers/pinctrl/pinctrl-utils.c

> -void pinctrl_utils_dt_free_map(struct pinctrl_dev *pctldev,
> -	      struct pinctrl_map *map, unsigned num_maps)
> +void pinctrl_utils_dt_free_map_config(struct pinctrl_dev *pctldev,
> +		struct pinctrl_map *map, unsigned num_maps,
> +		enum pinctrl_map_type type)
>  {
>  	int i;
>  
>  	for (i = 0; i < num_maps; i++)
> -		if (map[i].type == PIN_MAP_TYPE_CONFIGS_GROUP)
> +		if (map[i].type == type)
>  			kfree(map[i].data.configs.configs);

In other words, replace that if with:

switch (maps[i].type) {
case PIN_MAP_TYPE_CONFIGS_PIN:
case PIN_MAP_TYPE_CONFIGS_GROUP:
	kfree(map[i].data.configs.configs);
	break;
default:
	break;
}

