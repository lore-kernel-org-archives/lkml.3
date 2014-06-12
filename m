Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaFLAVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:21:42 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38763 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaFLAVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:21:40 -0400
Date: Wed, 11 Jun 2014 17:21:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 4/6] mm, compaction: skip buddy pages by their order
 in the migrate scanner
In-Reply-To: <5398492E.3070406@suse.cz>
Message-ID: <alpine.DEB.2.02.1406111720370.11536@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-4-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406041656400.22536@chino.kir.corp.google.com> <5390374E.5080708@suse.cz>
 <alpine.DEB.2.02.1406051428360.18119@chino.kir.corp.google.com> <53916BB0.3070001@suse.cz> <alpine.DEB.2.02.1406090207300.24247@chino.kir.corp.google.com> <53959C11.2000305@suse.cz> <alpine.DEB.2.02.1406091512540.5271@chino.kir.corp.google.com>
 <5396B31B.6080706@suse.cz> <alpine.DEB.2.02.1406101646540.32203@chino.kir.corp.google.com> <5398492E.3070406@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Vlastimil Babka wrote:

> > I hate to belabor this point, but I think gcc does treat it differently.
> > If you look at the assembly comparing your patch to if you do
> > 
> > 	unsigned long freepage_order = ACCESS_ONCE(page_private(page));
> > 
> > instead, then if you enable annotation you'll see that gcc treats the
> > store as page_x->D.y.private in your patch vs. MEM[(volatile long unsigned
> > int *)page_x + 48B] with the above.
> 
> Hm sure you compiled a version that used page_order_unsafe() and not
> page_order()? Because I do see:
> 
> MEM[(volatile long unsigned int *)valid_page_114 + 48B];
> 
> That's gcc 4.8.1, but our gcc guy said he tried 4.5+ and all was like this.
> And that it would be a gcc bug if not.
> He also did a test where page_order was called twice in one function and
> page_order_unsafe twice in another function. page_order() was reduced to a
> single access in the assembly, page_order_unsafe were two accesses.
> 

Ok, and I won't continue to push the point.  I think the lockless 
suitable_migration_target() call that looks at page_order() is fine in the 
free scanner since we use it as a racy check, but it might benefit from 
either a comment describing the behavior or a sanity check for 
page_order(page) <= MAX_ORDER as you've done before.
