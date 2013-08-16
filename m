Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab3HPWKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:10:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42649 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab3HPWKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:10:45 -0400
Date: Fri, 16 Aug 2013 17:00:34 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Luigi Semenzato <semenzato@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v6 3/5] zsmalloc: move it under zram
Message-ID: <20130816220034.GD7265@variantweb.net>
References: <1376459736-7384-1-git-send-email-minchan@kernel.org>
 <1376459736-7384-4-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376459736-7384-4-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081622-5806-0000-0000-000022743717
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 02:55:34PM +0900, Minchan Kim wrote:
> This patch moves zsmalloc under zram directory because there
> isn't any other user any more.
> 
> Before that, description will explain why we have needed custom
> allocator.
> 
> Zsmalloc is a new slab-based memory allocator for storing
> compressed pages.  It is designed for low fragmentation and
> high allocation success rate on large object, but <= PAGE_SIZE
> allocations.

One things zsmalloc will probably have to address before Andrew deems it
worthy is the "memmap peekers" issue.  I had to make this change in zbud
before Andrew would accept it and this is one of the reasons I have yet
to implement zsmalloc support for zswap yet.

Basically, zsmalloc makes the assumption that once the kernel page
allocator gives it a page for the pool, zsmalloc can stuff whatever
metatdata it wants into the struct page.  The problem comes when some
parts of the kernel do not obtain the struct page pointer via the
allocator but via walking the memmap.  Those routines will make certain
assumption about the state and structure of the data in the struct page,
leading to issues.

My solution for zbud was to move the metadata into the pool pages
themselves, using the first block of each page for metadata regarding that
page.

Andrew might also have something to say about the placement of
zsmalloc.c.  IIRC, if it was going to be merged, he wanted it in mm/ if
it was going to be messing around in the struct page.

Seth

