Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3HZOv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 10:51:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35034 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab3HZOv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 10:51:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] driver core / ACPI: Avoid device removal locking problems
Date: Mon, 26 Aug 2013 17:02:08 +0200
Message-ID: <1430120.G7JdUKlgj6@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <3389643.Fdir3g6c6B@vostro.rjw.lan>
References: <1543475.L7gSB7lLAu@vostro.rjw.lan> <4785337.sqQqDSPcpL@vostro.rjw.lan> <3389643.Fdir3g6c6B@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 26, 2013 04:43:26 PM Rafael J. Wysocki wrote:
> On Monday, August 26, 2013 02:42:09 PM Rafael J. Wysocki wrote:
> > On Monday, August 26, 2013 11:13:13 AM Gu Zheng wrote:
> > > Hi Rafael,

[...]

> 
> OK, so the patch below is quick and dirty and overkill, but it should make the
> splat go away at least.

And if this patch does make the splat go away for you, please also test the
appended one (Tejun, thanks for the hint!).

I'll address the ACPI part differently later.

> ---
>  drivers/acpi/scan.c |    3 ++-
>  drivers/base/core.c |   36 ++++++++++++++++++++----------------
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 
> Index: linux-pm/drivers/base/core.c
> ===================================================================
> --- linux-pm.orig/drivers/base/core.c
> +++ linux-pm/drivers/base/core.c
> @@ -49,6 +49,18 @@ static struct kobject *dev_kobj;
>  struct kobject *sysfs_dev_char_kobj;
>  struct kobject *sysfs_dev_block_kobj;
>  
> +static DEFINE_MUTEX(device_hotplug_lock);
> +
> +void lock_device_hotplug(void)
> +{
> +	mutex_lock(&device_hotplug_lock);
> +}
> +
> +void unlock_device_hotplug(void)
> +{
> +	mutex_unlock(&device_hotplug_lock);
> +}
> +
>  #ifdef CONFIG_BLOCK
>  static inline int device_is_not_partition(struct device *dev)
>  {
> @@ -408,9 +420,11 @@ static ssize_t show_online(struct device
>  {
>  	bool val;
>  
> -	lock_device_hotplug();
> +	if (!mutex_trylock(&device_hotplug_lock))
> +		return -EAGAIN;
> +
>  	val = !dev->offline;
> -	unlock_device_hotplug();
> +	mutex_unlock(&device_hotplug_lock);
>  	return sprintf(buf, "%u\n", val);
>  }
>  
> @@ -424,9 +438,11 @@ static ssize_t store_online(struct devic
>  	if (ret < 0)
>  		return ret;
>  
> -	lock_device_hotplug();
> +	if (!mutex_trylock(&device_hotplug_lock))
> +		return -EAGAIN;
> +
>  	ret = val ? device_online(dev) : device_offline(dev);
> -	unlock_device_hotplug();
> +	mutex_unlock(&device_hotplug_lock);
>  	return ret < 0 ? ret : count;
>  }
>  
> @@ -1479,18 +1495,6 @@ EXPORT_SYMBOL_GPL(put_device);
>  EXPORT_SYMBOL_GPL(device_create_file);
>  EXPORT_SYMBOL_GPL(device_remove_file);
>  
> -static DEFINE_MUTEX(device_hotplug_lock);
> -
> -void lock_device_hotplug(void)
> -{
> -	mutex_lock(&device_hotplug_lock);
> -}
> -
> -void unlock_device_hotplug(void)
> -{
> -	mutex_unlock(&device_hotplug_lock);
> -}
> -
>  static int device_check_offline(struct device *dev, void *not_used)
>  {
>  	int ret;
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -510,7 +510,8 @@ acpi_eject_store(struct device *d, struc
>  	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
>  		return -ENODEV;
>  
> -	mutex_lock(&acpi_scan_lock);
> +	if (!mutex_trylock(&acpi_scan_lock))
> +		return -EAGAIN;
>  
>  	if (acpi_device->flags.eject_pending) {
>  		/* ACPI eject notification event. */

Thanks,
Rafael


---
 drivers/base/core.c |   45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

Index: linux-pm/drivers/base/core.c
===================================================================
--- linux-pm.orig/drivers/base/core.c
+++ linux-pm/drivers/base/core.c
@@ -49,6 +49,28 @@ static struct kobject *dev_kobj;
 struct kobject *sysfs_dev_char_kobj;
 struct kobject *sysfs_dev_block_kobj;
 
+static DEFINE_MUTEX(device_hotplug_lock);
+
+void lock_device_hotplug(void)
+{
+	mutex_lock(&device_hotplug_lock);
+}
+
+void unlock_device_hotplug(void)
+{
+	mutex_unlock(&device_hotplug_lock);
+}
+
+static int try_to_lock_device_hotplug(void)
+{
+	if (!mutex_trylock(&device_hotplug_lock)) {
+		/* Avoid busy waiting, 10 ms of sleep should do. */
+		msleep(10);
+		return restart_syscall();
+	}
+	return 0;
+}
+
 #ifdef CONFIG_BLOCK
 static inline int device_is_not_partition(struct device *dev)
 {
@@ -407,8 +429,12 @@ static ssize_t show_online(struct device
 			   char *buf)
 {
 	bool val;
+	int ret;
+
+	ret = try_to_lock_device_hotplug();
+	if (ret)
+		return ret;
 
-	lock_device_hotplug();
 	val = !dev->offline;
 	unlock_device_hotplug();
 	return sprintf(buf, "%u\n", val);
@@ -424,7 +450,10 @@ static ssize_t store_online(struct devic
 	if (ret < 0)
 		return ret;
 
-	lock_device_hotplug();
+	ret = try_to_lock_device_hotplug();
+	if (ret)
+		return ret;
+
 	ret = val ? device_online(dev) : device_offline(dev);
 	unlock_device_hotplug();
 	return ret < 0 ? ret : count;
@@ -1479,18 +1508,6 @@ EXPORT_SYMBOL_GPL(put_device);
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
 
-static DEFINE_MUTEX(device_hotplug_lock);
-
-void lock_device_hotplug(void)
-{
-	mutex_lock(&device_hotplug_lock);
-}
-
-void unlock_device_hotplug(void)
-{
-	mutex_unlock(&device_hotplug_lock);
-}
-
 static int device_check_offline(struct device *dev, void *not_used)
 {
 	int ret;

