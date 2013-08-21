Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab3HUVbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 17:31:50 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:54664 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUVbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 17:31:48 -0400
Date: Wed, 21 Aug 2013 17:31:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
Message-ID: <20130821213144.GE2436@htj.dyndns.org>
References: <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
 <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
 <20130820142956.1194d8c798abf53f884a1fb6@linux-foundation.org>
 <20130821020132.GA4051@kmo-pixel>
 <20130821020742.GA3495@htj.dyndns.org>
 <20130821023151.GC4051@kmo-pixel>
 <20130821115941.GA18617@mtj.dyndns.org>
 <20130821210901.GA4657@kmo-pixel>
 <20130821211650.GD2436@htj.dyndns.org>
 <20130821212442.GC4657@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821212442.GC4657@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 21, 2013 at 02:24:42PM -0700, Kent Overstreet wrote:
> With single page allocations:
> 
> 1 << 15 bits per page
> 
> 1 << 9 pointers per page
> 
> So two layers of pointers does get us to 1 << 33 bits, which is what we
> need.

And single layer - 1 << 15 - would cover most of the use cases, right?
With 1 << (9 + 15) probably covering everyone else but the cyclic ones
doing the full circle.

> But now, since we need two layers of pointers instead of one, we need
> either another pointer deref for a node lookup - _always_, even when
> we've got 8 bytes of bits - or we need to branch on the depth of the
> tree, which is something we don't have now.

A likely() branch which is almost always hit is *extremely* cheap.

> This is extra overhead _no matter the size of the ida_, over my current
> approach.
> I'm assuming the common case is < one page of bits, based on the usage
> I've seen throughout the kernel that's probably way conservative.
> 
> In that case, your approach is going to be slower than mine, and there's
> no difference in the size of the allocations.

By single likely() branch.  I'm not even sure that'd be measureable in
most cases.  I'd take that over custom radix tree implementation which
needs high order allocations.

> I've already shown massive performance gains over the existing radix
> tree approach, you're the one claiming a different approach would be
> better.

So?  What difference does that make?  You should be able to justify
your custom thing.  If you do something unusual, of course someone is
gonna ask you to justify it and justifying that is *your*
responsibility.

Thanks.

-- 
tejun
