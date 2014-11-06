Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaKFIpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:45:06 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:33610 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaKFIpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:45:03 -0500
MIME-Version: 1.0
In-Reply-To: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
References: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
Date: Thu, 6 Nov 2014 12:45:02 +0400
Message-ID: <CALT56yOCBN1NAfNw=vThVZ_o=ONGOTvzKHBH5tCTQShJY0wkrQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Transition pxa25x clock to common clocks
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Mack <zonque@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014-11-02 18:16 GMT+03:00 Robert Jarzmik <robert.jarzmik@free.fr>:
> Hello pxa25x board maintainers,
>
> This patchset will move the clock code out of pxa subarchitecture into the
> common clock framework. As this change can bring a lot of regression, I'd like
> to test it on your boards.
>
> I prepared for you a git tree based on v3.18-rc :
>  - git fetch https://github.com:rjarzmik/linux.git work/clocks-pxa:try
>  - git checkout try
>
>  - it contains all the common clock fixes for pxa and this pathset
>  - it builds and runs on lubbock (thanks Russell for the board)
>  - make your defconfig, kernel, boot
>  - test
>    - if it does run normally, tell me
>    - if it doesn't boot, retry once with the kernel command line argument "clk_ignore_unused" and tell me if it fixed or not the problem
>    - be aware of the GPIO11 clock change
>      => this is especially true for Ian as my change doesn't look good
>
> If you could give me feedback if it works for you there will be less breakage.
>
> And if you want to give a review, even better.

Tested in qemu (pxa25x target).

0) Had to revert 23c4a3a5212701ad34bd30591fa33d7bacef9c5f to get kernel
to build for pxa25x + pxa27x.

1) I got the following backtrace early in the boot:

Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-00011-g7805b78 #97
[<c000e028>] (unwind_backtrace) from [<c000c0b4>] (show_stack+0x10/0x14)
[<c000c0b4>] (show_stack) from [<c01a3af0>] (Ldiv0+0x8/0x10)
[<c01a3af0>] (Ldiv0) from [<c029bb9c>] (clk_pxa25x_memory_get_rate+0x28/0x30)
[<c029bb9c>] (clk_pxa25x_memory_get_rate) from [<c029b114>]
(clk_composite_recalc_rate+0x20/0x24)
[<c029b114>] (clk_composite_recalc_rate) from [<c0299888>]
(__clk_init+0x1d0/0x4e8)
[<c0299888>] (__clk_init) from [<c0299d24>] (clk_register+0x100/0x1c4)
[<c0299d24>] (clk_register) from [<c029b518>]
(clk_register_composite+0x17c/0x250)
[<c029b518>] (clk_register_composite) from [<c04cecd4>]
(pxa25x_clocks_init+0x194/0x240)
[<c04cecd4>] (pxa25x_clocks_init) from [<c04c048c>] (pxa_timer_init+0x18/0x64)
[<c04c048c>] (pxa_timer_init) from [<c04bde88>] (time_init+0x1c/0x2c)
[<c04bde88>] (time_init) from [<c04bbb14>] (start_kernel+0x268/0x3e8)
[<c04bbb14>] (start_kernel) from [<a0008040>] (0xa0008040)

It might be due to something being not emulated properly, but I'd
suggest to add a check
anyway.

2) sa1100-rtc could not find a clock and thus failed to be probed.

3) Had to patch tc6393xb driver to call
clk_prepare_enable/clk_disable_unprepare -
  will submit a patch shortly.

4) Got an issue with IrDA driver - it gets -ENODEV for UARTCLK clock

-- 
With best wishes
Dmitry
