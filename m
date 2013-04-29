Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3D2OoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 10:44:15 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:5653 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab3D2OoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 10:44:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4041332"
Message-ID: <1367246649.3142.316.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v2 2/2] xen/balloon: Enforce various limits on target
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: "carsten@schiers.de" <carsten@schiers.de>,
        "darren.s.shepherd@gmail.com" <darren.s.shepherd@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "Ian Jackson" <Ian.Jackson@eu.citrix.com>,
        "james-xen@dingwall.me.uk" <james-xen@dingwall.me.uk>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Mon, 29 Apr 2013 15:44:09 +0100
In-Reply-To: <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
	 <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 12:37 +0100, Daniel Kiper wrote:

> This patch enforces on target limit statically defined in Linux Kernel
> source and limit defined by hypervisor or host. This way the balloon
> driver should not attempt to populate pages above given limits
> because they may fail.
> 
> Particularly this patch fixes bug which led to flood
> of dom0 kernel log with messages similar to:
> 
> System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
> xen_balloon: reserve_additional_memory: add_memory() failed: -17

I think it would be OK to simply tone down this message (and perhaps add
the failed pages to the balloon, if that makes sense). This isn't
dissimilar to increase_reservation failing.

> +/*
> + * Extra internal memory reserved by libxl.
> + * Check tools/libxl/libxl_memory.txt file in Xen source for more details.
> + */
> +#define LIBXL_MAXMEM_CONSTANT_PAGES	(1024 * 1024 / PAGE_SIZE)

I think we need to find a way to achieve your aims which doesn't require
leaking internal implementation details of libxl into the guest kernels.
What happens if libxl decides to double this?

> +
>  #ifdef CONFIG_HIGHMEM
>  #define inc_totalhigh_pages() (totalhigh_pages++)
>  #define dec_totalhigh_pages() (totalhigh_pages--)
> @@ -491,11 +496,42 @@ static void balloon_process(struct work_struct *work)
>  	mutex_unlock(&balloon_mutex);
>  }
>  
> -/* Resets the Xen limit, sets new target, and kicks off processing. */
> +/* Enforce limits, set new target and kick off processing. */
>  void balloon_set_new_target(unsigned long target)
>  {
> +	domid_t domid = DOMID_SELF;
> +	int rc;
> +
> +	/* Enforce statically defined limit. */
> +	target = min(target, MAX_DOMAIN_PAGES);
> +
> +	rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
> +
> +	if (xen_initial_domain()) {
> +		if (rc <= 0) {
> +			pr_debug("xen_balloon: %s: Initial domain target limit "
> +					"could not be established: %i\n",
> +					__func__, rc);
> +			goto no_host_limit;
> +		}
> +	} else {
> +		if (rc <= 0) {
> +			pr_info("xen_balloon: %s: Guest domain target limit "
> +				"could not be established: %i\n", __func__, rc);
> +			goto no_host_limit;
> +		}
> +
> +		/* Do not take into account memory reserved for internal stuff. */
> +		rc -= LIBXL_MAXMEM_CONSTANT_PAGES;
> +	}

Why is this needed? Wouldn't it be a toolstack bug to set the target
greater than this limit? But if it did ask then it would no doubt be
expecting the guest to try and reach that limit (perhaps it intends to
raise the maximum later?).

In any case it should be handled the same way as a failure in
increase_reservation is always handled, shouldn't it? No need for a
special case.

I don't think this change has anything to do with the add_memory()
failure you mention in the commit message.

> +
> +	/* Enforce hypervisor/host defined limit. */
> +	target = min_t(unsigned long, target, rc);
> +
> +no_host_limit:
>  	/* No need for lock. Not read-modify-write updates. */
>  	balloon_stats.target_pages = target;
> +
>  	schedule_delayed_work(&balloon_worker, 0);
>  }
>  EXPORT_SYMBOL_GPL(balloon_set_new_target);


