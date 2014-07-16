Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbaGPK03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:26:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733AbaGPKW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:22:58 -0400
Date: Wed, 16 Jul 2014 06:22:29 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: device-mapper development <dm-devel@redhat.com>
cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] blk-lib: fix error reporting
In-Reply-To: <1404828246.1967.8.camel@jarvis.lan>
Message-ID: <alpine.LRH.2.02.1407160614490.29250@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407031514320.3347@file01.intranet.prod.int.rdu2.redhat.com> <20140708095038.GA31180@infradead.org> <alpine.LRH.2.02.1407080859370.27276@file01.intranet.prod.int.rdu2.redhat.com> <1404828246.1967.8.camel@jarvis.lan>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jul 2014, James Bottomley wrote:

> On Tue, 2014-07-08 at 09:05 -0400, Mikulas Patocka wrote:
> > 
> > On Tue, 8 Jul 2014, Christoph Hellwig wrote:
> > 
> > > > +	if (unlikely(err))
> > > > +		ACCESS_ONCE(bb->error) = err;
> > > 
> > > I can't see a reason for the ACCESS_ONCE here.
> > 
> > Multiple bios can be completed concurrently, so they write bb->error at 
> > the same time. The compiler may do store tearing (see "store tearing" in 
> > Documentation/memory-barriers.txt) - it may split one 4-byte write into 
> > several smaller writes - and it could result in setting bb->error to 
> > invalid value. We need ACCESS_ONCE to make sure that store tearing doesn't 
> > happen.
> 
> That's not correct, because it's not applicable in this case.  Tearing
> may occur on misalignment (which ACCESS_ONCE() cannot rectify because
> it's architectural), short constant loads (again, usually architectural)
> and structure copies, none of which applies here.

Suppose this scenario:
CPU1 writes low byte of the first error code
CPU2 writes low byte of the second error code
CPU2 writes 3 high bytes of the second error code
CPU1 writes 3 high bytes of the first error code

- now, bb->error contains garbage - a mix of the first and second error 
code. That's why we need ACCESS_ONCE.

It may happen even if the variable is aligned. The compiler is allowed to 
split larger memory access to several smaller accesses. The compiler 
usually doesn't do this split (that's why omitting ACCESS_ONCE usually 
doesn't result in any observable misbehavior), but it is still a bug to 
omit it - you don't really know that for all 29 architectures gcc won't 
split the memory write...

> We can rely on a properly aligned 32 bit write being atomic.
>
> James

... only if you use ACCESS_ONCE ...

Mikulas
