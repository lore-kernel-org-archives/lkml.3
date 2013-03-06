Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab3CFLFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:05:09 -0500
Received: from smtp.citrix.com ([66.165.176.89]:38011 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031Ab3CFLFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:05:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,794,1355097600"; 
   d="scan'208";a="11459606"
Message-ID: <513722DF.6010204@citrix.com>
Date: Wed, 6 Mar 2013 11:05:03 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 1/1] xen/balloon: Enforce various limits on target
References: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/13 21:14, Daniel Kiper wrote:
> This patch enforces on target limit statically defined in Linux Kernel
> source and limit defined by hypervisor or host.
> 
> Particularly this patch fixes bug which led to flood
> of dom0 kernel log with messages similar to:
> 
> System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
> xen_balloon: reserve_additional_memory: add_memory() failed: -17

I think this helps in some cases, but because
reserve_additional_memory() places the hotplugged memory after max_pfn
without checking if there is anything already there, there are still
ways it can repeatedly fail.

e.g.,

1. If dom0 has had its maximum reservation limited initially (with the
dom0_mem option) /and/ the max reservation and target is subsequently
raised then the balloon driver will attempt to hotplug memory that
overlaps with E820_UNUSABLE regions in the e820 map and the hotplug will
fail.

2. If a domU has passed-through PCI devices max_pfn is before the PCI
memory window then the balloon driver will attempt to hotplug memory
over the PCI device BARs.

I think reserve_additional_memory() should check the current resource
map and the e820 map to find a large enough unused region.  This can be
done as an additional patch at a later date.

> It does not allow balloon driver to execute infinite
> loops when target exceeds limits in other cases too.

This sentence confuses me.

> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
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
> +			goto no_host_limit;
> +		}
> +
> +		host_limit = rc;

I think you should use this method for both dom0 and domUs.  No need to
check static-max from xenstore.

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

With the change above, you can change host_limit to unsigned long and
avoid the cast.

David
