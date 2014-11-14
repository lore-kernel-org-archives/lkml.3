Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaKNT7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:59:16 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:55332 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaKNT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:59:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141114083917.GT20972@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-2-git-send-email-wens@csie.org> <20141104165733.GI26729@lukather>
 <CAGb2v65VojZVEijdjXYGkMud7dMFzMzagfN=_4S3msZygu3YPQ@mail.gmail.com>
 <20141105100912.GD27686@lukather> <CAGb2v64RT4PKTji2KfDTFfc8b_kiTk0Vh49nEE9ZJukum7h2_Q@mail.gmail.com>
 <20141106085424.GF2989@lukather> <CAGb2v66Riu43PEzR2vLbg9r_WvZDLvxWtwAc3z43FkF57O2ksg@mail.gmail.com>
 <20141114083917.GT20972@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Sat, 15 Nov 2014 03:58:53 +0800
X-Google-Sender-Auth: QGAZLhpeCWVmW0cxbnqfZwrFQAc
Message-ID: <CAGb2v64_SkD3=xV+o4hK7fV0DusCDmPYgatWXQYrexa65k2Zjg@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH 1/6] clk: sunxi: Add support for sun9i
 a80 usb clocks and resets
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

Hi,

On Fri, Nov 14, 2014 at 4:39 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> Sorry for the belated answer.
>
> On Thu, Nov 06, 2014 at 05:19:24PM +0800, Chen-Yu Tsai wrote:
>> On Thu, Nov 6, 2014 at 4:54 PM, Maxime Ripard
>> <maxime.ripard@free-electrons.com> wrote:
>> > On Thu, Nov 06, 2014 at 10:09:27AM +0800, Chen-Yu Tsai wrote:
>> >> >> >> +static void __init sun9i_a80_usb_mod_setup(struct device_node *node)
>> >> >> >> +{
>> >> >> >> +     /* AHB1 gate must be enabled to access registers */
>> >> >> >> +     struct clk *ahb = of_clk_get(node, 0);
>> >> >> >> +
>> >> >> >> +     WARN_ON(IS_ERR(ahb));
>> >> >> >> +     clk_prepare_enable(ahb);
>> >> >> >
>> >> >> > Hmmmm. That look off.
>> >> >> >
>> >> >> > Why do you need the clock to be enabled all the time? Isn't the CCF
>> >> >> > already taking care of enabling the parent clock whenever it needs to
>> >> >> > access any register?
>> >> >>
>> >> >> There are also resets in the same block. That and I couldn't get it
>> >> >> working without enabling the clock beforehand.
>> >> >
>> >> > Ah, right.
>> >> >
>> >> > What happens if you just enable and disable the clocks in the
>> >> > reset_assert and reset_deassert right before and after accessing the
>> >> > registers?
>> >>
>> >> That doesn't work either. I forgot to mention that most of the clock
>> >> gates have the peripheral pll as their parent, not the ahb clock gate.
>> >
>> > Why it doesn't work? The clock needs more time to stabilize? The reset
>> > line is set back in reset if the clocks are disabled?
>>
>> Let me clarify, what you proposed will work for the resets.
>>
>> However the clock gates won't work if we use the generic clk-gate driver.
>> The problem is most of the gates don't have the ahb gate as their parent,
>> but pll4 (peripheral pll). When we enable the clock, the ahb gate isn't
>> its parent, and doesn't get enabled as a result. This is especially true
>> for the usb phy clocks: all of them use pll4 as their parent.
>
> I'm not sure I get this right. You mean that this USB clock needs
> *both* pll4 and its AHB gates to be enabled in order to run properly?
>
> Or that the PHY needs its AHB gate to be enabled?

What I meant was the USB clocks should have some backing PLL.
But let's just use the AHB gate for all the parents and keep
it simple for now. We can model it accurately after we get
documentation.

> Both ways, I still don't think it's the right thing to do.

As said above, I'll just use ahb gate as the parent, and do
what you said earlier about the reset controls (toggle the
gate before and after touching the register).


ChenYu
