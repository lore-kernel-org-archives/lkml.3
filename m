Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbaDHIXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 04:23:48 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:40250 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaDHIXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:23:44 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        peterz@infradead.org, eranian@google.com, andi.kleen@intel.com
Subject: Re: [PATCH 09/15 V3] perf, c2c: Sort based on hottest cache line
References: <1395689826-215033-1-git-send-email-dzickus@redhat.com>
	<1395689826-215033-10-git-send-email-dzickus@redhat.com>
Date: Tue, 08 Apr 2014 17:23:41 +0900
In-Reply-To: <1395689826-215033-10-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Mon, 24 Mar 2014 15:37:00 -0400")
Message-ID: <877g70w7oy.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2014 15:37:00 -0400, Don Zickus wrote:
> Now that we have all the events sort on a unique address, we can walk
> the rbtree sequential and count up all the HITMs for each cacheline
> fairly easily.
>
> Once we encounter a new event on a different cacheline, process the previous
> cacheline.  That includes determining if any HITMs were present on that
> cacheline and if so, add it to another rbtree sorted on the number of HITMs.
>
> This second rbtree sorted on number of HITMs will be the interesting data
> we want to report and will be displayed in a follow up patch.
>
> For now, organize the data properly.

just a few minor nitpicks below..


> +static int c2c_hitm__add_to_list(struct rb_root *root, struct c2c_hit *h)

Why does it have 'list' in the name while it's not a list?  Maybe just
using c2c_hit__add_entry() ?


> +{
> +	struct rb_node **p;
> +	struct rb_node *parent = NULL;
> +	struct c2c_hit *he;
> +	int64_t cmp;
> +	u64 l_hitms, r_hitms;
> +
> +	p = &root->rb_node;
> +
> +	while (*p != NULL) {
> +		parent = *p;
> +		he = rb_entry(parent, struct c2c_hit, rb_node);
> +
> +		/* sort on remote hitms first */
> +		l_hitms = he->stats.t.rmt_hitm;
> +		r_hitms = h->stats.t.rmt_hitm;
> +		cmp = r_hitms - l_hitms;
> +
> +		if (!cmp) {
> +			/* sort on local hitms */
> +			l_hitms = he->stats.t.lcl_hitm;
> +			r_hitms = h->stats.t.lcl_hitm;
> +			cmp = r_hitms - l_hitms;
> +		}
> +
> +		if (cmp > 0)
> +			p = &(*p)->rb_left;
> +		else
> +			p = &(*p)->rb_right;
> +	}
> +
> +	rb_link_node(&h->rb_node, parent, p);
> +	rb_insert_color(&h->rb_node, root);
> +
> +	return 0;
> +}


[SNIP]
> +static void c2c_hit__update_strings(struct c2c_hit *h,
> +				    struct hist_entry *n)

This one also has nothing with any string IMHO.


> +{
> +	if (h->pid != n->thread->pid_)
> +		h->pid = -1;
> +
> +	if (h->tid != n->thread->tid)
> +		h->tid = -1;
> +
> +	/* use original addresses here, not adjusted al_addr */
> +	if (h->iaddr != n->mem_info->iaddr.addr)
> +		h->iaddr = -1;
> +
> +	if (CLADRS(h->daddr) != CLADRS(n->mem_info->daddr.addr))
> +		h->daddr = -1;
> +
> +	CPU_SET(n->cpu, &h->stats.cpuset);
> +}


[SNIP]
> +static void c2c_analyze_hitms(struct perf_c2c *c2c)
> +{
> +
> +	struct rb_node *next = rb_first(c2c->hists.entries_in);
> +	struct hist_entry *he;
> +	struct c2c_hit *h = NULL;
> +	struct c2c_stats hitm_stats;
> +	struct rb_root hitm_tree = RB_ROOT;
> +	int shared_clines = 0;

It seems the shared_clines is set but not used in this patch.  Maybe
it'd better moving it to a patch which use it actually.

Thanks,
Namhyung


> +	u64 cl = 0;
> +
> +	memset(&hitm_stats, 0, sizeof(struct c2c_stats));
> +
> +	/* find HITMs */
> +	while (next) {
> +		he = rb_entry(next, struct hist_entry, rb_node_in);
> +		next = rb_next(&he->rb_node_in);
> +
> +		cl = he->mem_info->daddr.al_addr;
> +
> +		/* switch cache line objects */
> +		/* 'color' forces a boundary change based on the original sort */
> +		if (!h || !he->color || (CLADRS(cl) != h->cacheline)) {
> +			if (h && HAS_HITMS(h)) {
> +				c2c_hit__update_stats(&hitm_stats, &h->stats);
> +
> +				/* sort based on hottest cacheline */
> +				c2c_hitm__add_to_list(&hitm_tree, h);
> +				shared_clines++;
> +			} else {
> +				/* stores-only are un-interesting */
> +				free(h);
> +			}
> +			h = c2c_hit__new(CLADRS(cl), he);
> +			if (!h)
> +				goto cleanup;
> +		}
> +
> +
> +		c2c_decode_stats(&h->stats, he);
> +
> +		/* filter out non-hitms as un-interesting noise */
> +		if (valid_hitm_or_store(&he->mem_info->data_src)) {
> +			/* save the entry for later processing */
> +			list_add_tail(&he->pairs.node, &h->list);
> +
> +			c2c_hit__update_strings(h, he);
> +		}
> +	}
> +
> +	/* last chunk */
> +	if (h && HAS_HITMS(h)) {
> +		c2c_hit__update_stats(&hitm_stats, &h->stats);
> +		c2c_hitm__add_to_list(&hitm_tree, h);
> +		shared_clines++;
> +	} else
> +		free(h);
> +
> +cleanup:
> +	next = rb_first(&hitm_tree);
> +	while (next) {
> +		h = rb_entry(next, struct c2c_hit, rb_node);
> +		next = rb_next(&h->rb_node);
> +		rb_erase(&h->rb_node, &hitm_tree);
> +
> +		free(h);
> +	}
> +	return;
> +}
