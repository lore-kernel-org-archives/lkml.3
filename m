Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab3CTQOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:14:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33471 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab3CTQOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:14:02 -0400
Message-ID: <5149E048.6030305@wwwdotorg.org>
Date: Wed, 20 Mar 2013 10:14:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@ingics.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUG: pinmux: forbid mux_usecount to be set at UINT_MAX
References: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com> <1363779113-8776-2-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1363779113-8776-2-git-send-email-richard.genoud@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 05:31 AM, Richard Genoud wrote:
> If pin_free is called on a pin already freed, mux_usecount is set to
> UINT_MAX which is really a bad idea.
> This will silently ignore a double call to pin_free

Shouldn't we WARN_ON(this case)?

> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c

>  	if (!gpio_range) {
> -		desc->mux_usecount--;
> -		if (desc->mux_usecount)
> +		if (1 == desc->mux_usecount)
> +			desc->mux_usecount = 0;
> +		else
>  			return NULL;

What if desc-mux_usecount was 2; this patch prevents the use-count from
being decremented to 1 in this case. Shouldn't this be:

  	if (!gpio_range) {
+ 		if (WARN_ON(!desc->mux_usecount))
+ 			return NULL;
  		desc->mux_usecount--;

