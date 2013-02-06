Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796Ab3BFUHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:07:25 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:47845 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780Ab3BFUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:07:18 -0500
Message-ID: <5112B7F2.9060005@gmail.com>
Date: Wed, 06 Feb 2013 15:07:14 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Sridhar Samudrala <sri@us.ibm.com>, linux-sctp@vger.kernel.org
Subject: Re: [PATCH 76/77] sctp: convert to idr_alloc()
References: <1360179649-22465-1-git-send-email-tj@kernel.org> <1360179649-22465-77-git-send-email-tj@kernel.org>
In-Reply-To: <1360179649-22465-77-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 02:40 PM, Tejun Heo wrote:
> Convert to the much saner new idr interface.
>
> Only compile tested.
>
> v2: Don't preload if @gfp doesn't contain __GFP_WAIT as the function
>      may be being called from non-process ocntext.  Also, add a comment
>      explaining @idr_low never becomes zero.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Cc: Vlad Yasevich <vyasevich@gmail.com>

Acked-by: Vlad Yasevich <vyasevich@gmail.com>

-vlad

> Cc: Sridhar Samudrala <sri@us.ibm.com>
> Cc: linux-sctp@vger.kernel.org
> ---
>   net/sctp/associola.c | 31 +++++++++++++++----------------
>   1 file changed, 15 insertions(+), 16 deletions(-)
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index b45ed1f..0c9a791 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -1592,32 +1592,31 @@ int sctp_assoc_lookup_laddr(struct sctp_association *asoc,
>   /* Set an association id for a given association */
>   int sctp_assoc_set_id(struct sctp_association *asoc, gfp_t gfp)
>   {
> -	int assoc_id;
> -	int error = 0;
> +	bool preload = gfp & __GFP_WAIT;
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
> +	if (preload)
> +		idr_preload(gfp);
>   	spin_lock_bh(&sctp_assocs_id_lock);
> -	error = idr_get_new_above(&sctp_assocs_id, (void *)asoc,
> -				    idr_low, &assoc_id);
> -	if (!error) {
> -		idr_low = assoc_id + 1;
> +	/* 0 is not a valid id, idr_low is always >= 1 */
> +	ret = idr_alloc(&sctp_assocs_id, asoc, idr_low, 0, GFP_NOWAIT);
> +	if (ret >= 0) {
> +		idr_low = ret + 1;
>   		if (idr_low == INT_MAX)
>   			idr_low = 1;
>   	}
>   	spin_unlock_bh(&sctp_assocs_id_lock);
> -	if (error == -EAGAIN)
> -		goto retry;
> -	else if (error)
> -		return error;
> +	if (preload)
> +		idr_preload_end();
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

