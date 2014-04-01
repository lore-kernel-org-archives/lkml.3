Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaDALks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:40:48 -0400
Received: from smtp.citrix.com ([66.165.176.89]:42555 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaDALkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:40:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,772,1389744000"; 
   d="scan'208";a="116884336"
Message-ID: <1396352440.8667.117.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH net-next v2 2/2] xen-netback: Grant copy the header
 instead of map and memcpy
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <paul.durrant@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Date: Tue, 1 Apr 2014 12:40:40 +0100
In-Reply-To: <1396278539-27639-2-git-send-email-zoltan.kiss@citrix.com>
References: <1396278539-27639-1-git-send-email-zoltan.kiss@citrix.com>
	 <1396278539-27639-2-git-send-email-zoltan.kiss@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 16:08 +0100, Zoltan Kiss wrote:
>  
>  check_frags:
> -	for (i = start; i < nr_frags; i++) {
> +	for (i = 0; i < nr_frags; i++, gop_map++) {
>  		int j, newerr;
>  
>  		pending_idx = frag_get_pending_idx(&shinfo->frags[i]);
> -		tx_info = &vif->pending_tx_info[pending_idx];
>  
>  		/* Check error status: if okay then remember grant handle. */
> -		newerr = (++gop_map)->status;
> +		newerr = (gop_map)->status;

You've reworked the handling of gop_map and when and where it is
incremented, which might be a legit cleanup but does it relate to the
bulk of this change somehow that I'm missing?

>  [...] 
>  		__skb_put(skb, data_len);
> +		vif->tx_copy_ops[*copy_ops].source.u.ref = txreq.gref;
> +		vif->tx_copy_ops[*copy_ops].source.domid = vif->domid;
> +		vif->tx_copy_ops[*copy_ops].source.offset = txreq.offset;
> +
> +		vif->tx_copy_ops[*copy_ops].dest.u.gmfn =
> +			virt_to_mfn(skb->data);
> +		vif->tx_copy_ops[*copy_ops].dest.domid = DOMID_SELF;
> +		vif->tx_copy_ops[*copy_ops].dest.offset =
> +			offset_in_page(skb->data);
> +
> +		vif->tx_copy_ops[*copy_ops].len = data_len;
> +		vif->tx_copy_ops[*copy_ops].flags = GNTCOPY_source_gref;

We have gnttab_set_map_op. Should we have gnttap_set_copy_op too?

> -	BUG_ON(ret);
> +	else {
> +		gnttab_batch_copy(vif->tx_copy_ops, nr_cops);
> +		if (nr_mops != 0) {


if (nr_mops) would do.

> +			ret = gnttab_map_refs(vif->tx_map_ops,

So we use gnttab_batch_copy and gnttab_map_refs.

Shouldn't we either use gnttab_batch_copy and gnttab_batch_map or
gnttab_copy gnttab_map_refs. (where gnttab_copy might be a bare
GNTTABOP_copy or might be a helper wrapper).

The point of the batch interface is to handle page unsharing etc, but
doing it only for copies seems like a waste one way or another.

#include <paul's-comments>

Ian.

