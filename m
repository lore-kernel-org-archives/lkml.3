Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaFLVsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:48:46 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36156 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbaFLVsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:48:43 -0400
Date: Thu, 12 Jun 2014 14:48:41 -0700 (PDT)
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
In-Reply-To: <53999563.9060105@suse.cz>
Message-ID: <alpine.DEB.2.02.1406121446070.12437@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-4-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406041656400.22536@chino.kir.corp.google.com> <5390374E.5080708@suse.cz>
 <alpine.DEB.2.02.1406051428360.18119@chino.kir.corp.google.com> <53916BB0.3070001@suse.cz> <alpine.DEB.2.02.1406090207300.24247@chino.kir.corp.google.com> <53959C11.2000305@suse.cz> <alpine.DEB.2.02.1406091512540.5271@chino.kir.corp.google.com>
 <5396B31B.6080706@suse.cz> <alpine.DEB.2.02.1406101646540.32203@chino.kir.corp.google.com> <5398492E.3070406@suse.cz> <alpine.DEB.2.02.1406111720370.11536@chino.kir.corp.google.com> <53999563.9060105@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Vlastimil Babka wrote:

> > Ok, and I won't continue to push the point.
> 
> I'd rather know I'm correct and not just persistent enough :) If you confirm
> that your compiler behaves differently, then maybe making page_order_unsafe a
> #define instead of inline function would prevent this issue?
> 

The reason I was hesitatnt is because there's no way I can prove under all 
possible circumstances in which page_order_unsafe() could be used that gcc 
won't make the decision to reaccess.  I personally didn't think that doing

	if (PageBuddy(page)) {
		/*
		 * Racy check since we know PageBuddy() is true and we do
		 * some sanity checking on this scan to ensure it is an
		 * appropriate order.
		 */
		unsigned long order = ACCESS_ONCE(page_private(page));
		...
	}

was too much of a problem and actually put the ACCESS_ONCE() in the 
context in which it matters rather than hiding behind an inline function.

> > I think the lockless
> > suitable_migration_target() call that looks at page_order() is fine in the
> > free scanner since we use it as a racy check, but it might benefit from
> > either a comment describing the behavior or a sanity check for
> > page_order(page) <= MAX_ORDER as you've done before.
> 
> OK, I'll add that.
> 

Thanks!
