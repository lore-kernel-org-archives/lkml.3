Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaGBQEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:04:15 -0400
Received: from mail01.baslerweb.com ([80.156.24.166]:17614 "EHLO
	mail01.baslerweb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaGBQEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:04:14 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2014 12:04:13 EDT
Message-ID: <53B42B14.7010303@baslerweb.com>
Date: Wed, 2 Jul 2014 17:53:56 +0200
From: Stefan Klug <stefan.klug@baslerweb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <stern@rowland.harvard.edu>
Subject: [PATCH][RFC] USB: zerocopy support for usbfs
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.16.50.117]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,
in short: The attached patch adds zerocopy support to the usbfs driver.
I tested it on x86 and on a globalscale mirabox ARM board. Until now it 
works
quite nice and I'd love to get some comments and feedback on the patch.

Longer version: The usbfs driver does not support direct data transfers 
from the controller
to user-memory. For several use-cases (in my case USB3 Vision cameras 
pushing up to 360MB/s)
the copy operation from kernel to user-space results in a lot of 
unnecessary CPU overhead
especially on small embedded devices. I measured a decrease in CPU usage 
from 44% to 22% on
a the mirabox.

This patch implements zerocopy beside the existing code paths, so it is 
easy to disable
zerocopy at runtime and to directly compare the CPU usage.
To disable zerocopy just do an
     echo 1 > /sys/module/usbcore/parameters/usbfs_disable_zerocopy
and to reenable it
     echo 0 > /sys/module/usbcore/parameters/usbfs_disable_zerocopy

On modern desktop systems the change in CPU usage is quite low so this 
mostly affects
smaller embedded devices.

Implementation details:
The patch only touches drivers/usb/core/devio.c.
In procy_do_submiturb(), it is checked if zerocopy is allowed. This is 
currently a rough
check which compares the number of required pages to 
ps->dev->bus->sg_tablesize.
I don't know if there is more to check there.
Then the user memory provided inside the usbdevfs_urb structure is 
pinned to
physical memory using get_user_pages_fast().
All the user pages are added to the scatter-gather list and the logic 
continues as before.
In copy_urb_data_to_user() the pages are marked with 
set_page_dirty_lock() if the transfer
  was a zerocopy one.
In free_async() the pinned pages are released, if the transfer was a 
zerocopy one.

Questions/Notes:
- I'm quite unhappy with the added member async::is_user_mem. Is there a 
better place
   where I could store this information?
- I had a look at some other drivers using the get_user_pages -> 
sg_set_page -> page_cache_release
   technique and didn't see any special code to handle corner cases.
   Are there corner cases? - Like usb controllers not supporting the 
whole memory etc. ?
- In the kernel log I see messages like:
   xhci_hcd 0000:00:14.0: WARN Event TRB for slot 4 ep 8 with no TDs queued?
   after enabling zerocopy. Any idea where this might come from?

This patch should cleanly apply to the current master (3.16-rc2)

Kind regards
Stefan

Signed-off-by: Stefan Klug <stefan.klug@baslerweb.com>
---

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 257876e..c97d1ec 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -4,6 +4,7 @@
   *      devio.c  --  User space communication with USB devices.
   *
   *      Copyright (C) 1999-2000  Thomas Sailer (sailer@ife.ee.ethz.ch)
+ *      Copyright (C) 2014  Stefan Klug (stefan.klug@baslerweb.com)
   *
   *      This program is free software; you can redistribute it and/or 
modify
   *      it under the terms of the GNU General Public License as 
published by
@@ -30,6 +31,7 @@
   *    04.01.2000   0.2   Turned into its own filesystem
   *    30.09.2005   0.3   Fix user-triggerable oops in async URB delivery
   *                 (CAN-2005-3055)
+ *    07.05.2014   0.4   Added zerocopy support
   */

  /*****************************************************************************/
@@ -52,6 +54,7 @@
  #include <linux/uaccess.h>
  #include <asm/byteorder.h>
  #include <linux/moduleparam.h>
+#include <linux/pagemap.h>

  #include "usb.h"

@@ -94,6 +97,9 @@ struct async {
      u32 secid;
      u8 bulk_addr;
      u8 bulk_status;
+
+    //set to 1, if the buffer is pinned user-memory
+    u8 is_user_mem;
  };

  static bool usbfs_snoop;
@@ -118,6 +124,12 @@ module_param(usbfs_memory_mb, uint, 0644);
  MODULE_PARM_DESC(usbfs_memory_mb,
          "maximum MB allowed for usbfs buffers (0 = no limit)");

