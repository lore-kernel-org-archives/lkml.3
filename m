Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3FXSJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:09:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42192 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3FXSJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:09:27 -0400
Message-ID: <51C88B54.9000902@wwwdotorg.org>
Date: Mon, 24 Jun 2013 12:09:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com> <51BA1FE7.4000900@wwwdotorg.org> <CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com> <51BB3A2C.608@wwwdotorg.org> <20130617072021.GB4465@atomide.com> <51C20E3A.8090304@wwwdotorg.org> <20130620063823.GD5523@atomide.com> <51C3577E.6040709@wwwdotorg.org> <20130621062552.GI5523@atomide.com> <51C4A593.6000900@wwwdotorg.org> <20130624101055.GT5523@atomide.com>
In-Reply-To: <20130624101055.GT5523@atomide.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 04:10 AM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [130621 12:18]:
>> On 06/21/2013 12:25 AM, Tony Lindgren wrote:
>>> * Stephen Warren <swarren@wwwdotorg.org> [130620 12:32]:
>>>>
>>>> I assume you mean there shouldn't be any issue *modifying* the pinctrl
>>>> API to allow multiple states to be active at once? And where you're
>>>> talking about having multiple sets active at once already, you're
>>>> talking about some other API?
>>>
>>> Nope, the standard pinctrl API. At least I have not seen issues with
>>> having multiple states active the same time in a single driver.
>>
>> Please take a look at the implementation of pinctrl_select_state(). It
>> very explicitly performs the following steps:
>>
>> 1) Find all pins(groups) that are used in the current state but not the
>> new state, and execute pinctrl_disable_setting() on them. (For mux
>> settings only, not pin config, since the core doesn't have any idea how
>> to reverse config settings).
>>
>> 2) For all settings in the new state, apply those settings.
>>
>> So, it very explicitly only allows a single state to be set at a time.
>> Equally, p->state (the field which stores the currently selected state)
>> is a single item, not a set/list/array.
> 
> OK thanks I get now what you're saying. I did not see the p->state
> issue as the disable function won't do anything for the SoCs that I
> mostly deal with.
> 
>> So, this code needs rework if you want the core to support the concept
>> of having multiple states active at once, since it needs separate
>> pinctrl_activate_state() and pinctrl_deactivate_state() APIs, in order
>> to avoid step (1) above. And of course, p->state would need to be a
>> set/list/array.
> 
> I'll think about it a bit and do a patch to fix this. It seems that
> that we need just two entries in the p->state array: static (default),
> and dynamic. Then the dynamic would be typically one of: active, idle,
> rx, tx.

I'm not entirely convinced that "2" is the right number. If we start
allowing drivers to "piece together" multiple different state names, why
wouldn't you allow 3 (or n) different state names to be active at once?
Off-hand, I don't have specific use-cases in mind for more than 2 state
(or even 1 in my case I suspect) - it just seems like expecting to
arbitrarily restrict the number of co-active states is unlikely to last
for long, and it'll end up being a slippery slope.
