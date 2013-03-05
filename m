Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab3CET1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:27:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34630 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab3CET1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:27:21 -0500
Date: Tue, 5 Mar 2013 14:27:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <daniel.kiper@oracle.com>, david.vrabel@citrix.com
Cc: carsten@schiers.de, darren.s.shepherd@gmail.com, david.vrabel@citrix.com,
        james-xen@dingwall.me.uk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/1] xen/balloon: Enforce various limits on target
Message-ID: <20130305192705.GA2021@phenom.dumpdata.com>
References: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:14:51PM +0100, Daniel Kiper wrote:
> This patch enforces on target limit statically defined in Linux Kernel
> source and limit defined by hypervisor or host.
> 
> Particularly this patch fixes bug which led to flood
> of dom0 kernel log with messages similar to:
> 
> System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
> xen_balloon: reserve_additional_memory: add_memory() failed: -17
> 
> It does not allow balloon driver to execute infinite
> loops when target exceeds limits in other cases too.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>

One nitpick below; David, could you take a look just for a extra
set of eyes.
> ---
>  drivers/xen/balloon.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index a56776d..07da753 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -65,6 +65,7 @@
>  #include <xen/balloon.h>
>  #include <xen/features.h>
>  #include <xen/page.h>
> +#include <xen/xenbus.h>
>  
>  /*
>   * balloon_process() state:
> @@ -490,11 +491,55 @@ static void balloon_process(struct work_struct *work)
>  	mutex_unlock(&balloon_mutex);
>  }
>  
> -/* Resets the Xen limit, sets new target, and kicks off processing. */
> +/* Enforce limits, set new target and kick off processing. */
>  void balloon_set_new_target(unsigned long target)
>  {
> +	domid_t domid = DOMID_SELF;
> +	int rc;
> +	unsigned long long host_limit;
> +
> +	/* Enforce statically defined limit. */
> +	target = min(target, MAX_DOMAIN_PAGES);
> +
> +	if (xen_initial_domain()) {
> +		rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
> +
> +		/* Limit is not enforced by hypervisor. */
> +		if (rc == -EPERM)
> +			goto no_host_limit;
> +
> +		if (rc <= 0) {
> +			pr_info("xen_balloon: %s: Initial domain target limit "
> +				"could not be established: %i\n", __func__, rc);

Probably pr_debug. As this means the user booted without dom0_mem_max argument.
(B/c rc == UINT_MAX) I would say if you can check for that and it as part of
if (rc == -EPERM) check.


> +			goto no_host_limit;
> +		}
> +
> +		host_limit = rc;
> +	} else {
> +		rc = xenbus_scanf(XBT_NIL, "memory", "static-max",
> +							"%llu", &host_limit);
> +
> +		if (rc != 1) {
> +			pr_info("xen_balloon: %s: Guest domain target limit "
> +				"could not be established: %i\n", __func__, rc);
> +			goto no_host_limit;
> +		}
> +
> +		/*
> +		 * The given memory target limit value is in KiB, so it needs
> +		 * converting to pages. PAGE_SHIFT converts bytes to pages,
> +		 * hence PAGE_SHIFT - 10.
> +		 */
> +		host_limit >>= (PAGE_SHIFT - 10);
> +	}
> +
> +	/* Enforce hypervisor/host defined limit. */
> +	target = min(target, (unsigned long)host_limit);
> +
> +no_host_limit:
>  	/* No need for lock. Not read-modify-write updates. */
>  	balloon_stats.target_pages = target;
> +
>  	schedule_delayed_work(&balloon_worker, 0);
>  }
>  EXPORT_SYMBOL_GPL(balloon_set_new_target);
> -- 
> 1.7.10.4
> 
