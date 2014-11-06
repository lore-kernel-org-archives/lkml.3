Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaKFJTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:19:50 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48223 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaKFJTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:19:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141106085424.GF2989@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-2-git-send-email-wens@csie.org> <20141104165733.GI26729@lukather>
 <CAGb2v65VojZVEijdjXYGkMud7dMFzMzagfN=_4S3msZygu3YPQ@mail.gmail.com>
 <20141105100912.GD27686@lukather> <CAGb2v64RT4PKTji2KfDTFfc8b_kiTk0Vh49nEE9ZJukum7h2_Q@mail.gmail.com>
 <20141106085424.GF2989@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 6 Nov 2014 17:19:24 +0800
X-Google-Sender-Auth: 5Df9GTGgX_fA1jiaa71xk4kl5FA
Message-ID: <CAGb2v66Riu43PEzR2vLbg9r_WvZDLvxWtwAc3z43FkF57O2ksg@mail.gmail.com>
Subject: Re: [PATCH 1/6] clk: sunxi: Add support for sun9i a80 usb clocks and resets
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2014 at 4:54 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> On Thu, Nov 06, 2014 at 10:09:27AM +0800, Chen-Yu Tsai wrote:
>> >> >> +static void __init sun9i_a80_usb_mod_setup(struct device_node *node)
>> >> >> +{
>> >> >> +     /* AHB1 gate must be enabled to access registers */
>> >> >> +     struct clk *ahb = of_clk_get(node, 0);
>> >> >> +
>> >> >> +     WARN_ON(IS_ERR(ahb));
>> >> >> +     clk_prepare_enable(ahb);
>> >> >
>> >> > Hmmmm. That look off.
>> >> >
>> >> > Why do you need the clock to be enabled all the time? Isn't the CCF
>> >> > already taking care of enabling the parent clock whenever it needs to
>> >> > access any register?
>> >>
>> >> There are also resets in the same block. That and I couldn't get it
>> >> working without enabling the clock beforehand.
>> >
>> > Ah, right.
>> >
>> > What happens if you just enable and disable the clocks in the
>> > reset_assert and reset_deassert right before and after accessing the
>> > registers?
>>
>> That doesn't work either. I forgot to mention that most of the clock
>> gates have the peripheral pll as their parent, not the ahb clock gate.
>
> Why it doesn't work? The clock needs more time to stabilize? The reset
> line is set back in reset if the clocks are disabled?

Let me clarify, what you proposed will work for the resets.

However the clock gates won't work if we use the generic clk-gate driver.
The problem is most of the gates don't have the ahb gate as their parent,
but pll4 (peripheral pll). When we enable the clock, the ahb gate isn't
its parent, and doesn't get enabled as a result. This is especially true
for the usb phy clocks: all of them use pll4 as their parent.

I think this is a better representation of the hardware, but without
documents this is really just a guess.

As a whole, I think enabling the clock gate at the beginning is simpler.

ChenYu
