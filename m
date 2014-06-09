Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaFIWZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:25:22 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:36121 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaFIWZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:25:17 -0400
Date: Mon, 9 Jun 2014 15:25:14 -0700 (PDT)
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
In-Reply-To: <53959C11.2000305@suse.cz>
Message-ID: <alpine.DEB.2.02.1406091512540.5271@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-4-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406041656400.22536@chino.kir.corp.google.com> <5390374E.5080708@suse.cz>
 <alpine.DEB.2.02.1406051428360.18119@chino.kir.corp.google.com> <53916BB0.3070001@suse.cz> <alpine.DEB.2.02.1406090207300.24247@chino.kir.corp.google.com> <53959C11.2000305@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Vlastimil Babka wrote:

> > > > Sorry, I meant ACCESS_ONCE(page_private(page)) in the migration scanner
> > > 
> > > Hm but that's breaking the abstraction of page_order(). I don't know if
> > > it's
> > > worse to create a new variant of page_order() or to do this. BTW, seems
> > > like
> > > next_active_pageblock() in memory-hotplug.c should use this variant too.
> > > 
> > 
> > The compiler seems free to disregard the access of a volatile object above
> > because the return value of the inline function is unsigned long.  What's
> > the difference between unsigned long order = page_order_unsafe(page) and
> > unsigned long order = (unsigned long)ACCESS_ONCE(page_private(page)) and
> 
> I think there's none functionally, but one is abstraction layer violation and
> the other imply the context of usage as you say (but is that so uncommon?).
> 
> > the compiler being able to reaccess page_private() because the result is
> > no longer volatile qualified?
> 
> You think it will reaccess? That would defeat all current ACCESS_ONCE usages,
> no?
> 

I think the compiler is allowed to turn this into

	if (ACCESS_ONCE(page_private(page)) > 0 &&
	    ACCESS_ONCE(page_private(page)) < MAX_ORDER)
		low_pfn += (1UL << ACCESS_ONCE(page_private(page))) - 1;

since the inline function has a return value of unsigned long but gcc may 
not do this.  I think

	/*
	 * Big fat comment describing why we're using ACCESS_ONCE(), that 
	 * we're ok to race, and that this is meaningful only because of
	 * the previous PageBuddy() check.
	 */
	unsigned long pageblock_order = ACCESS_ONCE(page_private(page));

is better.
