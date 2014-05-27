Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaE0T4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbaE0T4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:56:09 -0400
Date: Tue, 27 May 2014 15:56:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>
Subject: Re: [PATCH] block: flush queued bios when the process blocks
In-Reply-To: <5384CE82.90601@kernel.dk>
Message-ID: <alpine.LRH.2.02.1405271526570.3223@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com> <5384AA79.4010206@kernel.dk> <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com> <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com> <5384CE82.90601@kernel.dk>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 May 2014, Jens Axboe wrote:

> On 2014-05-27 10:26, Mikulas Patocka wrote:
> > On Tue, 27 May 2014, Jens Axboe wrote:
> > 
> > > On 2014-05-27 09:23, Mikulas Patocka wrote:
> > > 
> > > > The patch adds bio list flushing to the scheduler just besides plug
> > > > flushsing.
> > > 
> > > ... which is exactly why I'm commenting. It'd be great to avoid yet one
> > > more
> > > scheduler hook for this sort of thing.
> > > 
> > > --
> > > Jens Axboe
> > 
> > One could create something like schedule notifier chain, but I'm not sure
> > if it is worth the complexity because of just two users. If more users
> > come in the future, it could be generalized.
> 
> Except such a thing already exists, there are unplug callback chains. All I'm
> asking is that you look into how feasible it would be to use something like
> that, instead of reinventing the wheel.
> 
> -- 
> Jens Axboe

Do you mean moving current->bio_list to struct blk_plug and calling 
blk_start_plug/blk_finish_plug around generic_make_request?

It would be possible on a condition that we can redirect all bios to a 
workqueue (i.e. eliminate bio_kmalloc and always use bio_alloc_bioset).

What are performance implications of this - does it make sense to have 
blk_start_plug/blk_finish_plug around every call to generic_make_request? 
- that means that all i/o requests will be added to a plug and then 
unplugged.

Mikulas
