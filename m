Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaA0QVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 11:21:03 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:54614 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaA0QVB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 11:21:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVNLYoWD=Q+utHUgEBJ1619Q5x=DsZEtmeEbogrQM2a0Q@mail.gmail.com>
References: <1390731668-904-1-git-send-email-geert@linux-m68k.org>
	<CAL_JsqLq+3Ehns0QaPajzLQCYUL+k+vx3j2vHTCdKMt948h6-g@mail.gmail.com>
	<CAMuHMdVNLYoWD=Q+utHUgEBJ1619Q5x=DsZEtmeEbogrQM2a0Q@mail.gmail.com>
Date: Mon, 27 Jan 2014 10:21:00 -0600
Message-ID: <CAL_JsqJyaMDkj6jE+qk6AuUNB0-TOLdqeYDBdjH+1YJFu2V0DQ@mail.gmail.com>
Subject: Re: [PATCH] of: Fix uninitialized child warning in
 for_each_child_of_node() if !OF
From: Rob Herring <robherring2@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 8:52 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Jan 27, 2014 at 3:16 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On Sun, Jan 26, 2014 at 4:21 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> If CONFIG_OF=n:
>>>
>>> drivers/i2c/i2c-mux.c: In function ‘i2c_add_mux_adapter’:
>>> drivers/i2c/i2c-mux.c:158: warning: ‘child’ is used uninitialized in this function
>>> drivers/leds/leds-lp55xx-common.c: In function ‘lp55xx_of_populate_pdata’:
>>> drivers/leds/leds-lp55xx-common.c:560: warning: ‘child’ is used uninitialized in this function
>>> drivers/leds/leds-pwm.c: In function ‘led_pwm_probe’:
>>> drivers/leds/leds-pwm.c:89: warning: ‘child’ is used uninitialized in this function
>>> drivers/mfd/stmpe.c: In function ‘stmpe_of_probe’:
>>> drivers/mfd/stmpe.c:1112: warning: ‘child’ is used uninitialized in this function
>>> drivers/mfd/tc3589x.c: In function ‘tc3589x_probe’:
>>> drivers/mfd/tc3589x.c:324: warning: ‘child’ is used uninitialized in this function
>>> drivers/power/charger-manager.c: In function ‘of_cm_parse_desc’:
>>> drivers/power/charger-manager.c:1606: warning: ‘child’ is used uninitialized in this function
>>>
>>> Introduced by commit 00b2c76a6abbe082bb5afb89ee49ec325e9cd4d2
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> ("include/linux/of.h: make for_each_child_of_node() reference its args when
>>> CONFIG_OF=n").
>>>
>>> Instead of dropping the "__of_use_dn(child)" again, explicitly set child
>>> to NULL, to protect against code using child after the loop (child == NULL
>>> is the loop termination condition if CONFIG_OF=y).
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>
>> Just got fixed in mainline:
>>
>> commit 00b2c76a6abbe082bb5afb89ee49ec325e9cd4d2
>
> Nope, this is the one that introduced new warnings.

Oh right, sorry. Read that too fast.

Won't your change trigger warnings from -Wunused-but-set-variable in
cases where child is not used? That would only be enabled for "W=1"
though.

I think the right fix here is all the for_each_X macros should not be
conditional on CONFIG_OF and we should rely on the functions they call
like of_get_next_child to do the right thing for !OF.

Rob
