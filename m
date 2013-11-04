Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3KDRWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:22:55 -0500
Received: from smtp.citrix.com ([66.165.176.89]:41937 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab3KDRWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:22:53 -0500
X-IronPort-AV: E=Sophos;i="4.93,633,1378857600"; 
   d="scan'208";a="70391341"
Message-ID: <5277D7EA.9000801@citrix.com>
Date: Mon, 4 Nov 2013 17:22:50 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Bob Liu <lliubbo@gmail.com>
CC: <konrad.wilk@oracle.com>, <xen-devel@lists.xenproject.org>,
        Bob Liu <bob.liu@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] drivers: xen-selfballoon: consider slab pages
References: <1383568764-30478-1-git-send-email-bob.liu@oracle.com>
In-Reply-To: <1383568764-30478-1-git-send-email-bob.liu@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 12:39, Bob Liu wrote:
> Currently the goal_page in xen-selfballon doesn't consider much about pages used
> in kernel space.
> A typical usage is slab pages, without consider slab pages the goal_page result
> may be too rough and lead extra memory pressure to guest os.

Can you provide some real world figures where the calculatation got it
wrong? What was the resultant behavior?  Swap death? OOM killer?

> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/xen/xen-selfballoon.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
> index 21e18c1..4814759 100644
> --- a/drivers/xen/xen-selfballoon.c
> +++ b/drivers/xen/xen-selfballoon.c
> @@ -191,6 +191,8 @@ static void selfballoon_process(struct work_struct *work)
>  		tgt_pages = cur_pages; /* default is no change */
>  		goal_pages = vm_memory_committed() +
>  				totalreserve_pages +
> +				global_page_state(NR_SLAB_RECLAIMABLE) +

Does SLAB_RECLAIMABLE want to be included here?  Unless I'm
misunderstanding here, SLAB_RECLAIMABLE is effectively free.

> +				global_page_state(NR_SLAB_UNRECLAIMABLE) +

This bit looks fine to me.

>  				MB2PAGES(selfballoon_reserved_mb);
>  #ifdef CONFIG_FRONTSWAP
>  		/* allow space for frontswap pages to be repatriated */

David
