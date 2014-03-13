Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaCMKR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:17:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51773 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaCMKR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:17:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,646,1389744000"; 
   d="scan'208";a="109507012"
Message-ID: <1394705874.25873.19.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next v7 4/9] xen-netback: Introduce TX grant mapping
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Date: Thu, 13 Mar 2014 10:17:54 +0000
In-Reply-To: <1394142511-14827-5-git-send-email-zoltan.kiss@citrix.com>
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>
	 <1394142511-14827-5-git-send-email-zoltan.kiss@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pulling out this one comment for the attention on the core Xen/Linux
maintainers.

On Thu, 2014-03-06 at 21:48 +0000, Zoltan Kiss wrote:
[...]
> @@ -343,8 +347,26 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
>  	vif->pending_prod = MAX_PENDING_REQS;
>  	for (i = 0; i < MAX_PENDING_REQS; i++)
>  		vif->pending_ring[i] = i;
> -	for (i = 0; i < MAX_PENDING_REQS; i++)
> -		vif->mmap_pages[i] = NULL;
> +	spin_lock_init(&vif->callback_lock);
> +	spin_lock_init(&vif->response_lock);
> +	/* If ballooning is disabled, this will consume real memory, so you
> +	 * better enable it. The long term solution would be to use just a
> +	 * bunch of valid page descriptors, without dependency on ballooning
> +	 */

I wonder if we ought to enforce this via Kconfig? i.e. making
CONFIG_XEN_BACKEND (or the individual backends) depend on BALLOON (or
select?) or by making CONFIG_XEN_BALLOON non-optional etc.

IIRC David V was looking into a solution involving auto hotplugging a
new region to use for this case, but then I guess
CONFIG_XEN_BALLOON_MEMORY_HOTPLUG would equally need to be enabled.

> +	err = alloc_xenballooned_pages(MAX_PENDING_REQS,
> +				       vif->mmap_pages,
> +				       false);
[...]

