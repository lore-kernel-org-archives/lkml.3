Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaKTFsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:48:09 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47891 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbaKTFsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:48:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141120025517.12298.7391@quantum>
References: <1414747777-12625-1-git-send-email-kever.yang@rock-chips.com>
	<CAD=FV=VByf=YKw7q4L2493C-z9uJ3dTSk9WZyCFdOkSjD2XoDw@mail.gmail.com>
	<20141120025517.12298.7391@quantum>
Date: Wed, 19 Nov 2014 21:48:05 -0800
X-Google-Sender-Auth: V_Vd9NSAq6h98g3Ql014L9pYTQk
Message-ID: <CAD=FV=V3x61CG_gGXQ8g4hERX0=3G3LtzF37+t3Z=A_ciVL=vw@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: change hierarchy for some clocks
From: Doug Anderson <dianders@chromium.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Kever Yang <kever.yang@rock-chips.com>,
        "Heiko Stuebner <heiko@sntech.de>," <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On Wed, Nov 19, 2014 at 6:55 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Doug Anderson (2014-11-04 13:32:49)
>> Kever
>>
>> On Fri, Oct 31, 2014 at 2:29 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
>> > This patch change the hierarchy for some clocks, to met the following
>> > bus hierarchy:
>> > hclk_usb_peri is bus clock for
>> > |- hclk_otg0,
>> > |- hclk_host0,
>> > |- hclk_host1,
>> > |- hclk_hsic
>> >
>> > hclk_emem is bus clock for
>> > |- hclk_nandc0
>> > |- hclk_nandc1
>> >
>> > hclk_mem is bus clock for
>> > |- hclk_sdmmc
>> > |- hclk_sdio0
>> > |- hclk_sdio1
>> > |- hclk_emmc
>>
>> So as I understand it the "parent" clocks aren't really parents but
>> are actually peer clocks.  That is if "hclk_usb_peri" is gated
>> "hclk_otg0" continues to run.  ...but the OTG periperhal is useless
>> without "hclk_usb_peri" also being enabled.
>>
>> There doesn't seem to be any real downside to modeling thing as you
>> have done it, though it's not quite a true representation of the
>> world.  A slightly more true representation would be to make it so
>> that whenever "hclk_otg0" is enabled/disabled that it makes an
>> enable/disable call to "hclk_usb_peri".  I think you'd have to
>> subclass the gate clock and patch your stuff in the "enable" function.
>>
>> I'm personally OK with things landing as you've described it (I can
>> see no downside), but it seems like this at least deserves a comment
>> (either in the code or the commit message).
>>
>> If Mike T. thinks that we should use a more truthful model or if
>> there's some better way to express this, you should of course listen
>> to him and not to me.
>
> I'm coming back to this thread sort of late (V2 is posted but the
> discussion is here in V1). I strongly believe that we should model the
> hardware closely, unless there is a convincing reason to do otherwise.
> That makes it more maintainable and more debuggable (e.g. the code
> matches the data sheet).
>
> Seems like there isn't a reason to make these clocks follow a
> parent/child relationship except for convenience?
>
> To clarify further, the requirement for enabling/maintaining the clocks
> isn't really about the clocks themselves, but about the downstream IP
> that consumes the clocks, right? In that case it is the downstream
> driver's responsibility to enable/disable these clocks to spec, not the
> clock driver's job to hide these details.

I don't think it's the downstream driver's job in this case.  Let me
see if I can describe it as I understand it:

1. We've got 4 different USB IP blocks _plus_ an IP block that all 4
blocks are connected to that helps interconnect them to the rest of
the system.

2. The USB IP blocks are not accessible unless the interconnect is clocked.

3. The Interconnect's clock is not truly the parent of the USB IP blocks.

You could maybe draw it like this (assumes fixed width)

                        clk_interconnect
                                |
            +------+       +---------+
-clk_usb1---| USB1 |==bus==|         |
            +------+       |         |
            +------+       |         |
-clk_usb2---| USB2 |==bus==| inter-  |==bus==
            +------+       | connect |
            +------+       |         |
-clk_usb3---| USB3 |==bus==|         |
            +------+       +---------+


The USB driver shouldn't need to know that there is an interconnect
hooking up the USB block to the rest of the system.  It's an artifact
of the SoC.  The USB driver should just turn on its bus clock.

In a pure sense we should have it so that if we turn on any of
clk_usb1, clk_usb2, or clk_usb3 we should tun on the interconnect.
...but we shouldn't describe them as parents because in the hardware
there's no real parent child relationship.

...but since we don't care about the rate of the clk_interconnect (we
can't control it separately) and if we list clk_usb1, clk_usb2, and
clk_usb3 as children of clk_interconnect we magically get everything
we want...


-Doug
