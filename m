Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3G3PYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:24:46 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59597 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab3G3PXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:23:46 -0400
Date: Mon, 29 Jul 2013 10:01:47 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 1/5] rbtree: add postorder iteration functions
Message-ID: <20130729150147.GA4381@variantweb.net>
References: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
 <1374873223-25557-2-git-send-email-cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374873223-25557-2-git-send-email-cody@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073015-8878-0000-0000-0000082C328D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 02:13:39PM -0700, Cody P Schafer wrote:
> Add postorder iteration functions for rbtree. These are useful for
> safely freeing an entire rbtree without modifying the tree at all.
> 
> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  include/linux/rbtree.h |  4 ++++
>  lib/rbtree.c           | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
> index 0022c1b..2879e96 100644
> --- a/include/linux/rbtree.h
> +++ b/include/linux/rbtree.h
> @@ -68,6 +68,10 @@ extern struct rb_node *rb_prev(const struct rb_node *);
>  extern struct rb_node *rb_first(const struct rb_root *);
>  extern struct rb_node *rb_last(const struct rb_root *);
> 
> +/* Postorder iteration - always visit the parent after it's children */

s/it's/its/

> +extern struct rb_node *rb_first_postorder(const struct rb_root *);
> +extern struct rb_node *rb_next_postorder(const struct rb_node *);
> +
>  /* Fast replacement of a single node without remove/rebalance/add/rebalance */
>  extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
>  			    struct rb_root *root);
> diff --git a/lib/rbtree.c b/lib/rbtree.c
> index c0e31fe..65f4eff 100644
> --- a/lib/rbtree.c
> +++ b/lib/rbtree.c
> @@ -518,3 +518,43 @@ void rb_replace_node(struct rb_node *victim, struct rb_node *new,
>  	*new = *victim;
>  }
>  EXPORT_SYMBOL(rb_replace_node);
> +
> +static struct rb_node *rb_left_deepest_node(const struct rb_node *node)
> +{
> +	for (;;) {
> +		if (node->rb_left)
> +			node = node->rb_left;

Assigning to an argument passed as const seems weird to me.  I would
think it shouldn't compile but it does.  I guess my understanding of
const is incomplete.

> +		else if (node->rb_right)
> +			node = node->rb_right;
> +		else
> +			return (struct rb_node *)node;
> +	}
> +}
> +
> +struct rb_node *rb_next_postorder(const struct rb_node *node)
> +{
> +	const struct rb_node *parent;
> +	if (!node)
> +		return NULL;
> +	parent = rb_parent(node);

Again here.

Seth

> +
> +	/* If we're sitting on node, we've already seen our children */
> +	if (parent && node == parent->rb_left && parent->rb_right) {
> +		/* If we are the parent's left node, go to the parent's right
> +		 * node then all the way down to the left */
> +		return rb_left_deepest_node(parent->rb_right);
> +	} else
> +		/* Otherwise we are the parent's right node, and the parent
> +		 * should be next */
> +		return (struct rb_node *)parent;
> +}
> +EXPORT_SYMBOL(rb_next_postorder);
> +
> +struct rb_node *rb_first_postorder(const struct rb_root *root)
> +{
> +	if (!root->rb_node)
> +		return NULL;
> +
> +	return rb_left_deepest_node(root->rb_node);
> +}
> +EXPORT_SYMBOL(rb_first_postorder);
> -- 
> 1.8.3.4
> 

