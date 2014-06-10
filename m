Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbaFJXyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:54:40 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60260 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaFJXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:54:39 -0400
Date: Tue, 10 Jun 2014 16:54:36 -0700 (PDT)
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
In-Reply-To: <5396B31B.6080706@suse.cz>
Message-ID: <alpine.DEB.2.02.1406101646540.32203@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-4-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406041656400.22536@chino.kir.corp.google.com> <5390374E.5080708@suse.cz>
 <alpine.DEB.2.02.1406051428360.18119@chino.kir.corp.google.com> <53916BB0.3070001@suse.cz> <alpine.DEB.2.02.1406090207300.24247@chino.kir.corp.google.com> <53959C11.2000305@suse.cz> <alpine.DEB.2.02.1406091512540.5271@chino.kir.corp.google.com>
 <5396B31B.6080706@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Vlastimil Babka wrote:

> > I think the compiler is allowed to turn this into
> > 
> > 	if (ACCESS_ONCE(page_private(page)) > 0 &&
> > 	    ACCESS_ONCE(page_private(page)) < MAX_ORDER)
> > 		low_pfn += (1UL << ACCESS_ONCE(page_private(page))) - 1;
> > 
> > since the inline function has a return value of unsigned long but gcc may
> > not do this.  I think
> > 
> > 	/*
> > 	 * Big fat comment describing why we're using ACCESS_ONCE(), that
> > 	 * we're ok to race, and that this is meaningful only because of
> > 	 * the previous PageBuddy() check.
> > 	 */
> > 	unsigned long pageblock_order = ACCESS_ONCE(page_private(page));
> > 
> > is better.
> 
> I've talked about it with a gcc guy and (although he didn't actually see the
> code so it might be due to me not explaining it perfectly), the compiler will
> inline page_order_unsafe() so that there's effectively.
> 
> unsigned long freepage_order = ACCESS_ONCE(page_private(page));
> 
> and now it cannot just replace all freepage_order occurences with new
> page_private() accesses. So thanks to the inlining, the volatile qualification
> propagates to where it matters. It makes sense to me, but if it's according to
> standard or gcc specific, I don't know.
> 

I hate to belabor this point, but I think gcc does treat it differently.  
If you look at the assembly comparing your patch to if you do

	unsigned long freepage_order = ACCESS_ONCE(page_private(page));

instead, then if you enable annotation you'll see that gcc treats the 
store as page_x->D.y.private in your patch vs. MEM[(volatile long unsigned 
int *)page_x + 48B] with the above.

I don't have the ability to prove that all versions of gcc optimization 
will not choose to reaccess page_private(page) here, but it does show that 
at least gcc 4.6.3 does not consider them to be equivalents.
