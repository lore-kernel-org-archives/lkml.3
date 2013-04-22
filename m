Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3DVWlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 18:41:36 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57613 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab3DVWle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 18:41:34 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 22 Apr 2013 15:42:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Alan Cox <alan@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] Watchdog: add pretimeout
Message-ID: <20130422224203.GA8805@roeck-us.net>
References: <20130422194347.GA14907@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130422194347.GA14907@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copying the watchdog mailing list.

On Mon, Apr 22, 2013 at 03:43:47PM -0400, Jörn Engel wrote:
> This patch adds a pretimeout with three actions to the generic watchdog
> code:
> 1) Print a kernel message.
> 2) Send a signal to the userspace process holding /dev/watchdogX open.
> 3) Call sys_sync.
> 
> I have found all of the above to be useful.  If the system gets rebooted
> by a watchdog, you first want to notice that it happened (1).  Next you
> want userspace logfiles from the time when it failed to acknowledge the
> watchdog.  (2) gives cooperating userspace a chance to flush userspace
> buffers and (3) increases the chances of those logfiles surviving the
> reboot.
> 
> 
> Given that this patch changes the userspace ABI, now would be a good
> time to raise concerns.  The most likely problem I see is using SIGILL
> to notify userspace.  Then again, whatever signal you pick will have
> other meanings attached, so the only choices are not to notify
> userspace or to pick some lesser of many evils.
> 
Hi Joern,

You could send a udev event, or a poll event, or both.

I think that sending a signal would be a bad idea, as it could inadvertently
kill the very application responsible for pinging the watchdog. And you
can not really expect that application to understand the difference
between your SIGSomething and a real signal.

Also, I think there should be a callback into the watchdog drivers.
There are watchdogs out there implementing a pre-timeout in hardware,
and the watchdog code could make use of that functionality.

Thanks,
Guenter

