Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaEUI2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:28:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaEUI2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:28:03 -0400
Date: Wed, 21 May 2014 10:28:00 +0200
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jack <jack@suse.cz>,
        akpm <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/1] fs/jbd/revoke.c: replace shift loop by ilog2
Message-ID: <20140521082800.GC24479@quack.suse.cz>
References: <20140520185016.b3f3d5bfe3ad6fc832d8c792@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520185016.b3f3d5bfe3ad6fc832d8c792@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-05-14 18:50:16, Fabian Frederick wrote:
> journal_init_revoke_table is only called with positive hash_size
> (JOURNAL_REVOKE_DEFAULT_HASH) so we can replace loop shift by ilog2
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Joe Perches <joe@perches.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
  Thanks. I've merged the patch to my tree.

								Honza
> ---
>  fs/jbd/revoke.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
> index 25c713e..8898bbd 100644
> --- a/fs/jbd/revoke.c
> +++ b/fs/jbd/revoke.c
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
> -- 
> 1.8.4.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
