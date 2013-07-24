Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3GXHAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:00:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33611 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3GXHAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:00:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130724155742.ff98a3230b70b4737fe0c31c@canb.auug.org.au>
References: <20130724155742.ff98a3230b70b4737fe0c31c@canb.auug.org.au>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 24 Jul 2013 15:00:27 +0800
Message-ID: <CA+a=Yy6jsVDAGA0ab6z4UdgKmqnQMCZbRfJX2+eoaBuFkbfChA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 staging tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Drokin <green@whamcloud.com>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 1:57 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Andrew,
>
> Today's linux-next merge of the akpm-current tree got a conflict in
> drivers/staging/lustre/lustre/ldlm/ldlm_pool.c between commit
> 91a50030f05e ("staging/lustre/ldlm: split client namespaces into active
> and inactive") from the staging tree and commit 48a91248649f
> ("staging/lustre/ldlm: convert to shrinkers to count/scan API") from the
> akpm-current tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
>
Hi Stephen,

How will such conflicts be handled in the end? Do I need to send
rebased patch to Andrew?

Thanks,
Tao

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
> index 101af4b,4c41e02..0000000
> --- a/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
> +++ b/drivers/staging/lustre/lustre/ldlm/ldlm_pool.c
> @@@ -597,16 -594,17 +593,17 @@@ int ldlm_pool_recalc(struct ldlm_pool *
>                 count = pl->pl_ops->po_recalc(pl);
>                 lprocfs_counter_add(pl->pl_stats, LDLM_POOL_RECALC_STAT,
>                                     count);
>  -              return count;
>         }
>  +      recalc_interval_sec = pl->pl_recalc_time - cfs_time_current_sec() +
>  +                            pl->pl_recalc_period;
>
>  -      return 0;
>  +      return recalc_interval_sec;
>   }
>  -EXPORT_SYMBOL(ldlm_pool_recalc);
>
> - /**
> + /*
>    * Pool shrink wrapper. Will call either client or server pool recalc callback
> -  * depending what pool \a pl is used.
> +  * depending what pool pl is used. When nr == 0, just return the number of
> +  * freeable locks. Otherwise, return the number of canceled locks.
>    */
>   int ldlm_pool_shrink(struct ldlm_pool *pl, int nr,
>                      unsigned int gfp_mask)
> @@@ -1028,26 -1025,20 +1025,21 @@@ static struct ptlrpc_thread *ldlm_pools
>   static struct completion ldlm_pools_comp;
>
>   /*
> -  * Cancel \a nr locks from all namespaces (if possible). Returns number of
> -  * cached locks after shrink is finished. All namespaces are asked to
> -  * cancel approximately equal amount of locks to keep balancing.
> +  * count locks from all namespaces (if possible). Returns number of
> +  * cached locks.
>    */
> - static int ldlm_pools_shrink(ldlm_side_t client, int nr,
> -                            unsigned int gfp_mask)
> + static unsigned long ldlm_pools_count(ldlm_side_t client, unsigned int gfp_mask)
>   {
> -       int total = 0, cached = 0, nr_ns;
> +       unsigned long total = 0, nr_ns;
>         struct ldlm_namespace *ns;
>  +      struct ldlm_namespace *ns_old = NULL; /* loop detection */
>         void *cookie;
>
> -       if (client == LDLM_NAMESPACE_CLIENT && nr != 0 &&
> -           !(gfp_mask & __GFP_FS))
> -               return -1;
> +       if (client == LDLM_NAMESPACE_CLIENT && !(gfp_mask & __GFP_FS))
> +               return 0;
>
> -       CDEBUG(D_DLMTRACE, "Request to shrink %d %s locks from all pools\n",
> -              nr, client == LDLM_NAMESPACE_CLIENT ? "client" : "server");
> +       CDEBUG(D_DLMTRACE, "Request to count %s locks from all pools\n",
> +              client == LDLM_NAMESPACE_CLIENT ? "client" : "server");
>
>         cookie = cl_env_reenter();
>
> @@@ -1094,8 -1080,8 +1096,8 @@@ static unsigned long ldlm_pools_scan(ld
>         /*
>          * Shrink at least ldlm_namespace_nr(client) namespaces.
>          */
> -       for (nr_ns = ldlm_namespace_nr_read(client) - nr_ns;
> -            nr_ns > 0; nr_ns--)
>  -      for (tmp = nr_ns = atomic_read(ldlm_namespace_nr(client));
> ++      for (tmp = nr_ns = ldlm_namespace_nr_read(client) - nr_ns;
> +            tmp > 0; tmp--)
>         {
>                 int cancel, nr_locks;
>
> @@@ -1125,26 -1108,36 +1124,36 @@@
>                 ldlm_namespace_put(ns);
>         }
>         cl_env_reexit(cookie);
> -       /* we only decrease the SLV in server pools shrinker, return -1 to
> -        * kernel to avoid needless loop. LU-1128 */
> -       return (client == LDLM_NAMESPACE_SERVER) ? -1 : cached;
> +       /*
> +        * we only decrease the SLV in server pools shrinker, return
> +        * SHRINK_STOP to kernel to avoid needless loop. LU-1128
> +        */
> +       return (client == LDLM_NAMESPACE_SERVER) ? SHRINK_STOP : freed;
> + }
> +
> + static unsigned long ldlm_pools_srv_count(struct shrinker *s, struct shrink_control *sc)
> + {
> +       return ldlm_pools_count(LDLM_NAMESPACE_SERVER, sc->gfp_mask);
>   }
>
> - static int ldlm_pools_srv_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
> + static unsigned long ldlm_pools_srv_scan(struct shrinker *s, struct shrink_control *sc)
>   {
> -       return ldlm_pools_shrink(LDLM_NAMESPACE_SERVER,
> -                                shrink_param(sc, nr_to_scan),
> -                                shrink_param(sc, gfp_mask));
> +       return ldlm_pools_scan(LDLM_NAMESPACE_SERVER, sc->nr_to_scan,
> +                              sc->gfp_mask);
>   }
>
> - static int ldlm_pools_cli_shrink(SHRINKER_ARGS(sc, nr_to_scan, gfp_mask))
> + static unsigned long ldlm_pools_cli_count(struct shrinker *s, struct shrink_control *sc)
>   {
> -       return ldlm_pools_shrink(LDLM_NAMESPACE_CLIENT,
> -                                shrink_param(sc, nr_to_scan),
> -                                shrink_param(sc, gfp_mask));
> +       return ldlm_pools_count(LDLM_NAMESPACE_CLIENT, sc->gfp_mask);
> + }
> +
> + static unsigned long ldlm_pools_cli_scan(struct shrinker *s, struct shrink_control *sc)
> + {
> +       return ldlm_pools_scan(LDLM_NAMESPACE_CLIENT, sc->nr_to_scan,
> +                              sc->gfp_mask);
>   }
>
>  -void ldlm_pools_recalc(ldlm_side_t client)
>  +int ldlm_pools_recalc(ldlm_side_t client)
>   {
>         __u32 nr_l = 0, nr_p = 0, l;
>         struct ldlm_namespace *ns;
