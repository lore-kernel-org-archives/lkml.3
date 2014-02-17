Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaBQPz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:55:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34576 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBQPzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:55:24 -0500
Date: Mon, 17 Feb 2014 15:54:51 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
Message-ID: <20140217155451.34b2c749@alan.etchedpixels.co.uk>
In-Reply-To: <20140217153518.30891455@alan.etchedpixels.co.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
	<1390208555-27770-3-git-send-email-tushar.behera@linaro.org>
	<20140120100415.GX15937@n2100.arm.linux.org.uk>
	<20140213181216.GB24155@kroah.com>
	<20140213181559.GB30257@n2100.arm.linux.org.uk>
	<20140213182701.GA32578@kroah.com>
	<20140213184249.GC30257@n2100.arm.linux.org.uk>
	<20140213232606.GA27372@kroah.com>
	<20140214000717.GG30257@n2100.arm.linux.org.uk>
	<20140214001436.GA16287@kroah.com>
	<20140214003834.GH30257@n2100.arm.linux.org.uk>
	<20140217153518.30891455@alan.etchedpixels.co.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And an even simpler broad brush approach will also work I think (untested)

The "zero crap" approach....

commit c5cd0be0576ba9059799ef5383402ff6ffc212a3
Author: Alan <gnomes@lxorguk.ukuu.org.uk>
Date:   Mon Feb 17 15:52:21 2014 +0000

    tty: Allow serial port allocations to be fully dynamic
    
    This switch allows platforms to make their serial port allocations entirely
    dynamic as is needed on some non-x86 platforms which have overlapping static
    minor numbers between some of their devices.
    
    Default to the old static allocations for maximum compatibility with ancient
    userspace.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index 65cd80b..670c076 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -166,6 +166,16 @@ config LEGACY_PTY_COUNT
 	  When not in use, each legacy PTY occupies 12 bytes on 32-bit
 	  architectures and 24 bytes on 64-bit architectures.
 
+config TTY_SERIAL_LEGACY
+	bool "Allocate legacy fixed minor numbers for serial ports"
+	default y
+	---help---
+	  Modern linux dynamically allocates device numbers. Some very old
+	  Linux distributions only support static device numbering.
+	  Selecting this option will enable support for very old
+	  userspace but on some non PC architectures may prevent you building
+	  a single kernel for multiple machines.
+
 config BFIN_JTAG_COMM
 	tristate "Blackfin JTAG Communication"
 	depends on BLACKFIN
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index ece2049..b78afc1 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2315,8 +2315,10 @@ int uart_register_driver(struct uart_driver *drv)
 
 	normal->driver_name	= drv->driver_name;
 	normal->name		= drv->dev_name;
+#ifdef CONFIG_TTY_SERIAL_LEGACY
 	normal->major		= drv->major;
 	normal->minor_start	= drv->minor;
+#endif	
 	normal->type		= TTY_DRIVER_TYPE_SERIAL;
 	normal->subtype		= SERIAL_TYPE_NORMAL;
 	normal->init_termios	= tty_std_termios;
