Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3KSKuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:50:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47597 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3KSKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:50:05 -0500
Date: Tue, 19 Nov 2013 10:50:00 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.4 01/12] cxgb3: Fix length calculation in
 write_ofld_wr() on 32-bit architectures
Message-ID: <20131119105000.GA3943@hercules.my.domain>
References: <20131118184130.257996039@linuxfoundation.org>
 <20131118184130.528352245@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118184130.528352245@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Nov 18, 2013 at 10:41:34AM -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 

I guess you can drop this commit because, as Ben has already pointed
out, it is required for kernels >= 3.11.

Cheers,
--
Luis


> ------------------
> 
> From: Ben Hutchings <ben@decadent.org.uk>
> 
> [ Upstream commit 262e827fe745642589450ae241b7afd3912c3f25 ]
> 
> The length calculation here is now invalid on 32-bit architectures,
> since sk_buff::tail is a pointer and sk_buff::transport_header is
> an integer offset:
> 
> drivers/net/ethernet/chelsio/cxgb3/sge.c: In function 'write_ofld_wr':
> drivers/net/ethernet/chelsio/cxgb3/sge.c:1603:9: warning: passing argument 4 of 'make_sgl' makes integer from pointer without a cast [enabled by default]
>          adap->pdev);
>          ^
> drivers/net/ethernet/chelsio/cxgb3/sge.c:964:28: note: expected 'unsigned int' but argument is of type 'sk_buff_data_t'
>  static inline unsigned int make_sgl(const struct sk_buff *skb,
>                             ^
> 
> Use the appropriate skb accessor functions.
> 
> Compile-tested only.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Fixes: 1a37e412a022 ('net: Use 16bits for *_headers fields of struct skbuff')
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ethernet/chelsio/cxgb3/sge.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/drivers/net/ethernet/chelsio/cxgb3/sge.c
> +++ b/drivers/net/ethernet/chelsio/cxgb3/sge.c
> @@ -1600,7 +1600,8 @@ static void write_ofld_wr(struct adapter
>  	flits = skb_transport_offset(skb) / 8;
>  	sgp = ndesc == 1 ? (struct sg_ent *)&d->flit[flits] : sgl;
>  	sgl_flits = make_sgl(skb, sgp, skb_transport_header(skb),
> -			     skb->tail - skb->transport_header,
> +			     skb_tail_pointer(skb) -
> +			     skb_transport_header(skb),
>  			     adap->pdev);
>  	if (need_skb_unmap()) {
>  		setup_deferred_unmapping(skb, adap->pdev, sgp, sgl_flits);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
