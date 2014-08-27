Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342AbaH0XSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:18:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50096 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933980AbaH0XSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:18:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, fengguang.wu@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, All applicable <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH V3] ACPI / OSL: Make acpi_os_map_cleanup() use call_rcu() to avoid deadlocks
Date: Thu, 28 Aug 2014 01:37:57 +0200
Message-ID: <8105997.7zQ9mSfecG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409123489-11786-1-git-send-email-tianyu.lan@intel.com>
References: <20140827022709.GA22064@localhost> <1409123489-11786-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2014 03:11:29 PM Lan Tianyu wrote:
> Deadlock is possible when CPU hotplug and evaluating ACPI method happen
> at the same time.
> 
> During CPU hotplug, acpi_cpu_soft_notify() is called under the CPU hotplug
> lock.  Then, acpi_cpu_soft_notify() calls acpi_bus_get_device() to obtain
> the struct acpi_device attached to the given ACPI handle.  The ACPICA's
> namespace lock will be acquired by acpi_bus_get_device() in the process.
> Thus it is possible to hold the ACPICA's namespace lock under the CPU
> hotplug lock.
> 
> Evaluating an ACPI method may involve accessing an operation region in
> system memory and the associated address space will be unmapped under
> the ACPICA's namespace lock after completing the access. Currently, osl.c
> uses RCU to protect memory ranges used by AML.  When unmapping them it
> calls synchronize_rcu() in acpi_os_map_cleanup(), but that blocks
> CPU hotplug by acquiring the CPU hotplug lock.  Thus it is possible to
> hold the CPU hotplug lock under the ACPICA's namespace lock.
> 
> This leads to deadlocks like the following one if AML accessing operation
> regions in memory is executed in parallel with CPU hotplug.

[cut]

> To avoid such deadlocks, modify acpi_os_map_cleanup() to use call_rcu()
> to schedule acpi_os_async_umap() asynchronously to umap memory regions
> that aren't used any more. The umap operation can't be done in the
> call_rcu()'s callback directly because the callback will be called in the
> soft irq context and acpi_unmap() holds mutex lock inside.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> [rjw: Subject and changelog.]
> Cc: All applicable <stable@vger.kernel.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/osl.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 3abe9b2..9baef71 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -40,6 +40,7 @@
>  #include <linux/nmi.h>
>  #include <linux/acpi.h>
>  #include <linux/efi.h>
> +#include <linux/async.h>
>  #include <linux/ioport.h>
>  #include <linux/list.h>
>  #include <linux/jiffies.h>
> @@ -94,6 +95,7 @@ struct acpi_ioremap {
>  	acpi_physical_address phys;
>  	acpi_size size;
>  	unsigned long refcount;
> +	struct rcu_head rcu;
>  };
>  
>  static LIST_HEAD(acpi_ioremaps);
> @@ -423,13 +425,25 @@ static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
>  		list_del_rcu(&map->list);
>  }
>  
> +static void acpi_os_async_umap(void *data, async_cookie_t cookie)
> +{
> +	struct acpi_ioremap *map = data;
> +
> +	acpi_unmap(map->phys, map->virt);
> +	kfree(map);
> +}
> +
> +static void acpi_os_map_reclaim(struct rcu_head *rcu)
> +{
> +	struct acpi_ioremap *map = container_of(rcu, struct acpi_ioremap, rcu);
> +
> +	async_schedule(acpi_os_async_umap, map);
> +}
> +
>  static void acpi_os_map_cleanup(struct acpi_ioremap *map)
>  {
> -	if (!map->refcount) {
> -		synchronize_rcu();
> -		acpi_unmap(map->phys, map->virt);
> -		kfree(map);
> -	}
> +	if (!map->refcount)
> +		call_rcu(&map->rcu, acpi_os_map_reclaim);
>  }
>  
>  void __ref acpi_os_unmap_iomem(void __iomem *virt, acpi_size size)
> 

This goes a bit too far.  First, if you need to start an async thread,
you can simply do synchronize_rcu() from there.  Second, though, perhaps
we can address the whole deadlock in a different way.

For example, if we do something like the patch below (which I haven't
tested, but it should work if I'm not missing something horribly), we
won't be taking the ACPI namespace lock under the CPU hotplug lock
in acpi_cpu_soft_notify() any more.

Rafael

---
 drivers/acpi/processor_driver.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/processor_driver.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_driver.c
+++ linux-pm/drivers/acpi/processor_driver.c
@@ -129,7 +129,11 @@ static int acpi_cpu_soft_notify(struct n
 	if (action == CPU_STARTING || action == CPU_DYING)
 		return NOTIFY_DONE;
 
-	if (!pr || acpi_bus_get_device(pr->handle, &device))
+	if (!pr || !pr->dev)
+		return NOTIFY_DONE;
+
+	device = ACPI_COMPANION(pr->dev);
+	if (!device)
 		return NOTIFY_DONE;
 
 	if (action == CPU_ONLINE) {

