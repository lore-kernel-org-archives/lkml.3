Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaKIWES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 17:04:18 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:44466 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaKIWEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 17:04:16 -0500
Date: Sun, 9 Nov 2014 14:00:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Tom Boshoven <tomboshoven@gmail.com>, x86@kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Alexander Monakov <amonakov@gmail.com>
Subject: Re: [PATCH v2] ACPI/osl: speedup grace period in acpi_os_map_cleanup
Message-ID: <20141109220038.GH4901@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141108094717.9388.34638.stgit@zurg>
 <20141109105337.4952.36899.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141109105337.4952.36899.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110922-0021-0000-0000-00000603FDDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

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
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

