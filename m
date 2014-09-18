Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaIRMWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:22:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaIRMWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:22:54 -0400
Date: Thu, 18 Sep 2014 20:22:26 +0800
From: Amos Kong <akong@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] hw_random: use reference counts on each struct hwrng.
Message-ID: <20140918122226.GA29803@air.redhat.com>
References: <87wq91odhf.fsf@rustcorp.com.au>
 <1411008506-28349-1-git-send-email-rusty@rustcorp.com.au>
 <1411008506-28349-2-git-send-email-rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411008506-28349-2-git-send-email-rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:18:23PM +0930, Rusty Russell wrote:
> current_rng holds one reference, and we bump it every time we want
> to do a read from it.
> 
> This means we only hold the rng_mutex to grab or drop a reference,
> so accessing /sys/devices/virtual/misc/hw_random/rng_current doesn't
> block on read of /dev/hwrng.
> 
> Using a kref is overkill (we're always under the rng_mutex), but
> a standard pattern.
> 
> This also solves the problem that the hwrng_fillfn thread was
> accessing current_rng without a lock, which could change (eg. to NULL)
> underneath it.

Hi Rusty,
 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/char/hw_random/core.c | 135 ++++++++++++++++++++++++++++--------------
>  include/linux/hw_random.h     |   2 +
>  2 files changed, 94 insertions(+), 43 deletions(-)

...

>  static int rng_dev_open(struct inode *inode, struct file *filp)
>  {
>  	/* enforce read-only access to this chrdev */
> @@ -154,21 +202,22 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  	ssize_t ret = 0;
>  	int err = 0;
>  	int bytes_read, len;
> +	struct hwrng *rng;
>  
>  	while (size) {
> -		if (mutex_lock_interruptible(&rng_mutex)) {
> -			err = -ERESTARTSYS;
> +		rng = get_current_rng();
> +		if (IS_ERR(rng)) {
> +			err = PTR_ERR(rng);
>  			goto out;
>  		}
> -
> -		if (!current_rng) {
> +		if (!rng) {
>  			err = -ENODEV;
> -			goto out_unlock;
> +			goto out;
>  		}
>  
>  		mutex_lock(&reading_mutex);
>  		if (!data_avail) {
> -			bytes_read = rng_get_data(current_rng, rng_buffer,
> +			bytes_read = rng_get_data(rng, rng_buffer,
>  				rng_buffer_size(),
>  				!(filp->f_flags & O_NONBLOCK));
>  			if (bytes_read < 0) {
> @@ -200,7 +249,6 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  			ret += len;
>  		}
>  
> -		mutex_unlock(&rng_mutex);
>  		mutex_unlock(&reading_mutex);
>  
>  		if (need_resched())
> @@ -210,15 +258,16 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  			err = -ERESTARTSYS;

We need put_rng() in this error path. Otherwise, unhotplug will hang
in the end of hwrng_unregister()

|        /* Just in case rng is reading right now, wait. */
|        wait_event(rng_done, atomic_read(&rng->ref.refcount) == 0);

Steps to reproduce the hang:
  guest) # dd if=/dev/hwrng of=/dev/null 
  cancel dd process after 10 seconds
  guest) # dd if=/dev/hwrng of=/dev/null &
  hotunplug rng device from qemu monitor
  result: device can't be removed (still can find in QEMU monitor)


diff --git a/drivers/char/hw_random/core.c
b/drivers/char/hw_random/core.c
index 96fa067..4e22d70 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -258,6 +258,7 @@ static ssize_t rng_dev_read(struct file *filp,
char __user *buf,
 
                if (signal_pending(current)) {
                        err = -ERESTARTSYS;
+                       put_rng(rng);
                        goto out;
                }

>  			goto out;
>  		}
> +
> +		put_rng(rng);
>  	}
>  out:
>  	return ret ? : err;
> -out_unlock:
> -	mutex_unlock(&rng_mutex);
> -	goto out;
> +
>  out_unlock_reading:
>  	mutex_unlock(&reading_mutex);
> -	goto out_unlock;
> +	put_rng(rng);
> +	goto out;
>  }
>  
>  
> @@ -257,8 +306,8 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>  			err = hwrng_init(rng);
>  			if (err)
>  				break;
> -			hwrng_cleanup(current_rng);
> -			current_rng = rng;
> +			drop_current_rng();
> +			set_current_rng(rng);
>  			err = 0;
>  			break;
>  		}
> @@ -272,17 +321,15 @@ static ssize_t hwrng_attr_current_show(struct device *dev,
>  				       struct device_attribute *attr,
>  				       char *buf)
>  {
> -	int err;
>  	ssize_t ret;
> -	const char *name = "none";
> +	struct hwrng *rng;
>  
> -	err = mutex_lock_interruptible(&rng_mutex);
> -	if (err)
> -		return -ERESTARTSYS;
> -	if (current_rng)
> -		name = current_rng->name;
> -	ret = snprintf(buf, PAGE_SIZE, "%s\n", name);
> -	mutex_unlock(&rng_mutex);
> +	rng = get_current_rng();
> +	if (IS_ERR(rng))
> +		return PTR_ERR(rng);
> +
> +	ret = snprintf(buf, PAGE_SIZE, "%s\n", rng ? rng->name : "none");
> +	put_rng(rng);
>  
>  	return ret;
>  }
> @@ -357,12 +404,16 @@ static int hwrng_fillfn(void *unused)
>  	long rc;
>  
>  	while (!kthread_should_stop()) {
> -		if (!current_rng)
> +		struct hwrng *rng;
> +
> +		rng = get_current_rng();
> +		if (IS_ERR(rng) || !rng)
>  			break;
>  		mutex_lock(&reading_mutex);
> -		rc = rng_get_data(current_rng, rng_fillbuf,
> +		rc = rng_get_data(rng, rng_fillbuf,
>  				  rng_buffer_size(), 1);
>  		mutex_unlock(&reading_mutex);
> +		put_rng(rng);

^^^
This put_rng() called a deadlock. I will describe in the bottom.
                

>  		if (rc <= 0) {
>  			pr_warn("hwrng: no data available\n");
>  			msleep_interruptible(10000);
> @@ -423,14 +474,13 @@ int hwrng_register(struct hwrng *rng)
>  		err = hwrng_init(rng);
>  		if (err)
>  			goto out_unlock;
> -		current_rng = rng;
> +		set_current_rng(rng);
>  	}
>  	err = 0;
>  	if (!old_rng) {
>  		err = register_miscdev();
>  		if (err) {
> -			hwrng_cleanup(rng);
> -			current_rng = NULL;
> +			drop_current_rng();
>  			goto out_unlock;
>  		}
>  	}
> @@ -457,22 +507,21 @@ EXPORT_SYMBOL_GPL(hwrng_register);
>  
>  void hwrng_unregister(struct hwrng *rng)
>  {
> -	int err;
> -
>  	mutex_lock(&rng_mutex);
>  
>  	list_del(&rng->list);
>  	if (current_rng == rng) {
> -		hwrng_cleanup(rng);
> -		if (list_empty(&rng_list)) {
> -			current_rng = NULL;
> -		} else {
> -			current_rng = list_entry(rng_list.prev, struct hwrng, list);
> -			err = hwrng_init(current_rng);
> -			if (err)
> -				current_rng = NULL;
> +		drop_current_rng();
> +		if (!list_empty(&rng_list)) {
> +			struct hwrng *tail;
> +
> +			tail = list_entry(rng_list.prev, struct hwrng, list);
> +
> +			if (hwrng_init(tail) == 0)
> +				set_current_rng(tail);
>  		}
>  	}
> +
>  	if (list_empty(&rng_list)) {
>  		unregister_miscdev();
>  		if (hwrng_fill)

hwrng_unregister() and put_rng() grab the lock, if hwrng_unregister()
takes the lock, hwrng_fillfn() will stay at put_rng() to wait the
lock.

Right now, thread_stop() is insider lock protection, but we try to
wake up the fillfn thread and wait for its completion.

         |   wake_up_process(k);
         |   wait_for_completion(&kthread->exited);

The solution is moving kthread_stop() outsider of lock protection.


@@ -524,11 +525,11 @@ void hwrng_unregister(struct hwrng *rng)
 
        if (list_empty(&rng_list)) {
                unregister_miscdev();
+               mutex_unlock(&rng_mutex);
                if (hwrng_fill)
                        kthread_stop(hwrng_fill);
-       }
-
-       mutex_unlock(&rng_mutex);
+       } else
+               mutex_unlock(&rng_mutex);
 
        /* Just in case rng is reading right now, wait. */
        wait_event(rng_done, atomic_read(&rng->ref.refcount) == 0);

================
After applied my additional two fixes, both cating hung and hotunplug
issues were resolved.

| test 0:
|   hotunplug rng device from qemu monitor
| 
| test 1:
|   guest) # dd if=/dev/hwrng of=/dev/null &
|   hotunplug rng device from qemu monitor
| 
| test 2:
|   guest) # dd if=/dev/random of=/dev/null &
|   hotunplug rng device from qemu monitor
| 
| test 4:
|   guest) # dd if=/dev/hwrng of=/dev/null &
|   cat /sys/devices/virtual/misc/hw_random/rng_*
| 
| test 5:
|   guest) # dd if=/dev/hwrng of=/dev/null 
|   cancel dd process after 10 seconds
|   guest) # dd if=/dev/hwrng of=/dev/null &
|   hotunplug rng device from qemu monitor
|
| test 6:
|   use a fifo as rng backend, execute test 0 ~ 5 with no input of fifo

Test are all passed :-)

I know you are going or you already started your holiday, I will post
a v2 with my additional patches.

Thanks, Amos

> diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
> index 914bb08cd738..c212e71ea886 100644
> --- a/include/linux/hw_random.h
> +++ b/include/linux/hw_random.h
> @@ -14,6 +14,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/list.h>
> +#include <linux/kref.h>
>  
>  /**
>   * struct hwrng - Hardware Random Number Generator driver
> @@ -44,6 +45,7 @@ struct hwrng {
>  
>  	/* internal. */
>  	struct list_head list;
> +	struct kref ref;
>  };
>  
>  /** Register a new Hardware Random Number Generator driver. */
> -- 
> 1.9.1
