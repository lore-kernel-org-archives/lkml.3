Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab3C0VpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:45:17 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:64213 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3C0VpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:45:15 -0400
MIME-Version: 1.0
In-Reply-To: <514201F1.6080508@st.com>
References: <1363189479-11240-1-git-send-email-linus.walleij@stericsson.com>
	<5140C3F5.9030406@wwwdotorg.org>
	<514201F1.6080508@st.com>
Date: Wed, 27 Mar 2013 22:45:13 +0100
Message-ID: <CACRpkdZ_Np-NMwO+nVLYnyUWPcidHq-MN8Ls0YMr4WxTLCLKjw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: move subsystem mutex to pinctrl_dev struct
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrice CHOTARD <patrice.chotard@st.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Seraphin BONNAFFE <seraphin.bonnaffe@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 5:59 PM, Patrice CHOTARD <patrice.chotard@st.com> wrote:
> On 03/13/2013 07:22 PM, Stephen Warren wrote:
>
>> On 03/13/2013 09:44 AM, Linus Walleij wrote:
>>> From: Patrice Chotard <patrice.chotard@st.com>
>>>
>>> This mutex avoids deadlock in case of use of multiple pin
>>> controllers. Before this modification, by using a global
>>> mutex, deadlock appeared when, for example, a call to
>>> pinctrl_pins_show() locked the pinctrl_mutex, called the
>>> ops->pin_dbg_show of a particular pin controller. If this
>>> pin controller needs I2C access to retrieve configuration
>>> information and I2C driver is using pinctrl to drive its
>>> pins, a call to pinctrl_select_state() try to lock again
>>> pinctrl_mutex which leads to a deadlock.
>>>
>>> Notice that the mutex grab from the two direction functions
>>> was moved into pinctrl_gpio_direction().
>>>
>>> For two cases, we can't replace pinctrl_mutex by
>>> pctldev->mutex, because at this stage, pctldev is
>>> not accessible :
>>>      - pinctrl_get()/pinctrl_put()
>>>      - pinctrl_register_maps()
>>>
>>> So add respectively pinctrl_list_mutex and
>>> pinctrl_maps_mutex in order to protect
>>> pinctrl_list and pinctrl_maps list instead.
>>
>> I can't see how this would be safe, or even how it would solve the
>> problem (and still be safe).
>>
>> In the scenario described above, pinctrl_pins_show() would need to lock
>> the list mutex since it's interacting with the list of pinctrl devices.
>> Then, the I2C drivers'c pinctrl_select() also needs to acquire that same
>> lock, since it's interacting with another entry in that same list in
>> order to re-program the other pinctrl device to route I2C to the correct
>> location.
>>
>
> Hi Stephen,
>
> Thanks for your review.
>
> I don't understand why, in pinctrl_pins_show(), pinctrl_list_mutex
> should be locked whereas pinctrl_list is not updated or parsed ?
>
>> So, I can't see how separating out the map lock would make any difference.
>>
>> Also, why is the map lock relevant here at all anyway? The I2C mux's
>> probe() should have executed pinctrl_get(), and isn't the map parsed at
>> that time, and converted to a struct pinctrl, and hence any later call
>> to pinctrl_select() doesn't touch the map?
>
>
> Sorry, but i don't follow what you mean ....
> In create_pinctrl(), maps is protected by pinctrl_maps_mutex.
> I don't understand the link between maps and pinctrl_select(),
> pinctrl_select_state_locked() doesn't touch the map.
>
>>
>> Is there a recursive lock type that could be used instead? I'm not sure
>> if that'd still be safe though.
>>
>> Finally, a long while ago when I removed these separate locks and
>> created the single lock, I raised a slew of complex points re: why it
>> was extremely hard to split up the locking. I talked about a number of
>> AB/BA deadlock cases IIRC mostly w.r.t pinctrl device registration. Were
>> those considered when writing this patch? What's the solution?
>
>
> I suppose you make reference to the comment you put on this commit ?
> 57b676f9c1b7cd84397fe5a86c9bd2788ac4bd32 : pinctrl: fix and simplify
> locking
>
> Added in CC Seraphin Bonnafe as he has reported the deadlock issue using
> several pin ctrollers.

Any reaction to this?

I can intuitively agree with the idea that the locking should not
be for the entire subsystem but preferably per-controller.

Indeed that commit says:

    Solving this requires the introduction of a higher-level lock, at least
    a lock per pin controller, which both gpio range registration and
    pinctrl_get()/put() will acquire.

So this is the "atleast".

Then it says:

    Related, a future change will add a
    "complete" op to the pin controller drivers, the idea being that each
    state's programming will be programmed into the pinctrl driver followed
    by the "complete" call,

Hm that is actually quite useful but we haven't got around to
doing that, and it should be able to use the same per-controller mutex.

And that of course brings into the question of locking when accessing
the list of such controllers, or the maps, neither of which are part
of any controller. So these needs to be a separate mutexes.

The old locking would be per-descriptor but this patch preserves
part of the reform in Stephen's patch, it keeps one big lock for
everything happening in a certain pin controller, but brings back
the two locks for lists and maps.

The commit message also states:

    However, each pinctrl mapping table entry may affect a different pin
    controller if necessary. Hence, with a per-pin-controller lock, almost
    any pinctrl API may need to acquire multiple locks, one per controller.
    To avoid deadlock, these would need to be acquired in the same order in
    all cases. This is extremely difficult to implement in the case of
    pinctrl_get(), which doesn't know which pin controllers to lock until it
    has parsed the entire mapping table, since it contains somewhat arbitrary
    data.

This is the real problem, right?

This patch will just take the pinctrl_list_mutex in the pinctrl_get()
path. If it then ends up in create_pinctrl() from there
it is iterating the map, and should thus also take the
pinctrl_maps_mutex, which it does.

I don't quite see how taking these two orthogonal mutexes would
be so complicated to get right, so please help me out here.

Yours,
Linus Walleij
