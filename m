Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaA0QaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:30:07 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:65496 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaA0QaF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:30:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJyaMDkj6jE+qk6AuUNB0-TOLdqeYDBdjH+1YJFu2V0DQ@mail.gmail.com>
References: <1390731668-904-1-git-send-email-geert@linux-m68k.org>
	<CAL_JsqLq+3Ehns0QaPajzLQCYUL+k+vx3j2vHTCdKMt948h6-g@mail.gmail.com>
	<CAMuHMdVNLYoWD=Q+utHUgEBJ1619Q5x=DsZEtmeEbogrQM2a0Q@mail.gmail.com>
	<CAL_JsqJyaMDkj6jE+qk6AuUNB0-TOLdqeYDBdjH+1YJFu2V0DQ@mail.gmail.com>
Date: Mon, 27 Jan 2014 17:23:35 +0100
X-Google-Sender-Auth: Gjtm9QrH1X1tofpKAvf_0BnieYs
Message-ID: <CAMuHMdUn2VJP-LRMKLmiC7jMw3NXLx0fZsGzQJtwjPLY7+9B5g@mail.gmail.com>
Subject: Re: [PATCH] of: Fix uninitialized child warning in
 for_each_child_of_node() if !OF
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 5:21 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Mon, Jan 27, 2014 at 8:52 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Mon, Jan 27, 2014 at 3:16 PM, Rob Herring <robherring2@gmail.com> wrote:
>>> On Sun, Jan 26, 2014 at 4:21 AM, Geert Uytterhoeven
>>> <geert@linux-m68k.org> wrote:
>>>> If CONFIG_OF=n:
>>>>
>>>> drivers/i2c/i2c-mux.c: In function ‘i2c_add_mux_adapter’:
>>>> drivers/i2c/i2c-mux.c:158: warning: ‘child’ is used uninitialized in this function
>>>> drivers/leds/leds-lp55xx-common.c: In function ‘lp55xx_of_populate_pdata’:
>>>> drivers/leds/leds-lp55xx-common.c:560: warning: ‘child’ is used uninitialized in this function
>>>> drivers/leds/leds-pwm.c: In function ‘led_pwm_probe’:
>>>> drivers/leds/leds-pwm.c:89: warning: ‘child’ is used uninitialized in this function
>>>> drivers/mfd/stmpe.c: In function ‘stmpe_of_probe’:
>>>> drivers/mfd/stmpe.c:1112: warning: ‘child’ is used uninitialized in this function
>>>> drivers/mfd/tc3589x.c: In function ‘tc3589x_probe’:
>>>> drivers/mfd/tc3589x.c:324: warning: ‘child’ is used uninitialized in this function
>>>> drivers/power/charger-manager.c: In function ‘of_cm_parse_desc’:
>>>> drivers/power/charger-manager.c:1606: warning: ‘child’ is used uninitialized in this function
>>>>
>>>> Introduced by commit 00b2c76a6abbe082bb5afb89ee49ec325e9cd4d2
>>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> ("include/linux/of.h: make for_each_child_of_node() reference its args when
>>>> CONFIG_OF=n").
>>>>
>>>> Instead of dropping the "__of_use_dn(child)" again, explicitly set child
>>>> to NULL, to protect against code using child after the loop (child == NULL
>>>> is the loop termination condition if CONFIG_OF=y).
>>>>
>>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>>
>>> Just got fixed in mainline:
>>>
>>> commit 00b2c76a6abbe082bb5afb89ee49ec325e9cd4d2
>>
>> Nope, this is the one that introduced new warnings.
>
> Oh right, sorry. Read that too fast.
>
> Won't your change trigger warnings from -Wunused-but-set-variable in
> cases where child is not used? That would only be enabled for "W=1"
> though.
>
> I think the right fix here is all the for_each_X macros should not be
> conditional on CONFIG_OF and we should rely on the functions they call
> like of_get_next_child to do the right thing for !OF.

That's indeed an alternative fix. As long as of_get_next_child() and
friends return NULL, that'll work fine.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
