Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab3BVVEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:04:32 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:59142 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab3BVVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:04:31 -0500
Date: Fri, 22 Feb 2013 13:03:51 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ric Mason <ric.masonn@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Petr Holasek <pholasek@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] ksm: treat unstable nid like in stable tree
In-Reply-To: <51271A7D.6020305@gmail.com>
Message-ID: <alpine.LNX.2.00.1302221250440.6100@eggly.anvils>
References: <alpine.LNX.2.00.1302210013120.17843@eggly.anvils> <alpine.LNX.2.00.1302210019390.17843@eggly.anvils> <51271A7D.6020305@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2013, Ric Mason wrote:
> On 02/21/2013 04:20 PM, Hugh Dickins wrote:
> > An inconsistency emerged in reviewing the NUMA node changes to KSM:
> > when meeting a page from the wrong NUMA node in a stable tree, we say
> > that it's okay for comparisons, but not as a leaf for merging; whereas
> > when meeting a page from the wrong NUMA node in an unstable tree, we
> > bail out immediately.
> 
> IIUC
> - ksm page from the wrong NUMA node will be add to current node's stable tree

That should never happen (and when I was checking with a WARN_ON it did
not happen).  What can happen is that a node already in a stable tree
has its page migrated away to another NUMA node.

> - normal page from the wrong NUMA node will be merged to current node's
> stable tree  <- where I miss here? I didn't see any special handling in
> function stable_tree_search for this case.

	nid = get_kpfn_nid(page_to_pfn(page));
	root = root_stable_tree + nid;

to choose the right tree for the page, and

				if (get_kpfn_nid(stable_node->kpfn) !=
						NUMA(stable_node->nid)) {
					put_page(tree_page);
					goto replace;
				}

to make sure that we don't latch on to a node whose page got migrated away.

> - normal page from the wrong NUMA node will compare but not as a leaf for
> merging after the patch

I don't understand you there, but hope my remarks above resolve it.

Hugh
