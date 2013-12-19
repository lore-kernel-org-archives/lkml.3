Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3LSHB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:01:28 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50167 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3LSHBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:01:25 -0500
MIME-Version: 1.0
In-Reply-To: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 19 Dec 2013 15:52:47 +0900
Message-ID: <CAAVeFuKAGfnnsbtBg=zfmciyMdZHgrX_EpecqPjG=oO6rZdWag@mail.gmail.com>
Subject: Re: [PATCH] Tracing events with GPIOs
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, masami.hiramatsu.pt@hitachi.com,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 9:22 AM, Jean-Jacques Hiblot
<jjhiblot@traphandler.com> wrote:
>
> This patch implements a new tracing mechanism based on kprobes and using GPIO.
> Debugging with GPIO is very common in the embedded world. At least for those of us
> fortunate enough to have an oscilloscope or a logic analyzer on their bench...
> This is especially true if the issue results of a hardware/sofware interaction.
>
> Typical use cases are :
> * mixed software/hardware debugging. For example when the software detects a
>   situation of interest (typically an error) it toggles a GPIO to trigger the
>   oscilloscope acquisition.
> * direct latency/duration measurements.
>
> examples:
> To trig the oscilloscope whenever a mmc command error:
>   echo "p:my_mmc_blk_error mmc_blk_cmd_error gpiopulse@13" > /sys/kernel/debug/tracing/kprobe_events
>   echo 1 > /sys/kernel/debug/tracing/events/kprobes/my_mmc_blk_error/enable

I do like this idea, however I wonder if you could try and make it use
the new gpio descriptor API (see Documentation/gpio/) instead of the
GPIO integers we are trying to deprecate (well ok, we just *started*
claiming they are deprecated).

This would probably make things a little bit more complicated on your
side, due to the fact the gpiod API is new and probably does not cover
all your needs. But it would also make your approach safer and more
future proof, on top of helping us refine gpiod for various use cases.

The problems I can see so far:

- Using gpiod, GPIOs are not specified as integers, but are typically
mapped to a given (device, function) pair (device can be NULL) using
device tree/platform data/ACPI and obtained by the corresponding
device driver through gpiod_get(). You would need to find a different
way to specify GPIOs, maybe using the gpio_chip's label and the GPIO
hardware number.

- Even if you do so, there is currently no way to arbitrarily obtain a
GPIO that has not been explicitly mapped to a (device, function), and
IIUC you need to specify the tracing GPIO freely from user-space. This
hints that we will need to add a function that is sensibly the same as
gpio_request_one() to the gpiod API, but I wonder if that does not
defeats the purpose somehow.

So using gpiod we would have the dual problem of how to represent the
GPIO you need from user-space, and how you can safely obtain it. It
would be interesting to hear what Linus thinks about it, and if he has
better ideas about how we could solve these issues (as he usually has
;) ).

(note that it is *not* a hard requirement to use gpiod over the legacy
integer API, but considering this is the direction we are taking, it
would be nice to consider it and see how we could solve the issues
mentioned above)

Thanks,
Alex.
