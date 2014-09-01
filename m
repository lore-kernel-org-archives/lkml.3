Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaIAHzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:55:46 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:56311 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaIAHzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <5404246E.4090908@de.bosch.com>
References: <1409336356-27682-1-git-send-email-dmitry_eremin@mentor.com>
	<20140829190129.GZ29327@sirena.org.uk>
	<5404246E.4090908@de.bosch.com>
Date: Mon, 1 Sep 2014 09:55:43 +0200
X-Google-Sender-Auth: RAx0ZGfrmJ8WC18R6wcG6NSdiEo
Message-ID: <CAMuHMdWPe7ATuTmTVOQg9=2eTYqCNep5SNzuA1B7d6hKNoA_Fw@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: GPIO #0 is a valid GPIO
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Mark Brown <broonie@kernel.org>,
        Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Gokulkrishnan Nagarajan <Gokulkrishnan.Nagarajan@in.bosch.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 9:46 AM, Dirk Behme <dirk.behme@de.bosch.com> wrote:
> On 29.08.2014 21:01, Mark Brown wrote:
>>
>> On Fri, Aug 29, 2014 at 10:19:16PM +0400, Dmitry Eremin-Solenikov wrote:
>>>
>>> From: Dirk Behme <dirk.behme@de.bosch.com>
>>>
>>> With GPIO #0, this if statement will always fail. Remove this, the
>>> check for gpio_is_valid() is sufficent here.
>>
>>
>> No, read the archives
>
> Could you kindly give us a pointer to the relevant thread in the archive?
>
>> this will break boards using zero as default.
>> Any current boards should be using DT and so shouldn't be using fixed
>> GPIO numbers in the first place which will mean they'll not end up
>> getting zero as a valid GPIO.
>
> Hmm? What's wrong with a DT entry
>
> <&gpio1 0 0>;
>
> for ena_gpio resulting in zero as a valid GPIO?
>
>> If you are using zero as a GPIO for some
>> reason provide a way to specify that the GPIO is a real GPIO and not
>> just the default value for the struct.
>
> Do you want to say that GPIO #0 (<&gpio1 0 0>;) isn't a valid GPIO for
> config->ena_gpio?
>
> I wonder how this fits to
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/gpio/gpio-legacy.txt
>
> "GPIOs are identified by unsigned integers in the range 0..MAX_INT"
>
> "If you want to initialize a structure with an invalid GPIO number, use
> some negative number (perhaps "-EINVAL");"
>
> then?

And include/asm-generic/gpio.h:

/* Platforms may implement their GPIO interface with library code,
 * at a small performance cost for non-inlined operations and some
 * extra memory (for code and for per-GPIO table entries).
 *
 * While the GPIO programming interface defines valid GPIO numbers
 * to be in the range 0..MAX_INT, this library restricts them to the
 * smaller range 0..ARCH_NR_GPIOS-1.
 *
 * ARCH_NR_GPIOS is somewhat arbitrary; it usually reflects the sum of
 * builtin/SoC GPIOs plus a number of GPIOs on expanders; the latter is
 * actually an estimate of a board-specific value.
 */

#ifndef ARCH_NR_GPIOS
#define ARCH_NR_GPIOS           256
#endif

/*
 * "valid" GPIO numbers are nonnegative and may be passed to
 * setup routines like gpio_request().  only some valid numbers
 * can successfully be requested and used.
 *
 * Invalid GPIO numbers are useful for indicating no-such-GPIO in
 * platform data and other tables.
 */

static inline bool gpio_is_valid(int number)
{
        return number >= 0 && number < ARCH_NR_GPIOS;
}

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
