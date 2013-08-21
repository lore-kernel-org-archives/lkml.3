Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab3HUCbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:31:44 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:64198 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3HUCbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:31:43 -0400
Date: Tue, 20 Aug 2013 19:31:51 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] idr: Use this_cpu_ptr() for percpu_ida
Message-ID: <20130821023151.GC4051@kmo-pixel>
References: <1375896905-6074-5-git-send-email-kmo@daterainc.com>
 <0000014059ec4c34-1bb53d48-c9ee-4e71-81b8-253026431c5c-000000@email.amazonses.com>
 <20130807183345.GA11612@kmo-pixel>
 <000001405a4b39ef-0715410a-5061-41e9-9414-86559f16570d-000000@email.amazonses.com>
 <20130807195733.GB11612@kmo-pixel>
 <000001405e5776ba-bcc96088-b5e8-4abe-b98e-2e9d7d9b112b-000000@email.amazonses.com>
 <1377033546.32763.4.camel@haakon3.risingtidesystems.com>
 <20130820142956.1194d8c798abf53f884a1fb6@linux-foundation.org>
 <20130821020132.GA4051@kmo-pixel>
 <20130821020742.GA3495@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821020742.GA3495@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:07:42PM -0400, Tejun Heo wrote:
> Hello, Kent.
> 
> On Tue, Aug 20, 2013 at 07:01:32PM -0700, Kent Overstreet wrote:
> > I think Tejun and I might be at a bit of an impasse with the ida rewrite
> > itself, but I don't think there were any outstanding objections to the
> > percpu ida code itself - and this is a standalone version.
> 
> The percpu ida code can be applied separately from the ida rewrite?

Yes - at the cost of using significantly more memory for the global
freelist

> > I was meaning to ask you Andrew, if you could take a look at the ida
> > discussion and lend your opinion - I don't think there's any _specific_
> > technical objections left to my ida code, and it's now on a more
> > philisophical "complexity vs. ..." level.
> 
> Hmmm... the objection was pretty specific - don't depend on high-order
> or vmalloc allocations when it can be easily avoided by using proper
> radix tree.

We only do vmalloc allocations for CONFIG_COMPACTION=n, and then only
when we need to allocate more than almost 1 _billion_ ids from a single
ida (twice than on 32 bit, so never because that gets us just about to
INT_MAX) - and then it's only 32k of vmalloc memory, for the entire ida.

This is with max allocation order of 4 for COMPACTION=y, 2 for
COMPACTION=n. 

All this for a performance improvement of 10x to 50x (or more), for the
ida sizes I measured.

So I could see your point if we were allocating gobs of vmalloc memory,
or high order allocations big enough to realistically be problematic (I
honestly don't think these will be) - but to me, this seems like a
pretty reasonable tradeoff for those performance gains.

(And the performance gains do substantially come from using more
contiguous memory and treating the whole data structure as an array, and
doing less pointer chasing/looping)
