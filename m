Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbaIDEDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:03:37 -0400
Received: from m13-20.163.com ([220.181.13.20]:36852 "EHLO m13-20.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaIDEDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:03:35 -0400
X-Originating-IP: [210.13.71.68, 123.58.177.192]
Date: Thu, 4 Sep 2014 12:02:11 +0800 (CST)
From: "Chao Xie" <xiechao_mail@163.com>
To: "Mike Turquette" <mturquette@linaro.org>
Cc: "Chao Xie" <chao.xie@marvell.com>, haojian.zhuang@gmail.com,
        haojian.zhuang@linaro.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH 06/12] clk: mmp: add mmp private gate clock
X-Priority: 3
X-Mailer: Coremail Webmail Server Version SP_ntes V3.5 build
 20140725(28226.6623) Copyright (c) 2002-2014 www.mailtech.cn 163com
In-Reply-To: <20140903175537.11368.98589@quantum>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
 <1409027904-21859-7-git-send-email-chao.xie@marvell.com>
 <20140903175537.11368.98589@quantum>
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <479e7ccf.16dee.1483ed3a882.Coremail.xiechao_mail@163.com>
X-CM-TRANSID: FMGowABHu+JE5AdUxmKDAA--.34225W
X-CM-SenderInfo: p0lhux5drbztllo6il2tof0z/1tbiRRL8F1EAOTLs2QACsR
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8443kxt007406



At 2014-09-04 01:55:37, "Mike Turquette" <mturquette@linaro.org> wrote:
>Quoting Chao Xie (2014-08-25 21:38:18)
>> From: Chao Xie <chao.xie@marvell.com>
>> 
>> Some SOCes have this kind of the gate clock
>> 1. There are some bits to control the gate not only one bit.
>> 2. Some clocks has operations of "out of reset" and "enable".
>>    To enable clock, we need do "out of reset" and "enable".
>>    To disable clock, we may not need "set to reset". It depends
>>    on the SOCes' design.
>
>Are there any other IP blocks affected by the "out of reset" and "set to
>reset" states? I wonder if you might benefit from the reset controller
>framework?  For example see,
>
>drivers/clk/qcom/gcc-apq8084.c
>
><snip>

>
Thanks to point it out.
To use the reset framework, there are some problem.
1. the reset bit is combined with the clocks disable/enable bits in same register. Seperating setting them means spinlock
protection and 2 operations for read-update the bits.


except that, i think reset framework can bring some benefits.


Even without the reset bit, we still need the gate clocks.
The enable/disable is not a bit operation, and it is bits operation for some devices.
In fact i want to use it to replace the old clk-apbc and clk-apmu clocks. 

>> +static int mmp_clk_gate_enable(struct clk_hw *hw)
>> +{
>> +       struct mmp_clk_gate *gate = to_clk_mmp_gate(hw);
>> +       struct clk *clk = hw->clk;
>> +       unsigned long flags = 0;
>> +       unsigned long rate;
>> +       u32 tmp;
>> +
>> +       if (gate->lock)
>> +               spin_lock_irqsave(gate->lock, flags);
>> +
>> +       tmp = readl(gate->reg);
>> +       tmp &= ~gate->mask;
>> +       tmp |= gate->val_enable;
>> +       writel(tmp, gate->reg);
>> +
>> +       if (gate->lock)
>> +               spin_unlock_irqrestore(gate->lock, flags);
>> +
>> +       if (gate->flags & MMP_CLK_GATE_NEED_DELAY) {
>> +               rate = __clk_get_rate(clk);
>> +               /* Need delay 2 cycles. */
>> +               udelay(2000000/rate);
>
>How long are these delays? Long enough to warrant using clk_prepare
>instead of clk_enable? Are these clocks enabled from interrupt context?

>
For power optimization, some clocks need to be enabled/disable in interrupt context.
The worst delay is rate=32KHZ, so the delay is 62.5us.

>Regards,
>Mike


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
