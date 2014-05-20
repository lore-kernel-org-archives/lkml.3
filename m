Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509AbaETUJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:09:40 -0400
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:59560 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750755AbaETUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:09:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:966:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3865:3867:3871:3874:4321:4385:4419:4605:5007:6119:6120:7652:7875:7901:7903:8603:9592:10004:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:14110:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flock07_53a02b1d0173a
X-Filterd-Recvd-Size: 5368
Message-ID: <1400616573.26709.33.camel@joe-AO725>
Subject: [PATCH] iowarrior: Convert local dbg macro to dev_dbg
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 20 May 2014 13:09:33 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more standard logging style.

Add terminating newlines to formats.
Remove __func__ as that can be added via dynamic debug.
Remove now unnecessary debug module parameter.
Remove the dbg macro too.

Signed-off-by: Joe Perches <joe@perches.com>
---

compiled/untested, no hardware.

 drivers/usb/misc/iowarrior.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 20bcfdd..c6bfd13 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -51,19 +51,12 @@
 */
 #define MAX_WRITES_IN_FLIGHT 4
 
-/* Use our own dbg macro */
-#undef dbg
-#define dbg( format, arg... ) do { if( debug ) printk( KERN_DEBUG __FILE__ ": " format "\n" , ## arg ); } while ( 0 )
-
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 /* Module parameters */
 static DEFINE_MUTEX(iowarrior_mutex);
-static bool debug = 0;
-module_param(debug, bool, 0644);
-MODULE_PARM_DESC(debug, "debug=1 enables debugging messages");
 
 static struct usb_driver iowarrior_driver;
 static DEFINE_MUTEX(iowarrior_open_disc_lock);
@@ -235,8 +228,8 @@ static void iowarrior_write_callback(struct urb *urb)
 	if (status &&
 	    !(status == -ENOENT ||
 	      status == -ECONNRESET || status == -ESHUTDOWN)) {
-		dbg("%s - nonzero write bulk status received: %d",
-		    __func__, status);
+		dev_dbg(&dev->interface->dev,
+			"nonzero write bulk status received: %d\n", status);
 	}
 	/* free up our allocated buffer */
 	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
@@ -251,7 +244,7 @@ static void iowarrior_write_callback(struct urb *urb)
  */
 static inline void iowarrior_delete(struct iowarrior *dev)
 {
-	dbg("%s - minor %d", __func__, dev->minor);
+	dev_dbg(&dev->interface->dev, "minor %d\n", dev->minor);
 	kfree(dev->int_in_buffer);
 	usb_free_urb(dev->int_in_urb);
 	kfree(dev->read_queue);
@@ -288,7 +281,8 @@ static ssize_t iowarrior_read(struct file *file, char __user *buffer,
 	if (dev == NULL || !dev->present)
 		return -ENODEV;
 
-	dbg("%s - minor %d, count = %zd", __func__, dev->minor, count);
+	dev_dbg(&dev->interface->dev, "minor %d, count = %zd\n",
+		dev->minor, count);
 
 	/* read count must be packet size (+ time stamp) */
 	if ((count != dev->report_size)
@@ -356,7 +350,8 @@ static ssize_t iowarrior_write(struct file *file,
 		retval = -ENODEV;
 		goto exit;
 	}
-	dbg("%s - minor %d, count = %zd", __func__, dev->minor, count);
+	dev_dbg(&dev->interface->dev, "minor %d, count = %zd\n",
+		dev->minor, count);
 	/* if count is 0 we're already done */
 	if (count == 0) {
 		retval = 0;
@@ -418,14 +413,16 @@ static ssize_t iowarrior_write(struct file *file,
 		int_out_urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!int_out_urb) {
 			retval = -ENOMEM;
-			dbg("%s Unable to allocate urb ", __func__);
+			dev_dbg(&dev->interface->dev,
+				"Unable to allocate urb\n");
 			goto error_no_urb;
 		}
 		buf = usb_alloc_coherent(dev->udev, dev->report_size,
 					 GFP_KERNEL, &int_out_urb->transfer_dma);
 		if (!buf) {
 			retval = -ENOMEM;
-			dbg("%s Unable to allocate buffer ", __func__);
+			dev_dbg(&dev->interface->dev,
+				"Unable to allocate buffer\n");
 			goto error_no_buffer;
 		}
 		usb_fill_int_urb(int_out_urb, dev->udev,
@@ -441,8 +438,9 @@ static ssize_t iowarrior_write(struct file *file,
 		}
 		retval = usb_submit_urb(int_out_urb, GFP_KERNEL);
 		if (retval) {
-			dbg("%s submit error %d for urb nr.%d", __func__,
-			    retval, atomic_read(&dev->write_busy));
+			dev_dbg(&dev->interface->dev,
+				"submit error %d for urb nr.%d\n",
+				retval, atomic_read(&dev->write_busy));
 			goto error;
 		}
 		/* submit was ok */
@@ -502,8 +500,8 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 		goto error_out;
 	}
 
-	dbg("%s - minor %d, cmd 0x%.4x, arg %ld", __func__, dev->minor, cmd,
-	    arg);
+	dev_dbg(&dev->interface->dev, "minor %d, cmd 0x%.4x, arg %ld\n",
+		dev->minor, cmd, arg);
 
 	retval = 0;
 	io_res = 0;
@@ -601,8 +599,6 @@ static int iowarrior_open(struct inode *inode, struct file *file)
 	int subminor;
 	int retval = 0;
 
-	dbg("%s", __func__);
-
 	mutex_lock(&iowarrior_mutex);
 	subminor = iminor(inode);
 
@@ -662,7 +658,7 @@ static int iowarrior_release(struct inode *inode, struct file *file)
 		return -ENODEV;
 	}
 
-	dbg("%s - minor %d", __func__, dev->minor);
+	dev_dbg(&dev->interface->dev, "minor %d\n", dev->minor);
 
 	/* lock our device */
 	mutex_lock(&dev->mutex);


