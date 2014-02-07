Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992AbaBGJdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:33:05 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2935 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaBGJdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:33:02 -0500
Message-ID: <52F4A82C.7010104@xs4all.nl>
Date: Fri, 07 Feb 2014 10:32:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 07/30] [media] radio-cadet: avoid interruptible_sleep_on
 race
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-8-git-send-email-arnd@arndb.de> <52D90A2F.2030903@xs4all.nl> <201401171528.02016.arnd@arndb.de>
In-Reply-To: <201401171528.02016.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd!

On 01/17/2014 03:28 PM, Arnd Bergmann wrote:
> On Friday 17 January 2014, Hans Verkuil wrote:
>>> @@ -323,25 +324,32 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
>>>       struct cadet *dev = video_drvdata(file);
>>>       unsigned char readbuf[RDS_BUFFER];
>>>       int i = 0;
>>> +     DEFINE_WAIT(wait);
>>>  
>>>       mutex_lock(&dev->lock);
>>>       if (dev->rdsstat == 0)
>>>               cadet_start_rds(dev);
>>> -     if (dev->rdsin == dev->rdsout) {
>>> +     while (1) {
>>> +             prepare_to_wait(&dev->read_queue, &wait, TASK_INTERRUPTIBLE);
>>> +             if (dev->rdsin != dev->rdsout)
>>> +                     break;
>>> +
>>>               if (file->f_flags & O_NONBLOCK) {
>>>                       i = -EWOULDBLOCK;
>>>                       goto unlock;
>>>               }
>>>               mutex_unlock(&dev->lock);
>>> -             interruptible_sleep_on(&dev->read_queue);
>>> +             schedule();
>>>               mutex_lock(&dev->lock);
>>>       }
>>> +
>>
>> This seems overly complicated. Isn't it enough to replace interruptible_sleep_on
>> by 'wait_event_interruptible(&dev->read_queue, dev->rdsin != dev->rdsout);'?
>>
>> Or am I missing something subtle?
> 
> The existing code sleeps with &dev->lock released because the cadet_handler()
> function needs to grab (and release) the same lock before it can wake up
> the reader thread.
> 
> Doing the simple wait_event_interruptible() would result in a deadlock here.

I don't see it. I propose this patch:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 545c04c..2f658c6 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -327,13 +327,15 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 	mutex_lock(&dev->lock);
 	if (dev->rdsstat == 0)
 		cadet_start_rds(dev);
-	if (dev->rdsin == dev->rdsout) {
+	while (dev->rdsin == dev->rdsout) {
 		if (file->f_flags & O_NONBLOCK) {
 			i = -EWOULDBLOCK;
 			goto unlock;
 		}
 		mutex_unlock(&dev->lock);
-		interruptible_sleep_on(&dev->read_queue);
+		if (wait_event_interruptible(&dev->read_queue,
+					     dev->rdsin != dev->rdsout))
+			return -EINTR;
 		mutex_lock(&dev->lock);
 	}
 	while (i < count && dev->rdsin != dev->rdsout)

Tested with my radio-cadet card.

This looks good to me. If I am still missing something, let me know!

Regards,

	Hans
