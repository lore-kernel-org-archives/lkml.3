Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336Ab3EAOlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:41:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53350 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427Ab3EAOlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:41:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH 2/3 RFC] Driver core: Use generic offline/online for CPU offline/online
Date: Wed, 01 May 2013 16:49:36 +0200
Message-ID: <4894519.gepD7lHY3G@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1367365326.16154.139.camel@misato.fc.hp.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <5608485.T3GFgtNYov@vostro.rjw.lan> <1367365326.16154.139.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 05:42:06 PM Toshi Kani wrote:
> On Mon, 2013-04-29 at 14:28 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Rework the CPU hotplug code in drivers/base/cpu.c to use the
> > generic offline/online support introduced previously instead of
> > its own CPU-specific code.
> > 
> > For this purpose, modify cpu_subsys to provide offline and online
> > callbacks for CONFIG_HOTPLUG_CPU set and remove the code handling
> > the CPU-specific 'online' sysfs attribute.
> > 
> > This modification is not supposed to change the user-observable
> > behavior of the kernel (i.e. the 'online' attribute will be present
> > in exactly the same place in sysfs and should trigger exactly the
> > same actions as before).
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/base/cpu.c |   62 ++++++++++++-----------------------------------------
> >  1 file changed, 15 insertions(+), 47 deletions(-)
> > 
> > Index: linux-pm/drivers/base/cpu.c
> > ===================================================================
> > --- linux-pm.orig/drivers/base/cpu.c
> > +++ linux-pm/drivers/base/cpu.c
> > @@ -16,66 +16,25 @@
> >  
> >  #include "base.h"
> >  
> > -struct bus_type cpu_subsys = {
> > -	.name = "cpu",
> > -	.dev_name = "cpu",
> > -};
> > -EXPORT_SYMBOL_GPL(cpu_subsys);
> > -
> >  static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
> >  
> >  #ifdef CONFIG_HOTPLUG_CPU
> > -static ssize_t show_online(struct device *dev,
> > -			   struct device_attribute *attr,
> > -			   char *buf)
> > +static int cpu_subsys_online(struct device *dev)
> >  {
> > -	struct cpu *cpu = container_of(dev, struct cpu, dev);
> > -
> > -	return sprintf(buf, "%u\n", !!cpu_online(cpu->dev.id));
> > +	return cpu_up(dev->id);
> >  }
> >  
> > -static ssize_t __ref store_online(struct device *dev,
> > -				  struct device_attribute *attr,
> > -				  const char *buf, size_t count)
> > +static int cpu_subsys_offline(struct device *dev)
> >  {
> > -	struct cpu *cpu = container_of(dev, struct cpu, dev);
> > -	ssize_t ret;
> > -
> > -	cpu_hotplug_driver_lock();
> 
> By replacing cpu_hotplug_driver_lock() with lock_device_offline() in
> patch 1/3, it no longer protects from other places that still use
> cpu_hotplug_device_lock(), such as save_mc_for_early().

Yes.

What about taking cpu_hotplug_driver_lock() around cpu_up() and
cpu_down() in cpu_subsys_online() and cpu_subsys_offline()?

Alternatively, I can just replace cpu_hotplug_driver_lock() with
lock_device_offline() everywhere.

Thanks,
Rafael


> > -	switch (buf[0]) {
> > -	case '0':
> > -		ret = cpu_down(cpu->dev.id);
> > -		if (!ret)
> > -			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> > -		break;
> > -	case '1':
> > -		ret = cpu_up(cpu->dev.id);
> > -		if (!ret)
> > -			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> > -		break;
> > -	default:
> > -		ret = -EINVAL;
> > -	}
> > -	cpu_hotplug_driver_unlock();
> > -
> > -	if (ret >= 0)
> > -		ret = count;
> > -	return ret;
> > +	return cpu_down(dev->id);
> >  }
> > -static DEVICE_ATTR(online, 0644, show_online, store_online);
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
