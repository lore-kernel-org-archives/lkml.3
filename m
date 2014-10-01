Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaJAU03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:26:29 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:64162 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaJAU01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <CANLsYkycNPFafpet+qGv7LhCVN1qj+GfhVuNyW=1WpOc07S7ng@mail.gmail.com>
References: <1412079987-1827-1-git-send-email-geert+renesas@glider.be>
	<1412079987-1827-2-git-send-email-geert+renesas@glider.be>
	<20140930160331.GN2548@arm.com>
	<CAMuHMdWA8zhBdT3QO9E8YinCFu3m943LenvYAO9A3F5y8RoSQQ@mail.gmail.com>
	<CANLsYkycNPFafpet+qGv7LhCVN1qj+GfhVuNyW=1WpOc07S7ng@mail.gmail.com>
Date: Wed, 1 Oct 2014 22:26:25 +0200
X-Google-Sender-Auth: Y2VVW0zhYlv3pWAzds5e9sZLNw4
Message-ID: <CAMuHMdUhCtJPyz=Chv+cowmBsZq1cdcwLnYCLWHmECo_cE1+eQ@mail.gmail.com>
Subject: Re: [PATCH/RFC v2 1/4] ARM: hw_breakpoint: Add arm_dbg_regs_available flag
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

On Wed, Oct 1, 2014 at 4:38 PM, Mathieu Poirier
<mathieu.poirier@linaro.org> wrote:
> On 1 October 2014 01:41, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> On Tue, Sep 30, 2014 at 6:03 PM, Will Deacon <will.deacon@arm.com> wrote:
>>> On Tue, Sep 30, 2014 at 01:26:24PM +0100, Geert Uytterhoeven wrote:
>>>> If power area D4, which contains the Coresight-ETM hardware block, is
>>>> powered down on R-Mobile A1 (r8a7740), the kernel crashes when
>>>> suspending from s2ram with:
>>>>
>>>>     Internal error: Oops - undefined instruction: 0 [#1] ARM
>>>>
>>>> This happens because dbg_cpu_pm_notify() calls reset_ctrl_regs(), which
>>>> can't access the debug registers as the debug module is powered down.
>>>>
>>>> As suggested by Russell King, track whether the ETM block is powered down
>>>> to fix this.
>>>>
>>>> The availability of the debug registers depends on the platform and its
>>>> state.  Hence provide a mechanism for platform code to indicate that the
>>>> debug registers are available or not, using a boolean flag that defaults
>>>> to true.
>
> I'm afraid the usage of the handle "arm,coresight-etm3x" is arbitrary
> here as what the code isn't related to an embedded trace module, but
> rather to the power domain that trace module happens to be in.  If we
> are to take that solution a handle name relate to the debug power
> domain is likely to be more appropriate.

W.r.t. PM domains, the datasheet only mentions "Coresight-ETM" being
in the D4 power area. That's why I used the "arm,coresight-etm3x" handle.
It's still to be discovered what else is hidden there...

>>> Whilst I guess this solves your problem, it doesn't feel like a scalable fix
>>> for something that can/will assumedly happen elsewhere in an SoC (e.g. PMU
>>> registers in perf). I'd much rather have a generic abstraction for power
>>> domains, which subsystems such as hw_breakpoint can attempt to take a
>>> reference on when they want to access registers in that domain.
>>
>> I agree this is a bit hackish, and not a long-term solution.
>>
>> As soon as the ARM debug/perf subsystem starts using devices instantiated
>> from DT, implementing PM runtime support, this will work out-of-the-box.
>> Until then, we cannot have proper support for the D4 PM domain on R-Mobile
>> SoCs, without hacks like this (or like never powering down the D4 PM domain
>> --- perhaps that's the way to go).
>>
>> I believe Mathieu is working on the former, but so far without converting
>> hw_breakpoint.c nor adding PM runtime support?
>
> Humm... At this time the coresight framework doesn't deal with PM
> runtime support.  It is something that's been on the list of things to
> do for a while now but I never had the time to get to it.  On the flip
> side I currently have two boards on my desk that need to interact with
> different debug domains to work properly and as such, the feature is
> bound to appear at some point.

OK. We'll see...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
