Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaDHBTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 21:19:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:2443 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaDHBT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,814,1389772800"; 
   d="scan'208";a="516289232"
Subject: [PATCH] Gadget: race between ffs_epfile_io() and
 ffs_func_eps_disable()
From: Chao Bi <chao.bi@intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Apr 2014 09:50:17 +0800
Message-ID: <1396921817.10644.16.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ffs_epfile_io() is called from userspace, while ffs_func_esp_disable() might
be called from USB disconnect interrupt, the two functions would run in parallel
but they are not well protected, that epfile->ep would be removed by
ffs_func_esp_disable() during ffs_epfile_io() is referring this pointer, then it
leads to kernel PANIC.

The scenario is as below:

Thread 1                                 Thread 2
   |                                        |
SyS_read                             dwc3_gadget_disconnect_interrupt
   |                                        |From 772c1c9ef451a9a84e48acf14ba613328920a2f4 Mon Sep 17 00:00:00 2001
From: channing <chao.bi@intel.com>
Date: Wed, 2 Apr 2014 16:37:57 +0800
Subject: [PATCH] Gadget: race between ffs_epfile_io() and
 ffs_func_eps_disable()

ffs_epfile_io() is called from userspace, while ffs_func_esp_disable() might
be called from USB disconnect interrupt, the two functions would run in parallel
but they are not well protected, that epfile->ep would be removed by
ffs_func_esp_disable() during ffs_epfile_io() is referring this pointer, then it
leads to kernel PANIC.

The scenario is as below:

Thread 1                                 Thread 2
   |                                        |
SyS_read                             dwc3_gadget_disconnect_interrupt
   |                                        |
ffs_epfile_read                         reset_config
   |                                        |
ffs_epfile_io                       ffs_func_eps_disable
   |                                        |
 -----                      usb_ep_disable():  epfile->ep->ep->desc = NULL
   |                                        |
usb_ep_align_maybe():                     -----
it refers ep->desc->wMaxPacketSize        -----

Signed-off-by: Chao Bi <chao.bi@intel.com>
---
 drivers/usb/gadget/f_fs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 2e164dc..1e12b3e 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -745,6 +745,12 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		 */
 		struct usb_gadget *gadget = epfile->ffs->gadget;
 
+		spin_lock_irq(&epfile->ffs->eps_lock);
+		/* In the meantime, endpoint got disabled or changed. */
+		if (epfile->ep != ep) {
+			spin_unlock_irq(&epfile->ffs->eps_lock);
+			return -ESHUTDOWN;
+		}
 		/*
 		 * Controller may require buffer size to be aligned to
 		 * maxpacketsize of an out endpoint.
@@ -752,6 +758,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		data_len = io_data->read ?
 			   usb_ep_align_maybe(gadget, ep->ep, io_data->len) :
 			   io_data->len;
+		spin_unlock_irq(&epfile->ffs->eps_lock);
 
 		data = kmalloc(data_len, GFP_KERNEL);
 		if (unlikely(!data))
-- 
1.7.9.5


ffs_epfile_read                         reset_config
   |                                        |
ffs_epfile_io                       ffs_func_eps_disable
   |                                        |
 -----                      usb_ep_disable():  epfile->ep->ep->desc = NULL
   |                                        |
usb_ep_align_maybe():                     -----
it refers ep->desc->wMaxPacketSize        -----

Signed-off-by: Chao Bi <chao.bi@intel.com>
---
 drivers/usb/gadget/f_fs.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 2e164dc..1e12b3e 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -745,6 +745,12 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		 */
 		struct usb_gadget *gadget = epfile->ffs->gadget;
 
+		spin_lock_irq(&epfile->ffs->eps_lock);
+		/* In the meantime, endpoint got disabled or changed. */
+		if (epfile->ep != ep) {
+			spin_unlock_irq(&epfile->ffs->eps_lock);
+			return -ESHUTDOWN;
+		}
 		/*
 		 * Controller may require buffer size to be aligned to
 		 * maxpacketsize of an out endpoint.
@@ -752,6 +758,7 @@ static ssize_t ffs_epfile_io(struct file *file, struct ffs_io_data *io_data)
 		data_len = io_data->read ?
 			   usb_ep_align_maybe(gadget, ep->ep, io_data->len) :
 			   io_data->len;
+		spin_unlock_irq(&epfile->ffs->eps_lock);
 
 		data = kmalloc(data_len, GFP_KERNEL);
 		if (unlikely(!data))
-- 
1.7.9.5



