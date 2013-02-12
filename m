Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab3BLQ5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:57:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42009 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3BLQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:57:32 -0500
Message-ID: <511A7478.8040506@wwwdotorg.org>
Date: Tue, 12 Feb 2013 09:57:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Laurent Meunier <laurent.meunier@st.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Subject: Re: [PATCH] pinctrl/pinconfig: add debug interface
References: <1360527070-18430-1-git-send-email-linus.walleij@stericsson.com> <51195A63.7080706@wwwdotorg.org> <CACRpkdZu0+maCE2GjuZcQPZPZbw=Fz0DUHYY8FXPdZEH0PeViQ@mail.gmail.com>
In-Reply-To: <CACRpkdZu0+maCE2GjuZcQPZPZbw=Fz0DUHYY8FXPdZEH0PeViQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 05:54 AM, Linus Walleij wrote:
> On Mon, Feb 11, 2013 at 9:53 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 02/10/2013 01:11 PM, Linus Walleij wrote:
>>> From: Laurent Meunier <laurent.meunier@st.com>
>>>
>>> This update adds a debugfs interface to modify a pin configuration
>>> for a given state in the pinctrl map. This allows to modify the
>>> configuration for a non-active state, typically sleep state.
>>> This configuration is not applied right away, but only when the state
>>> will be entered.
>>>
>>> This solution is mandated for us by HW validation: in order
>>> to test and verify several pin configurations during sleep without
>>> recompiling the software.
...
>>> +/**
>>> + * pinconf_dbg_config_write() - overwrite the pinctrl config in thepinctrl
>>> + * map, of a pin/state pair based on pinname and state that have been
>>> + * selected with the debugfs entries pinconf-name and pinconf-state
>>> + */
>>> +static int pinconf_dbg_config_write(struct file *file,
>>> +     const char __user *user_buf, size_t count, loff_t *ppos)
>>> +{
>>> +     int err;
>>> +     unsigned long config;
>>> +     struct pinctrl_maps *maps_node;
>>> +     struct pinctrl_map const *map;
>>> +     int i, j;
>>> +
>>> +     err = kstrtoul_from_user(user_buf, count, 0, &config);
>>> +
>>> +     if (err)
>>> +             return err;
>>> +
>>> +     dbg_config = config;
>>
>> That assumes that pin config values are a plain u32. While this is
>> commonly true in existing pinctrl drivers, it certainly isn't something
>> that the pinctrl core mandates;
> 
> So there is this unsigned long and it has a value.
> 
> The interface should support altering that unsigned long not
> really caring for what it contains. It seems pretty straight-forward
> to me.

But it's not an unsigned long - it's an opaque value that just happens
to be stored in an unsigned long.

> Of course, if this unsigned long is a pointer, this is just a
> fantastic recipe for shooting oneself in the foot, but again
> debugfs is just one big gun aimed at ones foot anyway, that's
> the whole point of debugfs.

But it'd be possible to handle this if the code to modify the map called
into the individual pinctrl driver to convert the data the user wrote
into the value to store in the map, just like it does for DT.

Then, it'd work in all cases.

Plus, it could convert e.g. "pull up" to 0x10001 rather than requiring
the user to manually encode the 0x10001 themselves; much more useful.

>> that's the whole point of
>> dt_node_to_map() for example, to allow the individual pinctrl drivers to
>> use whatever type (scalar, pointer-to-struct, ...) they want to
>> represent their config values.
> 
> Yes. But it is an unsigned long, and we support altering it.
> 
> And the whole point of debugfs is to do crazy stuff like that.

Well to some extent, but there's little point in creating a debugfs file
that makes different assumptions about what its doing than any other
code that uses the same data structures.

