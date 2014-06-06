Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaFFTxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 15:53:00 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51489 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaFFTw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 15:52:59 -0400
Date: Fri, 6 Jun 2014 12:51:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ken Helias <kenhelias@web.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ken Helias <kenhelias@firemail.de>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 03/13] list: Add list_add_(before|after) macros
In-Reply-To: <1402076072-4044-3-git-send-email-kenhelias@web.de>
Message-ID: <alpine.LSU.2.11.1406061242370.16010@eggly.anvils>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de> <1402076072-4044-3-git-send-email-kenhelias@web.de>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Ken Helias wrote:
> From: Ken Helias <kenhelias@firemail.de>
> 
> Many places in the code uses list_add_tail/list_add to insert an entry
> before/after another entry. This confuses the reader because these are usually
> used to add an item to a list_head and not an entry. hlist already have
> functions to do the same which makes the code a lot more readable. It would be
> a lot easier to understand when all places use a self explaining function name
> instead of misusing other functions.

I'll express my opinion: perhaps it's widely shared, perhaps it is not.

I think a patch like this (and the subsequent conversions) is unhelpful
churn.

The Linux struct list_head is designed and intended to be used for both
head and entry, and introducing aliases to make unnecessary distinctions
just hinders development instead of helping it.

If the reader is confused at first, I hope the reader will soon learn,
without needing to rely on aliases such as these.

Hugh

> 
> Signed-off-by: Ken Helias <kenhelias@firemail.de>
> Cc: Dipankar Sarma <dipankar@in.ibm.com>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ken Helias <kenhelias@firemail.de>
> Cc: Dave Jones <davej@redhat.com>
> ---
>  include/linux/list.h    | 22 ++++++++++++++++++++++
>  include/linux/rculist.h | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 60 insertions(+)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index ab43d01..5ea0eca 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -76,6 +76,28 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
>  	__list_add(new, head->prev, head);
>  }
>  
> +/**
> + * list_add_after
> + * @n: new entry to be added
> + * @prev: the existing element to add the new element after.
> + *
> + * Description:
> + * Adds the specified element to the specified list
> + * after the specified node.
> + */
> +#define list_add_after(n, prev) list_add(n, prev)
> +
> +/**
> + * list_add_before
> + * @n: new entry to be added
> + * @next:  the existing element to add the new element before.
> + *
> + * Description:
> + * Adds the specified element to the specified list
> + * before the specified node.
> + */
> +#define list_add_before(n, next) list_add_tail(n, next)
> +
>  /*
>   * Delete a list entry by making the prev/next entries
>   * point to each other.
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index 648773f..eec274d 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -103,6 +103,44 @@ static inline void list_add_tail_rcu(struct list_head *new,
>  }
>  
>  /**
> + * list_add_after_rcu
> + * @n: new entry to be added
> + * @prev: the existing element to add the new element after.
> + *
> + * Description:
> + * Adds the specified element to the specified list
> + * after the specified node while permitting racing traversals.
> + *
> + * The caller must take whatever precautions are necessary
> + * (such as holding appropriate locks) to avoid racing
> + * with another list-mutation primitive, such as list_add_rcu()
> + * or list_del_rcu(), running on this same list.
> + * However, it is perfectly legal to run concurrently with
> + * the _rcu list-traversal primitives, such as
> + * list_for_each_entry_rcu().
> + */
> +#define list_add_after_rcu(n, next) list_add_rcu(n, next)
> +
> +/**
> + * list_add_before_rcu
> + * @n: new entry to be added
> + * @next:  the existing element to add the new element before.
> + *
> + * Description:
> + * Adds the specified element to the specified list
> + * before the specified node while permitting racing traversals.
> + *
> + * The caller must take whatever precautions are necessary
> + * (such as holding appropriate locks) to avoid racing
> + * with another list-mutation primitive, such as list_add_tail_rcu()
> + * or list_del_rcu(), running on this same list.
> + * However, it is perfectly legal to run concurrently with
> + * the _rcu list-traversal primitives, such as
> + * list_for_each_entry_rcu().
> + */
> +#define list_add_before_rcu(n, next) list_add_tail_rcu(n, next)
> +
> +/**
>   * list_del_rcu - deletes entry from list without re-initialization
>   * @entry: the element to delete from the list.
>   *
> -- 
> 2.0.0
