Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab3J2S6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:58:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab3J2S6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:58:35 -0400
Date: Tue, 29 Oct 2013 19:58:29 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] llists: move llist_reverse_order from raid5 to
 llist.c
Message-ID: <20131029185829.GA9568@quack.suse.cz>
References: <20131024151921.537751910@bombadil.infradead.org>
 <20131024152314.028154051@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024152314.028154051@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-10-13 08:19:26, Christoph Hellwig wrote:
> Make this useful helper available for other users.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/raid5.c    |   14 --------------
>  include/linux/llist.h |    2 ++
>  lib/llist.c           |   22 ++++++++++++++++++++++
>  3 files changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 7ff4f25..046f1a9 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -293,20 +293,6 @@ static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
>  		do_release_stripe(conf, sh);
>  }
>  
> -static struct llist_node *llist_reverse_order(struct llist_node *head)
> -{
> -	struct llist_node *new_head = NULL;
> -
> -	while (head) {
> -		struct llist_node *tmp = head;
> -		head = head->next;
> -		tmp->next = new_head;
> -		new_head = tmp;
> -	}
> -
> -	return new_head;
> -}
> -
>  /* should hold conf->device_lock already */
>  static int release_stripe_list(struct r5conf *conf)
>  {
> diff --git a/include/linux/llist.h b/include/linux/llist.h
> index 8828a78..fbf10a0 100644
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -195,4 +195,6 @@ static inline struct llist_node *llist_del_all(struct llist_head *head)
>  
>  extern struct llist_node *llist_del_first(struct llist_head *head);
>  
> +struct llist_node *llist_reverse_order(struct llist_node *head);
> +
>  #endif /* LLIST_H */
> diff --git a/lib/llist.c b/lib/llist.c
> index 4a70d12..ef48b87 100644
> --- a/lib/llist.c
> +++ b/lib/llist.c
> @@ -81,3 +81,25 @@ struct llist_node *llist_del_first(struct llist_head *head)
>  	return entry;
>  }
>  EXPORT_SYMBOL_GPL(llist_del_first);
> +
> +/**
> + * llist_reverse_order - reverse order of a llist chain
> + * @head:	first item of the list to be reversed
> + *
> + * Reverse the oder of a chain of llist entries and return the
                  ^^ order

  Otherwise the patch looks fine. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> + * new first entry.
> + */
> +struct llist_node *llist_reverse_order(struct llist_node *head)
> +{
> +	struct llist_node *new_head = NULL;
> +
> +	while (head) {
> +		struct llist_node *tmp = head;
> +		head = head->next;
> +		tmp->next = new_head;
> +		new_head = tmp;
> +	}
> +
> +	return new_head;
> +}
> +EXPORT_SYMBOL_GPL(llist_reverse_order);
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
