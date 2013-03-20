Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3CTRAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:00:09 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:51470 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3CTRAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:00:07 -0400
MIME-Version: 1.0
In-Reply-To: <5149E048.6030305@wwwdotorg.org>
References: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com>
 <1363779113-8776-2-git-send-email-richard.genoud@gmail.com> <5149E048.6030305@wwwdotorg.org>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 20 Mar 2013 17:59:46 +0100
Message-ID: <CACQ1gAjNFgPg+k9MLgGfvWGTYK1mi2nsiQ-LwCu2gdjjL3wkCA@mail.gmail.com>
Subject: Re: [PATCH] BUG: pinmux: forbid mux_usecount to be set at UINT_MAX
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@ingics.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/20 Stephen Warren <swarren@wwwdotorg.org>:
> On 03/20/2013 05:31 AM, Richard Genoud wrote:
>> If pin_free is called on a pin already freed, mux_usecount is set to
>> UINT_MAX which is really a bad idea.
>> This will silently ignore a double call to pin_free
>
> Shouldn't we WARN_ON(this case)?
yes indeed, it may be better to issue a big warning because AFAIK
that's not normal.

>
>> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
>
>>       if (!gpio_range) {
>> -             desc->mux_usecount--;
>> -             if (desc->mux_usecount)
>> +             if (1 == desc->mux_usecount)
>> +                     desc->mux_usecount = 0;
>> +             else
>>                       return NULL;
>
> What if desc-mux_usecount was 2; this patch prevents the use-count from
> being decremented to 1 in this case. Shouldn't this be:
>
>         if (!gpio_range) {
> +               if (WARN_ON(!desc->mux_usecount))
> +                       return NULL;
>                 desc->mux_usecount--;
>
Well, I'm not very familiar with this code, but can mux_usecount be
higher than 1 ?
