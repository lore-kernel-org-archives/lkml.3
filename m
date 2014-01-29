Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaA2IwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:52:13 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:55794 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaA2IwM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 29 Jan 2014 03:52:12 -0500
Message-Id: <52E8CF540200007800117D88@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 29 Jan 2014 08:52:20 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: "Matt Rushton" <mrushton@amazon.com>, "Matt Wilson" <msw@amazon.com>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "Ian Campbell" <Ian.Campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen-blkback: fix shutdown race
References: <1390931015-5490-1-git-send-email-roger.pau@citrix.com>
 <1390931015-5490-4-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1390931015-5490-4-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.01.14 at 18:43, Roger Pau Monne <roger.pau@citrix.com> wrote:
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -985,17 +985,31 @@ static void __end_block_io_op(struct pending_req 
> *pending_req, int error)
>  	 * the proper response on the ring.
>  	 */
>  	if (atomic_dec_and_test(&pending_req->pendcnt)) {
> -		xen_blkbk_unmap(pending_req->blkif,
> +		struct xen_blkif *blkif = pending_req->blkif;
> +
> +		xen_blkbk_unmap(blkif,
>  		                pending_req->segments,
>  		                pending_req->nr_pages);
> -		make_response(pending_req->blkif, pending_req->id,
> +		make_response(blkif, pending_req->id,
>  			      pending_req->operation, pending_req->status);
> -		xen_blkif_put(pending_req->blkif);
> -		if (atomic_read(&pending_req->blkif->refcnt) <= 2) {
> -			if (atomic_read(&pending_req->blkif->drain))
> -				complete(&pending_req->blkif->drain_complete);
> +		free_req(blkif, pending_req);
> +		/*
> +		 * Make sure the request is freed before releasing blkif,
> +		 * or there could be a race between free_req and the
> +		 * cleanup done in xen_blkif_free during shutdown.
> +		 *
> +		 * NB: The fact that we might try to wake up pending_free_wq
> +		 * before drain_complete (in case there's a drain going on)
> +		 * it's not a problem with our current implementation
> +		 * because we can assure there's no thread waiting on
> +		 * pending_free_wq if there's a drain going on, but it has
> +		 * to be taken into account if the current model is changed.
> +		 */
> +		xen_blkif_put(blkif);
> +		if (atomic_read(&blkif->refcnt) <= 2) {
> +			if (atomic_read(&blkif->drain))
> +				complete(&blkif->drain_complete);
>  		}
> -		free_req(pending_req->blkif, pending_req);
>  	}
>  }

The put is still too early imo - you're explicitly accessing field in the
structure immediately afterwards. This may not be an issue at
present, but I think it's at least a latent one.

Apart from that, the two if()s would - at least to me - be more
clear if combined into one.

Jan

