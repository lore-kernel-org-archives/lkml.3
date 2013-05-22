Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3EVLR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:17:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:45295 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab3EVLRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:17:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the pm tree
Date: Wed, 22 May 2013 13:26:37 +0200
Message-ID: <3737298.Dstqiqm06u@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130522140213.eb65bcc559088b199db1857f@canb.auug.org.au>
References: <20130522134741.51b06d38cb4939003c8e37a0@canb.auug.org.au> <20130522140213.eb65bcc559088b199db1857f@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 22, 2013 02:02:13 PM Stephen Rothwell wrote:
> Hi all,

Hi Stephen,

Thanks for fixing this up!

Hi Greg,

What about merging my acpi-hotplug branch into the driver-core tree?

That would make the Linus' life easier going forward I suppose.

Thanks,
Rafael


> On Wed, 22 May 2013 13:47:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the driver-core tree got a conflict in
> > drivers/base/cpu.c between commit 0902a9044fa5 ("Driver core: Use generic
> > offline/online for CPU offline/online") from the pm tree and commit
> > 1c4e2d70afb1 ("cpu: make sure that cpu/online file created before
> > KOBJ_ADD is emitted") from the driver-core tree.
> > 
> > I fixed it up (they do some bits in common - see below) and can carry the
> > fix as necessary (no action is required).
> > 
> > diff --cc drivers/base/cpu.c
> > index 7431ba6,c377673..0000000
> > --- a/drivers/base/cpu.c
> > +++ b/drivers/base/cpu.c
> > @@@ -38,39 -34,66 +38,48 @@@ static void change_cpu_under_node(struc
> >   	cpu->node_id = to_nid;
> >   }
> >   
> >  -static ssize_t show_online(struct device *dev,
> >  -			   struct device_attribute *attr,
> >  -			   char *buf)
> >  +static int __ref cpu_subsys_online(struct device *dev)
> >   {
> >   	struct cpu *cpu = container_of(dev, struct cpu, dev);
> >  +	int cpuid = dev->id;
> >  +	int from_nid, to_nid;
> >  +	int ret;
> >  +
> >  +	cpu_hotplug_driver_lock();
> >  +
> >  +	from_nid = cpu_to_node(cpuid);
> >  +	ret = cpu_up(cpuid);
> >  +	/*
> >  +	 * When hot adding memory to memoryless node and enabling a cpu
> >  +	 * on the node, node number of the cpu may internally change.
> >  +	 */
> >  +	to_nid = cpu_to_node(cpuid);
> >  +	if (from_nid != to_nid)
> >  +		change_cpu_under_node(cpu, from_nid, to_nid);
> >   
> >  -	return sprintf(buf, "%u\n", !!cpu_online(cpu->dev.id));
> >  +	cpu_hotplug_driver_unlock();
> >  +	return ret;
> >   }
> >   
> >  -static ssize_t __ref store_online(struct device *dev,
> >  -				  struct device_attribute *attr,
> >  -				  const char *buf, size_t count)
> >  +static int cpu_subsys_offline(struct device *dev)
> >   {
> >  -	struct cpu *cpu = container_of(dev, struct cpu, dev);
> >  -	int cpuid = cpu->dev.id;
> >  -	int from_nid, to_nid;
> >  -	ssize_t ret;
> >  +	int ret;
> >   
> >   	cpu_hotplug_driver_lock();
> >  -	switch (buf[0]) {
> >  -	case '0':
> >  -		ret = cpu_down(cpuid);
> >  -		if (!ret)
> >  -			kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> >  -		break;
> >  -	case '1':
> >  -		from_nid = cpu_to_node(cpuid);
> >  -		ret = cpu_up(cpuid);
> >  -
> >  -		/*
> >  -		 * When hot adding memory to memoryless node and enabling a cpu
> >  -		 * on the node, node number of the cpu may internally change.
> >  -		 */
> >  -		to_nid = cpu_to_node(cpuid);
> >  -		if (from_nid != to_nid)
> >  -			change_cpu_under_node(cpu, from_nid, to_nid);
> >  -
> >  -		if (!ret)
> >  -			kobject_uevent(&dev->kobj, KOBJ_ONLINE);
> >  -		break;
> >  -	default:
> >  -		ret = -EINVAL;
> >  -	}
> >  +	ret = cpu_down(dev->id);
> >   	cpu_hotplug_driver_unlock();
> >  -
> >  -	if (ret >= 0)
> >  -		ret = count;
> >   	return ret;
> >   }
> >  -static DEVICE_ATTR(online, 0644, show_online, store_online);
> >   
> > + static struct attribute *hotplug_cpu_attrs[] = {
> > + 	&dev_attr_online.attr,
> > + 	NULL
> > + };
> > + 
> > + static struct attribute_group hotplug_cpu_attr_group = {
> > + 	.attrs = hotplug_cpu_attrs,
> > + };
> > + 
> >   void unregister_cpu(struct cpu *cpu)
> >   {
> >   	int logical_cpu = cpu->dev.id;
> > @@@ -102,20 -125,8 +111,19 @@@ static ssize_t cpu_release_store(struc
> >   static DEVICE_ATTR(probe, S_IWUSR, NULL, cpu_probe_store);
> >   static DEVICE_ATTR(release, S_IWUSR, NULL, cpu_release_store);
> >   #endif /* CONFIG_ARCH_CPU_PROBE_RELEASE */
> > - 
> >   #endif /* CONFIG_HOTPLUG_CPU */
> >   
> >  +struct bus_type cpu_subsys = {
> >  +	.name = "cpu",
> >  +	.dev_name = "cpu",
> >  +	.match = cpu_subsys_match,
> >  +#ifdef CONFIG_HOTPLUG_CPU
> >  +	.online = cpu_subsys_online,
> >  +	.offline = cpu_subsys_offline,
> >  +#endif
> >  +};
> >  +EXPORT_SYMBOL_GPL(cpu_subsys);
> >  +
> >   #ifdef CONFIG_KEXEC
> >   #include <linux/kexec.h>
> 
> OK, after doing that I got this error:
> 
> drivers/base/cpu.c:75:3: error: 'dev_attr_online' undeclared here (not in a function)
>   &dev_attr_online.attr,
>    ^
> 
> So I applied this merge fix patch:
> 
> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> index 811bb5a..ff97614 100644
> --- a/drivers/base/cpu.c
> +++ b/drivers/base/cpu.c
> @@ -71,15 +71,6 @@ static int cpu_subsys_offline(struct device *dev)
>  	return ret;
>  }
>  
> -static struct attribute *hotplug_cpu_attrs[] = {
> -	&dev_attr_online.attr,
> -	NULL
> -};
> -
> -static struct attribute_group hotplug_cpu_attr_group = {
> -	.attrs = hotplug_cpu_attrs,
> -};
> -
>  void unregister_cpu(struct cpu *cpu)
>  {
>  	int logical_cpu = cpu->dev.id;
> @@ -182,9 +173,6 @@ static const struct attribute_group *hotplugable_cpu_attr_groups[] = {
>  #ifdef CONFIG_KEXEC
>  	&crash_note_cpu_attr_group,
>  #endif
> -#ifdef CONFIG_HOTPLUG_CPU
> -	&hotplug_cpu_attr_group,
> -#endif
>  	NULL
>  };
>  
> Better ideas welcome :-)
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
