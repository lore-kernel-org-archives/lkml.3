Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3BUBfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:35:38 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:51203 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab3BUBfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:35:34 -0500
Message-ID: <1361410527.3456.8.camel@thor.lan>
Subject: Re: [PATCH v2 8/9] pps: Use a single cdev
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>
Cc: linux-serial@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, giometti@linux.it
Date: Wed, 20 Feb 2013 20:35:27 -0500
In-Reply-To: <e2550575ba1568393ddd435180bc4d0341d8cae3.1360677367.git.linux@horizon.com>
References: <cover.1360677367.git.linux@horizon.com>
	 <e2550575ba1568393ddd435180bc4d0341d8cae3.1360677367.git.linux@horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 02:02 -0500, George Spelvin wrote:
> One per device just seems wasteful, when we already manintain a
> data structure to map minor numbers to devices, and we already have
> a PPS_MAX_SOURCES #define.
> 
> This is also a more comprehensive fix to the use-after-free bug
> that has already received a minimal patch.
> ---
>  drivers/pps/pps.c          | 66 ++++++++++++++++++++++++----------------------
>  include/linux/pps_kernel.h |  1 -
>  2 files changed, 34 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
> index 6437703..754b0b5 100644
> --- a/drivers/pps/pps.c
> +++ b/drivers/pps/pps.c
> @@ -41,6 +41,8 @@
>  
>  static dev_t pps_devt;
>  static struct class *pps_class;
> +static struct cdev pps_cdev;
> +
>  
>  static DEFINE_MUTEX(pps_idr_lock);
>  static DEFINE_IDR(pps_idr);
> @@ -244,17 +246,23 @@ static long pps_cdev_ioctl(struct file *file,
>  
>  static int pps_cdev_open(struct inode *inode, struct file *file)
>  {
> -	struct pps_device *pps = container_of(inode->i_cdev,
> -						struct pps_device, cdev);
> -	file->private_data = pps;
> -	kobject_get(&pps->dev->kobj);
> -	return 0;
> +	int err = -ENXIO;
> +	struct pps_device *pps;
> +
> +	rcu_read_lock();
> +	pps = idr_find(&pps_idr, iminor(inode));
> +	if (pps) {
> +		file->private_data = pps;
> +		kobject_get(&pps->dev->kobj);
> +		err = 0;
> +	}
> +	rcu_read_unlock();

This should be:
	rcu_read_lock();
	pps = idr_find(&pps_idr, iminor(inode));
	rcu_read_unlock();
	if (pps) {
		file->private_data = pps;
		kobject_get(&pps->dev->kobj);
		err = 0;
	}

It's only the internal structures of idr that need rcu barriers.

> +	return err;
>  }
>  
>  static int pps_cdev_release(struct inode *inode, struct file *file)
>  {
> -	struct pps_device *pps = container_of(inode->i_cdev,
> -						struct pps_device, cdev);
> +	struct pps_device *pps = file->private_data;
>  	kobject_put(&pps->dev->kobj);
>  	return 0;
>  }
> @@ -277,8 +285,6 @@ static void pps_device_destruct(struct device *dev)
>  {
>  	struct pps_device *pps = dev_get_drvdata(dev);
>  
> -	cdev_del(&pps->cdev);
> -
>  	/* Now we can release the ID for re-use */
>  	pr_debug("deallocating pps%d\n", pps->id);
>  	mutex_lock(&pps_idr_lock);
> @@ -295,17 +301,14 @@ int pps_register_cdev(struct pps_device *pps)
>  	dev_t devt;
>  
>  	mutex_lock(&pps_idr_lock);
> -	/* Get new ID for the new PPS source */
> -	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
> -		mutex_unlock(&pps_idr_lock);
> -		return -ENOMEM;
> -	}
> -
> -	/* Now really allocate the PPS source.
> +	/* Get new ID for the new PPS source.
>  	 * After idr_get_new() calling the new source will be freely available
>  	 * into the kernel.
>  	 */
> -	err = idr_get_new(&pps_idr, pps, &pps->id);
> +	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0)
> +		err = -ENOMEM;
> +	else
> +		err = idr_get_new(&pps_idr, pps, &pps->id);

Your maintainer should be letting you know about this:

-------- Forwarded Message --------
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
Tejun Heo <tj@kernel.org>, Rodolfo Giometti <giometti@enneenne.com>
Subject: [PATCH 41/62] pps: convert to idr_alloc()
Date: Sat, 2 Feb 2013 17:20:42 -0800

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/pps/kapi.c |  2 +-
 drivers/pps/pps.c  | 36 ++++++++++++++----------------------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index f197e8e..cdad4d9 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -102,7 +102,7 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 		goto pps_register_source_exit;
 	}
 
-	/* These initializations must be done before calling idr_get_new()
+	/* These initializations must be done before calling idr_alloc()
 	 * in order to avoid reces into pps_event().
 	 */
 	pps->params.api_version = PPS_API_VERS;
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2420d5a..de8e663 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -290,29 +290,21 @@ int pps_register_cdev(struct pps_device *pps)
 	dev_t devt;
 
 	mutex_lock(&pps_idr_lock);
