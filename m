Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3A0XZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 18:25:55 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:48514 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3A0XZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 18:25:54 -0500
Date: Sun, 27 Jan 2013 15:25:54 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Simon Jeons <simon.jeons@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 8/11] ksm: make !merge_across_nodes migration safe
In-Reply-To: <1359276555.6763.6.camel@kernel>
Message-ID: <alpine.LNX.2.00.1301271514070.17495@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251803390.29196@eggly.anvils> <1359276555.6763.6.camel@kernel>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2013, Simon Jeons wrote:
> On Fri, 2013-01-25 at 18:05 -0800, Hugh Dickins wrote:
> > @@ -1344,10 +1401,29 @@ static void cmp_and_merge_page(struct pa
> >  	unsigned int checksum;
> >  	int err;
> >  
> > -	remove_rmap_item_from_tree(rmap_item);
> > +	stable_node = page_stable_node(page);
> > +	if (stable_node) {
> > +		if (stable_node->head != &migrate_nodes &&
> > +		    get_kpfn_nid(stable_node->kpfn) != NUMA(stable_node->nid)) {
> > +			rb_erase(&stable_node->node,
> > +				 &root_stable_tree[NUMA(stable_node->nid)]);
> > +			stable_node->head = &migrate_nodes;
> > +			list_add(&stable_node->list, stable_node->head);
> 
> Why list add &stable_node->list to stable_node->head? stable_node->head
> is used for queue what?

Read that as list_add(&stable_node->list, &migrate_nodes) if you prefer.
stable_node->head (overlaying stable_node->node.__rb_parent_color, which
would never point to migrate_nodes as an rb_node) &migrate_nodes is used
as "magic" to show that that rb_node is currently saved on this list,
rather than linked into the stable tree itself.  We could do some
#define MIGRATE_NODES_MAGIC 0xwhatever and put that in head instead.

> > @@ -1464,6 +1540,27 @@ static struct rmap_item *scan_get_next_r
> >  		 */
> >  		lru_add_drain_all();
> >  
> > +		/*
> > +		 * Whereas stale stable_nodes on the stable_tree itself
> > +		 * get pruned in the regular course of stable_tree_search(),
> 
> Which kinds of stable_nodes can be treated as stale? I just see remove
> rmap_item in stable_tree_search() and scan_get_next_rmap_item().

See get_ksm_page().
