Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaKHWNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 17:13:55 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:51759 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaKHWNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 17:13:53 -0500
Date: Sat, 8 Nov 2014 14:13:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Tom Boshoven <tomboshoven@gmail.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Alexander Monakov <amonakov@gmail.com>
Subject: Re: [PATCH] ACPI/osl: speedup grace period in acpi_os_map_cleanup
Message-ID: <20141108221347.GF4901@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141108094717.9388.34638.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141108094717.9388.34638.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110822-0025-0000-0000-000005F418A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2014 at 12:47:17PM +0400, Konstantin Khlebnikov wrote:
> ACPI maintains cache of ioremap regions to speed up operations and
> access to them from irq context where ioremap() calls aren't allowed.
> This code abuses synchronize_rcu() on unmap path for synchronization
> with fast-path in acpi_os_read/write_memory which uses this cache.
> 
> Since v3.10 CPUs are allowed to enter idle state even if they have RCU
> callbacks queued, see commit c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
> ("rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks").
> That change caused problems with nvidia proprietary driver which calls
> acpi_os_map/unmap_generic_address several times during initialization.
> Each unmap calls synchronize_rcu and adds significant delay. Totally
> initialization is slowed for a couple of seconds and that is enough to
> trigger timeout in hardware, gpu decides to "fell off the bus". Widely
> spread workaround is reducing "rcu_idle_gp_delay" from 4 to 1 jiffy.

Did anyone try replacing the synchronize_rcu() with
synchronize_rcu_expedited()?  That should provide substantial speedups
over synchronize_rcu().

							Thanx, Paul

> This patch replaces synchronize_rcu with per-acpi_ioremap atomic counter
> of side users and wait-queue which signals when counter falls to zero.
> List of struct acpi_ioremap is still protected by RCU but they're freed
> asynchronously using kfree_rcu.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Reported-and-tested-by: Alexander Monakov <amonakov@gmail.com>
> Tested-by: Tom Boshoven <tomboshoven@gmail.com>
> Link: https://devtalk.nvidia.com/default/topic/567297/linux/linux-3-10-driver-crash/
> ---
>  drivers/acpi/osl.c |   71 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 36 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9964f70..222252a 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -94,10 +94,13 @@ struct acpi_ioremap {
>  	acpi_physical_address phys;
>  	acpi_size size;
>  	unsigned long refcount;
> +	atomic_t active;
> +	struct rcu_head rcu_head;
>  };
> 
>  static LIST_HEAD(acpi_ioremaps);
>  static DEFINE_MUTEX(acpi_ioremap_lock);
> +static DECLARE_WAIT_QUEUE_HEAD(acpi_ioremap_wq);
> 
>  static void __init acpi_osi_setup_late(void);
> 
> @@ -293,17 +296,31 @@ acpi_map_lookup(acpi_physical_address phys, acpi_size size)
>  	return NULL;
>  }
> 
> -/* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
> -static void __iomem *
> -acpi_map_vaddr_lookup(acpi_physical_address phys, unsigned int size)
> +static void __iomem *acpi_get_ioremap(acpi_physical_address phys,
> +				acpi_size size, struct acpi_ioremap **pmap)
>  {
>  	struct acpi_ioremap *map;
> 
> +	rcu_read_lock();
>  	map = acpi_map_lookup(phys, size);
> -	if (map)
> +	if (map && atomic_inc_not_zero(&map->active)) {
> +		rcu_read_unlock();
> +		*pmap = map;
>  		return map->virt + (phys - map->phys);
> +	}
> +	rcu_read_unlock();
> 
> -	return NULL;
> +	*pmap = NULL;
> +	return acpi_os_ioremap(phys, size);
> +}
> +
> +static void acpi_put_ioremap(void __iomem *virt, struct acpi_ioremap *map)
> +{
> +	if (map) {
> +		if (atomic_dec_and_test(&map->active))
> +			wake_up_all(&acpi_ioremap_wq);
> +	} else
> +		iounmap(virt);
>  }
> 
>  void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
> @@ -411,6 +428,7 @@ acpi_os_map_iomem(acpi_physical_address phys, acpi_size size)
>  	map->phys = pg_off;
>  	map->size = pg_sz;
>  	map->refcount = 1;
> +	atomic_set(&map->active, 1);
> 
>  	list_add_tail_rcu(&map->list, &acpi_ioremaps);
> 
> @@ -436,9 +454,10 @@ static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
>  static void acpi_os_map_cleanup(struct acpi_ioremap *map)
>  {
>  	if (!map->refcount) {
> -		synchronize_rcu();
> +		atomic_dec(&map->active);
> +		wait_event(acpi_ioremap_wq, !atomic_read(&map->active));
>  		acpi_unmap(map->phys, map->virt);
> -		kfree(map);
> +		kfree_rcu(map, rcu_head);
>  	}
>  }
> 
> @@ -947,20 +966,14 @@ static inline u64 read64(const volatile void __iomem *addr)
>  acpi_status
>  acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
>  {
> +	struct acpi_ioremap *map;
>  	void __iomem *virt_addr;
>  	unsigned int size = width / 8;
> -	bool unmap = false;
>  	u64 dummy;
> 
> -	rcu_read_lock();
> -	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
> -	if (!virt_addr) {
> -		rcu_read_unlock();
> -		virt_addr = acpi_os_ioremap(phys_addr, size);
> -		if (!virt_addr)
> -			return AE_BAD_ADDRESS;
> -		unmap = true;
> -	}
> +	virt_addr = acpi_get_ioremap(phys_addr, size, &map);
> +	if (!virt_addr)
> +		return AE_BAD_ADDRESS;
> 
>  	if (!value)
>  		value = &dummy;
> @@ -982,10 +995,7 @@ acpi_os_read_memory(acpi_physical_address phys_addr, u64 *value, u32 width)
>  		BUG();
>  	}
> 
> -	if (unmap)
> -		iounmap(virt_addr);
> -	else
> -		rcu_read_unlock();
> +	acpi_put_ioremap(virt_addr, map);
> 
>  	return AE_OK;
>  }
> @@ -1006,19 +1016,13 @@ static inline void write64(u64 val, volatile void __iomem *addr)
>  acpi_status
>  acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
>  {
> +	struct acpi_ioremap *map;
>  	void __iomem *virt_addr;
>  	unsigned int size = width / 8;
> -	bool unmap = false;
> 
> -	rcu_read_lock();
> -	virt_addr = acpi_map_vaddr_lookup(phys_addr, size);
> -	if (!virt_addr) {
> -		rcu_read_unlock();
> -		virt_addr = acpi_os_ioremap(phys_addr, size);
> -		if (!virt_addr)
> -			return AE_BAD_ADDRESS;
> -		unmap = true;
> -	}
> +	virt_addr = acpi_get_ioremap(phys_addr, size, &map);
> +	if (!virt_addr)
> +		return AE_BAD_ADDRESS;
> 
>  	switch (width) {
>  	case 8:
> @@ -1037,10 +1041,7 @@ acpi_os_write_memory(acpi_physical_address phys_addr, u64 value, u32 width)
>  		BUG();
>  	}
> 
> -	if (unmap)
> -		iounmap(virt_addr);
> -	else
> -		rcu_read_unlock();
> +	acpi_put_ioremap(virt_addr, map);
> 
>  	return AE_OK;
>  }
> 

