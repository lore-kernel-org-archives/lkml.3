Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3BUWE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:04:58 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40422 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab3BUWE4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:04:56 -0500
MIME-Version: 1.0
Message-ID: <3e397e72-5fb3-4f5b-9879-0c8060a172ac@default>
Date: Thu, 21 Feb 2013 14:03:30 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv6 0/8] zswap: compressed swap caching
References: <1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <9e251fb2-be82-41d2-b6cd-e46525b263cb@default>
 <512666B2.1020609@linux.vnet.ibm.com>
In-Reply-To: <512666B2.1020609@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCHv6 0/8] zswap: compressed swap caching
> 
> On 02/21/2013 09:50 AM, Dan Magenheimer wrote:
> >> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> >> Subject: [PATCHv6 0/8] zswap: compressed swap caching
> >>
> >> Changelog:
> >>
> >> v6:
> >> * fix improper freeing of rbtree (Cody)
> >
> > Cody's bug fix reminded me of a rather fundamental question:
> >
> > Why does zswap use a rbtree instead of a radix tree?
> >
> > Intuitively, I'd expect that pgoff_t values would
> > have a relatively high level of locality AND at any one time
> > the set of stored pgoff_t values would be relatively non-sparse.
> > This would argue that a radix tree would result in fewer nodes
> > touched on average for lookup/insert/remove.
> 
> I considered using a radix tree, but I don't think there is a compelling
> reason to choose a radix tree over a red-black tree in this case
> (explanation below).
> 
> From a runtime standpoint, a radix tree might be faster.  The swap
> offsets will be largely in linearly bunched groups over the indexed
> range.  However, there are also memory constraints to consider in this
> particular situation.
> 
> Using a radix tree could result in intermediate radix_tree_node
> allocations in the store (insert) path in addition to the zswap_entry
> allocation.  Since we are under memory pressure, using the red-black
> tree, whose metadata is included in the struct zswap_entry, reduces the
> number of opportunities to fail.
> 
> On my system, the radix_tree_node structure is 568 bytes.  The
> radix_tree_node cache requires 4 pages per slab, an order-2 page
> allocation.  Growing that cache will be difficult under the pressure.
> 
> In my mind, cost of even a single node allocation failure resulting in
> an additional page swapped to disk will more that wipe out any possible
> performance advantage using a radix tree might have.

For slab, I agree that makes good sense.  But slub (the default allocator)
falls back, I think, to order-0 if order-2 fails.
