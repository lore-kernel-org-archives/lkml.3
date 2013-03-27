Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3C0XdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:33:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38268 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3C0XdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:33:05 -0400
Message-ID: <515381AC.4050206@wwwdotorg.org>
Date: Wed, 27 Mar 2013 17:33:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Patrice CHOTARD <patrice.chotard@st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Seraphin BONNAFFE <seraphin.bonnaffe@stericsson.com>
Subject: Re: [PATCH] pinctrl: move subsystem mutex to pinctrl_dev struct
References: <1363189479-11240-1-git-send-email-linus.walleij@stericsson.com> <5140C3F5.9030406@wwwdotorg.org> <514201F1.6080508@st.com> <CACRpkdZ_Np-NMwO+nVLYnyUWPcidHq-MN8Ls0YMr4WxTLCLKjw@mail.gmail.com>
In-Reply-To: <CACRpkdZ_Np-NMwO+nVLYnyUWPcidHq-MN8Ls0YMr4WxTLCLKjw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 03:45 PM, Linus Walleij wrote:
> On Thu, Mar 14, 2013 at 5:59 PM, Patrice CHOTARD <patrice.chotard@st.com> wrote:
>> On 03/13/2013 07:22 PM, Stephen Warren wrote:
>>
>>> On 03/13/2013 09:44 AM, Linus Walleij wrote:
>>>> From: Patrice Chotard <patrice.chotard@st.com>
>>>>
>>>> This mutex avoids deadlock in case of use of multiple pin
>>>> controllers. Before this modification, by using a global
>>>> mutex, deadlock appeared when, for example, a call to
>>>> pinctrl_pins_show() locked the pinctrl_mutex, called the
>>>> ops->pin_dbg_show of a particular pin controller. If this
>>>> pin controller needs I2C access to retrieve configuration
>>>> information and I2C driver is using pinctrl to drive its
>>>> pins, a call to pinctrl_select_state() try to lock again
>>>> pinctrl_mutex which leads to a deadlock.
>>>>
>>>> Notice that the mutex grab from the two direction functions
>>>> was moved into pinctrl_gpio_direction().
>>>>
>>>> For two cases, we can't replace pinctrl_mutex by
>>>> pctldev->mutex, because at this stage, pctldev is
>>>> not accessible :
>>>>      - pinctrl_get()/pinctrl_put()
>>>>      - pinctrl_register_maps()
>>>>
>>>> So add respectively pinctrl_list_mutex and
>>>> pinctrl_maps_mutex in order to protect
>>>> pinctrl_list and pinctrl_maps list instead.
>>>
>>> I can't see how this would be safe, or even how it would solve the
>>> problem (and still be safe).
>>>
>>> In the scenario described above, pinctrl_pins_show() would need to lock
>>> the list mutex since it's interacting with the list of pinctrl devices.
>>> Then, the I2C drivers'c pinctrl_select() also needs to acquire that same
>>> lock, since it's interacting with another entry in that same list in
>>> order to re-program the other pinctrl device to route I2C to the correct
>>> location.
>>>
>>
>> Hi Stephen,
>>
>> Thanks for your review.
>>
>> I don't understand why, in pinctrl_pins_show(), pinctrl_list_mutex
>> should be locked whereas pinctrl_list is not updated or parsed ?

Sorry for the slow response.

If pinctrl_pins_show() calls into a pin controller, then the list of pin
controllers must be locked to prevent that pin controller from being
destroyed while the "show" code is still using it.

I suppose an alternative would be module_get() the relevant driver's
module to prevent it from being unloaded. I'm not sure if that would
remove the need to scan through the list of pin controllers (which would
then require taking the lock), or whether something else knows which
driver is related to each debugfs file so that no list lookup is
required? Perhaps debugfs already does that internally somehow?

>>> So, I can't see how separating out the map lock would make any difference.
>>>
>>> Also, why is the map lock relevant here at all anyway? The I2C mux's
>>> probe() should have executed pinctrl_get(), and isn't the map parsed at
>>> that time, and converted to a struct pinctrl, and hence any later call
>>> to pinctrl_select() doesn't touch the map?
>>
>> Sorry, but i don't follow what you mean ....
>> In create_pinctrl(), maps is protected by pinctrl_maps_mutex.

>> I don't understand the link between maps and pinctrl_select(),
>> pinctrl_select_state_locked() doesn't touch the map.

Yes, pinctrl_select() shouldn't touch the map since it's already been
parsed.

