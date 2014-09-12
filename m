Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbaILTXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:23:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37476 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaILTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:23:46 -0400
Date: Fri, 12 Sep 2014 15:23:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, david.vrabel@citrix.com
Cc: xen-devel@lists.xenproject.org, David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen/blkback: unmap all persistent grants when frontend
 gets disconnected
Message-ID: <20140912192331.GF15656@laptop.dumpdata.com>
References: <1410182493-23638-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410182493-23638-1-git-send-email-vkuznets@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 03:21:33PM +0200, Vitaly Kuznetsov wrote:
> blkback does not unmap persistent grants when frontend goes to Closed
> state (e.g. when blkfront module is being removed). This leads to the
> following in guest's dmesg:
> 
> [  343.243825] xen:grant_table: WARNING: g.e. 0x445 still in use!
> [  343.243825] xen:grant_table: WARNING: g.e. 0x42a still in use!
> ...
> 
> When load module -> use device -> unload module sequence is performed multiple times
> it is possible to hit BUG() condition in blkfront module:
> 
> [  343.243825] kernel BUG at drivers/block/xen-blkfront.c:954!
> [  343.243825] invalid opcode: 0000 [#1] SMP
> [  343.243825] Modules linked in: xen_blkfront(-) ata_generic pata_acpi [last unloaded: xen_blkfront]
> ...
> [  343.243825] Call Trace:
> [  343.243825]  [<ffffffff814111ef>] ? unregister_xenbus_watch+0x16f/0x1e0
> [  343.243825]  [<ffffffffa0016fbf>] blkfront_remove+0x3f/0x140 [xen_blkfront]
> ...
> [  343.243825] RIP  [<ffffffffa0016aae>] blkif_free+0x34e/0x360 [xen_blkfront]
> [  343.243825]  RSP <ffff88001eb8fdc0>
> 
> We don't need to keep these grants if we're disconnecting as frontend might already
> forgot about them. Solve the issue by moving xen_blkbk_free_caches() call from
> xen_blkif_free() to xen_blkif_disconnect().
> 
> Now we can see the following:
> [  928.590893] xen:grant_table: WARNING: g.e. 0x587 still in use!
> [  928.591861] xen:grant_table: WARNING: g.e. 0x372 still in use!
> ...
> [  929.592146] xen:grant_table: freeing g.e. 0x587
> [  929.597174] xen:grant_table: freeing g.e. 0x372
> ...
> 
> Backend does not keep persistent grants any more, reconnect works fine.

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

David,

I usually combine the 'block' related patches in one branch and send them to Jens
for the merge window.

Want to do it the same way or do you want to alter the workflow?

> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  drivers/block/xen-blkback/xenbus.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
> index 3a8b810..54f4089 100644
> --- a/drivers/block/xen-blkback/xenbus.c
> +++ b/drivers/block/xen-blkback/xenbus.c
> @@ -270,6 +270,9 @@ static int xen_blkif_disconnect(struct xen_blkif *blkif)
>  		blkif->blk_rings.common.sring = NULL;
>  	}
>  
> +	/* Remove all persistent grants and the cache of ballooned pages. */
> +	xen_blkbk_free_caches(blkif);
> +
>  	return 0;
>  }
>  
> @@ -281,9 +284,6 @@ static void xen_blkif_free(struct xen_blkif *blkif)
>  	xen_blkif_disconnect(blkif);
>  	xen_vbd_free(&blkif->vbd);
>  
> -	/* Remove all persistent grants and the cache of ballooned pages. */
> -	xen_blkbk_free_caches(blkif);
> -
>  	/* Make sure everything is drained before shutting down */
>  	BUG_ON(blkif->persistent_gnt_c != 0);
>  	BUG_ON(atomic_read(&blkif->persistent_gnt_in_use) != 0);
> -- 
> 1.9.3
> 
