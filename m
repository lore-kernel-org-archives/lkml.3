Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab3DXI6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 04:58:21 -0400
Received: from mail-ia0-f170.google.com ([209.85.210.170]:50535 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab3DXI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 04:58:19 -0400
MIME-Version: 1.0
In-Reply-To: <5165636F.2000602@st.com>
References: <1363189479-11240-1-git-send-email-linus.walleij@stericsson.com>
	<5140C3F5.9030406@wwwdotorg.org>
	<514201F1.6080508@st.com>
	<CACRpkdZ_Np-NMwO+nVLYnyUWPcidHq-MN8Ls0YMr4WxTLCLKjw@mail.gmail.com>
	<515381AC.4050206@wwwdotorg.org>
	<5165636F.2000602@st.com>
Date: Wed, 24 Apr 2013 10:58:18 +0200
Message-ID: <CACRpkdYDqknA11E+9erixP+SLV4LDgVmmJ3CcJOnTRbfOZr9Bg@mail.gmail.com>
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

On Wed, Apr 10, 2013 at 3:04 PM, Patrice CHOTARD <patrice.chotard@st.com> wrote:
> On 03/28/2013 12:33 AM, Stephen Warren wrote:

>>>> I don't understand the link between maps and pinctrl_select(),
>>>> pinctrl_select_state_locked() doesn't touch the map.
>>
>> Yes, pinctrl_select() shouldn't touch the map since it's already been
>> parsed.
>>
>> But if there's a per-pinctrl-driver lock, then pinctrl_select() needs to
>> lock all those locks for each driver referenced by a struct
>> pinctrl_state entry.
>>
>> Perhaps it doesn't need to hold more than one of those at a time though;
>> that might help remove any possibility of deadlock.
>
> Ok, regarding pinctrl_select(), i will propose a new patch version which
> hold the per-pincontrol-driver lock referenced by each struct
> pinctrl_state entry.

I've tested this (with a newer patch from Patrice) and it regresses
on the U300 platform.

pinctrl_select_state() calls pinconf_apply_setting, which
calls ops->pin_config_set(), which needs to figure out the
GPIO range for this pin and calls back into core function
pinctrl_find_gpio_range_from_pin(), which again takes
the pctldev mutex -> deadlock.

What I do not understand is this: both pinctrl_lookup_state()
and pinctrl_select_state() are taking (today) the global
pinctrl mutex. Patrice's patch moves this to take the dev list
mutex.

Taking the dev list mutex is not correct since we're only
dealing with the isolated struct pinctrl * at this point.
I think. Unless the idea is to protect agains the device
being removed underneath.

I don't see the point in taking either mutex actually and
what it's protecting against. If it's just protecting against the
pinctrl device being removed during state selection, doing
that will cause *way* bigger problems anyway (think of all
the devices that have struct pinctrl * around!) so it's not
the way forward anyway. The struct pinctrl * was designed
to be floating around independently of the devices since
forever.

pinctrl_unregister() calls pinctrl_put_locked() on all pinctrl
handles, at which point it should scream if any of these are
in use and that is the big problem with removing the pinctrl
devices - the system as a whole just need to make sure
there are no users left, it cannot be guaranteed with
mutexes.

I just removed those two mutexes (in pinctrl_lookup_state
and pinctrl_select_state), will send the modified
version of Patrice's patch soon-ish.

Yours,
Linus Walleij
