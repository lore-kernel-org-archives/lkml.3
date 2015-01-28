Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbbA2BrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:47:10 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:46734 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757811AbbA2BrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:47:08 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] staging: comedi: comedi_fops.c: document exported functions
Date: Wed, 28 Jan 2015 18:41:46 +0000
Message-Id: <1422470510-9309-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
References: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kerneldoc for exported functions `comedi_dev_put()`,
`comedi_dev_get_from_minor()`, `comedi_is_subdevice_running()`, and
`comedi_event()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index bb2e796..8f65097 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -113,6 +113,18 @@ static void comedi_dev_kref_release(struct kref *kref)
 	kfree(dev);
 }
 
+/**
+ * comedi_dev_put - release a use of a comedi device structure
+ * @dev: comedi_device struct
+ *
+ * Must be called when a user of a comedi device is finished with it.
+ * When the last user of the comedi device calls this function, the
+ * comedi device is destroyed.
+ *
+ * Return 1 if the comedi device is destroyed by this call or dev is
+ * NULL, otherwise return 0.  Callers must not assume the comedi
+ * device is still valid if this function returns 0.
+ */
 int comedi_dev_put(struct comedi_device *dev)
 {
 	if (dev)
@@ -220,6 +232,18 @@ static struct comedi_device *comedi_dev_get_from_subdevice_minor(unsigned minor)
 	return dev;
 }
 
+/**
+ * comedi_dev_get_from_minor - get comedi device by minor device number
+ * @minor: minor device number
+ *
+ * Finds the comedi device associated by the minor device number, if any,
+ * and increments its reference count.  The comedi device is prevented from
+ * being freed until a matching call is made to comedi_dev_put().
+ *
+ * Return a pointer to the comedi device if it exists, with its usage
+ * reference incremented.  Return NULL if no comedi device exists with the
+ * specified minor device number.
+ */
 struct comedi_device *comedi_dev_get_from_minor(unsigned minor)
 {
 	if (minor < COMEDI_NUM_BOARD_MINORS)
@@ -600,6 +624,13 @@ static unsigned comedi_get_subdevice_runflags(struct comedi_subdevice *s)
 	return runflags;
 }
 
+/**
+ * comedi_is_subdevice_running - check if async command running on subdevice
+ * @s: comedi_subdevice struct
+ *
+ * Return true if an asynchronous comedi command is active on the comedi
+ * subdevice, else return false.
+ */
 bool comedi_is_subdevice_running(struct comedi_subdevice *s)
 {
 	unsigned runflags = comedi_get_subdevice_runflags(s);
@@ -2584,6 +2615,17 @@ static const struct file_operations comedi_fops = {
 	.llseek = noop_llseek,
 };
 
+/**
+ * comedi_event - handle events for asynchronous comedi command
+ * @dev: comedi_device struct
+ * @s: comedi_subdevice struct associated with dev
+ * Context: interrupt (usually), s->spin_lock spin-lock not held
+ *
+ * If an asynchronous comedi command is active on the subdevice, process
+ * any COMEDI_CB_... event flags that have been set, usually by an
+ * interrupt handler.  These may change the run state of the asynchronous
+ * command, wake a task, and/or send a SIGIO signal.
+ */
 void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 {
 	struct comedi_async *async = s->async;
-- 
2.1.4

