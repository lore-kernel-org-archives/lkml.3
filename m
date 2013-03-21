Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3CULcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:32:08 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:52582 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3CULcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:32:06 -0400
MIME-Version: 1.0
In-Reply-To: <5149E296.1030304@wwwdotorg.org>
References: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com>
 <1363779113-8776-3-git-send-email-richard.genoud@gmail.com> <5149E296.1030304@wwwdotorg.org>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 21 Mar 2013 12:31:44 +0100
Message-ID: <CACQ1gAgjku1c+49H8STASg8jhKwFuLuJ_prhnkcGyknVuZUfpw@mail.gmail.com>
Subject: Re: [PATCH] BUG: [RFC] pinctrl: pins are freed 2 times in pinctrl_bind_pins
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@ingics.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/20 Stephen Warren <swarren@wwwdotorg.org>:
> On 03/20/2013 05:31 AM, Richard Genoud wrote:
>> If the function pinctrl_select_state() fails because one pin is already
>> taken elsewhere, pinmux_enable_setting makes all the necessary pin_free
>> calls (and not more than necessary).
>> The problem here is that devm_pinctrl_put() will be called on the pin
>> group, and each pin in this group has already been freed.
>>
>> Example:
>> If a i2c function has already sucessfully taken pins 5 and 6.
>> And now, pinctrl_bind_pins() is called for function PHY (pins 3 4 5 6 7).
>> pinmux_enable_setting() will fail AND call pin_free on necessary pins.
>> But if devm_pinctrl_put() is called, it will call again pin_free on pins
>> 3 4 5 6 7.
>> So, the pins 5 and 6 will be released (and pins 3 4 7 double freed).
>> Which means that even if the i2c function has claim the pins, they will
>> be available for other functions.
>>
>> This patch simply doesn't call devm_pinctrl_put when
>> pinctrl_select_state fails, but I'm not sure it's the right thing to do.
>
> The correct fix here is not to skip the call to devm_pinctrl_put(),
> since that undoes a lot of other things besides the current state selection.
>
> Instead, pinctrl_select_state_locked() needs to be fixed so that:
>
> a)
>
> Change "p->state = state;" to "p->state = NULL;" or similar, to indicate
> that no state is selected. (Please validate if a NULL value in that
> variable will cause problems elsewhere)
>
> b)
>
> Add back the assignment "p->state = state;" at the end of the function,
> if no error occurred.
>
> c)
>
> Fix the list_for_each_entry() call that applies all the settings for the
> new state so that if it fails, it undoes everything that it's applied so
> far. That's the hard part, unless there's a
> list_for_each_entry_before_the_current_one_that_list_for_each_entry_iterated_over_already()
> macro!
ok, I'll look into that.
Thanks for your advices !

PS: with its 90chars long, your macro won't please checkpatch.pl ! :)

Regards,
Richard
