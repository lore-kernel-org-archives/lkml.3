Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab3C1PrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:47:23 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62639 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab3C1PrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:47:22 -0400
MIME-Version: 1.0
In-Reply-To: <5154594D.6000103@wwwdotorg.org>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
 <1364222843-30305-4-git-send-email-richard.genoud@gmail.com>
 <5153859A.8000801@wwwdotorg.org> <CACQ1gAjEUsCuFThzAfoX3-PHn3h70=qw+uktHNd9cQDWeQZ1Jw@mail.gmail.com>
 <5154594D.6000103@wwwdotorg.org>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 28 Mar 2013 16:47:01 +0100
Message-ID: <CACQ1gAhL8q_-4vJ=ivLQ=bbt5k9QHDd5dtKLWoXT8DsM0MFa0A@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: disable and free setting in select_state in
 case of error
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/28 Stephen Warren <swarren@wwwdotorg.org>:
> On 03/28/2013 04:55 AM, Richard Genoud wrote:
>> 2013/3/28 Stephen Warren <swarren@wwwdotorg.org>:
>>> On 03/25/2013 08:47 AM, Richard Genoud wrote:
>>>> If enabling a pin fails in pinctrl_select_state_locked(), all the
>>>> previous enabled pins have to be disabled to get back to the previous
>>>> state.
>>>
>>>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>
>>>> +     list_for_each_entry(setting2, &state->settings, node) {
>>>> +             if (&setting2->node == &setting->node)
>>>> +                     break;
>>>> +             pinctrl_free_setting(true, setting2);
>>>
>>> That's clearly wrong.
>>>
>>> pinctrl_free_setting() is supposed to free any memory associated with
>>> the setting; the storage that holds the representation of that setting.
>>>
>>> It's only appropriate to do that in pinctrl_put(), when actually
>>> destroying the whole struct pinctrl object. If pinctrl_select() fails,
>>> we don't want to destroy/invalidate the struct pinctrl content, but
>>> rather keep it around in case the driver uses it again even if the face
>>> of previous errors.
>>>
>>> In other words, what you should be doing inside this loop body is
>>> exactly what the body of the first loop inside pinctrl_select_state()
>>> does to "undo" any previously selected state, which is to call
>>> pinmux_disable_setting() for each entry, or something similar to that.
>>
>> The code here tries to undo what have been done in the *second* loop
>> of pinctrl_select_state().
>>
>> The "do" loop is:
>>
>>       list_for_each_entry(setting, &state->settings, node) {
>>               switch (setting->type) {
>>               case PIN_MAP_TYPE_MUX_GROUP:
>>                       ret = pinmux_enable_setting(setting);
>>                       break;
>>               case PIN_MAP_TYPE_CONFIGS_PIN:
>>               case PIN_MAP_TYPE_CONFIGS_GROUP:
>>                       ret = pinconf_apply_setting(setting);
>>                       break;
>>               default:
>>                       ret = -EINVAL;
>>                       break;
>>               }
>>
>>               if (ret < 0)
>>                       goto unapply_new_state;
>>       }
>
> Right, I understand that.
>
>> And maybe I'm wrong, but I understood that to "undo" pinmux_enable_setting,
>> we call pinmux_disable_setting()
>
> Yes.
>
>> and pinmux_free_setting() (which is empty for now).
>
> No. pinmux_free_setting() free's the storage for a setting. Right now,
> nothing is dynamically allocated for the setting, so there's nothing to
> do. However, it's still semantically wrong to try to free it at this point.
Ok, I understand now.

>
>> And to undo pinconf_apply_setting() we call pinconf_free_setting()
>> And that's what pinctrl_free_setting() does.
>
> There's no way to undo the application of a setting. The only way to
> undo it is to apply a new setting that over-writes it. Hopefully,
> re-applying a different state would do that, but it's not guaranteed.
>
> Again, pinconf_free_setting() is all about freeing any dynamically
> allocated storage required to represent the setting itself; it's not
> about (un-)programming HW.
>
got it.
I'll change that

thanks !


-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