-	/* Get new ID for the new PPS source */
-	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
-		mutex_unlock(&pps_idr_lock);
-		return -ENOMEM;
-	}
-
-	/* Now really allocate the PPS source.
-	 * After idr_get_new() calling the new source will be freely available
-	 * into the kernel.
+	/*
+	 * Get new ID for the new PPS source.  After idr_alloc() calling
+	 * the new source will be freely available into the kernel.
 	 */
-	err = idr_get_new(&pps_idr, pps, &pps->id);
-	mutex_unlock(&pps_idr_lock);
-
-	if (err < 0)
-		return err;
-
-	pps->id &= MAX_IDR_MASK;
-	if (pps->id >= PPS_MAX_SOURCES) {
-		pr_err("%s: too many PPS sources in the system\n",
-					pps->info.name);
-		err = -EBUSY;
-		goto free_idr;
+	err = idr_alloc(&pps_idr, pps, 0, PPS_MAX_SOURCES, GFP_KERNEL);
+	if (err < 0) {
+		if (err == -ENOSPC) {
+			pr_err("%s: too many PPS sources in the system\n",
+			       pps->info.name);
+			err = -EBUSY;
+		}
+		goto out_unlock;
 	}
+	pps->id = err;
+	mutex_unlock(&pps_idr_lock);
 
 	devt = MKDEV(MAJOR(pps_devt), pps->id);
 
@@ -345,8 +337,8 @@ del_cdev:
 free_idr:
 	mutex_lock(&pps_idr_lock);
 	idr_remove(&pps_idr, pps->id);
+out_unlock:
 	mutex_unlock(&pps_idr_lock);
-
 	return err;
 }
 
-- 
1.8.1


>  	mutex_unlock(&pps_idr_lock);
>  
>  	if (err < 0)
> @@ -321,33 +324,21 @@ int pps_register_cdev(struct pps_device *pps)
>  
>  	devt = MKDEV(MAJOR(pps_devt), pps->id);
>  
> -	cdev_init(&pps->cdev, &pps_cdev_fops);
> -	pps->cdev.owner = pps->info.owner;
> -
> -	err = cdev_add(&pps->cdev, devt, 1);
> -	if (err) {
> -		pr_err("%s: failed to add char device %d:%d\n",
> -				pps->info.name, MAJOR(pps_devt), pps->id);
> -		goto free_idr;
> -	}
>  	pps->dev = device_create(pps_class, pps->info.dev, devt, pps,
>  							"pps%d", pps->id);
>  	if (IS_ERR(pps->dev)) {
>  		err = PTR_ERR(pps->dev);
> -		goto del_cdev;
> +		goto free_idr;
>  	}
>  
>  	/* Override the release function with our own */
>  	pps->dev->release = pps_device_destruct;
>  
>  	pr_debug("source %s got cdev (%d:%d)\n", pps->info.name,
> -			MAJOR(pps_devt), pps->id);
> +			MAJOR(devt), MINOR(devt));
>  
>  	return 0;
>  
> -del_cdev:
> -	cdev_del(&pps->cdev);
> -
>  free_idr:
>  	mutex_lock(&pps_idr_lock);
>  	idr_remove(&pps_idr, pps->id);
> @@ -401,8 +392,9 @@ EXPORT_SYMBOL(pps_lookup_dev);
>  
>  static void __exit pps_exit(void)
>  {
> -	class_destroy(pps_class);
> +	cdev_del(&pps_cdev);
>  	unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
> +	class_destroy(pps_class);
>  }
>  
>  static int __init pps_init(void)
> @@ -422,12 +414,22 @@ static int __init pps_init(void)
>  		goto remove_class;
>  	}
>  
> +	cdev_init(&pps_cdev, &pps_cdev_fops);
> +	pps_cdev.owner = THIS_MODULE;
> +	err = cdev_add(&pps_cdev, pps_devt, PPS_MAX_SOURCES);
> +	if (err < 0) {
> +		pr_err("failed to register struct cdev\n");
> +		goto remove_region;
> +	}
> +
>  	pr_info("LinuxPPS API ver. %d registered\n", PPS_API_VERS);
>  	pr_info("Software ver. %s - Copyright 2005-2007 Rodolfo Giometti "
>  		"<giometti@linux.it>\n", PPS_VERSION);
>  
>  	return 0;
>  
> +remove_region:
> +	unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
>  remove_class:
>  	class_destroy(pps_class);
>  
> diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
> index 7db3eb9..caca565 100644
> --- a/include/linux/pps_kernel.h
> +++ b/include/linux/pps_kernel.h
> @@ -70,7 +70,6 @@ struct pps_device {
>  
>  	unsigned int id;			/* PPS source unique ID */
>  	void const *lookup_cookie;		/* pps_lookup_dev only */
> -	struct cdev cdev;
>  	struct device *dev;
>  	struct fasync_struct *async_queue;	/* fasync method */
>  	spinlock_t lock;


