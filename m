Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559Ab3JPJR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:17:59 -0400
Received: from smtp-in.kfki.hu ([148.6.0.26]:42933 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760148Ab3JPJR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:17:57 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Oct 2013 05:17:57 EDT
Date: Wed, 16 Oct 2013 11:12:01 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Thierry Reding <thierry.reding@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Maxime Jayat <maxime@artisandeveloppeur.fr>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the trivial tree
In-Reply-To: <1381845763-10487-2-git-send-email-treding@nvidia.com>
Message-ID: <alpine.DEB.2.10.1310161057190.13374@blackhole.kfki.hu>
References: <1381845763-10487-1-git-send-email-treding@nvidia.com> <1381845763-10487-2-git-send-email-treding@nvidia.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Thierry Reding wrote:

> Today's linux-next merge of the trivial tree got conflicts in
> 
> 	net/netfilter/xt_set.c
> 
> caused by commits 3f79410 (treewide: Fix common typo in "identify") and
> bd3129f (netfilter: ipset: order matches and targets separatedly in
> xt_set.c).
> 
> I fixed them up (see below). Please verify that the resolution looks
> good.

I don't really get it: patch bd3129f was part of a patchset, which was 
applied to net-next and there it was complete.

There's none of the patchset in question in linux-next, so what's the 
trivial tree? Where's lost what?

[The patch below doesn't look good, because it should contain the removed 
part for the revision 1 match due to the reordering in the file.]

Best regards,
Jozsef

> ---
> diff --cc net/netfilter/xt_set.c
> index e7c4e0e,4b9d6b4..80c2e2d
> --- a/net/netfilter/xt_set.c
> +++ b/net/netfilter/xt_set.c
> @@@ -81,10 -81,10 +81,10 @@@ set_match_v0_checkentry(const struct xt
>   	struct xt_set_info_match_v0 *info = par->matchinfo;
>   	ip_set_id_t index;
>   
>  -	index = ip_set_nfnl_get_byindex(info->match_set.index);
>  +	index = ip_set_nfnl_get_byindex(par->net, info->match_set.index);
>   
>   	if (index == IPSET_INVALID_ID) {
> - 		pr_warning("Cannot find set indentified by id %u to match\n",
> + 		pr_warning("Cannot find set identified by id %u to match\n",
>   			   info->match_set.index);
>   		return -ENOENT;
>   	}
> @@@ -106,104 -106,9 +106,104 @@@ set_match_v0_destroy(const struct xt_mt
>   {
>   	struct xt_set_info_match_v0 *info = par->matchinfo;
>   
>  -	ip_set_nfnl_put(info->match_set.index);
>  +	ip_set_nfnl_put(par->net, info->match_set.index);
>   }
>   
>  +/* Revision 1 match */
>  +
>  +static bool
>  +set_match_v1(const struct sk_buff *skb, struct xt_action_param *par)
>  +{
>  +	const struct xt_set_info_match_v1 *info = par->matchinfo;
>  +	ADT_OPT(opt, par->family, info->match_set.dim,
>  +		info->match_set.flags, 0, UINT_MAX);
>  +
>  +	if (opt.flags & IPSET_RETURN_NOMATCH)
>  +		opt.cmdflags |= IPSET_FLAG_RETURN_NOMATCH;
>  +
>  +	return match_set(info->match_set.index, skb, par, &opt,
>  +			 info->match_set.flags & IPSET_INV_MATCH);
>  +}
>  +
>  +static int
>  +set_match_v1_checkentry(const struct xt_mtchk_param *par)
>  +{
>  +	struct xt_set_info_match_v1 *info = par->matchinfo;
>  +	ip_set_id_t index;
>  +
>  +	index = ip_set_nfnl_get_byindex(par->net, info->match_set.index);
>  +
>  +	if (index == IPSET_INVALID_ID) {
> - 		pr_warning("Cannot find set indentified by id %u to match\n",
> ++		pr_warning("Cannot find set identified by id %u to match\n",
>  +			   info->match_set.index);
>  +		return -ENOENT;
>  +	}
>  +	if (info->match_set.dim > IPSET_DIM_MAX) {
>  +		pr_warning("Protocol error: set match dimension "
>  +			   "is over the limit!\n");
>  +		ip_set_nfnl_put(par->net, info->match_set.index);
>  +		return -ERANGE;
>  +	}
>  +
>  +	return 0;
>  +}
>  +
>  +static void
>  +set_match_v1_destroy(const struct xt_mtdtor_param *par)
>  +{
>  +	struct xt_set_info_match_v1 *info = par->matchinfo;
>  +
>  +	ip_set_nfnl_put(par->net, info->match_set.index);
>  +}
>  +
>  +/* Revision 3 match */
>  +
>  +static bool
>  +match_counter(u64 counter, const struct ip_set_counter_match *info)
>  +{
>  +	switch (info->op) {
>  +	case IPSET_COUNTER_NONE:
>  +		return true;
>  +	case IPSET_COUNTER_EQ:
>  +		return counter == info->value;
>  +	case IPSET_COUNTER_NE:
>  +		return counter != info->value;
>  +	case IPSET_COUNTER_LT:
>  +		return counter < info->value;
>  +	case IPSET_COUNTER_GT:
>  +		return counter > info->value;
>  +	}
>  +	return false;
>  +}
>  +
>  +static bool
>  +set_match_v3(const struct sk_buff *skb, struct xt_action_param *par)
>  +{
>  +	const struct xt_set_info_match_v3 *info = par->matchinfo;
>  +	ADT_OPT(opt, par->family, info->match_set.dim,
>  +		info->match_set.flags, info->flags, UINT_MAX);
>  +	int ret;
>  +
>  +	if (info->packets.op != IPSET_COUNTER_NONE ||
>  +	    info->bytes.op != IPSET_COUNTER_NONE)
>  +		opt.cmdflags |= IPSET_FLAG_MATCH_COUNTERS;
>  +
>  +	ret = match_set(info->match_set.index, skb, par, &opt,
>  +			info->match_set.flags & IPSET_INV_MATCH);
>  +
>  +	if (!(ret && opt.cmdflags & IPSET_FLAG_MATCH_COUNTERS))
>  +		return ret;
>  +
>  +	if (!match_counter(opt.ext.packets, &info->packets))
>  +		return 0;
>  +	return match_counter(opt.ext.bytes, &info->bytes);
>  +}
>  +
>  +#define set_match_v3_checkentry	set_match_v1_checkentry
>  +#define set_match_v3_destroy	set_match_v1_destroy
>  +
>  +/* Revision 0 interface: backward compatible with netfilter/iptables */
>  +
>   static unsigned int
>   set_target_v0(struct sk_buff *skb, const struct xt_action_param *par)
>   {
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
