Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab3JWLHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 07:07:31 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40928 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3JWLH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 07:07:29 -0400
Date: Wed, 23 Oct 2013 12:07:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf callchain: Convert children list to rbtree
Message-ID: <20131023110723.GA2502@localhost.localdomain>
References: <1381468543-25334-2-git-send-email-namhyung@kernel.org>
 <tip-e369517ce5f796945c6af047b4e8b1d650e03458@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-e369517ce5f796945c6af047b4e8b1d650e03458@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 12:54:48AM -0700, tip-bot for Namhyung Kim wrote:
> Commit-ID:  e369517ce5f796945c6af047b4e8b1d650e03458
> Gitweb:     http://git.kernel.org/tip/e369517ce5f796945c6af047b4e8b1d650e03458
> Author:     Namhyung Kim <namhyung.kim@lge.com>
> AuthorDate: Fri, 11 Oct 2013 14:15:36 +0900
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Mon, 21 Oct 2013 17:33:23 -0300
> 
> perf callchain: Convert children list to rbtree
> 
> Current collapse stage has a scalability problem which can be reproduced
> easily with a parallel kernel build.
> 
> This is because it needs to traverse every children of callchains
> linearly during the collapse/merge stage.
> 
> Converting it to a rbtree reduced the overhead significantly.
> 
> On my 400MB perf.data file which recorded with make -j32 kernel build:
> 
>   $ time perf --no-pager report --stdio > /dev/null
> 
> before:
>   real	6m22.073s
>   user	6m18.683s
>   sys	0m0.706s
> 
> after:
>   real	0m20.780s
>   user	0m19.962s
>   sys	0m0.689s
> 
> During the perf report the overhead on append_chain_children went down
> from 96.69% to 18.16%:
> 
>   -  18.16%  perf  perf                [.] append_chain_children
>      - append_chain_children
>         - 77.48% append_chain_children
>            + 69.79% merge_chain_branch
>            - 22.96% append_chain_children
>               + 67.44% merge_chain_branch
>               + 30.15% append_chain_children
>               + 2.41% callchain_append
>            + 7.25% callchain_append
>         + 12.26% callchain_append
>         + 10.22% merge_chain_branch
>   +  11.58%  perf  perf                [.] dso__find_symbol
>   +   8.02%  perf  perf                [.] sort__comm_cmp
>   +   5.48%  perf  libc-2.17.so        [.] malloc_consolidate
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/r/1381468543-25334-2-git-send-email-namhyung@kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

I finally found some time to review this, and the patch looks good, thanks a lot Namhyung!

Just a few non critical thoughts:

> ---
>  tools/perf/util/callchain.c | 147 +++++++++++++++++++++++++++++++++-----------
>  tools/perf/util/callchain.h |  11 ++--
>  2 files changed, 116 insertions(+), 42 deletions(-)
> 
> diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
> index 482f680..e3970e3 100644
> --- a/tools/perf/util/callchain.c
> +++ b/tools/perf/util/callchain.c
> @@ -21,12 +21,6 @@
>  
>  __thread struct callchain_cursor callchain_cursor;
>  
> -#define chain_for_each_child(child, parent)	\
> -	list_for_each_entry(child, &parent->children, siblings)
> -
> -#define chain_for_each_child_safe(child, next, parent)	\
> -	list_for_each_entry_safe(child, next, &parent->children, siblings)

We can probably keep these APIs using the rb root iteration code.

There should be an rb_node_for_each() anyway, and rb_node_for_each_entry(). People
refused to have to have such an API because they feared it would encourage blind use
of this O(n log n) iteration. There is plenty of such usecase in practice though, especially
in perf. So I think we can now start to think about it for real.

