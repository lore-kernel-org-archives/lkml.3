Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbaGHNFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:05:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861AbaGHNFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:05:32 -0400
Date: Tue, 8 Jul 2014 09:05:05 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] blk-lib: fix error reporting
In-Reply-To: <20140708095038.GA31180@infradead.org>
Message-ID: <alpine.LRH.2.02.1407080859370.27276@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1407031514320.3347@file01.intranet.prod.int.rdu2.redhat.com> <20140708095038.GA31180@infradead.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jul 2014, Christoph Hellwig wrote:

> > +	if (unlikely(err))
> > +		ACCESS_ONCE(bb->error) = err;
> 
> I can't see a reason for the ACCESS_ONCE here.

Multiple bios can be completed concurrently, so they write bb->error at 
the same time. The compiler may do store tearing (see "store tearing" in 
Documentation/memory-barriers.txt) - it may split one 4-byte write into 
several smaller writes - and it could result in setting bb->error to 
invalid value. We need ACCESS_ONCE to make sure that store tearing doesn't 
happen.

Mikulas

> Also the likely/unlikely annotations here smell like premature
> optimization.
> 
> Otherwise looks good to me.
