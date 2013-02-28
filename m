Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab3B1K6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:58:51 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:38269 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3B1K6u convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 28 Feb 2013 05:58:50 -0500
Message-Id: <512F467602000078000C1E0C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 28 Feb 2013 10:58:46 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Roger Pau Monne" <roger.pau@citrix.com>
Cc: <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 01/12] xen-blkback: don't store
 dev_bus_addr
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-2-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1362047335-26402-2-git-send-email-roger.pau@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.13 at 11:28, Roger Pau Monne <roger.pau@citrix.com> wrote:
> dev_bus_addr returned in the grant ref map operation is the mfn of the
> passed page, there's no need to store it in the persistent grant
> entry, since we can always get it provided that we have the page.

Interesting that you come up with this, as I have a similar patch
pending (not posted yet), aiming at reducing the stack usage in
dispatch_rw_block_io(): seg[].buf is really unnecessary with the
dev_bus_addr storing removed, as the only reader of that field
can equally well use req->u.rw.seg[i].first_sect.

And then the biolist[] array really can be folded into a union
with the remaining seg[] one, as their usage scopes are easily
separable.

> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -621,9 +621,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  				 * If this is a new persistent grant
>  				 * save the handler
>  				 */
> -				persistent_gnts[i]->handle = map[j].handle;
> -				persistent_gnts[i]->dev_bus_addr =
> -					map[j++].dev_bus_addr;
> +				persistent_gnts[i]->handle = map[j++].handle;
>  			}
>  			pending_handle(pending_req, i) =
>  				persistent_gnts[i]->handle;
> @@ -631,7 +629,8 @@ static int xen_blkbk_map(struct blkif_request *req,
>  			if (ret)
>  				continue;
>  
> -			seg[i].buf = persistent_gnts[i]->dev_bus_addr |
> +			seg[i].buf = pfn_to_mfn(page_to_pfn(
> +				persistent_gnts[i]->page)) << PAGE_SHIFT |

So why do you do this? The only reader masks the field with
~PAGE_MASK anyway.

Jan

