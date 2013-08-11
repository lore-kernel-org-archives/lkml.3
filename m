Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab3HKUbt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 16:31:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:38018 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab3HKUbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 16:31:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH] ACPI, cpu hotplug: move try_offline_node() after acpi_unmap_lsapic()
Date: Sun, 11 Aug 2013 22:42 +0200
Message-ID: <33585791.CVfk6FmZRF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1376100679.10300.333.camel@misato.fc.hp.com>
References: <5200CBBF.1090904@jp.fujitsu.com> <7919266.6MVd1N6sIX@vostro.rjw.lan> <1376100679.10300.333.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 09, 2013 08:11:19 PM Toshi Kani wrote:
> On Sat, 2013-08-10 at 01:29 +0200, Rafael J. Wysocki wrote:
> > On Friday, August 09, 2013 04:16:56 PM Toshi Kani wrote:
> > > On Fri, 2013-08-09 at 15:28 +0800, Tang Chen wrote:
> > > > On 08/07/2013 12:56 AM, Toshi Kani wrote:
> > > > > On Tue, 2013-08-06 at 19:11 +0900, Yasuaki Ishimatsu wrote:
> > > > >> try_offline_node() checks that all cpus related with removed node have been
> > > > >> removed by using cpu_present_bits. If all cpus related with removed node have
> > > > >> been removed, try_offline_node() clears the node information.
> > > > >>
> > > > >> But try_offline_node() called from acpi_processor_remove() never clears
> > > > >> the node information. For disabling cpu_present_bits, acpi_unmap_lsapic()
> > > > >> need be called. But acpi_unmap_lsapic() is called after try_offline_node()
> > > > >> runs. So when try_offline_node() runs, the cpu's cpu_present_bits is always
> > > > >> set.
> > > > >>
> > > > >> This patch moves try_offline_node() after acpi_unmap_lsapic().
> > > > >>
> > > > >> Signed-off-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> > > > >
> > > > > The change looks good to me.
> > > > >
> > > > > Acked-by: Toshi Kani<toshi.kani@hp.com>
> > > > >
> > > > > BTW, do you know why try_offline_node() has to use stop_machine()?
> > > > 
> > > > try_offline_node() is used to check if the node could be hot-removed
> > > > after each memory or cpu hot-remove operation.
> > > > 
> > > > In memory hot-remove path, we have lock_memory_hotplug() to series all
> > > > the memory hot-remove options.
> > > > 
> > > > But when doing cpu hot-remove,
> > > > 
> > > > acpi_processor_remove()
> > > >   |->try_offline_node()
> > > > 
> > > > There is no lock to protect it. I think, when we are going to hot-remove
> > > > a node, others should not do any memory or cpu hotplug operation. In memory
> > > > hotplug path, we have lock_memory_hotplug(). But in cpu hotplug path, I
> > > > didn't find any lock. So we used stop_machine() to call check_cpu_on_node().
> > > > If we find any cpu still present, we return and do not remove the node.
> > > 
> > > CPU/Memory hotplug operations and sysfs eject are serialized with
> > > acpi_os_hotplug_execute().  CPU online/offline is protected by
> > > cpu_hotplug_[begin|done]() and [get|put]_online_cpus().  But, yes,
> > > online/offline and hotplug operations are not serialized.  I tried to
> > > serialize them before, but that framework was not well received.
> > 
> > What about lock_device_hotplug()?  It is taken by both online/offline and
> > the ACPI hotplug code, isn't it?
> 
> Oh, that's right!  I forgot about this one.  Yes, lock_device_hotplug()
> nicely protects online/offline and hotplug operations. :-)
> 
> > > Anyway, it looks to me that cpu_up()->mem_online_node() path can race
> > > with try_offline_node().
> > 
> > It can in principle, but I'm not sure if there's a way to trigger that
> > race.  Do you have an example?
> 
> With lock_device_hotplug(), I agree that we do not have this race
> condition -- cpu_up() may not run while other hotplug is running.
> store_online() will be blocked at lock_device_hotplug() in such case.
> When store_online() acquired the lock, this CPU may have been deleted.
> So, we still need to make sure that this case is handled properly.

Yes.

> I suppose sysfs keeps *dev valid with ref_count (Is that right?).

Yes, it does.

> I think cpu_up() needs to check with cpu_present(), not cpu_possible(), at
> the top.  Otherwise, cpu_to_node(cpu) may return NUMA_NO_NODE (-1), which is
> probably not a good value for node_online(nid).

We do cpu_to_node(cpuid) in cpu_subsys_online() before that, so maybe
it's better to check the result already there and bail out if that's
negative?

Something like the patch below.

Thanks,
Rafael


---
 drivers/base/cpu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/base/cpu.c
===================================================================
--- linux-pm.orig/drivers/base/cpu.c
+++ linux-pm/drivers/base/cpu.c
@@ -43,11 +43,14 @@ static int __ref cpu_subsys_online(struc
 	struct cpu *cpu = container_of(dev, struct cpu, dev);
 	int cpuid = dev->id;
 	int from_nid, to_nid;
-	int ret;
+	int ret = -ENODEV;
 
 	cpu_hotplug_driver_lock();
 
 	from_nid = cpu_to_node(cpuid);
+	if (from_nid == NUMA_NO_NODE)
+		goto out;
+
 	ret = cpu_up(cpuid);
 	/*
 	 * When hot adding memory to memoryless node and enabling a cpu
@@ -57,6 +60,7 @@ static int __ref cpu_subsys_online(struc
 	if (from_nid != to_nid)
 		change_cpu_under_node(cpu, from_nid, to_nid);
 
+ out:
 	cpu_hotplug_driver_unlock();
 	return ret;
 }

