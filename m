Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3LBHfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:35:39 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:33824 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LBHfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:35:37 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1384859269-19801-8-git-send-email-lee.jones@linaro.org>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
	<1384859269-19801-8-git-send-email-lee.jones@linaro.org>
Date: Sun, 1 Dec 2013 23:35:37 -0800
Message-ID: <CAOesGMiu16f_L=cMWFCNZMjNB9tBK-2LXn02k-R7FhkkgR5-+g@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 07/10] ASoC: ux500: Store DMA data in the DAI
 differently in the pdata and DT case
From: Olof Johansson <olof@lixom.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LinusW <linus.walleij@linaro.org>, Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 19, 2013 at 3:07 AM, Lee Jones <lee.jones@linaro.org> wrote:
> In this patch we do two things. Firstly, instead of open coding the
> store of DMA data in to the DAI for later use, we use the API provided.
> Secondly we create and store similar DMA data for the DT case, only
> this time we use 'struct snd_dmaengine_dai_dma_data' which is provided
> by the core for this very reason.
>
> Cc: alsa-devel@alsa-project.org
> Cc: Mark Brown <broonie@kernel.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>


Seems like this hit -next for the first time today, and it panics
snowball on boot of u8500_defconfig. I bisected down to this patch.

The panic is below. Last output is the dev_dbg() in
ux500_pcm_request_chan. dma_cfg seems to be 0x0000004(!) at that
point. It's indeed crashing on first deref of dma_cfg (confirmed via
addr2line).


