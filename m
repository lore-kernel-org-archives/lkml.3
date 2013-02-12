Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377Ab3BLPcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 10:32:10 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:42381 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571Ab3BLPcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 10:32:08 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZu0+maCE2GjuZcQPZPZbw=Fz0DUHYY8FXPdZEH0PeViQ@mail.gmail.com>
References: <1360527070-18430-1-git-send-email-linus.walleij@stericsson.com>
	<51195A63.7080706@wwwdotorg.org>
	<CACRpkdZu0+maCE2GjuZcQPZPZbw=Fz0DUHYY8FXPdZEH0PeViQ@mail.gmail.com>
Date: Tue, 12 Feb 2013 23:32:08 +0800
Message-ID: <CAN1soZzCpc5grX2iNNpD0VtEctCPg1kDks1CURwNGAn4zN5vuw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/pinconfig: add debug interface
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laurent Meunier <laurent.meunier@st.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 8:54 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
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
>>
>> I never understood why HW engineers can't just recompile the kernel.
>> Besides, it's just a device tree change these days - no recompile even
>> required, right?
>
> Oh well, they have their habits, like testing a range of different
> HW configs after each other, say you have a reference design
> with a nailed down mux+config, but you want to loop over a few
> possible configurations (not for that hardware, but applicable for
> other designs) and make sure they actually work too. The number
> of recompiles and reboots soon goes through the roof.
>
> So the HW people hack the kernel a lot to do this kind of things,
> and then someone get to maintain their hacks. So this is a step
> in the direction of letting them have a generic tool to do the trick.
>
>>> diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
>>
>> To be worth including, hadn't this feature also better also allow
>> editing of pin mux settings too, and even addition/removal of entries,
>> so some more core file would be a better place?
>
> I think it'll be orthogonal: one file for the pinconf stuff (something
> like in this patch) and then another patch for the pinmux
> stuff. I'm trying to keep these two separate.
>
>>> +/* 32bit read/write ressources */
>>> +#define MAX_NAME_LEN 16
>>> +char dbg_pinname[MAX_NAME_LEN]; /* shared: name of the state of the pin*/
>>> +char dbg_state_name[MAX_NAME_LEN]; /* shared: state of the pin*/
>>> +static u32 dbg_config; /* shared: config to be read/set for the pin & state*/
>>
>> Rather than setting pin name, state name, and config separately,
>> wouldn't it be better to accept a single write() with all those
>> parameters contained in it at once, so no persistent state was required.
>> Say something like:
>>
>> modify configs_pin devicename state pinname newvalue
>>
>> That would allow "add", "delete" to be implemented in addition to modify
>> later if desired.
>
> Hm. Sounds useful.
>
> Laurent what do you say about this?
>
> Could you augment the patch like that?
>
>>> +static int pinconf_dbg_pinname_write(struct file *file,
>>> +     const char __user *user_buf, size_t count, loff_t *ppos)
>>> +{
>>> +     int err;
>>> +
>>> +     if (count > MAX_NAME_LEN)
>>> +             return -EINVAL;
>>> +
>>> +     err = sscanf(user_buf, "%15s", dbg_pinname);
>>
>> That %15 had better somehow be related to MAX_NAME_LEN.
>>
>> I'd suggest making MAX_NAME_LEN 15, and the variable declarations above
>> use MAX_NAME_LEN + 1, so that MAX_NAME_LEN can be used as part of the
>> scanf parameter here.
>
> OK -> Laurent.
>
>From this patch, we need to input "debug state" & "debug name" first. Then we
could program the new updated config. Do we really use these new nodes & these
steps in debugfs?

"pinconf-pins" can dump all configs of all pins. But it could only
dump the run-time
configs. Could we extend it to support dumping idle configs? Could we append
the write interface on pinconf-pins?

If we dump "pinconf-pins", we can find that all pins are listed in
number sequence.
It seems that we can make use the number directly. "debug name" is unnecessary.

By the way, program pinconf really help software guy to tune power consumption
on pins. Only programming pinconf in idle state may be still limited.
It's better to
program the mux setting in idle state.

Regards
Haojian
