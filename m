Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbaEaXiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:38:22 -0400
Received: from donald.hachti.de ([188.40.85.216]:36977 "EHLO donald.hachti.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbaEaXiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:38:20 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sat, 31 May 2014 19:38:19 EDT
From: Philipp Hachtmann <hachti@hachti.de>
To: jhovold@gmail.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Philipp Hachtmann <hachti@hachti.de>
Subject: [PATCH 0/2] Add synchronous FIFO and CBUS support for FT232H
Date: Sun,  1 Jun 2014 01:31:04 +0200
Message-Id: <1401579066-8298-1-git-send-email-hachti@hachti.de>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I am currently developing hardware around the FTDI FT232H chip. The chip
can be programmed into asynchronous FIFO mode by EEPROM settings. Using
it with ftdi_sio in asynchronous mode works out of the box.

1. Synchronous FIFO mode
========================

The even more wonderful synchronous FIFO mode has to be enabled in software.
I first tried to use libftdi which worked in *some way*. But I think having
support for the synchronous FIFO mode in the ftdi_sio driver would be very
nice. So I took some inspiration from libftdi and prepared a patch which
adds the support to the driver. Only for FT232H. The patch adds a sysfs 
attribute "syncmode" which can be set and reset by the user.
Currently only exactly the FT232H is supported. But I know that there are
more FTDI chips (which ones? how?) which also support the sync FIFO mode.

The patch won't change any behaviour unless

a) you have an FT232H connected

AND 

b) you use the syncmode attribute.


2. CBUS bitbang support
=======================

The FT232H also supports software control of four CBUS lines.
In my application I use two of them for signalling purposes. The CBUS
patch adds a sysfs attribute which allows to set the CBUS mask and pins
like libftdi does it.
The attribute is read/write but the read function is currently just a
stub which returns -EIO.

3. The buffer thing
===================

With the sync mode patch I get transfer rates about 5 to 8 MB/sec in each
direction and simultaneously. That's not that much.
FTDI says (in an application note) that one should increase send and receive
buffer sizes.
I don't know too much about USB and even less about the usb-serial stuff.

Then I made this experiment:

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 3eabacf..de57931 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1002,8 +1002,10 @@ static struct usb_serial_driver ftdi_sio_device = {
        .description =          "FTDI USB Serial Device",
        .id_table =             id_table_combined,
        .num_ports =            1,
-       .bulk_in_size =         512,
-       .bulk_out_size =        256,
+       //      .bulk_in_size =         512,
+       //      .bulk_out_size =        256,
+       .bulk_in_size =         48*1024,
+       .bulk_out_size =        48*1024,
        .probe =                ftdi_sio_probe,
        .port_probe =           ftdi_sio_port_probe,
        .port_remove =          ftdi_sio_port_remove,
@@ -1326,0 +1328,0 @@ static int change_speed(struct tty_struct *tty, struct usb_serial_port *port)

With that rude hack I get transfer rates of at least 15 MB/s into each
direction simultaneously and approx. 30MB/sec in one direction only.

The usb_serial_driver structure is a static global thing for all FTDI chips.
I *know* that the above diff is absolutely impossible to apply. It was just
an experiment.

I just don't know how to get this third thing right. So I would appreciate any
support getting this right.

Kind regards

Philipp


Philipp Hachtmann (2):
  usb/ftdi_sio: Add synchronous FIFO mode support for FT232H
  usb/ftdi_sio: Add support for setting CBUS pins on FT232H

 drivers/usb/serial/ftdi_sio.c | 129 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/serial/ftdi_sio.h |  16 ++++++
 2 files changed, 143 insertions(+), 2 deletions(-)

-- 
2.0.0.rc2

