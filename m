Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbaEEWWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:22:34 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:27104 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbaEEWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:22:33 -0400
Message-ID: <1399328550.2646.5.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] zram: remove global tb_lock by using lock-free CAS
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Date: Mon, 05 May 2014 15:22:30 -0700
In-Reply-To: <20140505134615.04cb627bb2784cabcb844655@linux-foundation.org>
References: <000001cf6816$d538c370$7faa4a50$%yang@samsung.com>
	 <20140505152014.GA8551@cerebellum.variantweb.net>
	 <1399312844.2570.28.camel@buesod1.americas.hpqcorp.net>
	 <20140505134615.04cb627bb2784cabcb844655@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 13:46 -0700, Andrew Morton wrote:
> On Mon, 05 May 2014 11:00:44 -0700 Davidlohr Bueso <davidlohr@hp.com> wrote:
> 
> > > > @@ -339,12 +338,14 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
> > > >  	unsigned long handle;
> > > >  	u16 size;
> > > >  
> > > > -	read_lock(&meta->tb_lock);
> > > > +	while(atomic_cmpxchg(&meta->table[index].state, IDLE, ACCESS) != IDLE)
> > > > +		cpu_relax();
> > > > +
> > > 
> > > So... this might be dumb question, but this looks like a spinlock
> > > implementation.
> > > 
> > > What advantage does this have over a standard spinlock?
> > 
> > I was wondering the same thing. Furthermore by doing this you'll loose
> > the benefits of sharing the lock... your numbers do indicate that it is
> > for the better. Also, note that hopefully rwlock_t will soon be updated
> > to be fair and perform up to par with spinlocks, something which is long
> > overdue. So you could reduce the critical region by implementing the
> > same granularity, just don't implement your own locking schemes, like
> > this.
> 
> It sounds like seqlocks will match this access pattern pretty well?

Indeed. And after a closer look, except for zram_slot_free_notify(),
that lock is always shared. So, unless fine graining it implies taking
the lock exclusively like in this patch (if so, that needs to be
explicitly documented in the changelog), we would ideally continue to
share it. That _should_ provide nicer performance numbers when using the
correct lock.