But if there's a per-pinctrl-driver lock, then pinctrl_select() needs to
lock all those locks for each driver referenced by a struct
pinctrl_state entry.

Perhaps it doesn't need to hold more than one of those at a time though;
that might help remove any possibility of deadlock.

>>> Is there a recursive lock type that could be used instead? I'm not sure
>>> if that'd still be safe though.
>>>
>>> Finally, a long while ago when I removed these separate locks and
>>> created the single lock, I raised a slew of complex points re: why it
>>> was extremely hard to split up the locking. I talked about a number of
>>> AB/BA deadlock cases IIRC mostly w.r.t pinctrl device registration. Were
>>> those considered when writing this patch? What's the solution?
>>
>> I suppose you make reference to the comment you put on this commit ?
>> 57b676f9c1b7cd84397fe5a86c9bd2788ac4bd32 : pinctrl: fix and simplify
>> locking

Yes, that commit and the email thread surrounding it.

>> Added in CC Seraphin Bonnafe as he has reported the deadlock issue using
>> several pin ctrollers.
> 
> Any reaction to this?

I was hoping that Patrice would go through the various issues I raised
in that commit log and the surrounding email discussion and point out
exactly why the proposed locking scheme would not cause the problems I
mentioned there.

> I can intuitively agree with the idea that the locking should not
> be for the entire subsystem but preferably per-controller.

Yes, that would be great if it doesn't introduce any issues.

> Indeed that commit says:
> 
>     Solving this requires the introduction of a higher-level lock, at least
>     a lock per pin controller, which both gpio range registration and
>     pinctrl_get()/put() will acquire.
> 
> So this is the "atleast".

Yup.

> Then it says:
> 
>     Related, a future change will add a
>     "complete" op to the pin controller drivers, the idea being that each
>     state's programming will be programmed into the pinctrl driver followed
>     by the "complete" call,
> 
> Hm that is actually quite useful but we haven't got around to
> doing that, and it should be able to use the same per-controller mutex.

Indeed. I guess nobody ended up caring about that optimization yet.
Still, it's something that should be easy to add any time it's useful.

> And that of course brings into the question of locking when accessing
> the list of such controllers, or the maps, neither of which are part
> of any controller. So these needs to be a separate mutexes.
> 
> The old locking would be per-descriptor but this patch preserves
> part of the reform in Stephen's patch, it keeps one big lock for
> everything happening in a certain pin controller, but brings back
> the two locks for lists and maps.

OK.

> The commit message also states:
> 
>     However, each pinctrl mapping table entry may affect a different pin
>     controller if necessary. Hence, with a per-pin-controller lock, almost
>     any pinctrl API may need to acquire multiple locks, one per controller.
>     To avoid deadlock, these would need to be acquired in the same order in
>     all cases. This is extremely difficult to implement in the case of
>     pinctrl_get(), which doesn't know which pin controllers to lock until it
>     has parsed the entire mapping table, since it contains somewhat arbitrary
>     data.
> 
> This is the real problem, right?

That's one issue.

Perhaps if we acquire and release the locks for each controller as we
process each individual entry in struct pinctrl_state, we'll never hold
more than one per-pinctrl-driver lock at once, so there won't be any
possibility of ABBA locking problems across multiple pinctrl drivers.

But there's at least one more issue that I vaguely recall now: When
registering a pinctrl driver, the pinctrl core can automatically select
that device's own default state (a/k/a hogging). pinctrl_register()
would need to hold the list lock since it's manipulating the list.
However, if we re-use the pinctrl_select() code, then that requires
recursive locking; the lock is held once by pinctrl_register, and would
need to be taken during map->pinctrl_state conversion in order to look
up the pinctrl driver for each map entry. There was some reason it
didn't make sense to first register the new pinctrl driver, then drop
the list lock, then apply the hogs outside the lock, but I forget what
that was:-( Perhaps I was mistaken here. Or perhaps, I was just trying
to avoid many lock/unlock operations during register, and I should have
just not tried to avoid that.

> This patch will just take the pinctrl_list_mutex in the pinctrl_get()
> path. If it then ends up in create_pinctrl() from there
> it is iterating the map, and should thus also take the
> pinctrl_maps_mutex, which it does.
> 
> I don't quite see how taking these two orthogonal mutexes would
> be so complicated to get right, so please help me out here.

The main issue I was trying to avoid was deadlock due to ABBA lock
acquisition.
