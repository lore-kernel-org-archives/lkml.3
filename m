Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaBRVwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:52:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBRVwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:52:19 -0500
Date: Tue, 18 Feb 2014 13:53:44 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT v2 1/8] drivers: base: support cpu cache
 information interface to userspace via sysfs
Message-ID: <20140218215344.GC20495@kroah.com>
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com>
 <1391791763-28518-2-git-send-email-sudeep.holla@arm.com>
 <20140207192925.GB18771@kroah.com>
 <52F915F6.9000501@arm.com>
 <20140211001310.GB3692@kroah.com>
 <52FCEB03.6040608@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FCEB03.6040608@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 03:55:47PM +0000, Sudeep Holla wrote:
> Hi Greg,
> 
> On 11/02/14 00:13, Greg Kroah-Hartman wrote:
> > On Mon, Feb 10, 2014 at 06:09:58PM +0000, Sudeep Holla wrote:
> >> On 07/02/14 19:29, Greg Kroah-Hartman wrote:
> >>> On Fri, Feb 07, 2014 at 04:49:16PM +0000, Sudeep Holla wrote:
> >>>> From: Sudeep Holla <sudeep.holla@arm.com>
> >>>>
> >>>> This patch adds initial support for providing processor cache information
> >>>> to userspace through sysfs interface. This is based on already existing
> >>>> implementations(x86, ia64, s390 and powerpc) and hence the interface is
> >>>> intended to be fully compatible.
> >>>>
> >>>> The main purpose of this generic support is to avoid further code
> >>>> duplication to support new architectures and also to unify all the existing
> >>>> different implementations.
> >>>>
> >>>> This implementation maintains the hierarchy of cache objects which reflects
> >>>> the system's cache topology. Cache objects are instantiated as needed as
> >>>> CPUs come online. The cache objects are replicated per-cpu even if they are
> >>>> shared. A per-cpu array of cache information maintained is used mainly for
> >>>> sysfs-related book keeping.
> >>>
> >>> I thought I asked that you not use "raw" kobjects for this, instead
> >>> using 'struct device' or just an attribute group?
> >>>
> >>
> >> Correct, sorry I should have mentioned here instead of cover letter that it's
> >> not yet done. Since the changes involved other architectures, I posted v2 to get
> >> early feedback and testing. More over it's one place to fix now instead of 4
> >> unlike before.
> > 
> > Ok, I'll wait to review it after you do the device conversion.
> > 
> >> Just adding cache as a device as you suggested won't suffice here. As we need to
> >> track multiple cache indices for each cpu, devices are needed for each cache
> >> index. I tried using device_create_with_groups which provides all we need in one
> >> api for cache indices but since cpu devices are not associated with any class,
> >> it fails if class is NULL. Any suggestions ?
> > 
> > Make the cpu devices be part of a class?
> 
> I was able to convert these to use struct device instead of raw kobjects. But it
> requires some changes in order to retain the existing sysfs path mainly due to
> the fact that cpus are using legacy subsys_system_register and introducing
> cpu_class conflicts with cpu bus. The base changes in the driver core is as
> below. Is this acceptable ? or any other alternate suggestions ?
> 
> --->8
>  drivers/base/bus.c  | 2 ++
>  drivers/base/core.c | 8 ++++++++
>  drivers/base/cpu.c  | 7 +++++++
>  include/linux/cpu.h | 2 ++
>  4 files changed, 19 insertions(+)
> 
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 59dc808..c33bfdb 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -518,10 +518,12 @@ int bus_add_device(struct device *dev)
>  						&dev->kobj, dev_name(dev));
>  		if (error)
>  			goto out_id;
> +		if (!dev->class) {
>  			error = sysfs_create_link(&dev->kobj,
>  				&dev->bus->p->subsys.kobj, "subsystem");
>  			if (error)
>  				goto out_subsys;
> +		}
>  		klist_add_tail(&dev->p->knode_bus, &bus->p->klist_devices);
>  	}
>  	return 0;

This change worries me, does it cause anything else to happen in sysfs
that looks differently from what it does today?

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 2b56717..ef81984 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -10,6 +10,7 @@
>   *
>   */
> 
> +#include <linux/cpu.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
> @@ -759,6 +760,8 @@ static struct kobject *get_device_parent(struct device *dev,
>  			return &block_class.p->subsys.kobj;
>  		}
>  #endif
> +		if (dev->class == cpu_class)
> +			return &parent->kobj;

I don't think this is ok :)

Oh wait, we do this for disk classes today, ick, ok, nevermind, but
comment it really well please.

>  		/*
>  		 * If we have no parent, we live in "virtual".
> @@ -843,6 +846,8 @@ static int device_add_class_symlinks(struct device *dev)
>  	if (sysfs_deprecated && dev->class == &block_class)
>  		return 0;
>  #endif
> +	if (dev->class == cpu_class)
> +		return 0;

Same here.

>  	/* link in the class directory pointing to the device */
>  	error = sysfs_create_link(&dev->class->p->subsys.kobj,
> @@ -873,6 +878,9 @@ static void device_remove_class_symlinks(struct device *dev)
>  	if (sysfs_deprecated && dev->class == &block_class)
>  		return;
>  #endif
> +	if (dev->class == cpu_class)
> +		return;

And here.

thanks,

greg k-h
