Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3G2R0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:26:21 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34076 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab3G2R0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:26:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130729165329.GA5773@linutronix.de>
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
	<20130729165329.GA5773@linutronix.de>
Date: Mon, 29 Jul 2013 12:26:19 -0500
Message-ID: <CADYTM3b9MFPM4iDpe3H1uKC1ZCawrQCebqrZikXxS-s9VNDgpw@mail.gmail.com>
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back after removal
From: Bin Liu <binmlist@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Mon, Jul 29, 2013 at 11:53 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> So you say, am335x-evm is not able to run OTG mode and may only run in
> host mode and as a consequence it must not call musb_platform_try_idle()
> because it throws that one bit away and there is no way to bring it back?

I did not say AM335xEVM is not able to run OTG mode. The problem is in
OTG mode the SESSION bit will be cleared once the device is unplugged,
then there is no way the SESSION bit will come back in the current
mainline kernel.

The TI 3.2 kernel works around this OTG issue by toggling the SESSION
bit in b_idle handling in otg_timer(). The workaround makes most users
happy but it causes VBUS voltage pulsing. That is why I said I don't
know an ideal solution without a ID pin interrupt support.

>
> However, if I look at the tree you reference, I see in
> arch/arm/mach-omap2/board-am335xevm.c:
> | static struct omap_musb_board_data musb_board_data = {
> |         .interface_type = MUSB_INTERFACE_ULPI,
> |         .mode           = MUSB_OTG,
> |         .power          = 500,
> |         .instances      = 1,
> | };
> …
> | static void __init am335x_evm_init(void)
> …
> |   usb_musb_init(&musb_board_data);
>
> and it creates a "ti81xx-usbss" device.
>
> So it creates a musb device with mode MUSB_OTG no matter what.

I think you looked at a wrong file, maybe a wrong branch. Please check
[1], which defines

2644          * mode[0:3] = USB0PORT's mode
2645          * mode[4:7] = USB1PORT's mode
2646          * AM335X beta EVM has USB0 in OTG mode and USB1 in host mode.
2647          */
2648         .mode           = (MUSB_HOST << 4) | MUSB_OTG,

> I agree that without that try_idle part things keep working but it
> seems, that it is also called in the other tree.
>

Then because AM335xEVM USB1 port does not call *try_idle() in this 3.2
kernel, its SESSION bit is always set.

But I don't have a clear idea how to solve this in the mainline kernel
since is_otg_enabled() has been cleaned.

>>
>>Regards,
>>-Bin.
>
> Sebastian


Regards,
-Bin.

[1]: http://arago-project.org/git/projects/?p=linux-am33x.git;a=blob;f=arch/arm/mach-omap2/board-am335xevm.c;h=aec37f371342455e06626c47e0e92beb51930ed2;hb=refs/heads/v3.2-staging
