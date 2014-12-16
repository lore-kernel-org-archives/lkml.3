Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaLPMA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:00:27 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57958 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaLPMA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:00:26 -0500
Message-ID: <54901ED3.30207@linux.com>
Date: Tue, 16 Dec 2014 15:00:19 +0300
From: Alexander Popov <alex.popov@linux.com>
Reply-To: alex.popov@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Gerhard Sittig <gsi@denx.de>
Subject: Re: Disabled LocalPlus Controller (LPC) clock on MPC512x
References: <5475BE5A.4090503@linux.com> <547D98DF.9000708@sirius-es.it>
In-Reply-To: <547D98DF.9000708@sirius-es.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

02.12.2014 13:47, Matteo Facchinetti пишет:
> On 26/11/2014 12:49, Alexander Popov wrote:
>> Hello.
> Hi.

Thanks for your reply, Matteo.
I've looked deeper and have more information about the crash.

>> My Freescale TWR-MPC5125 board instantly reboots if I touch
>> any physical address on the LocalPlus Bus (LPB) for the first time
>> when Linux has already booted.
>>
>> This effect is reproduced by using /dev/mem or loading a kernel module
>> which works with any peripherals on LPB.
>>
>> It took me some time to find out that such crash is caused by
>> clk_disable_unused() in drivers/clk/clk.c, which disables
>> LocalPlus Controller (LPC) clock if I don't touch LPB addresses in the
>> previous initcalls.

My first diagnosis was not correct: clk_disable_unused() doesn't disable
LPC clock because in arch/powerpc/platforms/512x/clock-commonclk.c
we call:
	clk_prepare_enable(clks[MPC512x_CLK_LPC]);

But clk_disable_unused() disables NFC clock as unused which seems to be
a real reason of board crash.

>> So starting Linux with clk_ignore_unused bootparam
>> or inserting dummy LPB reading to some initcall is a temporary fix.

In fact clk_ignore_unused bootparam helps to avoid disabling NFC clock.
The board crash is reproduced again if I perform the following steps:
1. disable NFC clock in uboot by clearing NFC_EN bit in SCCR1 register,
2. boot Linux with clk_ignore_unused,
3. touch any LPB address.

At the same time disabling NFC clock and reading from LPB certainly
in uboot doesn't make MPC5125 reset instantly. So I can't reproduce
the crash in uboot. It looks like we do something wrong in Linux.

>    - may be good to enable MPC512x_CLK_LPC only when localbus is enabled
> by the dts
>    - if enabled, MPC512x_CLK_LPC have to setup with CLK_IGNORE_UNUSED
> flag because never get claimed by any driver.

This approach didn't help to fix the crash because in fact
clk_disable_unused() doesn't disable LPC clock as I wrote above.

> I put in CC "Gerhard Sittig" also beacuse it might be interesting to
> know his point of view as the author of mpc512x common clock driver.

Surely. Thanks.

Best regards,
Alexander

