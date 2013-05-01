Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab3EAUUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 16:20:40 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:29747 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3EAUUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 16:20:37 -0400
Message-ID: <1367438865.16154.160.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/3 RFC] Driver core: Use generic offline/online for CPU
 offline/online
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Date: Wed, 01 May 2013 14:07:45 -0600
In-Reply-To: <4894519.gepD7lHY3G@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
	 <5608485.T3GFgtNYov@vostro.rjw.lan>
	 <1367365326.16154.139.camel@misato.fc.hp.com>
	 <4894519.gepD7lHY3G@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 16:49 +0200, Rafael J. Wysocki wrote:
> On Tuesday, April 30, 2013 05:42:06 PM Toshi Kani wrote:
> > On Mon, 2013-04-29 at 14:28 +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > 
> > > Rework the CPU hotplug code in drivers/base/cpu.c to use the
> > > generic offline/online support introduced previously instead of
> > > its own CPU-specific code.
> > > 
> > > For this purpose, modify cpu_subsys to provide offline and online
> > > callbacks for CONFIG_HOTPLUG_CPU set and remove the code handling
> > > the CPU-specific 'online' sysfs attribute.
> > > 
> > > This modification is not supposed to change the user-observable
> > > behavior of the kernel (i.e. the 'online' attribute will be present
> > > in exactly the same place in sysfs and should trigger exactly the
> > > same actions as before).
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > > ---
> > >  drivers/base/cpu.c |   62 ++++++++++++-----------------------------------------
> > >  1 file changed, 15 insertions(+), 47 deletions(-)
> > > 
> > > Index: linux-pm/drivers/base/cpu.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/base/cpu.c
> > > +++ linux-pm/drivers/base/cpu.c
> > > @@ -16,66 +16,25 @@
> > >  
> > >  #include "base.h"
> > >  
> > > -struct bus_type cpu_subsys = {
> > > -	.name = "cpu",
> > > -	.dev_name = "cpu",
> > > -};
> > > -EXPORT_SYMBOL_GPL(cpu_subsys);
> > > -
> > >  static DEFINE_PER_CPU(struct device *, cpu_sys_devices);
> > >  
> > >  #ifdef CONFIG_HOTPLUG_CPU
> > > -static ssize_t show_online(struct device *dev,
> > > -			   struct device_attribute *attr,
> > > -			   char *buf)
> > > +static int cpu_subsys_online(struct device *dev)
> > >  {
> > > -	struct cpu *cpu = container_of(dev, struct cpu, dev);
> > > -
> > > -	return sprintf(buf, "%u\n", !!cpu_online(cpu->dev.id));
> > > +	return cpu_up(dev->id);
> > >  }
> > >  
> > > -static ssize_t __ref store_online(struct device *dev,
> > > -				  struct device_attribute *attr,
> > > -				  const char *buf, size_t count)
> > > +static int cpu_subsys_offline(struct device *dev)
> > >  {
> > > -	struct cpu *cpu = container_of(dev, struct cpu, dev);
> > > -	ssize_t ret;
> > > -
> > > -	cpu_hotplug_driver_lock();
> > 
> > By replacing cpu_hotplug_driver_lock() with lock_device_offline() in
> > patch 1/3, it no longer protects from other places that still use
> > cpu_hotplug_device_lock(), such as save_mc_for_early().
> 
> Yes.
> 
> What about taking cpu_hotplug_driver_lock() around cpu_up() and
> cpu_down() in cpu_subsys_online() and cpu_subsys_offline()?

Sounds like a reasonable approach to me. 

> Alternatively, I can just replace cpu_hotplug_driver_lock() with
> lock_device_offline() everywhere.

That works too.  Not sure which way is better.  If we go this option,
I'd suggest to rename lock_device_offline() since it could be misleading
that the lock is only used for offline, i.e. excluding online.
lock_device_hotplug() might be less confusing although we distinguish
online/offline and hotplug operations.

Thanks,
-Toshi

