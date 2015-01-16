Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbbAPPhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:37:48 -0500
Received: from stinky.trash.net ([213.144.137.162]:43201 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbbAPPhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:37:46 -0500
Date: Fri, 16 Jan 2015 15:37:40 +0000
From: Patrick McHardy <kaber@trash.net>
To: Thomas Graf <tgraf@suug.ch>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, paulmck@linux.vnet.ibm.com,
        edumazet@google.com, john.r.fastabend@intel.com, josh@joshtriplett.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/9] rhashtable: Do hashing inside of
 rhashtable_lookup_compare()
Message-ID: <20150116153740.GG30132@acer.localdomain>
References: <cover.1420230585.git.tgraf@suug.ch>
 <d579f486c3d4a88744dffc23a794601b025b41f4.1420230585.git.tgraf@suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d579f486c3d4a88744dffc23a794601b025b41f4.1420230585.git.tgraf@suug.ch>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.01, Thomas Graf wrote:
> Hash the key inside of rhashtable_lookup_compare() like
> rhashtable_lookup() does. This allows to simplify the hashing
> functions and keep them private.

One more question:

> diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
> index 1e316ce..614ee09 100644
> --- a/net/netfilter/nft_hash.c
> +++ b/net/netfilter/nft_hash.c
> @@ -94,28 +94,40 @@ static void nft_hash_remove(const struct nft_set *set,
>  	kfree(he);
>  }
>  
> +struct nft_compare_arg {
> +	const struct nft_set *set;
> +	struct nft_set_elem *elem;
> +};
> +
> +static bool nft_hash_compare(void *ptr, void *arg)
> +{
> +	struct nft_hash_elem *he = ptr;
> +	struct nft_compare_arg *x = arg;
> +
> +	if (!nft_data_cmp(&he->key, &x->elem->key, x->set->klen)) {
> +		x->elem->cookie = &he->node;
> +		x->elem->flags = 0;
> +		if (x->set->flags & NFT_SET_MAP)
> +			nft_data_copy(&x->elem->data, he->data);

Is there any reason why we need to perform the assignments in the
compare function? The reason why I'm asking is because to add
timeout support, I need another compare function for nft_hash_lookup()
and I'd prefer to use a single one for both cases.

> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  static int nft_hash_get(const struct nft_set *set, struct nft_set_elem *elem)
>  {
>  	const struct rhashtable *priv = nft_set_priv(set);
> -	const struct bucket_table *tbl = rht_dereference_rcu(priv->tbl, priv);
> -	struct rhash_head __rcu * const *pprev;
> -	struct nft_hash_elem *he;
> -	u32 h;
> -
> -	h = rhashtable_hashfn(priv, &elem->key, set->klen);
> -	pprev = &tbl->buckets[h];
> -	rht_for_each_entry_rcu(he, tbl->buckets[h], node) {
> -		if (nft_data_cmp(&he->key, &elem->key, set->klen)) {
> -			pprev = &he->node.next;
> -			continue;
> -		}
> +	struct nft_compare_arg arg = {
> +		.set = set,
> +		.elem = elem,
> +	};
>  
> -		elem->cookie = (void *)pprev;
> -		elem->flags = 0;
> -		if (set->flags & NFT_SET_MAP)
> -			nft_data_copy(&elem->data, he->data);
> +	if (rhashtable_lookup_compare(priv, &elem->key,
> +				      &nft_hash_compare, &arg))
>  		return 0;
> -	}
> +
>  	return -ENOENT;
>  }
>  
