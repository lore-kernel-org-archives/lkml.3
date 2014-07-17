Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaGQAtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:49:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:53619 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbaGQAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:49:39 -0400
Date: Wed, 16 Jul 2014 17:49:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Bob Liu <bob.liu@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm, tmp: only collapse hugepages to nodes with affinity
 for zone_reclaim_mode
In-Reply-To: <53C69E92.70608@suse.cz>
Message-ID: <alpine.DEB.2.02.1407161748400.23892@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407141807030.8808@chino.kir.corp.google.com> <alpine.DEB.2.02.1407151712520.12279@chino.kir.corp.google.com> <53C5D3D2.8080000@oracle.com> <53C69E92.70608@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014, Vlastimil Babka wrote:

> >> @@ -2545,6 +2571,11 @@ static int khugepaged_scan_pmd(struct mm_struct *mm,
> >>  		 * hit record.
> >>  		 */
> >>  		node = page_to_nid(page);
> >> +		if (node != last_node) {
> >> +			if (khugepaged_scan_abort(node))
> >> +				goto out_unmap;
> > 
> > Nitpick: How about not break the loop but only reset the related
> > khugepaged_node_load[] to zero. E.g. modify khugepaged_scan_abort() like
> > this:
> > if (node_distance(nid, i) > RECLAIM_DISTANCE)
> >    khugepaged_node_load[i] = 0;
> > 
> > By this way, we may have a chance to find a more suitable node.
> 
> Hm theoretically there might be a suitable node, but this approach wouldn't
> work. By resetting it to zero you forget that there ever was node 'i'. If there
> is no more base page from node 'i', the load remains zero and the next call with
> 'nid' will think that 'nid' is OK.
> 

Right, the suggestion is wrong because we do not want to ever collapse to 
a node when the distance from the source page is > RECLAIM_DISTANCE, 
that's the entire point of the patch.