ux500-msp-i2s ux500-msp-i2s.1: ux500_pcm_request_chan: MSP 1 (Playback): Enter.
Unable to handle kernel NULL pointer dereference at virtual address 0000002c
pgd = c0004000
[0000002c] *pgd=00000000
Internal error: Oops: 805 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.0-rc1-00003-g6bcb570-dirty #19
task: ef060000 ti: ef04a000 task.ti: ef04a000
PC is at ux500_pcm_request_chan+0xbc/0xe4
LR is at ux500_pcm_request_chan+0x8c/0xe4
pc : [<c02edf00>]    lr : [<c02eded0>]    psr: 60000113
sp : ef04bd10  ip : 00000001  fp : 00020000
r10: ef20be10  r9 : 00800000  r8 : ef1ec010
r7 : ef20be10  r6 : ef0e5c90  r5 : 00000004  r4 : ef1f6800
r3 : 00000004  r2 : 00000000  r1 : 00000004  r0 : c01ed7d4
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5787d  Table: 0000404a  DAC: 00000015
Process swapper/0 (pid: 1, stack limit = 0xef04a240)
Stack: (0xef04bd10 to 0xef04c000)
bd00:                                     ef1f6800 c04b8e9c 00000000 00000000
bd20: ef1f6800 ef1b80c0 ef1b80cc c02eaa44 00000001 ef1b80cc ef1b8000 ef1ec010
bd40: 00000000 00000001 ef1b80cc ef1b8000 ef226d80 00000000 ef04bd70 c02e98a0
bd60: 00000000 ef04bd6c ef0e6100 ef1f6c00 35386261 305f3030 38626120 2d303035
bd80: 65646f63 61642d63 2d302e69 00000030 ef0e6100 ef0e6100 ef0e5e40 ef0e6100
bda0: 00000000 ef0e5e40 c056c630 c00fc240 00000000 c056c4a0 ef1ec010 ef1b8000
bdc0: c056c630 ef226d80 00000000 00000000 00000002 c02dfdec c056c4b0 00000000
bde0: eec10088 c0569050 00000000 c056c5a8 c056c598 c0569050 c0569090 c02da820
be00: c00303a8 ef1f7400 c056c580 c0569050 c04b7ec4 c056c4c0 c022147c c056c4a0
be20: 000005b8 c104138c c10415e4 ef221e10 00000069 ef04a030 00000000 c02e01a4
be40: c056c448 c1041df4 c104138c c10415e4 ef221e10 c02ee0b8 ef221e10 c056c45c
be60: 00000000 c056c45c c052d958 c0220860 c0220848 ef221e10 c05a1f3c c021f0dc
be80: 00000000 ef221e10 c056c45c ef221e44 00000000 c021f2c8 00000000 c056c45c
bea0: c021f23c c021d70c ef03065c ef1a9db4 c056c45c ef1e3200 c055e4d8 c021e8a4
bec0: c04bbd08 c056c45c 00000006 c056c45c 00000006 c0572680 c0572680 c021f8ac
bee0: 00000000 c053de50 00000006 c0008870 ef010900 c04846d4 ef09a100 c03b54e8
bf00: 00000000 c0572680 0000150c c00f3c6c 00000000 c054edd0 a0000013 00000001
bf20: c104273d c03c868c 00000069 c0035398 c04ee1bc 00000006 c1042748 00000006
bf40: c054edc0 c053de50 00000006 c0572680 c0572680 c051150c 00000069 c0535bdc
bf60: c0535bd0 c0511c30 00000006 00000006 c051150c 00000000 80000000 10000000
bf80: 00000000 00000000 c03aa2ac 00000000 00000000 00000000 00000000 00000000
bfa0: 00000000 c03aa2b4 00000000 c000e478 00000000 00000000 00000000 00000000
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000002 00000000
[<c02edf00>] (ux500_pcm_request_chan+0xbc/0xe4) from [<c02eaa44>]
(dmaengine_pcm_new+0x16c/0x1a0)
[<c02eaa44>] (dmaengine_pcm_new+0x16c/0x1a0) from [<c02e98a0>]
(soc_new_pcm+0x2bc/0x3c8)
[<c02e98a0>] (soc_new_pcm+0x2bc/0x3c8) from [<c02dfdec>]
(snd_soc_instantiate_card+0xff0/0x113c)
[<c02dfdec>] (snd_soc_instantiate_card+0xff0/0x113c) from [<c02e01a4>]
(snd_soc_register_card+0x26c/0x3a4)
[<c02e01a4>] (snd_soc_register_card+0x26c/0x3a4) from [<c02ee0b8>]
(mop500_probe+0xe0/0x128)
[<c02ee0b8>] (mop500_probe+0xe0/0x128) from [<c0220860>]
(platform_drv_probe+0x18/0x48)
[<c0220860>] (platform_drv_probe+0x18/0x48) from [<c021f0dc>]
(driver_probe_device+0x124/0x240)
[<c021f0dc>] (driver_probe_device+0x124/0x240) from [<c021f2c8>]
(__driver_attach+0x8c/0x90)
[<c021f2c8>] (__driver_attach+0x8c/0x90) from [<c021d70c>]
(bus_for_each_dev+0x60/0x94)
[<c021d70c>] (bus_for_each_dev+0x60/0x94) from [<c021e8a4>]
(bus_add_driver+0x148/0x1f0)
[<c021e8a4>] (bus_add_driver+0x148/0x1f0) from [<c021f8ac>]
(driver_register+0x78/0xf8)
[<c021f8ac>] (driver_register+0x78/0xf8) from [<c0008870>]
(do_one_initcall+0x100/0x14c)
[<c0008870>] (do_one_initcall+0x100/0x14c) from [<c0511c30>]
(kernel_init_freeable+0x138/0x1d8)
[<c0511c30>] (kernel_init_freeable+0x138/0x1d8) from [<c03aa2b4>]
(kernel_init+0x8/0x120)
[<c03aa2b4>] (kernel_init+0x8/0x120) from [<c000e478>] (ret_from_fork+0x14/0x3c)
Code: e1a01005 e30d07d4 e34c001e e3520000 (05853028)

I'm out of time to debug this more until tomorrow night or possibly
later, so I figured I'd report it at least.


-Olof
