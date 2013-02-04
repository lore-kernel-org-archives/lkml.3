Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3BDQWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:22:32 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:62574 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3BDQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:22:30 -0500
Message-ID: <510FE042.8040503@gmail.com>
Date: Mon, 04 Feb 2013 11:22:26 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        Sridhar Samudrala <sri@us.ibm.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
Subject: Re: [PATCH 60/62] sctp: convert to idr_alloc()
References: <1359854463-2538-1-git-send-email-tj@kernel.org> <1359854463-2538-61-git-send-email-tj@kernel.org>
In-Reply-To: <1359854463-2538-61-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2013 08:21 PM, Tejun Heo wrote:
> Convert to the much saner new idr interface.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vlad Yasevich <vyasevich@gmail.com>
> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: linux-sctp@vger.kernel.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.
>
>   net/sctp/associola.c | 27 +++++++++++----------------
>   1 file changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index b45ed1f..a9962e4 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1592,32 +1592,27 @@ int sctp_assoc_lookup_laddr(struct sctp_association *asoc,
>   /* Set an association id for a given association */
>   int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
>   {
> -	int assoc_id;
> -	int error = 0;
> +	int ret;
>
>   	/* If the id is already assigned, keep it. */
>   	if (asoc->assoc_id)
> -		return error;
> -retry:
> -	if (unlikely(!idr_pre_get(&sctp_assocs_id, gfp)))
> -		return -ENOMEM;
> +		return 0;
>
> +	idr_preload(gfp);
>   	spin_lock_bh(&sctp_assocs_id_lock);
> -	error = idr_get_new_above(&sctp_assocs_id, (void *)asoc,
> -				    idr_low, &assoc_id);
> -	if (!error) {
> -		idr_low = assoc_id + 1;
> +	ret = idr_alloc(&sctp_assocs_id, asoc, idr_low, 0, GFP_NOWAIT);
> +	if (ret >= 0) {

In SCTP, association id is not allowed to be 0, so we have to treat 0 as 
an error.

-vlad

> +		idr_low = ret + 1;
>   		if (idr_low == INT_MAX)
>   			idr_low = 1;
>   	}
>   	spin_unlock_bh(&sctp_assocs_id_lock);
> -	if (error == -EAGAIN)
> -		goto retry;
> -	else if (error)
> -		return error;
> +	idr_preload_end();
> +	if (ret < 0)
> +		return ret;
>
> -	asoc->assoc_id = (sctp_assoc_t) assoc_id;
> -	return error;
> +	asoc->assoc_id = (sctp_assoc_t)ret;
> +	return 0;
>   }
>
>   /* Free the ASCONF queue */
>

