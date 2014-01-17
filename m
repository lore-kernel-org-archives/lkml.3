Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaAQKrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:47:31 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2106 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAQKr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:47:29 -0500
Message-ID: <52D90A2F.2030903@xs4all.nl>
Date: Fri, 17 Jan 2014 11:47:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH, RFC 07/30] [media] radio-cadet: avoid interruptible_sleep_on
 race
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de> <1388664474-1710039-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1388664474-1710039-8-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd!

On 01/02/2014 01:07 PM, Arnd Bergmann wrote:
> interruptible_sleep_on is racy and going away. This replaces
> one use in the radio-cadet driver with an open-coded
> wait loop that lets us check the condition under the mutex
> but sleep without it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/radio/radio-cadet.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
> index 545c04c..67b5bbf 100644
> --- a/drivers/media/radio/radio-cadet.c
> +++ b/drivers/media/radio/radio-cadet.c
> @@ -39,6 +39,7 @@
>  #include <linux/pnp.h>
>  #include <linux/sched.h>
>  #include <linux/io.h>		/* outb, outb_p			*/
> +#include <linux/wait.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-ctrls.h>
> @@ -323,25 +324,32 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
>  	struct cadet *dev = video_drvdata(file);
>  	unsigned char readbuf[RDS_BUFFER];
>  	int i = 0;
> +	DEFINE_WAIT(wait);
>  
>  	mutex_lock(&dev->lock);
>  	if (dev->rdsstat == 0)
>  		cadet_start_rds(dev);
> -	if (dev->rdsin == dev->rdsout) {
> +	while (1) {
> +		prepare_to_wait(&dev->read_queue, &wait, TASK_INTERRUPTIBLE);
> +		if (dev->rdsin != dev->rdsout)
> +			break;
> +
>  		if (file->f_flags & O_NONBLOCK) {
>  			i = -EWOULDBLOCK;
>  			goto unlock;
>  		}
>  		mutex_unlock(&dev->lock);
> -		interruptible_sleep_on(&dev->read_queue);
> +		schedule();
>  		mutex_lock(&dev->lock);
>  	}
> +

This seems overly complicated. Isn't it enough to replace interruptible_sleep_on
by 'wait_event_interruptible(&dev->read_queue, dev->rdsin != dev->rdsout);'?

Or am I missing something subtle?

Regards,

	Hans

>  	while (i < count && dev->rdsin != dev->rdsout)
>  		readbuf[i++] = dev->rdsbuf[dev->rdsout++];
>  
>  	if (i && copy_to_user(data, readbuf, i))
>  		i = -EFAULT;
>  unlock:
> +	finish_wait(&dev->read_queue, &wait);
>  	mutex_unlock(&dev->lock);
>  	return i;
>  }
> 