> -
>  static void
>  rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
>  		    enum chain_mode mode)
> @@ -71,10 +65,16 @@ static void
>  __sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
>  		  u64 min_hit)
>  {
> +	struct rb_node *n;
>  	struct callchain_node *child;
>  
> -	chain_for_each_child(child, node)
> +	n = rb_first(&node->rb_root_in);
> +	while (n) {
> +		child = rb_entry(n, struct callchain_node, rb_node_in);
> +		n = rb_next(n);
> +
>  		__sort_chain_flat(rb_root, child, min_hit);
> +	}
>  
>  	if (node->hit && node->hit >= min_hit)
>  		rb_insert_callchain(rb_root, node, CHAIN_FLAT);
> @@ -94,11 +94,16 @@ sort_chain_flat(struct rb_root *rb_root, struct callchain_root *root,
>  static void __sort_chain_graph_abs(struct callchain_node *node,
>  				   u64 min_hit)
>  {
> +	struct rb_node *n;
>  	struct callchain_node *child;
>  
>  	node->rb_root = RB_ROOT;
> +	n = rb_first(&node->rb_root_in);
> +
> +	while (n) {
> +		child = rb_entry(n, struct callchain_node, rb_node_in);
> +		n = rb_next(n);
>  
> -	chain_for_each_child(child, node) {
>  		__sort_chain_graph_abs(child, min_hit);
>  		if (callchain_cumul_hits(child) >= min_hit)
>  			rb_insert_callchain(&node->rb_root, child,
> @@ -117,13 +122,18 @@ sort_chain_graph_abs(struct rb_root *rb_root, struct callchain_root *chain_root,
>  static void __sort_chain_graph_rel(struct callchain_node *node,
>  				   double min_percent)
>  {
> +	struct rb_node *n;
>  	struct callchain_node *child;
>  	u64 min_hit;
>  
>  	node->rb_root = RB_ROOT;
>  	min_hit = ceil(node->children_hit * min_percent);
>  
> -	chain_for_each_child(child, node) {
> +	n = rb_first(&node->rb_root_in);
> +	while (n) {
> +		child = rb_entry(n, struct callchain_node, rb_node_in);
> +		n = rb_next(n);
> +
>  		__sort_chain_graph_rel(child, min_percent);
>  		if (callchain_cumul_hits(child) >= min_hit)
>  			rb_insert_callchain(&node->rb_root, child,
> @@ -173,19 +183,26 @@ create_child(struct callchain_node *parent, bool inherit_children)
>  		return NULL;
>  	}
>  	new->parent = parent;
> -	INIT_LIST_HEAD(&new->children);
>  	INIT_LIST_HEAD(&new->val);
>  
>  	if (inherit_children) {
> -		struct callchain_node *next;
> +		struct rb_node *n;
> +		struct callchain_node *child;
> +
> +		new->rb_root_in = parent->rb_root_in;
> +		parent->rb_root_in = RB_ROOT;
>  
> -		list_splice(&parent->children, &new->children);
> -		INIT_LIST_HEAD(&parent->children);
> +		n = rb_first(&new->rb_root_in);
> +		while (n) {
> +			child = rb_entry(n, struct callchain_node, rb_node_in);
> +			child->parent = new;
> +			n = rb_next(n);
> +		}
>  
> -		chain_for_each_child(next, new)
> -			next->parent = new;
> +		/* make it the first child */
> +		rb_link_node(&new->rb_node_in, NULL, &parent->rb_root_in.rb_node);
> +		rb_insert_color(&new->rb_node_in, &parent->rb_root_in);
>  	}
> -	list_add_tail(&new->siblings, &parent->children);
>  
>  	return new;
>  }
> @@ -223,7 +240,7 @@ fill_node(struct callchain_node *node, struct callchain_cursor *cursor)
>  	}
>  }
>  
> -static void
> +static struct callchain_node *
>  add_child(struct callchain_node *parent,
>  	  struct callchain_cursor *cursor,
>  	  u64 period)
> @@ -235,6 +252,19 @@ add_child(struct callchain_node *parent,
>  
>  	new->children_hit = 0;
>  	new->hit = period;
> +	return new;
> +}
> +
> +static s64 match_chain(struct callchain_cursor_node *node,
> +		      struct callchain_list *cnode)
> +{
> +	struct symbol *sym = node->sym;
> +
> +	if (cnode->ms.sym && sym &&
> +	    callchain_param.key == CCKEY_FUNCTION)
> +		return cnode->ms.sym->start - sym->start;
> +	else
> +		return cnode->ip - node->ip;
>  }
>  
>  /*
> @@ -272,9 +302,33 @@ split_add_child(struct callchain_node *parent,
>  
>  	/* create a new child for the new branch if any */
>  	if (idx_total < cursor->nr) {
> +		struct callchain_node *first;
> +		struct callchain_list *cnode;
> +		struct callchain_cursor_node *node;
> +		struct rb_node *p, **pp;
> +
>  		parent->hit = 0;
> -		add_child(parent, cursor, period);
>  		parent->children_hit += period;
> +
> +		node = callchain_cursor_current(cursor);
> +		new = add_child(parent, cursor, period);
> +
> +		/*
> +		 * This is second child since we moved parent's children
> +		 * to new (first) child above.
> +		 */
> +		p = parent->rb_root_in.rb_node;
> +		first = rb_entry(p, struct callchain_node, rb_node_in);
> +		cnode = list_first_entry(&first->val, struct callchain_list,
> +					 list);
> +
> +		if (match_chain(node, cnode) < 0)
> +			pp = &p->rb_left;
> +		else
> +			pp = &p->rb_right;
> +
> +		rb_link_node(&new->rb_node_in, p, pp);
> +		rb_insert_color(&new->rb_node_in, &parent->rb_root_in);
>  	} else {
>  		parent->hit = period;
>  	}
> @@ -291,16 +345,40 @@ append_chain_children(struct callchain_node *root,
>  		      u64 period)
>  {
>  	struct callchain_node *rnode;
> +	struct callchain_cursor_node *node;
> +	struct rb_node **p = &root->rb_root_in.rb_node;
> +	struct rb_node *parent = NULL;
> +
> +	node = callchain_cursor_current(cursor);
> +	if (!node)
> +		return;
>  
>  	/* lookup in childrens */
> -	chain_for_each_child(rnode, root) {
> -		unsigned int ret = append_chain(rnode, cursor, period);
> +	while (*p) {
> +		s64 ret;
> +		struct callchain_list *cnode;
>  
> -		if (!ret)
> +		parent = *p;
> +		rnode = rb_entry(parent, struct callchain_node, rb_node_in);
> +		cnode = list_first_entry(&rnode->val, struct callchain_list,
> +					 list);
> +
> +		/* just check first entry */
> +		ret = match_chain(node, cnode);
> +		if (ret == 0) {
> +			append_chain(rnode, cursor, period);

Then append_chain() probably deserve a cleanup. In fact it shouldn't
anymore have code to handle cases where there is no match.

I'm adding that to my TODO-list.

>  			goto inc_children_hit;
> +		}
> +
> +		if (ret < 0)
> +			p = &parent->rb_left;
> +		else
> +			p = &parent->rb_right;
>  	}
>  	/* nothing in children, add to the current node */
> -	add_child(root, cursor, period);
> +	rnode = add_child(root, cursor, period);
> +	rb_link_node(&rnode->rb_node_in, parent, p);
> +	rb_insert_color(&rnode->rb_node_in, &root->rb_root_in);
>  
>  inc_children_hit:
>  	root->children_hit += period;
> @@ -325,28 +403,20 @@ append_chain(struct callchain_node *root,
>  	 */
>  	list_for_each_entry(cnode, &root->val, list) {
>  		struct callchain_cursor_node *node;
> -		struct symbol *sym;
>  
>  		node = callchain_cursor_current(cursor);
>  		if (!node)
>  			break;
>  
> -		sym = node->sym;
> -
> -		if (cnode->ms.sym && sym &&
> -		    callchain_param.key == CCKEY_FUNCTION) {
> -			if (cnode->ms.sym->start != sym->start)
> -				break;
> -		} else if (cnode->ip != node->ip)
> +		if (match_chain(node, cnode) != 0)
>  			break;
>  
> -		if (!found)
> -			found = true;
> +		found = true;
>  
>  		callchain_cursor_advance(cursor);
>  	}
>  
> -	/* matches not, relay on the parent */
> +	/* matches not, relay no the parent */

Probably some mistake?

>  	if (!found) {
>  		cursor->curr = curr_snap;
>  		cursor->pos = start;
> @@ -395,8 +465,9 @@ merge_chain_branch(struct callchain_cursor *cursor,
>  		   struct callchain_node *dst, struct callchain_node *src)
>  {
>  	struct callchain_cursor_node **old_last = cursor->last;
> -	struct callchain_node *child, *next_child;
> +	struct callchain_node *child;
>  	struct callchain_list *list, *next_list;
> +	struct rb_node *n;
>  	int old_pos = cursor->nr;
>  	int err = 0;
>  
> @@ -412,12 +483,16 @@ merge_chain_branch(struct callchain_cursor *cursor,
>  		append_chain_children(dst, cursor, src->hit);
>  	}
>  
> -	chain_for_each_child_safe(child, next_child, src) {
> +	n = rb_first(&src->rb_root_in);
> +	while (n) {
> +		child = container_of(n, struct callchain_node, rb_node_in);
> +		n = rb_next(n);
> +		rb_erase(&child->rb_node_in, &src->rb_root_in);

I'm not sure if it works that way. Maybe. Or maybe we can miss some entries
if we erase the parent and then we look at the next entry after the child.

For example:

       A
      / \
     B   C

All have the same weight. Then we can have:

n = first(); // n = A
child = next(n); // child = B


      C
      |
      B

remove(n) // remove A
n = child; // n = B
child = next(n); // child = NULL

Ok this probably can't happen. I guess we are supposed to end up with:

      B
      |
      C

Still the removal of parents behind a walk through children is scary. Maybe that works
but it's scary.

I'd rather have:

while ((entry = rb_first(root)) != NULL)
    rb_erase(root, entry);

> +
>  		err = merge_chain_branch(cursor, dst, child);
>  		if (err)
>  			break;
>  
> -		list_del(&child->siblings);
>  		free(child);
>  	}
>  
> diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
> index 2b585bc..7bb3602 100644
> --- a/tools/perf/util/callchain.h
> +++ b/tools/perf/util/callchain.h
> @@ -21,11 +21,11 @@ enum chain_order {
>  
>  struct callchain_node {
>  	struct callchain_node	*parent;
> -	struct list_head	siblings;
> -	struct list_head	children;
>  	struct list_head	val;
> -	struct rb_node		rb_node; /* to sort nodes in an rbtree */
> -	struct rb_root		rb_root; /* sorted tree of children */

This needs some more details I think. Also following this logic, rb_root should be rb_root_out.

> +	struct rb_node		rb_node_in; /* to insert nodes in an rbtree */
> +	struct rb_node		rb_node;    /* to sort nodes in an output tree */
> +	struct rb_root		rb_root_in; /* input tree of children */
> +	struct rb_root		rb_root;    /* sorted output tree of children */
>  	unsigned int		val_nr;
>  	u64			hit;
>  	u64			children_hit;
> @@ -86,13 +86,12 @@ extern __thread struct callchain_cursor callchain_cursor;
>  
>  static inline void callchain_init(struct callchain_root *root)
>  {
> -	INIT_LIST_HEAD(&root->node.siblings);
> -	INIT_LIST_HEAD(&root->node.children);
>  	INIT_LIST_HEAD(&root->node.val);
>  
>  	root->node.parent = NULL;
>  	root->node.hit = 0;
>  	root->node.children_hit = 0;
> +	root->node.rb_root_in = RB_ROOT;
>  	root->max_depth = 0;
>  }
>  

Ok other than that it's all good. I'm adding all these details in my TODO list and will send some
patches, thanks again for this optimization!
