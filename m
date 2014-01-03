Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaACQXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 11:23:04 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13369 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaACQXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 11:23:02 -0500
X-IronPort-AV: E=Sophos;i="4.95,598,1384300800"; 
   d="scan'208";a="87392084"
Date: Fri, 3 Jan 2014 16:22:01 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 17/18] xen/pvh/arm/arm64: Disable PV code that does
 not work with PVH (v2)
In-Reply-To: <1388550945-25499-18-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1401031610470.8667@kaball.uk.xensource.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-18-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> As we do not have yet a mechanism for that.
> 
> This also impacts the ARM/ARM64 code (which does not have
> hotplug support yet).
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/cpu_hotplug.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
> index cc6513a..5f80802 100644
> --- a/drivers/xen/cpu_hotplug.c
> +++ b/drivers/xen/cpu_hotplug.c
> @@ -4,6 +4,7 @@
>  
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> +#include <xen/features.h>
>  
>  #include <asm/xen/hypervisor.h>
>  #include <asm/cpu.h>
> @@ -102,7 +103,8 @@ static int __init setup_vcpu_hotplug_event(void)
>  	static struct notifier_block xsn_cpu = {
>  		.notifier_call = setup_cpu_watcher };
>  
> -	if (!xen_pv_domain())
> +	/* PVH/ARM/ARM64 TBD/FIXME: future work */
> +	if (!xen_pv_domain() || xen_feature(XENFEAT_auto_translated_physmap))
>  		return -ENODEV;
>  
>  	register_xenstore_notifier(&xsn_cpu);

Sorry for being a bit obnoxious but I was thinking that using a
xen_feature(XENFEAT_auto_translated_physmap) check is conceptually
wrong, because cpu hotplug and nested paging are orthogonal.

Given that we most probably want to follow the PV path for cpu_hotplug
(that is using drivers/xen/cpu_hotplug.c), is there actually a problem
with building and initializing it on PVH guests?
If it works as it is, I would be tempted to leave it for now.

Otherwise the patch is OK and you can add my Acked-by.
