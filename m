Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3BHAHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:07:11 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:36107 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3BHAHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:07:09 -0500
Date: Thu, 7 Feb 2013 16:07:17 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/11] ksm: reorganize ksm_check_stable_tree
In-Reply-To: <20130205164823.GJ21389@suse.de>
Message-ID: <alpine.LNX.2.00.1302071558100.2133@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils> <alpine.LNX.2.00.1301251758190.29196@eggly.anvils> <20130205164823.GJ21389@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Mel Gorman wrote:
> On Fri, Jan 25, 2013 at 05:59:35PM -0800, Hugh Dickins wrote:
> > Memory hotremove's ksm_check_stable_tree() is pitifully inefficient
> > (restarting whenever it finds a stale node to remove), but rearrange
> > so that at least it does not needlessly restart from nid 0 each time.
> > And add a couple of comments: here is why we keep pfn instead of page.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > ---
> >  mm/ksm.c |   38 ++++++++++++++++++++++----------------
> >  1 file changed, 22 insertions(+), 16 deletions(-)
> > 
> > --- mmotm.orig/mm/ksm.c	2013-01-25 14:36:52.152205940 -0800
> > +++ mmotm/mm/ksm.c	2013-01-25 14:36:53.244205966 -0800
> > @@ -1830,31 +1830,36 @@ void ksm_migrate_page(struct page *newpa
> >  #endif /* CONFIG_MIGRATION */
> >  
> >  #ifdef CONFIG_MEMORY_HOTREMOVE
> > -static struct stable_node *ksm_check_stable_tree(unsigned long start_pfn,
> > -						 unsigned long end_pfn)
> > +static void ksm_check_stable_tree(unsigned long start_pfn,
> > +				  unsigned long end_pfn)
> >  {
> > +	struct stable_node *stable_node;
> >  	struct rb_node *node;
> >  	int nid;
> >  
> > -	for (nid = 0; nid < nr_node_ids; nid++)
> > -		for (node = rb_first(&root_stable_tree[nid]); node;
> > -				node = rb_next(node)) {
> > -			struct stable_node *stable_node;
> > -
> > +	for (nid = 0; nid < nr_node_ids; nid++) {
> > +		node = rb_first(&root_stable_tree[nid]);
> > +		while (node) {
> 
> This is not your fault, the old code is wrong too. It is assuming that all
> nodes are populated in numeric orders with no holes. It won't work if just
> two nodes 0 and 4 are online. It should be using for_each_online_node().

If the old code is wrong, it probably would be my fault!  But I believe
this is okay: these rb_roots we're looking at, they are in memory which
is not being offlined, and the trees for offline nodes will simply be
empty, won't they?  Something's badly wrong if otherwise.

I certainly prefer to avoid for_each_online_node() etc: maybe I'm
confusing with for_each_online_something_else(), but experience tells
that you can get into nasty hotplug mutex ordering issues with those
things - not worth the pain if you can easily and safely avoid them.

Hugh
