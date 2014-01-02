Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaABQcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:32:08 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:23101 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaABQcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:32:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,591,1384300800"; 
   d="scan'208";a="87089386"
Message-ID: <52C59483.5030607@citrix.com>
Date: Thu, 2 Jan 2014 16:32:03 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 15/18] xen/pvh: Piggyback on PVHVM for grant driver
 (v2)
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> In PVH the shared grant frame is the PFN and not MFN,
> hence its mapped via the same code path as HVM.
> 
> The allocation of the grant frame is done differently - we
> do not use the early platform-pci driver and have an
> ioremap area - instead we use balloon memory and stitch
> all of the non-contingous pages in a virtualized area.
> 
> That means when we call the hypervisor to replace the GMFN
> with a XENMAPSPACE_grant_table type, we need to lookup the
> old PFN for every iteration instead of assuming a flat
> contingous PFN allocation.
> 
> Lastly, we only use v1 for grants. This is because PVHVM
> is not able to use v2 due to no XENMEM_add_to_physmap
> calls on the error status page (see commit
> 69e8f430e243d657c2053f097efebc2e2cd559f0
>  xen/granttable: Disable grant v2 for HVM domains.)
> 
> Until that is implemented this workaround has to
> be in place.
> 
> Also per suggestions by Stefano utilize the PVHVM paths
> as they share common functionality.
> 
> v2 of this patch moves most of the PVH code out in the
> arch/x86/xen/grant-table driver and touches only minimally
> the generic driver.
[...]
> --- a/arch/x86/xen/grant-table.c
> +++ b/arch/x86/xen/grant-table.c
[...]
> +static int __init xen_pvh_gnttab_setup(void)
> +{
> +	if (!xen_domain())
> +		return -ENODEV;
> +
> +	if (!xen_pv_domain())
> +		return -ENODEV;
> +
> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> +		return -ENODEV;

Replace all these with if (!xen_pvh_domain()) ?

> @@ -1320,4 +1323,4 @@ static int __gnttab_init(void)
>  	return gnttab_init();
>  }
>  
> -core_initcall(__gnttab_init);
> +core_initcall_sync(__gnttab_init);

Why has this become _sync?

David

