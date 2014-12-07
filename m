Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaLGSNT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 13:13:19 -0500
Received: from mail.us.es ([193.147.175.20]:52702 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaLGSNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 13:13:17 -0500
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.98.5/19745. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-101.4/7.5):. 
 Processed in 2.014717 secs); 07 Dec 2014 18:13:14 -0000
X-Spam-ASN: AS12715 87.216.0.0/16
X-Envelope-From: pneira@us.es
Date: Sun, 7 Dec 2014 19:15:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        bill bonaparte <programme110@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH 3.17 122/122] netfilter: conntrack: fix race in
 __nf_conntrack_confirm against get_next_corpse
Message-ID: <20141207181530.GB3952@salvia>
References: <20141205223305.514276242@linuxfoundation.org>
 <20141205223324.613437397@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141205223324.613437397@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, withdraw this patch. It has been reverted.

Thanks Greg.

On Fri, Dec 05, 2014 at 02:44:56PM -0800, Greg Kroah-Hartman wrote:
> 3.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: bill bonaparte <programme110@gmail.com>
> 
> commit 5195c14c8b27cc0b18220ddbf0e5ad3328a04187 upstream.
> 
> After removal of the central spinlock nf_conntrack_lock, in
> commit 93bb0ceb75be2 ("netfilter: conntrack: remove central
> spinlock nf_conntrack_lock"), it is possible to race against
> get_next_corpse().
> 
> The race is against the get_next_corpse() cleanup on
> the "unconfirmed" list (a per-cpu list with seperate locking),
> which set the DYING bit.
> 
> Fix this race, in __nf_conntrack_confirm(), by removing the CT
> from unconfirmed list before checking the DYING bit.  In case
> race occured, re-add the CT to the dying list.
> 
> While at this, fix coding style of the comment that has been
> updated.
> 
> Fixes: 93bb0ceb75be2 ("netfilter: conntrack: remove central spinlock nf_conntrack_lock")
> Reported-by: bill bonaparte <programme110@gmail.com>
> Signed-off-by: bill bonaparte <programme110@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  net/netfilter/nf_conntrack_core.c |   14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -611,12 +611,16 @@ __nf_conntrack_confirm(struct sk_buff *s
>  	 */
>  	NF_CT_ASSERT(!nf_ct_is_confirmed(ct));
>  	pr_debug("Confirming conntrack %p\n", ct);
> -	/* We have to check the DYING flag inside the lock to prevent
> -	   a race against nf_ct_get_next_corpse() possibly called from
> -	   user context, else we insert an already 'dead' hash, blocking
> -	   further use of that particular connection -JM */
> +
> +	/* We have to check the DYING flag after unlink to prevent
> +	 * a race against nf_ct_get_next_corpse() possibly called from
> +	 * user context, else we insert an already 'dead' hash, blocking
> +	 * further use of that particular connection -JM.
> +	 */
> +	nf_ct_del_from_dying_or_unconfirmed_list(ct);
>  
>  	if (unlikely(nf_ct_is_dying(ct))) {
> +		nf_ct_add_to_dying_list(ct);
>  		nf_conntrack_double_unlock(hash, reply_hash);
>  		local_bh_enable();
>  		return NF_ACCEPT;
> @@ -636,8 +640,6 @@ __nf_conntrack_confirm(struct sk_buff *s
>  		    zone == nf_ct_zone(nf_ct_tuplehash_to_ctrack(h)))
>  			goto out;
>  
> -	nf_ct_del_from_dying_or_unconfirmed_list(ct);
> -
>  	/* Timer relative to confirmation time, not original
>  	   setting time, otherwise we'd get timer wrap in
>  	   weird delay cases. */
> 
> 
