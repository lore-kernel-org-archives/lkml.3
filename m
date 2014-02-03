Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaBCXQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:16:37 -0500
Received: from 1wt.eu ([62.212.114.60]:56189 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaBCXQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:16:35 -0500
Date: Tue, 4 Feb 2014 00:16:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
Message-ID: <20140203231603.GA11613@1wt.eu>
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <52EA2875.5020807@free-electrons.com> <52EA2A04.2070109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EA2A04.2070109@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Thu, Jan 30, 2014 at 11:31:32AM +0100, Sebastian Hesselbarth wrote:
> On 01/30/14 11:24, Gregory CLEMENT wrote:
> >On 25/01/2014 19:19, Sebastian Hesselbarth wrote:
> >>This patch set fixes clk init order that went upside-down with
> >>v3.14. I haven't really investigated what caused this, but I assume
> >>it is related with DT node reordering by addresses.
> >
> >Can you explain what kind of issue do you observe?
> 
> Sure. When probing CLK_OF_DECLAREed clock drivers, clock-gating driver
> gets registered before core-clocks. It therefore cannot resolve it's
> parent clock name for tclk and all clock gates will have no parent
> clock.
> 
> Usually, you'll see in some drivers (e.g. v643xx_eth) div_by_zero errors
> poping up, when they calculate a frequency division factors based on
> clock gate frequency, which should have been tclk but is 0 now.

Well, to be honnest, I have no idea whether your patch is the right way
to fix the problem or not, but what I can say is that it fixes such oopses
that appear in 3.14-rc1 when booting on mirabox :

Division by zero in kernel.
CPU: 0 PID: 6 Comm: kworker/u2:0 Not tainted 3.13.0-bck-mbx #6
Workqueue: kmmcd mmc_rescan
[<c0010865>] (unwind_backtrace+0x1/0x98) from [<c000e947>] (show_stack+0xb/0xc)
[<c000e947>] (show_stack+0xb/0xc) from [<c0135913>] (Ldiv0+0x9/0x12)
[<c0135913>] (Ldiv0+0x9/0x12) from [<c01f708b>] (mvsd_set_ios+0xcb/0x160)
[<c01f708b>] (mvsd_set_ios+0xcb/0x160) from [<c01ec1fd>] (__mmc_set_clock+0x2d/0
x40)
[<c01ec1fd>] (__mmc_set_clock+0x2d/0x40) from [<c01f1a59>] (mmc_sdio_init_card+0
x391/0x808)
[<c01f1a59>] (mmc_sdio_init_card+0x391/0x808) from [<c01f2163>] (mmc_attach_sdio
+0x5b/0x218)
[<c01f2163>] (mmc_attach_sdio+0x5b/0x218) from [<c01ed0d9>] (mmc_rescan+0x159/0x
1b4)
[<c01ed0d9>] (mmc_rescan+0x159/0x1b4) from [<c0024579>] (process_one_work+0xa9/0
x21c)
[<c0024579>] (process_one_work+0xa9/0x21c) from [<c002494d>] (worker_thread+0xb5
/0x248)
[<c002494d>] (worker_thread+0xb5/0x248) from [<c0027f1b>] (kthread+0x7b/0x94)
+0xa7/0x138)
[<c04228b3>] (kernel_init_freeable+0xa7/0x138) from [<c027e6cf>] (kernel_init+0x
7/0xb8)
[<c027e6cf>] (kernel_init+0x7/0xb8) from [<c000cb9d>] (ret_from_fork+0x11/0x34)
mvsdio d00d4000.mvsdio: lacking card detect (fall back to polling)

By the way, seeing how often a trick related to the DT is nedeed to solve an
oops or a panic, I'm really scared that this whole DT mess is just becoming
the exact copy of the ACPI mess (but 15 years later) and we'll experience the
same horrible things :-( Sometimes I'm wondering whether there are not too
many structural things put in there...

Regards,
Willy

