Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbbAJAtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:49:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbbAJAs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:48:59 -0500
Date: Fri, 9 Jan 2015 16:48:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stefan Agner <stefan@agner.ch>
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] serial: fsl_lpuart: delete timer on shutdown
Message-ID: <20150110004858.GB4171@kroah.com>
References: <1420848539-4519-1-git-send-email-stefan@agner.ch>
 <1420848539-4519-2-git-send-email-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420848539-4519-2-git-send-email-stefan@agner.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 01:08:58AM +0100, Stefan Agner wrote:
> If the serial port gets closed while a RX transfer is in progress,
> the timer might fire after the serial port shutdown finished. This
> leads in a NULL pointer dereference:
> 
> [    7.508324] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> [    7.516590] pgd = 86348000
> [    7.519445] [00000000] *pgd=86179831, *pte=00000000, *ppte=00000000
> [    7.526145] Internal error: Oops: 17 [#1] ARM
> [    7.530611] Modules linked in:
> [    7.533876] CPU: 0 PID: 123 Comm: systemd Not tainted 3.19.0-rc3-00004-g5b11ea7 #1778
> [    7.541827] Hardware name: Freescale Vybrid VF610 (Device Tree)
> [    7.547862] task: 861c3400 ti: 86ac8000 task.ti: 86ac8000
> [    7.553392] PC is at lpuart_timer_func+0x24/0xf8
> [    7.558127] LR is at lpuart_timer_func+0x20/0xf8
> [    7.562857] pc : [<802df99c>]    lr : [<802df998>]    psr: 600b0113
> [    7.562857] sp : 86ac9b90  ip : 86ac9b90  fp : 86ac9bbc
> [    7.574467] r10: 80817180  r9 : 80817b98  r8 : 80817998
> [    7.579803] r7 : 807acee0  r6 : 86989000  r5 : 00000100  r4 : 86997210
> [    7.586444] r3 : 86ac8000  r2 : 86ac9bc0  r1 : 86997210  r0 : 00000000
> [    7.593085] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [    7.600341] Control: 10c5387d  Table: 86348059  DAC: 00000015
> [    7.606203] Process systemd (pid: 123, stack limit = 0x86ac8230)
> 
> Setup the timer on UART startup which allows to delete the timer
> unconditionally on shutdown. This also saves the initialization
> on each transfer.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/tty/serial/fsl_lpuart.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Do stable kernels care about this as well, or is this just a regression
from 3.18?

thanks,

greg k-h
