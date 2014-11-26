Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaKZLtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:49:52 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44675 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaKZLtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:49:50 -0500
Message-ID: <5475BE5A.4090503@linux.com>
Date: Wed, 26 Nov 2014 14:49:46 +0300
From: Alexander Popov <alex.popov@linux.com>
Reply-To: alex.popov@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Disabled LocalPlus Controller (LPC) clock on MPC512x
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

My Freescale TWR-MPC5125 board instantly reboots if I touch
any physical address on the LocalPlus Bus (LPB) for the first time
when Linux has already booted.

This effect is reproduced by using /dev/mem or loading a kernel module
which works with any peripherals on LPB.

It took me some time to find out that such crash is caused by
clk_disable_unused() in drivers/clk/clk.c, which disables
LocalPlus Controller (LPC) clock if I don't touch LPB addresses in the
previous initcalls. So starting Linux with clk_ignore_unused bootparam
or inserting dummy LPB reading to some initcall is a temporary fix.

Is it correct to gate LPC clock? If yes, how to avoid the mentioned
crashes properly?

There's a piece of code in arch/powerpc/platforms/512x/clock-commonclk.c
which is doubtful for me:

/*
  * pre-enable those "internal" clock items which never get
  * claimed by any peripheral driver, to not have the clock
  * subsystem disable them late at startup
  */
clk_prepare_enable(clks[MPC512x_CLK_DUMMY]);
clk_prepare_enable(clks[MPC512x_CLK_E300]);    /* PowerPC CPU */
clk_prepare_enable(clks[MPC512x_CLK_DDR]);    /* DRAM */
clk_prepare_enable(clks[MPC512x_CLK_MEM]);    /* SRAM */
clk_prepare_enable(clks[MPC512x_CLK_IPS]);    /* SoC periph */
clk_prepare_enable(clks[MPC512x_CLK_LPC]);    /* boot media */

Does it mean that these clocks should be registered with
CLK_IGNORE_UNUSED flag?

Thanks a lot.
Best regards,
Alexander
