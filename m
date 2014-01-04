Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaADUwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 15:52:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbaADUwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 15:52:35 -0500
Date: Sat, 4 Jan 2014 15:52:14 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: John David Anglin <dave.anglin@bell.net>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andi Kleen <ak@linux.intel.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@iki.fi>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] fix crash when using XFS on loopback
In-Reply-To: <BLU0-SMTP1018039B0747722C9B5B22E97B50@phx.gbl>
Message-ID: <alpine.LRH.2.02.1401041536210.21108@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401041241590.4648@file01.intranet.prod.int.rdu2.redhat.com> <BLU0-SMTP390C5C965F9A4FB18F1EBE97B50@phx.gbl> <alpine.LRH.2.02.1401041451350.21108@file01.intranet.prod.int.rdu2.redhat.com>
 <BLU0-SMTP1018039B0747722C9B5B22E97B50@phx.gbl>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 4 Jan 2014, John David Anglin wrote:

> On 4-Jan-14, at 2:55 PM, Mikulas Patocka wrote:
> 
> > On Sat, 4 Jan 2014, John David Anglin wrote:
> > 
> > > On 4-Jan-14, at 12:45 PM, Mikulas Patocka wrote:
> > > 
> > > > * flush_dcache_page asks for the list of userspace mappings, however
> > > > that
> > > > page->mapping field is reused by the slab subsystem for a different
> > > > purpose. This causes the crash.
> > > 
> > > I'd noticed the other day that the parisc implementation of
> > > flush_dcache_page()
> > > should return if "!mapping || mapping != page->mapping" is true.  This
> > > would
> > > have avoided crash.
> > > 
> > > Dave
> > 
> > I think no.
> > 
> > page_mapping returns NULL if the page has only anonymous mapping and it is
> > not placed in the swap cache. In this case, you need to flush the kernel
> > cache.
> 
> 
> The suggestion is to add the "mapping != page->mapping" to the current NULL
> check.
> It occurs after the kernel cache flush.

"if (!mapping || mapping != page->mapping) return;"
returns if the mapping is NULL (and that is wrong because the variable 
mapping is NULL for anonymous pages).

You could probably return "if (!mapping && !PageAnon(page))", but the 
other architectures aren't doing it.

> It doesn't seem right to flush the vma mappings associated with swap address
> space
> and that appears to be happening with current code.
>
> Dave
> --
> John David Anglin	dave.anglin@bell.net

I suppose that "vma_interval_tree_foreach" is empty operation for swap 
address space. Or isn't it?

Mikulas
