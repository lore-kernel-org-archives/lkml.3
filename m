Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031339Ab3HIWSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 18:18:09 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:14351 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031204Ab3HIWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 18:18:08 -0400
Message-ID: <1376086616.10300.302.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI, cpu hotplug: move try_offline_node() after
 acpi_unmap_lsapic()
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        rafael.j.wysocki@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wen Congyang <wency@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 16:16:56 -0600
In-Reply-To: <52049A2E.8080101@cn.fujitsu.com>
References: <5200CBBF.1090904@jp.fujitsu.com>
	 <1375808178.10300.181.camel@misato.fc.hp.com>
	 <52049A2E.8080101@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 15:28 +0800, Tang Chen wrote:
> On 08/07/2013 12:56 AM, Toshi Kani wrote:
> > On Tue, 2013-08-06 at 19:11 +0900, Yasuaki Ishimatsu wrote:
> >> try_offline_node() checks that all cpus related with removed node have been
> >> removed by using cpu_present_bits. If all cpus related with removed node have
> >> been removed, try_offline_node() clears the node information.
> >>
> >> But try_offline_node() called from acpi_processor_remove() never clears
> >> the node information. For disabling cpu_present_bits, acpi_unmap_lsapic()
> >> need be called. But acpi_unmap_lsapic() is called after try_offline_node()
> >> runs. So when try_offline_node() runs, the cpu's cpu_present_bits is always
> >> set.
> >>
> >> This patch moves try_offline_node() after acpi_unmap_lsapic().
> >>
> >> Signed-off-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> >
> > The change looks good to me.
> >
> > Acked-by: Toshi Kani<toshi.kani@hp.com>
> >
> > BTW, do you know why try_offline_node() has to use stop_machine()?
> 
> try_offline_node() is used to check if the node could be hot-removed
> after each memory or cpu hot-remove operation.
> 
> In memory hot-remove path, we have lock_memory_hotplug() to series all
> the memory hot-remove options.
> 
> But when doing cpu hot-remove,
> 
> acpi_processor_remove()
>   |->try_offline_node()
> 
> There is no lock to protect it. I think, when we are going to hot-remove
> a node, others should not do any memory or cpu hotplug operation. In memory
> hotplug path, we have lock_memory_hotplug(). But in cpu hotplug path, I
> didn't find any lock. So we used stop_machine() to call check_cpu_on_node().
> If we find any cpu still present, we return and do not remove the node.

CPU/Memory hotplug operations and sysfs eject are serialized with
acpi_os_hotplug_execute().  CPU online/offline is protected by
cpu_hotplug_[begin|done]() and [get|put]_online_cpus().  But, yes,
online/offline and hotplug operations are not serialized.  I tried to
serialize them before, but that framework was not well received.

Anyway, it looks to me that cpu_up()->mem_online_node() path can race
with try_offline_node().  And I do not think stop_machine() protects
this case, either.  try_offline_node() stops the execution of
num_online_node() during stop_machine(), but then lets it continues to
run after that.  I think they need to be protected by a lock.

I will look further to see if I can come up with some solution.

Thanks,
-Toshi

