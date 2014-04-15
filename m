Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaDOH0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:26:36 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:42982 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaDOH0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:26:34 -0400
MIME-Version: 1.0
In-Reply-To: <534C7D36.9090008@linaro.org>
References: <534C7D36.9090008@linaro.org>
Date: Tue, 15 Apr 2014 09:26:33 +0200
Message-ID: <CAPDyKFp=DikkmXnyHsTJF6W_FpTDJZYiSk9n7Nh+RwY=r=P4-Q@mail.gmail.com>
Subject: Re: [Regression?] qemu-system-arm flooding "sd_write_data: not in
 Receiving-Data state"
From: Ulf Hansson <ulf.hansson@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, Chris Ball <chris@printf.net>,
        Johan Rudholm <jrudholm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 02:28, John Stultz <john.stultz@linaro.org> wrote:
> (Forgive the duplicate, I forgot to cc lkml)
>
> I was testing v3.15-rc1 in my qemu-system-arm environment and noticed a
> flood of the following messages:
>     sd_write_data: not in Receiving-Data state
>
> After looking around in the kernel and not finding such a message, I
> realized this was actually a message from qemu, not the kernel.
>
> The system seems to boot normally, but is just very noisy w/ the qemu
> messages.
>
> Not sure if this is really a problem with qemu-system-arm, but this
> doesn't occur w/ 3.14 and previous kernels.
>
> Bisecting it down pointed to:
>
> commit e7f3d22289e4307b3071cc18b1d8ecc6598c0be4
> Author: Ulf Hansson <ulf.hansson@linaro.org>
> Date:   Fri Jan 10 14:51:42 2014 +0100
>
>     mmc: mmci: Handle CMD irq before DATA irq
>         In case of a read operation both MCI_CMDRESPEND and MCI_DATAEND
> can be
>     set in the status register when entering the interrupt handler. This is
>     due to that the card start sending data before the host has
>     acknowledged the command response.
>         To resolve the issue for this scenario, we must start by
> handling the
>     CMD irq instead of the DATA irq. The reason is beacuse the completion
>     of the DATA irq will not respect the current command and then causing
>     it to be garbled.
>         Cc: Russell King <linux@arm.linux.org.uk>
>     Cc: Johan Rudholm <jrudholm@gmail.com>
>     Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>     Signed-off-by: Chris Ball <chris@printf.net>
>

Hi John,

Just some more background to the patch; it resolves a race condition
in the IRQ handler for the mmci driver. A quite simple patch which
thus seems to trigger an issue for the qemu-system-arm model. I
haven't seen this on real hardware, at least yet. :-)

>
>
> $ qemu-system-arm -version
> QEMU emulator version 1.5.0 (Debian 1.5.0+dfsg-3ubuntu5.3), Copyright
> (c) 2003-2008 Fabrice Bellard
>
> Booting w/:
> qemu-system-arm -kernel zImage-arm -M vexpress-a9 -cpu cortex-a9
> -nographic -m 1024  -append 'root=/dev/mmcblk0p2 rw mem=1024M
> raid=noautodetect console=ttyAMA0,38400n8 rootwait vmalloc=256MB
> devtmpfs.mount=0' -sd test-arm.img -redir tcp:4300::22
>
> Let me know if you have any other questions or need any other info to
> help trouble-shoot this.

I am quite new to the qemu-system-arm model, I will need to spend some
time with it to be able to help out more.

Though, maybe you can provide me with some information about the qemu
environment you are using?

1. Especially, what variant of the ARM primcell pl180 is being
modelled/used here? The mmci driver handles a handful of different
variants.
2. What type of mmc/sd card is being modelled/used here?

Kind regards
Ulf Hansson

>
> thanks
> -john
