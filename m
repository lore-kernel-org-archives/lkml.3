Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaJAHlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:41:12 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:41281 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaJAHlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:41:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140930160331.GN2548@arm.com>
References: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
	<1412079987-1827-2-git-send-email-geert+renesas@glider.be>
	<20140930160331.GN2548@arm.com>
Date: Wed, 1 Oct 2014 09:41:08 +0200
X-Google-Sender-Auth: Bo6Fx7yccO_nZAzjWB_VpGC7KjA
Message-ID: <CAMuHMdWA8zhBdT3QO9E8YinCFu3m943LenvYAO9A3F5y8RoSQQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 1/4] ARM: hw_breakpoint: Add arm_dbg_regs_available flag
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <linux@arm.linux.org.uk>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

On Tue, Sep 30, 2014 at 6:03 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Sep 30, 2014 at 01:26:24PM +0100, Geert Uytterhoeven wrote:
>> If power area D4, which contains the Coresight-ETM hardware block, is
>> powered down on R-Mobile A1 (r8a7740), the kernel crashes when
>> suspending from s2ram with:
>>
>>     Internal error: Oops - undefined instruction: 0 [#1] ARM
>>
>> This happens because dbg_cpu_pm_notify() calls reset_ctrl_regs(), which
>> can't access the debug registers as the debug module is powered down.
>>
>> As suggested by Russell King, track whether the ETM block is powered down
>> to fix this.
>>
>> The availability of the debug registers depends on the platform and its
>> state.  Hence provide a mechanism for platform code to indicate that the
>> debug registers are available or not, using a boolean flag that defaults
>> to true.

> Whilst I guess this solves your problem, it doesn't feel like a scalable fix
> for something that can/will assumedly happen elsewhere in an SoC (e.g. PMU
> registers in perf). I'd much rather have a generic abstraction for power
> domains, which subsystems such as hw_breakpoint can attempt to take a
> reference on when they want to access registers in that domain.

I agree this is a bit hackish, and not a long-term solution.

As soon as the ARM debug/perf subsystem starts using devices instantiated
from DT, implementing PM runtime support, this will work out-of-the-box.
Until then, we cannot have proper support for the D4 PM domain on R-Mobile
SoCs, without hacks like this (or like never powering down the D4 PM domain
--- perhaps that's the way to go).

I believe Mathieu is working on the former, but so far without converting
hw_breakpoint.c nor adding PM runtime support?

Thanks for your understanding!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
