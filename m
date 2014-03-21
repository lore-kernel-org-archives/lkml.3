Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaCUOtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:49:32 -0400
Received: from wst.daktronics.com ([63.85.214.45]:51905 "EHLO
	wst.daktronics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaCUOtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:49:31 -0400
From: Matt Sickler <Matt.Sickler@daktronics.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "hjk@hansjkoch.de" <hjk@hansjkoch.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH]: UIO read(2)/write(2) overrides
Thread-Topic: [PATCH]: UIO read(2)/write(2) overrides
Thread-Index: Ac9FDxO9KmNAPrQNTAiN9FrBa597DAALBoCAAApAKZA=
Date: Fri, 21 Mar 2014 14:49:28 +0000
Message-ID: <8FAD17D1809CB042A0963E8337B9FE3DD7D871@MB-EXC-04.daktronics.lan>
References: <8FAD17D1809CB042A0963E8337B9FE3DD7D823@MB-EXC-04.daktronics.lan>
 <20140321142429.GA25833@kroah.com>
In-Reply-To: <20140321142429.GA25833@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.5.14.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
>
>On Fri, Mar 21, 2014 at 02:20:11PM +0000, Matt Sickler wrote:
>> Tiny patch to let uio-based drivers override the read(2), write(2), and poll(2) syscalls.
>> The rationale is that some uio-based drivers might want the mmap(2)
>> functionality of UIO, but have no need for the IRQ semantics of read(2) and write(2).
>
>Can you submit a driver that uses these new interfaces as well?  I don't want to add something that isn't used in the kernel.

We're developing a driver for a new product but the driver is still in a state of flux, so it's not ready for posting yet.
We will definitely get this out there once it's more polished.
If you want to hold off applying this patch until we have something to submit that uses it, I'm fine with that. 
I wanted to get the community's thoughts about this patch too.  (This is my first, now second, email to LKML).


>> Signed-Off-by: Matt Sickler <Matt.Sickler@daktronics.com>
>> ---
>> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c index
>> a673e5b..da1bfc8 100644
>> --- a/drivers/uio/uio.c
>> +++ b/drivers/uio/uio.c
>> @@ -505,6 +505,9 @@ static unsigned int uio_poll(struct file *filep, poll_table *wait)
>>     struct uio_listener *listener = filep->private_data;
>>     struct uio_device *idev = listener->dev;
>>
>> +   if (idev->info->poll)
>> +       return idev->info->poll(filep, wait);
>> +
>
>Your email client ate all the tabs and created a patch that can't be applied :(

Apologies, "Enterprise" email clients tend to do that.
This patch should be correctly formatted, if it's not I'll suffer through making mutt talk to Exchange.
---
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index a673e5b..da1bfc8 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -505,6 +505,9 @@ static unsigned int uio_poll(struct file *filep, poll_table *wait)
 	struct uio_listener *listener = filep->private_data;
 	struct uio_device *idev = listener->dev;
 
+	if (idev->info->poll)
+		return idev->info->poll(filep, wait);
+
 	if (!idev->info->irq)
 		return -EIO;
 
@@ -523,6 +526,9 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 	ssize_t retval;
 	s32 event_count;
 
+	if (idev->info->read)
+		return idev->info->read(filep, buf, count, ppos);
+
 	if (!idev->info->irq)
 		return -EIO;
 
@@ -571,6 +577,9 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
 	ssize_t retval;
 	s32 irq_on;
 
+	if (idev->info->write)
+		return idev->info->write(filep, buf, count, ppos);
+
 	if (!idev->info->irq)
 		return -EIO;
 
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 1ad4724..f15ace1 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -16,6 +16,7 @@
 
 #include <linux/fs.h>
 #include <linux/interrupt.h>
+#include <linux/poll.h>
 
 struct module;
 struct uio_map;
@@ -95,6 +96,11 @@ struct uio_info {
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
+	unsigned int (*poll)(struct file *filep, poll_table *wait);
+	ssize_t (*read)(struct file *filep, char __user *buf,
+	                size_t count, loff_t *ppos);
+	ssize_t (*write)(struct file *filep, const char __user *buf,
+	                 size_t count, loff_t *ppos);
 };
 
 extern int __must_check
