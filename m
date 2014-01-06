Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaAFEca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 23:32:30 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59206 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaAFEc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 23:32:29 -0500
X-AuditID: 9c93016f-b7b4eae000000985-fa-52ca31db319b
Date: Mon, 6 Jan 2014 13:32:37 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave@sr71.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org,
        cl@linux-foundation.org
Subject: Re: [PATCH 0/9] re-shrink 'struct page' when SLUB is on.
Message-ID: <20140106043237.GE696@lge.com>
References: <20140103180147.6566F7C1@viggo.jf.intel.com>
 <20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103141816.20ef2a24c8adffae040e53dc@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 02:18:16PM -0800, Andrew Morton wrote:
> On Fri, 03 Jan 2014 10:01:47 -0800 Dave Hansen <dave@sr71.net> wrote:
> 
> > This is a minor update from the last version.  The most notable
> > thing is that I was able to demonstrate that maintaining the
> > cmpxchg16 optimization has _some_ value.
> > 
> > Otherwise, the code changes are just a few minor cleanups.
> > 
> > ---
> > 
> > SLUB depends on a 16-byte cmpxchg for an optimization which
> > allows it to not disable interrupts in its fast path.  This
> > optimization has some small but measurable benefits:
> > 
> > 	http://lkml.kernel.org/r/52B345A3.6090700@sr71.net
> 
> So really the only significant benefit from the cmpxchg16 is with
> cache-cold eight-byte kmalloc/kfree?  8% faster in this case?  But with
> cache-hot kmalloc/kfree the benefit of cmpxchg16 is precisely zero.

Hello,

I guess that cmpxchg16 is not used in this cache-hot kmalloc/kfree test,
because kfree would be done in free fast-path. In this case,
this_cpu_cmpxchg_double() would be called, so you cannot find any effect
of cmpxchg16.

Thanks.

> 
> This is really weird and makes me suspect a measurement glitch.
> 
> Even if this 8% is real, it's unclear that it's worth all the
> complexity the cmpxchg16 adds.
> 
> It would be really useful (hint :)) if we were to know exactly where
> that 8% is coming from - perhaps it's something which is not directly
> related to the cmpxchg16, and we can fix it separately.
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