+
+static bool usbfs_disable_zerocopy = false;
+module_param(usbfs_disable_zerocopy, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(usbfs_disable_zerocopy, "true to disable zerocopy and 
fallback to the old implementation");
+
+
  /* Hard limit, necessary to avoid arithmetic overflow */
  #define USBFS_XFER_MAX        (UINT_MAX / 2 - 1000000)

@@ -289,14 +301,23 @@ static struct async *alloc_async(unsigned int 
numisoframes)
  static void free_async(struct async *as)
  {
      int i;
+    struct page* p;

      put_pid(as->pid);
      if (as->cred)
          put_cred(as->cred);
+
      for (i = 0; i < as->urb->num_sgs; i++) {
-        if (sg_page(&as->urb->sg[i]))
-            kfree(sg_virt(&as->urb->sg[i]));
+        p = sg_page(&as->urb->sg[i]);
+        if (p) {
+            if(as->is_user_mem) {
+                page_cache_release(p);
+            } else {
+                kfree(sg_virt(&as->urb->sg[i]));
+            }
+        }
      }
+
      kfree(as->urb->sg);
      kfree(as->urb->transfer_buffer);
      kfree(as->urb->setup_packet);
@@ -419,9 +440,11 @@ static void snoop_urb_data(struct urb *urb, 
unsigned len)
      }
  }

-static int copy_urb_data_to_user(u8 __user *userbuffer, struct urb *urb)
+static int copy_urb_data_to_user(u8 __user *userbuffer, struct async *as)
  {
      unsigned i, len, size;
+    struct urb *urb = as->urb;
+    struct page* page;

      if (urb->number_of_packets > 0)        /* Isochronous */
          len = urb->transfer_buffer_length;
@@ -434,12 +457,20 @@ static int copy_urb_data_to_user(u8 __user 
*userbuffer, struct urb *urb)
          return 0;
      }

-    for (i = 0; i < urb->num_sgs && len; i++) {
-        size = (len > USB_SG_SIZE) ? USB_SG_SIZE : len;
-        if (copy_to_user(userbuffer, sg_virt(&urb->sg[i]), size))
-            return -EFAULT;
-        userbuffer += size;
-        len -= size;
+    if(as->is_user_mem) {
+        for (i = 0; i < urb->num_sgs; i++) {
+            page = sg_page(&urb->sg[i]);
+            if (page)
+                set_page_dirty_lock(page);
+        }
+    } else {
+        for (i = 0; i < urb->num_sgs && len; i++) {
+            size = (len > USB_SG_SIZE) ? USB_SG_SIZE : len;
+            if (copy_to_user(userbuffer, sg_virt(&urb->sg[i]), size))
+                return -EFAULT;
+            userbuffer += size;
+            len -= size;
+        }
      }

      return 0;
@@ -1294,6 +1325,12 @@ static int proc_do_submiturb(struct usb_dev_state 
*ps, struct usbdevfs_urb *uurb
      unsigned int stream_id = 0;
      void *buf;

+    int num_pages = 0;
+    void *buf_aligned = 0; //the page aligned version of urb->buffer
+    int buf_offset = 0; // the offset nbetween urb->buffer and 
buf_alignment
+    int o;
+    struct page **pages = NULL;
+
      if (uurb->flags & ~(USBDEVFS_URB_ISO_ASAP |
                  USBDEVFS_URB_SHORT_NOT_OK |
                  USBDEVFS_URB_BULK_CONTINUATION |
@@ -1369,9 +1406,21 @@ static int proc_do_submiturb(struct usb_dev_state 
*ps, struct usbdevfs_urb *uurb
              uurb->type = USBDEVFS_URB_TYPE_INTERRUPT;
              goto interrupt_urb;
          }
-        num_sgs = DIV_ROUND_UP(uurb->buffer_length, USB_SG_SIZE);
-        if (num_sgs == 1 || num_sgs > ps->dev->bus->sg_tablesize)
-            num_sgs = 0;
+
+
+        buf_aligned = (char*)((unsigned long)uurb->buffer & PAGE_MASK);
+        buf_offset = uurb->buffer - buf_aligned;
+        if(uurb->buffer_length > 0)
+            num_pages = DIV_ROUND_UP(uurb->buffer_length + buf_offset, 
PAGE_SIZE);
+
+        if(usbfs_disable_zerocopy || num_pages > 
ps->dev->bus->sg_tablesize) {
+            num_pages = 0;
+
+            //fallback to the non-zerocopy path
+            num_sgs = DIV_ROUND_UP(uurb->buffer_length, USB_SG_SIZE);
+            if (num_sgs == 1 || num_sgs > ps->dev->bus->sg_tablesize)
+                num_sgs = 0;
+        }
          if (ep->streams)
              stream_id = uurb->stream_id;
          break;
@@ -1435,8 +1484,14 @@ static int proc_do_submiturb(struct usb_dev_state 
*ps, struct usbdevfs_urb *uurb
          goto error;
      }

-    u += sizeof(struct async) + sizeof(struct urb) + uurb->buffer_length +
-         num_sgs * sizeof(struct scatterlist);
+    u += sizeof(struct async) + sizeof(struct urb) +
+         num_sgs * sizeof(struct scatterlist) +
+         num_pages * sizeof(struct scatterlist);
+
+    //only add buffer_length if not doing zerocopy
+    if(!num_pages)
+        u += uurb->buffer_length;
+
      ret = usbfs_increase_memory_usage(u);
      if (ret)
          goto error;
@@ -1471,6 +1526,57 @@ static int proc_do_submiturb(struct usb_dev_state 
*ps, struct usbdevfs_urb *uurb
              }
              totlen -= u;
          }
+    } else if(num_pages) {
+        pages = kmalloc(num_pages*sizeof(struct page*), GFP_KERNEL);
+        if(!pages) {
+            ret = -ENOMEM;
+            goto error;
+        }
+
+        //create the scatterlist
+        as->urb->sg = kmalloc(num_pages * sizeof(struct scatterlist), 
GFP_KERNEL);
+        if (!as->urb->sg) {
+            ret = -ENOMEM;
+            goto error;
+        }
+
+        ret = get_user_pages_fast((unsigned long)buf_aligned,
+                   num_pages,
+                   is_in,
+                   pages);
+
+        if(ret < 0) {
+            printk("get_user_pages failed %i\n", ret);
+            goto error;
+        }
+
+        //did we get all pages?
+        if(ret < num_pages) {
+            printk("get_user_pages didn't deliver all pages %i\n", ret);
+            //free the pages and error out
+            for(i=0; i<ret; i++) {
+                page_cache_release(pages[i]);
+            }
+            ret = -ENOMEM;
+            goto error;
+        }
+
+        as->is_user_mem = 1;
+        as->urb->num_sgs = num_pages;
+        sg_init_table(as->urb->sg, as->urb->num_sgs);
+
+        totlen = uurb->buffer_length + buf_offset;
+        o = buf_offset;
+        for (i = 0; i < as->urb->num_sgs; i++) {
+            u = (totlen > PAGE_SIZE) ? PAGE_SIZE : totlen;
+            u-= o;
+            sg_set_page(&as->urb->sg[i], pages[i], u, o);
+            totlen -= u + o;
+            o = 0;
+        }
+
+        kfree(pages);
+        pages = NULL;
      } else if (uurb->buffer_length > 0) {
          as->urb->transfer_buffer = kmalloc(uurb->buffer_length,
                  GFP_KERNEL);
@@ -1602,6 +1708,7 @@ static int proc_do_submiturb(struct usb_dev_state 
*ps, struct usbdevfs_urb *uurb
   error:
      kfree(isopkt);
      kfree(dr);
+    kfree(pages);
      if (as)
          free_async(as);
      return ret;
@@ -1650,7 +1757,7 @@ static int processcompl(struct async *as, void 
__user * __user *arg)
      unsigned int i;

      if (as->userbuffer && urb->actual_length) {
-        if (copy_urb_data_to_user(as->userbuffer, urb))
+        if (copy_urb_data_to_user(as->userbuffer, as))
              goto err_out;
      }
      if (put_user(as->status, &userurb->status))
@@ -1818,7 +1925,7 @@ static int processcompl_compat(struct async *as, 
void __user * __user *arg)
      unsigned int i;

      if (as->userbuffer && urb->actual_length) {
-        if (copy_urb_data_to_user(as->userbuffer, urb))
+        if (copy_urb_data_to_user(as->userbuffer, as))
              return -EFAULT;
      }
      if (put_user(as->status, &userurb->status))



---


Stefan Klug
Software Developer

Basler AG
An der Strusbek 60-62
22926 Ahrensburg
Germany

Tel. +49 4102 463 582
Fax +49 4102 463 46 582
 
Stefan.Klug@baslerweb.com

www.baslerweb.com

Vorstand: Dr.-Ing. Dietmar Ley (Vorsitzender) · John P. Jennings · Arndt Bake · Hardy Mehl
Aufsichtsratsvorsitzender: Norbert Basler 
Basler AG · Amtsgericht Lübeck HRB 4090 · Ust-IdNr.: DE 135 098 121 · Steuer-Nr.: 30 292 04497 · WEEE-Reg.-Nr. DE 83888045
