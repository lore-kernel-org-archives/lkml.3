Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab3FFRbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:31:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3FFRbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:31:36 -0400
Date: Thu, 6 Jun 2013 10:31:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, Johan Hovold <jhovold@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] USB: serial: increase the number of devices we support
Message-ID: <20130606173135.GB1866@kroah.com>
References: <20130606173103.GA1812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606173103.GA1812@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

We had the limit of 255 USB to serial devices on one system for almost
15 years, with no complaints.  But now it's time to move on from these
tiny "baby" systems, and bump the number up to 512, which should last
us a few more years:
	"512 is a nice number" -- Tobias Winter

Note, this is still a static value, and uses up tty core memory with
this many tty devices allocated.  Converting the driver to use
TTY_DRIVER_DYNAMIC_DEV is the next thing to do in order to remove this
limitation.

Reported-by: Tobias Winter <tobias@linuxdingsda.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    9 ++++++---
 include/linux/usb/serial.h      |    3 ---
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -43,6 +43,9 @@
 #define DRIVER_AUTHOR "Greg Kroah-Hartman <gregkh@linuxfoundation.org>"
 #define DRIVER_DESC "USB Serial Driver core"
 
+#define USB_SERIAL_TTY_MAJOR	188
+#define USB_SERIAL_TTY_MINORS	512	/* should be enough for a while */
+
 /* There is no MODULE_DEVICE_TABLE for usbserial.c.  Instead
    the MODULE_DEVICE_TABLE declarations in each serial driver
    cause the "hotplug" program to pull in whatever module is necessary
@@ -460,7 +463,7 @@ static int serial_proc_show(struct seq_f
 	char tmp[40];
 
 	seq_puts(m, "usbserinfo:1.0 driver:2.0\n");
-	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
+	for (i = 0; i < USB_SERIAL_TTY_MINORS; ++i) {
 		port = usb_serial_port_get_by_minor(i);
 		if (port == NULL)
 			continue;
@@ -1229,7 +1232,7 @@ static int __init usb_serial_init(void)
 {
 	int result;
 
-	usb_serial_tty_driver = alloc_tty_driver(SERIAL_TTY_MINORS);
+	usb_serial_tty_driver = alloc_tty_driver(USB_SERIAL_TTY_MINORS);
 	if (!usb_serial_tty_driver)
 		return -ENOMEM;
 
@@ -1242,7 +1245,7 @@ static int __init usb_serial_init(void)
 
 	usb_serial_tty_driver->driver_name = "usbserial";
 	usb_serial_tty_driver->name = "ttyUSB";
-	usb_serial_tty_driver->major = SERIAL_TTY_MAJOR;
+	usb_serial_tty_driver->major = USB_SERIAL_TTY_MAJOR;
 	usb_serial_tty_driver->minor_start = 0;
 	usb_serial_tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
 	usb_serial_tty_driver->subtype = SERIAL_TYPE_NORMAL;
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -19,9 +19,6 @@
 #include <linux/sysrq.h>
 #include <linux/kfifo.h>
 
-#define SERIAL_TTY_MAJOR	188	/* Nice legal number now */
-#define SERIAL_TTY_MINORS	254	/* loads of devices :) */
-
 /* The maximum number of ports one device can grab at once */
 #define MAX_NUM_PORTS		8
 
