Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaEEUqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:46:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaEEUqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:46:17 -0400
Date: Mon, 5 May 2014 13:46:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Seth Jennings <sjennings@variantweb.net>,
        Weijie Yang <weijie.yang@samsung.com>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>, weijie.yang.kh@gmail.com,
        heesub.shin@samsung.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: Re: [PATCH] zram: remove global tb_lock by using lock-free CAS
Message-Id: <20140505134615.04cb627bb2784cabcb844655@linux-foundation.org>
In-Reply-To: <1399312844.2570.28.camel@buesod1.americas.hpqcorp.net>
References: <000001cf6816$d538c370$7faa4a50$%yang@samsung.com>
	<20140505152014.GA8551@cerebellum.variantweb.net>
	<1399312844.2570.28.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2014 11:00:44 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:

> > > @@ -339,12 +338,14 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> > >  	unsigned long handle;
> > >  	u16 size;
> > >  
> > > -	read_lock(&meta->tb_lock);
> > > +	while(atomic_cmpxchg(&meta->table[index].state, IDLE, ACCESS) != IDLE)
> > > +		cpu_relax();
> > > +
> > 
> > So... this might be dumb question, but this looks like a spinlock
> > implementation.
> > 
> > What advantage does this have over a standard spinlock?
> 
> I was wondering the same thing. Furthermore by doing this you'll loose
> the benefits of sharing the lock... your numbers do indicate that it is
> for the better. Also, note that hopefully rwlock_t will soon be updated
> to be fair and perform up to par with spinlocks, something which is long
> overdue. So you could reduce the critical region by implementing the
> same granularity, just don't implement your own locking schemes, like
> this.

It sounds like seqlocks will match this access pattern pretty well?
