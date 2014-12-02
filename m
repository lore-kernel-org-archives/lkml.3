Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaLBKxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 05:53:41 -0500
Received: from mx.vmgattei.com ([77.223.18.35]:37954 "EHLO mx.vmgattei.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaLBKxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 05:53:40 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 05:53:39 EST
Message-ID: <547D98DF.9000708@sirius-es.it>
Date: Tue, 02 Dec 2014 11:47:59 +0100
From: Matteo Facchinetti <matteo.facchinetti@sirius-es.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: alex.popov@linux.com
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Gerhard Sittig <gsi@denx.de>
Subject: Re: Disabled LocalPlus Controller (LPC) clock on MPC512x
References: <5475BE5A.4090503@linux.com>
In-Reply-To: <5475BE5A.4090503@linux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/2014 12:49, Alexander Popov wrote:
> Hello.
>
Hi.

> My Freescale TWR-MPC5125 board instantly reboots if I touch
> any physical address on the LocalPlus Bus (LPB) for the first time
> when Linux has already booted.
>
> This effect is reproduced by using /dev/mem or loading a kernel module
> which works with any peripherals on LPB.
>
> It took me some time to find out that such crash is caused by
> clk_disable_unused() in drivers/clk/clk.c, which disables
> LocalPlus Controller (LPC) clock if I don't touch LPB addresses in the
> previous initcalls. So starting Linux with clk_ignore_unused bootparam
> or inserting dummy LPB reading to some initcall is a temporary fix.
>
> Is it correct to gate LPC clock?
For me yes, because it's physically present on SoC and could not be muxed.

> If yes, how to avoid the mentioned
> crashes properly?
>
> There's a piece of code in arch/powerpc/platforms/512x/clock-commonclk.c
> which is doubtful for me:
>
> /*
>  * pre-enable those "internal" clock items which never get
>  * claimed by any peripheral driver, to not have the clock
>  * subsystem disable them late at startup
>  */
> clk_prepare_enable(clks[MPC512x_CLK_DUMMY]);
> clk_prepare_enable(clks[MPC512x_CLK_E300]);    /* PowerPC CPU */
> clk_prepare_enable(clks[MPC512x_CLK_DDR]);    /* DRAM */
> clk_prepare_enable(clks[MPC512x_CLK_MEM]);    /* SRAM */
> clk_prepare_enable(clks[MPC512x_CLK_IPS]);    /* SoC periph */
> clk_prepare_enable(clks[MPC512x_CLK_LPC]);    /* boot media */
>
> Does it mean that these clocks should be registered with
> CLK_IGNORE_UNUSED flag?
>
Yes, in my opinion this groups of clocks may be considered as "always on",
but I don't think that MPC512x_CLK_LPC is an "internal" clock and then 
It could be enable if really used only.
In detail:
   - may be good to enable MPC512x_CLK_LPC only when localbus is enabled 
by the dts
   - if enabled, MPC512x_CLK_LPC have to setup with CLK_IGNORE_UNUSED 
flag because never get claimed by any driver.

I put in CC "Gerhard Sittig" also beacuse it might be interesting to 
know his point of view as the author of mpc512x common clock driver.

Regards,
Matteo

> Thanks a lot.
> Best regards,
> Alexander
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

