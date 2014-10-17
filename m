Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaJQHzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:55:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaJQHzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:55:21 -0400
From: Thomas Renninger <trenn@suse.de>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [patch 2/3] ipmi: Remove ipmi_major module parameter and define global IPMI_MAJOR
Date: Fri, 17 Oct 2014 09:55:19 +0200
Message-ID: <2671173.hSj4Ui9Upr@d46>
User-Agent: KMail/4.11.5 (Linux/3.11.10-11-desktop; KDE/4.11.5; x86_64; ; )
In-Reply-To: <543DCD42.8030501@acm.org>
References: <20141014144020.683892494@d46.suse.de> <20141014144315.519093022@d46.suse.de> <543DCD42.8030501@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, October 14, 2014 08:26:26 PM Corey Minyard wrote:
> Sorry to top post on this, but you attached the file, so it's hard to reply
> inline.
> 
> There's no way this can go in.  There's not enough major device numbers
> for all the devices that exist, we have mechanisms to handle dynamically
> assigning numbers, and the IPMI driver just isn't important enough to
> warrant it's own major device number.
Hm, I always get 248, on 2 different machines. Just luck?
If 248 is still free (and according to major.h it is), why not?

> The particular mechanism to pass in the major number was just a temporary
> measure.  It is no longer really necessary and could be removed.
Ok, if I read above right, you mean:
The module param to specify the major number can vanish.
But I must not try to invent a new MAJOR_IPMI definition in major.h.
Instead the whole thing can be dynamic (use MKDEV, remember the return
value and use it later to freeing again).

Thanks,

     Thomas

 
> -corey
> 
> On 10/14/2014 09:40 AM, trenn@suse.de wrote:
> 
> There should be no need to specify the major number of /dev/ipmiX via module
> parameter. Others do not need this as well.
> This is the way msr.c (/dev/cpu/X/msr) is doing it as well.
> 
> Side effect of this patch will be that the userspace interface cannot
> be disabled at kernel level anymore. But this can also be enforced by not
> letting userspace create the device file /dev/ipmiX.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: minyard@acm.org
> 
> Index: kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
> ===================================================================
> --- kernel_ipmi.orig/drivers/char/ipmi/ipmi_devintf.c
> +++ kernel_ipmi/drivers/char/ipmi/ipmi_devintf.c
> @@ -39,6 +39,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/ipmi.h>
> +#include <linux/major.h>
>  #include <linux/mutex.h>
>  #include <linux/init.h>
>  #include <linux/device.h>
> @@ -867,14 +868,6 @@ static const struct file_operations ipmi
> 
>  #define DEVICE_NAME     "ipmidev"
> 
> -static int ipmi_major;
> -module_param(ipmi_major, int, 0);
> -MODULE_PARM_DESC(ipmi_major, "Sets the major number of the IPMI device. 
> By" -		 " default, or if you set it to zero, it will choose the next"
> -		 " available device.  Setting it to -1 will disable the"
> -		 " interface.  Other values will set the major device number"
> -		 " to that value.");
> -
>  /* Keep track of the devices that are registered. */
>  struct ipmi_reg_list {
>  	dev_t            dev;
> @@ -887,7 +880,7 @@ static struct class *ipmi_class;
> 
>  static void ipmi_new_smi(int if_num, struct device *device)
>  {
> -	dev_t dev = MKDEV(ipmi_major, if_num);
> +	dev_t dev = MKDEV(IPMI_MAJOR, if_num);
>  	struct ipmi_reg_list *entry;
> 
>  	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
> @@ -906,7 +899,7 @@ static void ipmi_new_smi(int if_num, str
> 
>  static void ipmi_smi_gone(int if_num)
>  {
> -	dev_t dev = MKDEV(ipmi_major, if_num);
> +	dev_t dev = MKDEV(IPMI_MAJOR, if_num);
>  	struct ipmi_reg_list *entry;
> 
>  	mutex_lock(&reg_list_mutex);
> @@ -932,9 +925,6 @@ int __init init_ipmi_devintf(void)
>  {
>  	int rv;
> 
> -	if (ipmi_major < 0)
> -		return -EINVAL;
> -
>  	printk(KERN_INFO "ipmi device interface\n");
> 
>  	ipmi_class = class_create(THIS_MODULE, "ipmi");
> @@ -943,20 +933,16 @@ int __init init_ipmi_devintf(void)
>  		return PTR_ERR(ipmi_class);
>  	}
> 
> -	rv = register_chrdev(ipmi_major, DEVICE_NAME, &ipmi_fops);
> +	rv = register_chrdev(IPMI_MAJOR, DEVICE_NAME, &ipmi_fops);
>  	if (rv < 0) {
>  		class_destroy(ipmi_class);
> -		printk(KERN_ERR "ipmi: can't get major %d\n", ipmi_major);
> +		printk(KERN_ERR "ipmi: can't get major %d\n", IPMI_MAJOR);
>  		return rv;
>  	}
> 
> -	if (ipmi_major == 0) {
> -		ipmi_major = rv;
> -	}
> -
>  	rv = ipmi_smi_watcher_register(&smi_watcher);
>  	if (rv) {
> -		unregister_chrdev(ipmi_major, DEVICE_NAME);
> +		unregister_chrdev(IPMI_MAJOR, DEVICE_NAME);
>  		class_destroy(ipmi_class);
>  		printk(KERN_WARNING "ipmi: can't register smi watcher\n");
>  		return rv;
> @@ -977,5 +963,5 @@ void cleanup_ipmi_dev(void)
>  	mutex_unlock(&reg_list_mutex);
>  	class_destroy(ipmi_class);
>  	ipmi_smi_watcher_unregister(&smi_watcher);
> -	unregister_chrdev(ipmi_major, DEVICE_NAME);
> +	unregister_chrdev(IPMI_MAJOR, DEVICE_NAME);
>  }
> Index: kernel_ipmi/include/uapi/linux/major.h
> ===================================================================
> --- kernel_ipmi.orig/include/uapi/linux/major.h
> +++ kernel_ipmi/include/uapi/linux/major.h
> @@ -173,6 +173,8 @@
> 
>  #define VIOTAPE_MAJOR		230
> 
> +#define IPMI_MAJOR              248
> +
>  #define BLOCK_EXT_MAJOR		259
>  #define SCSI_OSD_MAJOR		260	/* open-osd's OSD scsi device 
*/

