Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab3FDCuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 22:50:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42728 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3FDCuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 22:50:00 -0400
Date: Mon, 3 Jun 2013 19:49:59 -0700
From: Greg KH <greg@kroah.com>
To: Tobias Winter <tobias@linuxdingsda.de>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Rob Landley <rob@landley.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] raise the maximum number of usb-serial devices to 512
Message-ID: <20130604024959.GA10697@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369721825.2776.36@driftwood>
 <51A327A4.7020908@linuxdingsda.de>
 <87obbwbo8s.fsf@nemi.mork.no>
 <51A332E2.1090403@linuxdingsda.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 02:28:51PM +0200, Bjørn Mork wrote:
> But, IMHO, a nicer approach would be to make the allocation completely
> dynamic, using e.g. the idr subsystem. Static tables are always feel
> like straight jackets to me, no matter how big they are :)

You are right, I didn't change the code to use idr (it predates idr by
about a decade or so), because I thought we needed the "rage" logic that
the usb-serial minor reservation does.

But I'm not so sure anymore, so here's a patch to change to use the idr
code, and should remove all minor number limitations (well 65k is the
limit the tty core should be setting I think.)

Tobias, can you test this patch out?  Note, I only compiled it, did not
get the chance to actually run it, so it might not work at all.

thanks,

greg k-h

Subject: [PATCH] usb: serial: remove minor number limitation of 255


Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

 drivers/usb/serial/usb-serial.c |   86 +++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 4753c00..74b6f08 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -37,6 +37,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/kfifo.h>
+#include <linux/idr.h>
 #include "pl2303.h"
 
 #define DRIVER_AUTHOR "Greg Kroah-Hartman <gregkh@linuxfoundation.org>"
@@ -49,7 +50,7 @@
    drivers depend on it.
 */
 
-static struct usb_serial *serial_table[SERIAL_TTY_MINORS];
+static DEFINE_IDR(serial_minors);
 static DEFINE_MUTEX(table_lock);
 static LIST_HEAD(usb_serial_driver_list);
 
@@ -61,59 +62,52 @@ static LIST_HEAD(usb_serial_driver_list);
 struct usb_serial *usb_serial_get_by_index(unsigned index)
 {
 	struct usb_serial *serial;
+	struct usb_serial_port *port;
 
 	mutex_lock(&table_lock);
-	serial = serial_table[index];
-
-	if (serial) {
-		mutex_lock(&serial->disc_mutex);
-		if (serial->disconnected) {
-			mutex_unlock(&serial->disc_mutex);
-			serial = NULL;
-		} else {
-			kref_get(&serial->kref);
-		}
-	}
+	port = idr_find(&serial_minors, index);
 	mutex_unlock(&table_lock);
+	if (!port)
+		return NULL;
+
+	serial = port->serial;
+	kref_get(&serial->kref);
 	return serial;
 }
 
-static struct usb_serial *get_free_serial(struct usb_serial *serial,
-					int num_ports, unsigned int *minor)
+static int get_free_port(struct usb_serial_port *port)
 {
-	unsigned int i, j;
-	int good_spot;
-
-	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
+	int i;
 
-	*minor = 0;
 	mutex_lock(&table_lock);
-	for (i = 0; i < SERIAL_TTY_MINORS; ++i) {
-		if (serial_table[i])
-			continue;
+	i = idr_alloc(&serial_minors, port, 0, 0, GFP_KERNEL);
+	if (i < 0)
+		return -EEXIST;
+	port->number = i;
+	mutex_unlock(&table_lock);
+	return i;
+}
 
-		good_spot = 1;
-		for (j = 1; j <= num_ports-1; ++j)
-			if ((i+j >= SERIAL_TTY_MINORS) || (serial_table[i+j])) {
-				good_spot = 0;
-				i += j;
-				break;
-			}
-		if (good_spot == 0)
-			continue;
+static int get_free_serial(struct usb_serial *serial, int num_ports,
+			   unsigned int *minor)
+{
+	unsigned int i;
+	unsigned int x;
 
-		*minor = i;
-		j = 0;
-		dev_dbg(&serial->interface->dev, "%s - minor base = %d\n", __func__, *minor);
-		for (i = *minor; (i < (*minor + num_ports)) && (i < SERIAL_TTY_MINORS); ++i) {
-			serial_table[i] = serial;
-			serial->port[j++]->number = i;
-		}
-		mutex_unlock(&table_lock);
-		return serial;
+	dev_dbg(&serial->interface->dev, "%s %d\n", __func__, num_ports);
+
+	*minor = 0xffffffff;
+	for (i = 0; i < num_ports; ++i) {
+		x = get_free_port(serial->port[i]);
+		if (x < 0)
+			goto error;
+		if (*minor == 0xffffffff)
+			*minor = x;
 	}
-	mutex_unlock(&table_lock);
-	return NULL;
+	return 0;
+error:
+	// FIXME unwind the already allocated minors
+	return -ENODEV;
 }
 
 static void return_serial(struct usb_serial *serial)
@@ -122,7 +116,7 @@ static void return_serial(struct usb_serial *serial)
 
 	mutex_lock(&table_lock);
 	for (i = 0; i < serial->num_ports; ++i)
-		serial_table[serial->minor + i] = NULL;
+		idr_remove(&serial_minors, serial->port[i]->number);
 	mutex_unlock(&table_lock);
 }
 
@@ -1041,7 +1035,7 @@ static int usb_serial_probe(struct usb_interface *interface,
 	 */
 	serial->disconnected = 1;
 
-	if (get_free_serial(serial, num_ports, &minor) == NULL) {
+	if (get_free_serial(serial, num_ports, &minor)) {
 		dev_err(ddev, "No more free serial devices\n");
 		goto probe_error;
 	}
@@ -1225,7 +1219,6 @@ static struct usb_driver usb_serial_driver = {
 
 static int __init usb_serial_init(void)
 {
-	int i;
 	int result;
 
 	usb_serial_tty_driver = alloc_tty_driver(SERIAL_TTY_MINORS);
@@ -1233,9 +1226,6 @@ static int __init usb_serial_init(void)
 		return -ENOMEM;
 
 	/* Initialize our global data */
-	for (i = 0; i < SERIAL_TTY_MINORS; ++i)
-		serial_table[i] = NULL;
-
 	result = bus_register(&usb_serial_bus_type);
 	if (result) {
 		pr_err("%s - registering bus driver failed\n", __func__);
