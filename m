Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3G2Qxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:53:31 -0400
Received: from www.linutronix.de ([62.245.132.108]:48026 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3G2Qxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:53:30 -0400
Date: Mon, 29 Jul 2013 18:53:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Bin Liu <binmlist@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back
 after removal
Message-ID: <20130729165329.GA5773@linutronix.de>
References: <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
 <20130726163101.GB29819@linutronix.de>
 <CADYTM3bfkxEYgvk5v_0=BJFMb8izULpgc1uZVPDPnSs29UpYeA@mail.gmail.com>
 <CADYTM3b7-WHA73qMypUSd8VcTWuvooap_Ki65BcoJ7qKhejXZw@mail.gmail.com>
 <51F2BE6F.3010008@linutronix.de>
 <CADYTM3Y5p-ysgbcL4qZMWLiRVbcPgNQgtydpdhYQJLtd+r1hfw@mail.gmail.com>
 <51F2D427.7050106@linutronix.de>
 <CADYTM3ZAsBuFi2guX-j+0f837Uy4EkZ0_QEhKV+WWUOsaDfaDQ@mail.gmail.com>
 <51F2DD90.2030405@linutronix.de>
 <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CADYTM3Y18yo7S6=k6rgFgpPdbZSH4-92q2FmEnWgjxmQ5g2jbA@mail.gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bin Liu | 2013-07-26 22:07:14 [-0500]:

>Sebastian,
Hi Bin,

>I have not tested it yet, but I believe I found why host mode works on
>TI 3.2 kernel but not on mainline. Please look at Line 786 in 3.2
>kernel musb_core.c [1].
>
>773         if ((int_usb & MUSB_INTR_DISCONNECT) && !musb->ignore_disconnect) {
>......
>785                                 if (musb->a_wait_bcon != 0 &&
>786                                                 is_otg_enabled(musb))
>787                                         musb_platform_try_idle(musb, jiffies
>788                                         +
>msecs_to_jiffies(musb->a_wait_bcon));
>
>So when the device is unplugged, *_try_idle() is not called in host
>mode, then the SESSION bit will stay set. But in mainline kernel,
>*_try_idle() will be called regardless.
>
>Please let me know your thoughts.

I am not too familiar with what should happen. The is_otg_enabled() part
is gone since v3.7-rc1 via:
|commit 032ec49f5351e9cb242b1a1c367d14415043ab95
|Author: Felipe Balbi <balbi@ti.com>
|Date:   Thu Nov 24 15:46:26 2011 +0200
|
|    usb: musb: drop useless board_mode usage
|    
|    we are compiling the driver always with full OTG
|    capabilities, so that board_mode trick becomes
|    useless.
|    
|    Signed-off-by: Felipe Balbi <balbi@ti.com>

So you say, am335x-evm is not able to run OTG mode and may only run in
host mode and as a consequence it must not call musb_platform_try_idle()
because it throws that one bit away and there is no way to bring it back?

However, if I look at the tree you reference, I see in
arch/arm/mach-omap2/board-am335xevm.c:
| static struct omap_musb_board_data musb_board_data = {
|         .interface_type = MUSB_INTERFACE_ULPI,
|         .mode           = MUSB_OTG,
|         .power          = 500,
|         .instances      = 1,
| };
…
| static void __init am335x_evm_init(void)
…
|   usb_musb_init(&musb_board_data);

and it creates a "ti81xx-usbss" device.

So it creates a musb device with mode MUSB_OTG no matter what.
I agree that without that try_idle part things keep working but it
seems, that it is also called in the other tree.

>
>Regards,
>-Bin.

Sebastian
