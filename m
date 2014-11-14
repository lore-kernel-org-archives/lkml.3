Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285AbaKNQNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:13:01 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:47212 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934727AbaKNQM7 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 14 Nov 2014 11:12:59 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2014 11:12:58 EST
Date: Fri, 14 Nov 2014 23:52:44 +0800
From: joeyli <jlee@suse.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Tom Boshoven <tomboshoven@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Alexander Monakov <amonakov@gmail.com>
Subject: Re: [PATCH v2] ACPI/osl: speedup grace period in acpi_os_map_cleanup
Message-ID: <20141114155244.GF32750@linux-rxt1.site>
References: <20141108094717.9388.34638.stgit@zurg>
 <20141109105337.4952.36899.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141109105337.4952.36899.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On Sun, Nov 09, 2014 at 01:53:37PM +0400, Konstantin Khlebnikov wrote:
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
> 
> This patch replaces synchronize_rcu() with synchronize_rcu_expedited()
> which is much faster.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Reported-and-tested-by: Alexander Monakov <amonakov@gmail.com>
> Cc: Tom Boshoven <tomboshoven@gmail.com>
> Link: https://devtalk.nvidia.com/default/topic/567297/linux/linux-3-10-driver-crash/

Please feel free to add Tested-by:

Tested-by: Lee, Chun-Yi <jlee@suse.com>


This patch fixed the performance issue on VMWare workstation 10.0.2 with the
virtual machine that has more than 2 CPU and 4G memory:

Mware workstation 10.0.2 
  BIOS DMI: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
  vCPU = 8
  vMEM = 4G
  mem.hotplug=TRUE

physical CPUs on host machine: Intel(R) Xeon(R) CPU X5670  @ 2.93GHz  * 24

I tested this patch with v3.12, v3.17, v3.18-rc4 mainline kernel, those kernel
call can produced issue and all got speedup when acpi initial. I suggest this
patch go to stable kernel patch fixing.


Thanks a lot!
Joey Lee

> ---
>  drivers/acpi/osl.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 9964f70..217713c 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -436,7 +436,7 @@ static void acpi_os_drop_map_ref(struct acpi_ioremap *map)
>  static void acpi_os_map_cleanup(struct acpi_ioremap *map)
>  {
>  	if (!map->refcount) {
> -		synchronize_rcu();
> +		synchronize_rcu_expedited();
>  		acpi_unmap(map->phys, map->virt);
>  		kfree(map);
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
