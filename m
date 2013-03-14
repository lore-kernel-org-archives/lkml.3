Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3CNQ7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 12:59:50 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:52098 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796Ab3CNQ7s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 12:59:48 -0400
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Seraphin BONNAFFE <seraphin.bonnaffe@stericsson.com>
Date: Thu, 14 Mar 2013 17:59:29 +0100
Subject: Re: [PATCH] pinctrl: move subsystem mutex to pinctrl_dev struct
Thread-Topic: [PATCH] pinctrl: move subsystem mutex to pinctrl_dev struct
Thread-Index: Ac4g1UsEIlACix4FRJKh4p/Cs61PlQ==
Message-ID: <514201F1.6080508@st.com>
References: <1363189479-11240-1-git-send-email-linus.walleij@stericsson.com>
 <5140C3F5.9030406@wwwdotorg.org>
In-Reply-To: <5140C3F5.9030406@wwwdotorg.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
acceptlanguage: fr-FR, en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 07:22 PM, Stephen Warren wrote:

> On 03/13/2013 09:44 AM, Linus Walleij wrote:
>> From: Patrice Chotard <patrice.chotard@st.com>
>>
>> This mutex avoids deadlock in case of use of multiple pin
>> controllers. Before this modification, by using a global
>> mutex, deadlock appeared when, for example, a call to
>> pinctrl_pins_show() locked the pinctrl_mutex, called the
>> ops->pin_dbg_show of a particular pin controller. If this
>> pin controller needs I2C access to retrieve configuration
>> information and I2C driver is using pinctrl to drive its
>> pins, a call to pinctrl_select_state() try to lock again
>> pinctrl_mutex which leads to a deadlock.
>>
>> Notice that the mutex grab from the two direction functions
>> was moved into pinctrl_gpio_direction().
>>
>> For two cases, we can't replace pinctrl_mutex by
>> pctldev->mutex, because at this stage, pctldev is
>> not accessible :
>> 	- pinctrl_get()/pinctrl_put()
>> 	- pinctrl_register_maps()
>>
>> So add respectively pinctrl_list_mutex and
>> pinctrl_maps_mutex in order to protect
>> pinctrl_list and pinctrl_maps list instead.
> 
> I can't see how this would be safe, or even how it would solve the
> problem (and still be safe).
> 
> In the scenario described above, pinctrl_pins_show() would need to lock
> the list mutex since it's interacting with the list of pinctrl devices.
> Then, the I2C drivers'c pinctrl_select() also needs to acquire that same
> lock, since it's interacting with another entry in that same list in
> order to re-program the other pinctrl device to route I2C to the correct
> location.
> 

Hi Stephen,

Thanks for your review.

I don't understand why, in pinctrl_pins_show(), pinctrl_list_mutex
should be locked whereas pinctrl_list is not updated or parsed ?

> So, I can't see how separating out the map lock would make any difference.
> 
> Also, why is the map lock relevant here at all anyway? The I2C mux's
> probe() should have executed pinctrl_get(), and isn't the map parsed at
> that time, and converted to a struct pinctrl, and hence any later call
> to pinctrl_select() doesn't touch the map?


Sorry, but i don't follow what you mean ....
In create_pinctrl(), maps is protected by pinctrl_maps_mutex.
I don't understand the link between maps and pinctrl_select(),
pinctrl_select_state_locked() doesn't touch the map.

> 
> Is there a recursive lock type that could be used instead? I'm not sure
> if that'd still be safe though.
> 
> Finally, a long while ago when I removed these separate locks and
> created the single lock, I raised a slew of complex points re: why it
> was extremely hard to split up the locking. I talked about a number of
> AB/BA deadlock cases IIRC mostly w.r.t pinctrl device registration. Were
> those considered when writing this patch? What's the solution?


I suppose you make reference to the comment you put on this commit ?
57b676f9c1b7cd84397fe5a86c9bd2788ac4bd32 : pinctrl: fix and simplify
locking

Added in CC Seraphin Bonnafe as he has reported the deadlock issue using
several pin ctrollers.