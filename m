Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaAMBnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 20:43:39 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64540 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaAMBng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 20:43:36 -0500
X-AuditID: 9c93016f-b7c41ae000003ec1-88-52d344c6c049
Date: Mon, 13 Jan 2014 10:44:08 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>, Dave Hansen <dave@sr71.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
Message-ID: <20140113014408.GA25900@lge.com>
References: <20140103180147.6566F7C1@viggo.jf.intel.com>
 <20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org>
 <20140106043237.GE696@lge.com>
 <52D05D90.3060809@sr71.net>
 <20140110153913.844e84755256afd271371493@linux-foundation.org>
 <52D0854F.5060102@sr71.net>
 <CAOJsxLE-oMpV2G-gxrhyv0Au1tPd87Ow57VD5CWFo41wF8F4Yw@mail.gmail.com>
 <alpine.DEB.2.10.1401111854580.6036@nuc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401111854580.6036@nuc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 06:55:39PM -0600, Christoph Lameter wrote:
> On Sat, 11 Jan 2014, Pekka Enberg wrote:
> 
> > On Sat, Jan 11, 2014 at 1:42 AM, Dave Hansen <dave@sr71.net> wrote:
> > > On 01/10/2014 03:39 PM, Andrew Morton wrote:
> > >>> I tested 4 cases, all of these on the "cache-cold kfree()" case.  The
> > >>> first 3 are with vanilla upstream kernel source.  The 4th is patched
> > >>> with my new slub code (all single-threaded):
> > >>>
> > >>>      http://www.sr71.net/~dave/intel/slub/slub-perf-20140109.png
> > >>
> > >> So we're converging on the most complex option.  argh.
> > >
> > > Yeah, looks that way.
> >
> > Seems like a reasonable compromise between memory usage and allocation speed.
> >
> > Christoph?
> 
> Fundamentally I think this is good. I need to look at the details but I am
> only going to be able to do that next week when I am back in the office.

Hello,

I have another guess about the performance result although I didn't look at
these patches in detail. I guess that performance win of 64-byte sturct on
small allocations can be caused by low latency when accessing slub's metadata,
that is, struct page.

Following is pages per slab via '/proc/slabinfo'.

size    pages per slab
...
256     1   
512     1   
1024    2   
2048    4   
4096    8   
8192    8   

We only touch one struct page on small allocation.
In 64-byte case, we always use one cacheline for touching struct page, since
it is aligned to cacheline size. However, in 56-byte case, we possibly use
two cachelines because struct page isn't aligned to cacheline size.

This aspect can change on large allocation cases. For example, consider
4096-byte allocation case. In 64-byte case, it always touches 8 cachelines
for metadata, however, in 56-byte case, it touches 7 or 8 cachelines since
8 struct page occupies 8 * 56 bytes memory, that is, 7 cacheline size.

This guess may be wrong, so if you think it wrong, please ignore it. :)

And I have another opinion on this patchset. Diminishing struct page size
will affect other usecases beside the slub. As we know, Dave found this
by doing sequential 'dd'. I think that it may be the best case for 56-byte case.
If we randomly touch the struct page, this un-alignment can cause regression
since touching the struct page will cause two cachline misses. So, I think
that it is better to get more benchmark results to this patchset for convincing
ourselves. If possible, how about asking Fengguang to run whole set of
his benchmarks before going forward?

Thanks.
