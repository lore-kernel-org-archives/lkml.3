Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaHAM2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:28:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaHAM2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:28:00 -0400
Message-ID: <53DB864B.2070205@redhat.com>
Date: Fri, 01 Aug 2014 14:21:31 +0200
From: Nikolay Aleksandrov <nikolay@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Graf <tgraf@suug.ch>, davem@davemloft.net, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, challa@noironetworks.com, walpole@cs.pdx.edu,
        dev@openvswitch.org, tklauser@distanz.ch,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] nftables: Convert nft_hash to use generic
 rhashtable
References: <cover.1406891028.git.tgraf@suug.ch> <bd4d9fa542072358cb0bd77e493ec5785a1d9666.1406891028.git.tgraf@suug.ch>
In-Reply-To: <bd4d9fa542072358cb0bd77e493ec5785a1d9666.1406891028.git.tgraf@suug.ch>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 01:58 PM, Thomas Graf wrote:
> The sizing of the hash table and the practice of requiring a lookup
> to retrieve the pprev to be stored in the element cookie before the
> deletion of an entry is left intact.
> 
> Signed-off-by: Thomas Graf <tgraf@suug.ch>
> Acked-by: Patrick McHardy <kaber@trash.net>
> ---
<<snip>>
> @@ -257,36 +82,28 @@ static void nft_hash_elem_destroy(const struct nft_set *set,
>  static void nft_hash_remove(const struct nft_set *set,
>  			    const struct nft_set_elem *elem)
>  {
> -	struct nft_hash *priv = nft_set_priv(set);
> -	struct nft_hash_table *tbl = nft_dereference(priv->tbl);
> -	struct nft_hash_elem *he, __rcu **pprev;
> +	struct rhashtable *priv = nft_set_priv(set);
> +	struct rhash_head *he, __rcu **pprev;
>  
>  	pprev = elem->cookie;
> -	he = nft_dereference((*pprev));
> -
> -	RCU_INIT_POINTER(*pprev, he->next);
> -	synchronize_rcu();
> -	kfree(he);
> +	he = rht_dereference((*pprev), priv);
>  
> -	/* Shrink table beneath 30% load */
> -	if (set->nelems - 1 < tbl->size * 3 / 10 &&
> -	    tbl->size > NFT_HASH_MIN_SIZE)
> -		nft_hash_tbl_shrink(set, priv);
> +	rhashtable_remove_pprev(priv, he, pprev, GFP_KERNEL);
>  }
<<snip>>
Hi again,
Sorry for the late response but I just got around to check the 3rd patch now,
so my question about this fragment is: before nft_hash_remove() would free the
element after removal, but after this change I don't see where and when the
removed element would get freed ?

Nik

