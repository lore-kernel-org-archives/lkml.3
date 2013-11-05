Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3KEJeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:34:31 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:51954 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab3KEJeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:34:25 -0500
Message-ID: <5278BB96.20207@gmail.com>
Date: Tue, 05 Nov 2013 10:34:14 +0100
From: Richard Genoud <richard.genoud@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Wenyou Yang <wenyou.yang@atmel.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: SPI zero-length transfer: What should it do ?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As I was coding something like this:
	static struct spi_ioc_transfer *xfer;
	struct spi_frame *rx_frame;
	xfer = calloc(nb, sizeof(*xfer));

	for (i = 0; i < nb; i++) {
		xfer[i].tx_buf = (unsigned long)tx_buf;
		xfer[i].rx_buf = (unsigned long)rx_buf;
		xfer[i].len = 0;
	}

	err = ioctl(spi_data->fd, SPI_IOC_MESSAGE(nb), xfer);
I ran into a bug in spi-atmel.c

NB: The zero-length SPI message was not intentional, it was just a bug in my software.

[   13.593750] spidev spi1.1:   xfer len 0 rx tx cs 8bits 150 usec 18000000Hz
[   13.601562] spidev spi1.1:   xfer len 0 rx tx cs 8bits 150 usec 18000000Hz
[   13.601562] spidev spi1.1:   xfer len 0 rx tx cs 8bits 150 usec 18000000Hz
[   13.609375] spidev spi1.1:   xfer len 0 rx tx cs 8bits 150 usec 18000000Hz
[   13.617187] spidev spi1.1:   xfer len 0 rx tx cs 8bits 150 usec 18000000Hz
[   13.625000] spidev spi1.1:   xfer len 0 rx tx cs 8bits 150 usec 18000000Hz
[   13.632812] spidev spi1.1:   xfer len 0 rx tx cs 8bits 150 usec 18000000Hz
[   13.632812] atmel_spi f0004000.spi: new message c7b49ec4 submitted for spi1.1
[   13.632812] atmel_spi f0004000.spi: start message c7b49ec4 for spi1.1
[   13.632812] spidev spi1.1: activate 16, mr 000d0031
[   13.632812] atmel_spi f0004000.spi: atmel_spi_next_xfer_pio
[   13.632812] atmel_spi f0004000.spi:   start pio xfer c79d80c0: len 0 tx c6e00000 rx c6e00000 bitpw 8
[   13.632812] irq 29: nobody cared (try booting with the "irqpoll" option)
[   13.632812] CPU: 0 PID: 494 Comm: multichannel Not tainted 3.11.2 #1
[   13.632812] [<c0012e20>] (unwind_backtrace+0x0/0xe0) from [<c0010bb8>] (show_stack+0x10/0x14)
[   13.632812] [<c0010bb8>] (show_stack+0x10/0x14) from [<c004d5b4>] (__report_bad_irq+0x1c/0xb4)
[   13.632812] [<c004d5b4>] (__report_bad_irq+0x1c/0xb4) from [<c004d9ac>] (note_interrupt+0x178/0x234)
[   13.632812] [<c004d9ac>] (note_interrupt+0x178/0x234) from [<c004c078>] (handle_irq_event_percpu+0x170/0x1a0)
[   13.632812] [<c004c078>] (handle_irq_event_percpu+0x170/0x1a0) from [<c004c0d0>] (handle_irq_event+0x28/0x38)
[   13.632812] [<c004c0d0>] (handle_irq_event+0x28/0x38) from [<c004e57c>] (handle_fasteoi_irq+0xa4/0xe4)
[   13.632812] [<c004e57c>] (handle_fasteoi_irq+0xa4/0xe4) from [<c004b910>] (generic_handle_irq+0x20/0x30)
[   13.632812] [<c004b910>] (generic_handle_irq+0x20/0x30) from [<c000f3e8>] (handle_IRQ+0x60/0x84)
[   13.632812] [<c000f3e8>] (handle_IRQ+0x60/0x84) from [<c00115e0>] (__irq_svc+0x40/0x4c)
[   13.632812] [<c00115e0>] (__irq_svc+0x40/0x4c) from [<bf1293dc>] (spidev_sync+0x6c/0x94 [spidev])
[   13.632812] [<bf1293dc>] (spidev_sync+0x6c/0x94 [spidev]) from [<bf129b24>] (spidev_ioctl+0x53c/0x66c [spidev])
[   13.632812] [<bf129b24>] (spidev_ioctl+0x53c/0x66c [spidev]) from [<c0087730>] (vfs_ioctl+0x28/0x3c)
[   13.632812] [<c0087730>] (vfs_ioctl+0x28/0x3c) from [<c0088158>] (do_vfs_ioctl+0x4e8/0x54c)
[   13.632812] [<c0088158>] (do_vfs_ioctl+0x4e8/0x54c) from [<c00881f0>] (SyS_ioctl+0x34/0x58)
[   13.632812] [<c00881f0>] (SyS_ioctl+0x34/0x58) from [<c000e500>] (ret_fast_syscall+0x0/0x2c)
[   13.632812] handlers:
[   13.632812] [<bf01142c>] atmel_spi_pio_interrupt [spi_atmel]
[   13.632812] Disabling IRQ #29

And that make me wonder what was the behavior to adopt in case of a zero-length transfer ?
Should spidev.c just return ok without doing anything ? Should it return -EINVAL ?
Or maybe we should activate/deactivate the chip select ?


Best regards,
Richard.
