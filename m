Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3A2CDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:03:15 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52375 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3A2CDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:03:13 -0500
Date: Mon, 28 Jan 2013 18:03:16 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/11] ksm: remove old stable nodes more thoroughly
In-Reply-To: <20130128154407.16a623a4.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1301281747210.4947@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251800550.29196@eggly.anvils> <20130128154407.16a623a4.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2013, Andrew Morton wrote:
> On Fri, 25 Jan 2013 18:01:59 -0800 (PST)
> Hugh Dickins <hughd@google.com> wrote:
> 
> > +static int remove_all_stable_nodes(void)
> > +{
> > +	struct stable_node *stable_node;
> > +	int nid;
> > +	int err = 0;
> > +
> > +	for (nid = 0; nid < nr_node_ids; nid++) {
> > +		while (root_stable_tree[nid].rb_node) {
> > +			stable_node = rb_entry(root_stable_tree[nid].rb_node,
> > +						struct stable_node, node);
> > +			if (remove_stable_node(stable_node)) {
> > +				err = -EBUSY;
> 
> It's a bit rude to overwrite remove_stable_node()'s return value.

Well.... yes, but only the tiniest bit rude :)

> 
> > +				break;	/* proceed to next nid */
> > +			}
> > +			cond_resched();
> 
> Why is this here?

Because we don't have a limit on the length of this loop, and if
every node which remove_stable_node() finds is already stale, and
has no rmap_item still attached, then there would be no rescheduling
point in the unbounded loop without this one.  I was taught to worry
about bad latencies even in unpreemptible kernels.

Hugh