> Signed-off-by: Joern Engel <joern@logfs.org>
> ---
>  drivers/watchdog/watchdog_core.c |   29 ++++++++++++++++++++++
>  drivers/watchdog/watchdog_dev.c  |   50 ++++++++++++++++++++++++++++++++++++++
>  include/linux/watchdog.h         |    8 ++++++
>  3 files changed, 87 insertions(+)
> 
> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
> index 3796434..349a2c4 100644
> --- a/drivers/watchdog/watchdog_core.c
> +++ b/drivers/watchdog/watchdog_core.c
> @@ -36,12 +36,35 @@
>  #include <linux/init.h>		/* For __init/__exit/... */
>  #include <linux/idr.h>		/* For ida_* macros */
>  #include <linux/err.h>		/* For IS_ERR macros */
> +#include <linux/signal.h>	/* For send_sig */
> +#include <linux/sched.h>	/* For send_sig */
> +#include <linux/syscalls.h>	/* For sys_sync */
>  
>  #include "watchdog_core.h"	/* For watchdog_dev_register/... */
>  
>  static DEFINE_IDA(watchdog_ida);
>  static struct class *watchdog_class;
>  
> +static void watchdog_pretimeout_fire(unsigned long data)
> +{
> +	struct watchdog_device *wdd = (void *)data;
> +
> +	pr_emerg("Watchdog will fire in %ds\n", wdd->pretimeout_delta);
> +	spin_lock(&wdd->pretimeout_task_lock);
> +	if (wdd->pretimeout_task) {
> +		send_sig(SIGILL, wdd->pretimeout_task, 0);
> +		pr_emerg("Sent SIGILL to %d\n", wdd->pretimeout_task->pid);
> +	} else
> +		pr_emerg("Noone around to notify\n");
> +	spin_unlock(&wdd->pretimeout_task_lock);
> +	schedule_work(&wdd->pretimeout_work);
> +}
> +
> +static void watchdog_pretimeout_sync(struct work_struct *unused)
> +{
> +	sys_sync();
> +}
> +
>  /**
>   * watchdog_register_device() - register a watchdog device
>   * @wdd: watchdog device
> @@ -79,6 +102,12 @@ int watchdog_register_device(struct watchdog_device *wdd)
>  	 * corrupted in a later stage then we expect a kernel panic!
>  	 */
>  
> +	init_timer(&wdd->pretimeout_timer);
> +	wdd->pretimeout_timer.function = watchdog_pretimeout_fire;
> +	wdd->pretimeout_timer.data = (unsigned long)wdd;
> +	spin_lock_init(&wdd->pretimeout_task_lock);
> +	INIT_WORK(&wdd->pretimeout_work, watchdog_pretimeout_sync);
> +
>  	mutex_init(&wdd->lock);
>  	id = ida_simple_get(&watchdog_ida, 0, MAX_DOGS, GFP_KERNEL);
>  	if (id < 0)
> diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
> index ef8edec..d231228 100644
> --- a/drivers/watchdog/watchdog_dev.c
> +++ b/drivers/watchdog/watchdog_dev.c
> @@ -73,6 +73,10 @@ static int watchdog_ping(struct watchdog_device *wddev)
>  	if (!watchdog_active(wddev))
>  		goto out_ping;
>  
> +	if (wddev->pretimeout)
> +		mod_timer(&wddev->pretimeout_timer,
> +				jiffies + wddev->pretimeout * HZ);
> +
>  	if (wddev->ops->ping)
>  		err = wddev->ops->ping(wddev);  /* ping the watchdog */
>  	else
> @@ -106,6 +110,10 @@ static int watchdog_start(struct watchdog_device *wddev)
>  	if (watchdog_active(wddev))
>  		goto out_start;
>  
> +	if (wddev->pretimeout)
> +		mod_timer(&wddev->pretimeout_timer,
> +				jiffies + wddev->pretimeout * HZ);
> +
>  	err = wddev->ops->start(wddev);
>  	if (err == 0)
>  		set_bit(WDOG_ACTIVE, &wddev->status);
> @@ -145,6 +153,9 @@ static int watchdog_stop(struct watchdog_device *wddev)
>  		goto out_stop;
>  	}
>  
> +	if (wddev->pretimeout)
> +		del_timer(&wddev->pretimeout_timer);
> +
>  	err = wddev->ops->stop(wddev);
>  	if (err == 0)
>  		clear_bit(WDOG_ACTIVE, &wddev->status);
> @@ -185,6 +196,24 @@ out_status:
>  	return err;
>  }
>  
> +/**
> + *	watchdog_set_pretimeout - set the watchdog timer pretimeout
> + *	@wddev: the watchdog device to set the pretimeout for
> + *	@new_delta: the new pretimeout (as delta to the timeout)
> + *	@new_timeout: the new timeout
> + */
> +static int watchdog_set_pretimeout(struct watchdog_device *wddev,
> +		unsigned int new_delta, unsigned int new_timeout)
> +{
> +	if (new_delta >= new_timeout)
> +		return -EINVAL;
> +	wddev->pretimeout_delta = new_delta;
> +	wddev->pretimeout = new_timeout - new_delta;
> +	pr_info("WATCHDOG: set pretimeout %d - %d = %d\n", new_timeout, new_delta,
> +			wddev->pretimeout);
> +	return 0;
> +}
> +
>  /*
>   *	watchdog_set_timeout: set the watchdog timer timeout
>   *	@wddev: the watchdog device to set the timeout for
> @@ -373,9 +402,20 @@ static long watchdog_ioctl(struct file *file, unsigned int cmd,
>  			return -EOPNOTSUPP;
>  		watchdog_ping(wdd);
>  		return 0;
> +	case WDIOC_SETPRETIMEOUT:
> +		if (get_user(val, p))
> +			return -EFAULT;
> +		if (watchdog_set_pretimeout(wdd, val, wdd->timeout))
> +			return -EINVAL;
> +		/* Fall through */
> +	case WDIOC_GETPRETIMEOUT:
> +		return put_user(wdd->pretimeout_delta, p);
>  	case WDIOC_SETTIMEOUT:
>  		if (get_user(val, p))
>  			return -EFAULT;
> +		err = watchdog_set_pretimeout(wdd, wdd->pretimeout_delta, val);
> +		if (err < 0)
> +			return err;
>  		err = watchdog_set_timeout(wdd, val);
>  		if (err < 0)
>  			return err;
> @@ -413,6 +453,7 @@ static int watchdog_open(struct inode *inode, struct file *file)
>  {
>  	int err = -EBUSY;
>  	struct watchdog_device *wdd;
> +	unsigned long flags;
>  
>  	/* Get the corresponding watchdog device */
>  	if (imajor(inode) == MISC_MAJOR)
> @@ -435,6 +476,10 @@ static int watchdog_open(struct inode *inode, struct file *file)
>  	if (err < 0)
>  		goto out_mod;
>  
> +	spin_lock_irqsave(&wdd->pretimeout_task_lock, flags);
> +	wdd->pretimeout_task = current;
> +	spin_unlock_irqrestore(&wdd->pretimeout_task_lock, flags);
> +
>  	file->private_data = wdd;
>  
>  	if (wdd->ops->ref)
> @@ -463,6 +508,7 @@ out:
>  static int watchdog_release(struct inode *inode, struct file *file)
>  {
>  	struct watchdog_device *wdd = file->private_data;
> +	unsigned long flags;
>  	int err = -EBUSY;
>  
>  	/*
> @@ -483,6 +529,10 @@ static int watchdog_release(struct inode *inode, struct file *file)
>  		watchdog_ping(wdd);
>  	}
>  
> +	spin_lock_irqsave(&wdd->pretimeout_task_lock, flags);
> +	wdd->pretimeout_task = NULL;
> +	spin_unlock_irqrestore(&wdd->pretimeout_task_lock, flags);
> +
>  	/* Allow the owner module to be unloaded again */
>  	module_put(wdd->ops->owner);
>  
> diff --git a/include/linux/watchdog.h b/include/linux/watchdog.h
> index 3a9df2f..90e7135 100644
> --- a/include/linux/watchdog.h
> +++ b/include/linux/watchdog.h
> @@ -59,6 +59,8 @@ struct watchdog_ops {
>   * @info:	Pointer to a watchdog_info structure.
>   * @ops:	Pointer to the list of watchdog operations.
>   * @bootstatus:	Status of the watchdog device at boot.
> + * @pretimeout_delta:	The watchdog devices pretimeout value (in s before timeout).
> + * @pretimeout:	The watchdog devices pretimeout value (in absolute seconds).
>   * @timeout:	The watchdog devices timeout value.
>   * @min_timeout:The watchdog devices minimum timeout value.
>   * @max_timeout:The watchdog devices maximum timeout value.
> @@ -82,7 +84,13 @@ struct watchdog_device {
>  	struct device *parent;
>  	const struct watchdog_info *info;
>  	const struct watchdog_ops *ops;
> +	struct task_struct *pretimeout_task;
> +	spinlock_t pretimeout_task_lock;
> +	struct timer_list pretimeout_timer;
> +	struct work_struct pretimeout_work;
>  	unsigned int bootstatus;
> +	unsigned int pretimeout_delta;
> +	unsigned int pretimeout;
>  	unsigned int timeout;
>  	unsigned int min_timeout;
>  	unsigned int max_timeout;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
