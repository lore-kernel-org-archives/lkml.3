Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaIDEQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:16:32 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:43507 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaIDEQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:16:30 -0400
MIME-Version: 1.0
In-Reply-To: <479e7ccf.16dee.1483ed3a882.Coremail.xiechao_mail@163.com>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
 <1409027904-21859-7-git-send-email-chao.xie@marvell.com> <20140903175537.11368.98589@quantum>
 <479e7ccf.16dee.1483ed3a882.Coremail.xiechao_mail@163.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 4 Sep 2014 12:16:09 +0800
X-Google-Sender-Auth: ZpEJpk_znLzoId-fSbdM9G8INGE
Message-ID: <CAGb2v65NbK+WT0dVsr6sMkFG0wwPXeFanyp17PdvqG0AGJ1DPg@mail.gmail.com>
Subject: Re: Re: [PATCH 06/12] clk: mmp: add mmp private gate clock
To: Chao Xie <xiechao_mail@163.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, haojian.zhuang@gmail.com,
        Chao Xie <chao.xie@marvell.com>, haojian.zhuang@linaro.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 12:02 PM, Chao Xie <xiechao_mail@163.com> wrote:
>
>
> At 2014-09-04 01:55:37, "Mike Turquette" <mturquette@linaro.org> wrote:
>>Quoting Chao Xie (2014-08-25 21:38:18)
>>> From: Chao Xie <chao.xie@marvell.com>
>>>
>>> Some SOCes have this kind of the gate clock
>>> 1. There are some bits to control the gate not only one bit.
>>> 2. Some clocks has operations of "out of reset" and "enable".
>>>    To enable clock, we need do "out of reset" and "enable".
>>>    To disable clock, we may not need "set to reset". It depends
>>>    on the SOCes' design.
>>
>>Are there any other IP blocks affected by the "out of reset" and "set to
>>reset" states? I wonder if you might benefit from the reset controller
>>framework?  For example see,
>>
>>drivers/clk/qcom/gcc-apq8084.c
>>
>><snip>
>
>>
> Thanks to point it out.
> To use the reset framework, there are some problem.
> 1. the reset bit is combined with the clocks disable/enable bits in same register. Seperating setting them means spinlock
> protection and 2 operations for read-update the bits.
>
>
> except that, i think reset framework can bring some benefits.

Check out the sunxi gates clk
(drivers/clk/sunxi/clk-sunxi.c:sunxi_gates_clk_setup())
In particular, the usb gate clk, which has gates and reset controls
in the same register. The driver registers separate clk gates and reset
controls for each bit, but uses the same spinlock for all bits.


ChenYu

> Even without the reset bit, we still need the gate clocks.
> The enable/disable is not a bit operation, and it is bits operation for some devices.
> In fact i want to use it to replace the old clk-apbc and clk-apmu clocks.
>
>>> +static int mmp_clk_gate_enable(struct clk_hw *hw)
>>> +{
>>> +       struct mmp_clk_gate *gate = to_clk_mmp_gate(hw);
>>> +       struct clk *clk = hw->clk;
>>> +       unsigned long flags = 0;
>>> +       unsigned long rate;
>>> +       u32 tmp;
>>> +
>>> +       if (gate->lock)
>>> +               spin_lock_irqsave(gate->lock, flags);
>>> +
>>> +       tmp = readl(gate->reg);
>>> +       tmp &= ~gate->mask;
>>> +       tmp |= gate->val_enable;
>>> +       writel(tmp, gate->reg);
>>> +
>>> +       if (gate->lock)
>>> +               spin_unlock_irqrestore(gate->lock, flags);
>>> +
>>> +       if (gate->flags & MMP_CLK_GATE_NEED_DELAY) {
>>> +               rate = __clk_get_rate(clk);
>>> +               /* Need delay 2 cycles. */
>>> +               udelay(2000000/rate);
>>
>>How long are these delays? Long enough to warrant using clk_prepare
>>instead of clk_enable? Are these clocks enabled from interrupt context?
>
>>
> For power optimization, some clocks need to be enabled/disable in interrupt context.
> The worst delay is rate=32KHZ, so the delay is 62.5us.
