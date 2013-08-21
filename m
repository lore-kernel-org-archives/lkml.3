Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3HUMFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:05:01 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:44258 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab3HUMFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:05:00 -0400
Date: Wed, 21 Aug 2013 07:59:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
Message-ID: <20130821115941.GA18617@mtj.dyndns.org>
References: <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
 <20130807183345.GA11612@kmo-pixel>
 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
 <20130807195733.GB11612@kmo-pixel>
 <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
 <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
 <20130820142956.1194d8c798abf53f884a1fb6@linux-foundation.org>
 <20130821020132.GA4051@kmo-pixel>
 <20130821020742.GA3495@htj.dyndns.org>
 <20130821023151.GC4051@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821023151.GC4051@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Tue, Aug 20, 2013 at 07:31:51PM -0700, Kent Overstreet wrote:
> All this for a performance improvement of 10x to 50x (or more), for the
> ida sizes I measured.

That's misleading, isn't it?  We should see large performance
improvements even without the large pages.  What matters more is the
leaf node performance for vast majority of cases and an extra radix
tree layer on top would cover most of whatever is left.  Whether to
use high order pages or not only affects the extreme niche use cases
and I don't think going for high order pages to micro optimize those
extreme use cases is the right trade off.

> So I could see your point if we were allocating gobs of vmalloc memory,
> or high order allocations big enough to realistically be problematic (I
> honestly don't think these will be) - but to me, this seems like a
> pretty reasonable tradeoff for those performance gains.

The trade off is made up as the bulk of the performance benefit can be
gained without resorting to high order allocations.

> (And the performance gains do substantially come from using more
> contiguous memory and treating the whole data structure as an array, and
> doing less pointer chasing/looping)

I really have hard time buying that.  Let's say you go with single
page leaf node and an extra single page layer on top.  How many IDs
are we talking about?  For the cases which are most performance
sensitive, this doesn't even matter a bit as percpu caching layer
would be on top anyway.  I really don't think the micro optimization
is called for at the cost of high order allocations from low level
tool library.

Thanks.

-- 
tejun
