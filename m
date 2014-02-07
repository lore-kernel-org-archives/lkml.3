Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaBGLgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:36:31 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4806 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaBGLg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:36:28 -0500
Message-ID: <52F4C51A.90002@xs4all.nl>
Date: Fri, 07 Feb 2014 12:35:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 07/30] [media] radio-cadet: avoid interruptible_sleep_on
 race
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <201401171528.02016.arnd@arndb.de> <52F4A82C.7010104@xs4all.nl> <55674412.rAimUmdW3X@wuerfel>
In-Reply-To: <55674412.rAimUmdW3X@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 11:17 AM, Arnd Bergmann wrote:
> On Friday 07 February 2014 10:32:28 Hans Verkuil wrote:
>>         mutex_lock(&dev->lock);
>>         if (dev->rdsstat == 0)
>>                 cadet_start_rds(dev);
>> -       if (dev->rdsin == dev->rdsout) {
>> +       while (dev->rdsin == dev->rdsout) {
>>                 if (file->f_flags & O_NONBLOCK) {
>>                         i = -EWOULDBLOCK;
>>                         goto unlock;
>>                 }
>>                 mutex_unlock(&dev->lock);
>> -               interruptible_sleep_on(&dev->read_queue);
>> +               if (wait_event_interruptible(&dev->read_queue,
>> +                                            dev->rdsin != dev->rdsout))
>> +                       return -EINTR;
>>                 mutex_lock(&dev->lock);
>>         }
>>         while (i < count && dev->rdsin != dev->rdsout)
>>
> 
> This will normally work, but now the mutex is no longer
> protecting the shared access to the dev->rdsin and
> dev->rdsout variables, which was evidently the intention
> of the author of the original code.
> 
> AFAICT, the possible result is a similar race as before:
> if once CPU changes dev->rdsin after the process in
> cadet_read dropped the lock, the wakeup may get lost.
> 
> It's quite possible this race never happens in practice,
> but the code is probably still wrong.
> 
> If you think we don't actually need the lock to check
> "dev->rdsin != dev->rdsout", the code can be simplified
> further, to
> 
> 	if ((dev->rdsin == dev->rdsout) && (file->f_flags & O_NONBLOCK)) {
> 	        return -EWOULDBLOCK;
> 	i = wait_event_interruptible(&dev->read_queue, dev->rdsin != dev->rdsout);
> 	if (i)
> 		return i;
> 	
> 	Arnd
> 

OK, let's try again. This patch is getting bigger and bigger, but it is always
nice to know that your ISA card that almost no one else in the world has is really,
really working well. :-)

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 545c04c..d27e8b2 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -270,6 +270,16 @@ reset_rds:
 	outb(inb(dev->io + 1) & 0x7f, dev->io + 1);
 }
 
+static bool cadet_has_rds_data(struct cadet *dev)
+{
+	bool result;
+	
+	mutex_lock(&dev->lock);
+	result = dev->rdsin != dev->rdsout;
+	mutex_unlock(&dev->lock);
+	return result;
+}
+
 
 static void cadet_handler(unsigned long data)
 {
@@ -279,13 +289,12 @@ static void cadet_handler(unsigned long data)
 	if (mutex_trylock(&dev->lock)) {
 		outb(0x3, dev->io);       /* Select RDS Decoder Control */
 		if ((inb(dev->io + 1) & 0x20) != 0)
-			printk(KERN_CRIT "cadet: RDS fifo overflow\n");
+			pr_err("cadet: RDS fifo overflow\n");
 		outb(0x80, dev->io);      /* Select RDS fifo */
+
 		while ((inb(dev->io) & 0x80) != 0) {
 			dev->rdsbuf[dev->rdsin] = inb(dev->io + 1);
-			if (dev->rdsin + 1 == dev->rdsout)
-				printk(KERN_WARNING "cadet: RDS buffer overflow\n");
-			else
+			if (dev->rdsin + 1 != dev->rdsout)
 				dev->rdsin++;
 		}
 		mutex_unlock(&dev->lock);
@@ -294,7 +303,7 @@ static void cadet_handler(unsigned long data)
 	/*
 	 * Service pending read
 	 */
-	if (dev->rdsin != dev->rdsout)
+	if (cadet_has_rds_data(dev))
 		wake_up_interruptible(&dev->read_queue);
 
 	/*
@@ -327,22 +336,21 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 	mutex_lock(&dev->lock);
 	if (dev->rdsstat == 0)
 		cadet_start_rds(dev);
-	if (dev->rdsin == dev->rdsout) {
-		if (file->f_flags & O_NONBLOCK) {
-			i = -EWOULDBLOCK;
-			goto unlock;
-		}
-		mutex_unlock(&dev->lock);
-		interruptible_sleep_on(&dev->read_queue);
-		mutex_lock(&dev->lock);
-	}
+	mutex_unlock(&dev->lock);
+
+	if (!cadet_has_rds_data(dev) && (file->f_flags & O_NONBLOCK))
+		return -EWOULDBLOCK;
+	i = wait_event_interruptible(dev->read_queue, cadet_has_rds_data(dev));
+	if (i)
+		return i;
+
+	mutex_lock(&dev->lock);
 	while (i < count && dev->rdsin != dev->rdsout)
 		readbuf[i++] = dev->rdsbuf[dev->rdsout++];
+	mutex_unlock(&dev->lock);
 
 	if (i && copy_to_user(data, readbuf, i))
-		i = -EFAULT;
-unlock:
-	mutex_unlock(&dev->lock);
+		return -EFAULT;
 	return i;
 }
 
@@ -352,7 +360,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strlcpy(v->driver, "ADS Cadet", sizeof(v->driver));
 	strlcpy(v->card, "ADS Cadet", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
+	strlcpy(v->bus_info, "ISA:radio-cadet", sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
 			  V4L2_CAP_READWRITE | V4L2_CAP_RDS_CAPTURE;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -491,7 +499,7 @@ static unsigned int cadet_poll(struct file *file, struct poll_table_struct *wait
 			cadet_start_rds(dev);
 		mutex_unlock(&dev->lock);
 	}
-	if (dev->rdsin != dev->rdsout)
+	if (cadet_has_rds_data(dev))
 		res |= POLLIN | POLLRDNORM;
 	return res;
 }

