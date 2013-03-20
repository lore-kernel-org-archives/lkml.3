Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3CTRI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 13:08:58 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42886 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893Ab3CTRI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 13:08:56 -0400
Message-ID: <5149ED25.4010309@wwwdotorg.org>
Date: Wed, 20 Mar 2013 11:08:53 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@ingics.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BUG: pinmux: forbid mux_usecount to be set at UINT_MAX
References: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com> <1363779113-8776-2-git-send-email-richard.genoud@gmail.com> <5149E048.6030305@wwwdotorg.org> <CACQ1gAjNFgPg+k9MLgGfvWGTYK1mi2nsiQ-LwCu2gdjjL3wkCA@mail.gmail.com>
In-Reply-To: <CACQ1gAjNFgPg+k9MLgGfvWGTYK1mi2nsiQ-LwCu2gdjjL3wkCA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 10:59 AM, Richard Genoud wrote:
> 2013/3/20 Stephen Warren <swarren@wwwdotorg.org>:
>> On 03/20/2013 05:31 AM, Richard Genoud wrote:
>>> If pin_free is called on a pin already freed, mux_usecount is set to
>>> UINT_MAX which is really a bad idea.
>>> This will silently ignore a double call to pin_free
>>
>> Shouldn't we WARN_ON(this case)?
> yes indeed, it may be better to issue a big warning because AFAIK
> that's not normal.
> 
>>
>>> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
>>
>>>       if (!gpio_range) {
>>> -             desc->mux_usecount--;
>>> -             if (desc->mux_usecount)
>>> +             if (1 == desc->mux_usecount)
>>> +                     desc->mux_usecount = 0;
>>> +             else
>>>                       return NULL;
>>
>> What if desc-mux_usecount was 2; this patch prevents the use-count from
>> being decremented to 1 in this case. Shouldn't this be:
>>
>>         if (!gpio_range) {
>> +               if (WARN_ON(!desc->mux_usecount))
>> +                       return NULL;
>>                 desc->mux_usecount--;
>
> Well, I'm not very familiar with this code, but can mux_usecount be
> higher than 1 ?

Possibly not, but isn't that more something that the
resource-acquisition code (i.e. whatever does mux_usecount++) should
enforce; the cleanup code should probably support all cases in case the
enforcement rules change in the future. Either that, or convert the
field to a bool so it's clear what the range is.

