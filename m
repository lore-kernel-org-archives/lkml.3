Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbaIRRIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:08:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbaIRRIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:08:32 -0400
Date: Fri, 19 Sep 2014 01:08:13 +0800
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: herbert@gondor.apana.org.au, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com
Subject: Re: [PATCH v2 3/6] hw_random: use reference counts on each struct
 hwrng.
Message-ID: <20140918170813.GA30440@air.redhat.com>
References: <1411043867-21109-1-git-send-email-akong@redhat.com>
 <1411043867-21109-4-git-send-email-akong@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411043867-21109-4-git-send-email-akong@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 08:37:44PM +0800, Amos Kong wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
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
> 
> V2: reduce reference count in signal_pending path
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Amos Kong <akong@redhat.com>

Reply myself.

> ---
>  drivers/char/hw_random/core.c | 136 +++++++++++++++++++++++++++++-------------
>  include/linux/hw_random.h     |   2 +
>  2 files changed, 95 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index a0905c8..ee9e504 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -42,6 +42,7 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/random.h>
> +#include <linux/err.h>
>  #include <asm/uaccess.h>
>  
>  
> @@ -91,6 +92,59 @@ static void add_early_randomness(struct hwrng *rng)
>  		add_device_randomness(bytes, bytes_read);
>  }
>  
> +static inline void cleanup_rng(struct kref *kref)
> +{
> +	struct hwrng *rng = container_of(kref, struct hwrng, ref);
> +
> +	if (rng->cleanup)
> +		rng->cleanup(rng);
> +}
> +
> +static void set_current_rng(struct hwrng *rng)
> +{
> +	BUG_ON(!mutex_is_locked(&rng_mutex));
> +	kref_get(&rng->ref);
> +	current_rng = rng;
> +}
> +
> +static void drop_current_rng(void)
> +{
> +	BUG_ON(!mutex_is_locked(&rng_mutex));
> +	if (!current_rng)
> +		return;
> +
> +	kref_put(&current_rng->ref, cleanup_rng);
> +	current_rng = NULL;
> +}
> +
> +/* Returns ERR_PTR(), NULL or refcounted hwrng */
> +static struct hwrng *get_current_rng(void)
> +{
> +	struct hwrng *rng;
> +
> +	if (mutex_lock_interruptible(&rng_mutex))
> +		return ERR_PTR(-ERESTARTSYS);
> +
> +	rng = current_rng;
> +	if (rng)
> +		kref_get(&rng->ref);
> +
> +	mutex_unlock(&rng_mutex);
> +	return rng;
> +}
> +
> +static void put_rng(struct hwrng *rng)
> +{
> +	/*
> +	 * Hold rng_mutex here so we serialize in case they set_current_rng
> +	 * on rng again immediately.
> +	 */
> +	mutex_lock(&rng_mutex);
> +	if (rng)
> +		kref_put(&rng->ref, cleanup_rng);
> +	mutex_unlock(&rng_mutex);
> +}
> +
>  static inline int hwrng_init(struct hwrng *rng)
>  {
>  	if (rng->init) {
> @@ -113,12 +167,6 @@ static inline int hwrng_init(struct hwrng *rng)
>  	return 0;
>  }
>  
> -static inline void hwrng_cleanup(struct hwrng *rng)
> -{
> -	if (rng && rng->cleanup)
> -		rng->cleanup(rng);
> -}
> -
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
> @@ -208,17 +256,19 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>  
>  		if (signal_pending(current)) {
>  			err = -ERESTARTSYS;
> +			put_rng(rng);
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
> @@ -257,8 +307,8 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
>  			err = hwrng_init(rng);
>  			if (err)
>  				break;
> -			hwrng_cleanup(current_rng);
> -			current_rng = rng;
> +			drop_current_rng();
> +			set_current_rng(rng);

We got a warning in boot stage when above set_current_rng() is executed,
it can be fixed by init rng->ref in hwrng_init().


@@ -166,6 +169,8 @@ static inline int hwrng_init(struct hwrng *rng)
        if (current_quality > 0 && !hwrng_fill)
                start_khwrngd();
 
+       kref_init(&rng->ref);
+
        return 0;
 }


[    2.754303] ------------[ cut here ]------------
[    2.756018] WARNING: at include/linux/kref.h:47 kref_get.part.2+0x1e/0x27()
[    2.758150] Modules linked in: virtio_rng(+) parport_pc(+) parport mperf xfs libcrc32c sd_mod sr_mod cdrom crc_t10dif crct10dif_common ata_generic pata_acpi virtio_net cirrus syscopyarea sysfillrect sysimgblt drm_kms_helper ttm ata_piix drm libata virtio_pci virtio_ring virtio i2c_core floppy dm_mirror dm_region_hash dm_log dm_mod
[    2.765686] CPU: 0 PID: 470 Comm: systemd-udevd Not tainted 3.10.0-161.el7.rusty.x86_64 #1
[    2.767806] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[    2.770449]  0000000000000000 0000000075730141 ffff88007bb13b68 ffffffff815f0673
[    2.772570]  ffff88007bb13ba0 ffffffff8106bc41 ffffffff819a0e50 ffff880036cd1000
[    2.774970]  ffff8800370a2cc0 0000000000000000 ffffffffa025c0e0 ffff88007bb13bb0
[    2.777267] Call Trace:
[    2.778843]  [<ffffffff815f0673>] dump_stack+0x19/0x1b
[    2.780824]  [<ffffffff8106bc41>] warn_slowpath_common+0x61/0x80
[    2.782726]  [<ffffffff8106bd6a>] warn_slowpath_null+0x1a/0x20
[    2.784566]  [<ffffffff815f106f>] kref_get.part.2+0x1e/0x27
[    2.786382]  [<ffffffff813b2d1a>] set_current_rng+0x3a/0x50
[    2.788184]  [<ffffffff813b32f8>] hwrng_register+0x148/0x290
[    2.790175]  [<ffffffffa005f7c0>] ? vp_reset+0x90/0x90 [virtio_pci]
[    2.792456]  [<ffffffffa025a149>] virtrng_scan+0x19/0x30 [virtio_rng]
[    2.794424]  [<ffffffffa0022208>] virtio_dev_probe+0x118/0x150 [virtio]
[    2.796391]  [<ffffffff813cac57>] driver_probe_device+0x87/0x390
[    2.798579]  [<ffffffff813cb033>] __driver_attach+0x93/0xa0
[    2.800576]  [<ffffffff813cafa0>] ? __device_attach+0x40/0x40
[    2.802500]  [<ffffffff813c89e3>] bus_for_each_dev+0x73/0xc0
[    2.804387]  [<ffffffff813ca6ae>] driver_attach+0x1e/0x20
[    2.806284]  [<ffffffff813ca200>] bus_add_driver+0x200/0x2d0
[    2.808511]  [<ffffffffa0034000>] ? 0xffffffffa0033fff
[    2.810313]  [<ffffffff813cb6b4>] driver_register+0x64/0xf0
[    2.812265]  [<ffffffffa0022540>] register_virtio_driver+0x20/0x30 [virtio]
[    2.814246]  [<ffffffffa0034010>] virtio_rng_driver_init+0x10/0x1000 [virtio_rng]
[    2.816253]  [<ffffffff810020b8>] do_one_initcall+0xb8/0x230
[    2.818053]  [<ffffffff810da4fa>] load_module+0x131a/0x1b20
[    2.819835]  [<ffffffff812ede80>] ? ddebug_proc_write+0xf0/0xf0
[    2.821635]  [<ffffffff810d6a93>] ? copy_module_from_fd.isra.43+0x53/0x150
[    2.823723]  [<ffffffff810daeb6>] SyS_finit_module+0xa6/0xd0
[    2.825892]  [<ffffffff81600669>] system_call_fastpath+0x16/0x1b
[    2.827768] ---[ end trace bf8396ed0ec968f2 ]---


>  			err = 0;
>  			break;
>  		}
> @@ -272,17 +322,15 @@ static ssize_t hwrng_attr_current_show(struct device *dev,
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
> @@ -357,12 +405,16 @@ static int hwrng_fillfn(void *unused)
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
>  		if (rc <= 0) {
>  			pr_warn("hwrng: no data available\n");
>  			msleep_interruptible(10000);
> @@ -423,14 +475,13 @@ int hwrng_register(struct hwrng *rng)
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
> @@ -457,22 +508,21 @@ EXPORT_SYMBOL_GPL(hwrng_register);
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
>  		mutex_unlock(&rng_mutex);
>  		unregister_miscdev();
> diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
> index 914bb08..c212e71 100644
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
> 1.9.3
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

-- 
			Amos.
