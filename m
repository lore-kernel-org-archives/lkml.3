Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaETQ4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:56:55 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:38070 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751266AbaETQ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:56:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3871:4321:5007:6119:7652:7901:7903:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lock43_1b34a474f21a
X-Filterd-Recvd-Size: 2173
Message-ID: <1400605009.26709.4.camel@joe-AO725>
Subject: Re: [PATCH 1/1] fs/jbd/revoke.c: replace shift loop by ilog2
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>
Date: Tue, 20 May 2014 09:56:49 -0700
In-Reply-To: <20140520185016.b3f3d5bfe3ad6fc832d8c792@skynet.be>
References: <20140520185016.b3f3d5bfe3ad6fc832d8c792@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 18:50 +0200, Fabian Frederick wrote:
> journal_init_revoke_table is only called with positive hash_size
> (JOURNAL_REVOKE_DEFAULT_HASH) so we can replace loop shift by ilog2

This commit message is lacking something like:

Also replace index variable tmp with the more commonly used i.

> diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
[]
> @@ -231,19 +231,15 @@ record_cache_failure:
>  
>  static struct jbd_revoke_table_s *journal_init_revoke_table(int hash_size)
>  {
> -	int shift = 0;
> -	int tmp = hash_size;
> +	int i;
>  	struct jbd_revoke_table_s *table;
>  
>  	table = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
>  	if (!table)
>  		goto out;
>  
> -	while((tmp >>= 1UL) != 0UL)
> -		shift++;
> -
>  	table->hash_size = hash_size;
> -	table->hash_shift = shift;
> +	table->hash_shift = ilog2(hash_size);
>  	table->hash_table =
>  		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
>  	if (!table->hash_table) {
> @@ -252,8 +248,8 @@ static struct jbd_revoke_table_s *journal_init_revoke_table(int hash_size)
>  		goto out;
>  	}
>  
> -	for (tmp = 0; tmp < hash_size; tmp++)
> -		INIT_LIST_HEAD(&table->hash_table[tmp]);
> +	for (i = 0; i < hash_size; i++)
> +		INIT_LIST_HEAD(&table->hash_table[i]);
>  
>  out:
>  	return table;



