Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbaH0FEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 01:04:31 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65180 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaH0FE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 01:04:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140827003527.GA6149@lunn.ch>
References: <1408375833-10703-1-git-send-email-tomeu.vizoso@collabora.com>
 <1408375833-10703-4-git-send-email-tomeu.vizoso@collabora.com>
 <20140820225513.5251.284@quantum> <53F5A587.9030200@collabora.com>
 <20140821133825.GH8608@lunn.ch> <20140822192933.5251.53733@quantum>
 <20140822201112.GH17277@lunn.ch> <20140826214631.5251.66177@quantum>
 <20140826223637.GA5324@lunn.ch> <20140826233008.5251.50447@quantum> <20140827003527.GA6149@lunn.ch>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 26 Aug 2014 22:04:05 -0700
Message-ID: <CAPtuhThyUPrY2AqVEsyRQqR-8hsj_GAe1W0u_XXonP-C2o_Xew@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] cpufreq: kirkwood: Remove use of the clk provider API
To: Andrew Lunn <andrew@lunn.ch>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>, Tomasz Figa <t.figa@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 5:35 PM, Andrew Lunn <andrew@lunn.ch> wrote:
>> One final thought I have had is that it might be a good idea to have a
>> mux clock which represents the clock signal that feeds into the cpu. It
>> seems that a mux is exactly what is going on here with cpuclk rate and
>> ddrclk rate.
>
> I did think of this when i implemented the cpufreq driver. What makes
> it hard is that this bit is mixed in the same 32 bit register as the
> gate clocks. It would mean two clock providers sharing the same
> register, sharing a spinlock, etc. And the gating provider is shared
> with all mvebu platforms, dove, kirkword, orion5x, and four different
> armada SoCs. So i'm pushing complexity into this shared code, which
> none of the others need. Does the standard mux clock do what is
> needed? Or would i have to write a new clock provider?

Well I think that the mux-clock type should suffice. Both the standard
gate and mux can have a spinlock passed in at registration-time, so it
could be a shared spinlock. The standard mux clock expects a bitfield
in a register, similar to the single-bit approach taken by the gate
clock. So I think it could do just fine.

>
>> I even wonder if it is even appropriate to model this transition with a
>> clock enable operation? Maybe it is only a multiplex operation, or
>> perhaps a combination of enabling the powersave clock and changing the
>> parent input to the cpu?
>>
>> My idea is instead of relying on a cpufreq driver to parse the state of
>> your clocks and understand the multiplexing, you can use the clock
>> framework for that. In fact that might help you get one step closer to
>> using the cpufreq-cpu0.c/cpufreq-generic.c implementation.
>
> So you want the whole disabling of interrupt delivery to the cpu,
> flipping the mux, wait for interrupt and re-enabling of interrupt
> delivery to the cpu inside the clock provider? That is way past a
> simple mux clock.

No way! I said, "one step closer" for a reason. The interrupt stuff is
clearly out of scope.

Regards,
Mike

>
>        Andrew
