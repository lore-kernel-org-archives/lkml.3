Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbaIWVSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:18:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37940 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaIWVR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:17:57 -0400
Date: Tue, 23 Sep 2014 14:17:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, Nitin Gupta <ngupta@vflare.org>,
        Luigi Semenzato <semenzato@google.com>, juno.choi@lge.com
Subject: Re: [PATCH v1 4/5] zram: add swap full hint
Message-Id: <20140923141755.b7854bae484cfe434797be02@linux-foundation.org>
In-Reply-To: <20140923045602.GC8325@bbox>
References: <1411344191-2842-1-git-send-email-minchan@kernel.org>
	<1411344191-2842-5-git-send-email-minchan@kernel.org>
	<20140922141118.de46ae5e54099cf2b39c8c5b@linux-foundation.org>
	<20140923045602.GC8325@bbox>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 13:56:02 +0900 Minchan Kim <minchan@kernel.org> wrote:

> > 
> > > +#define ZRAM_FULLNESS_PERCENT 80
> > 
> > We've had problems in the past where 1% is just too large an increment
> > for large systems.
> 
> So, do you want fullness_bytes like dirty_bytes?

Firstly I'd like you to think about whether we're ever likely to have
similar granularity problems with this tunable.  If not then forget
about it.

If yes then we should do something.  I don't like the "bytes" thing
much because it requires that the operator know the pool size
beforehand, and any time that changes, the "bytes" needs hanging too. 
Ratios are nice but percent is too coarse.  Maybe kernel should start
using "ppm" for ratios, parts per million.  hrm.

> > > @@ -711,6 +732,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
> > >  	down_write(&zram->init_lock);
> > >  
> > >  	zram->limit_pages = 0;
> > > +	atomic_set(&zram->alloc_fail, 0);
> > >  
> > >  	if (!init_done(zram)) {
> > >  		up_write(&zram->init_lock);
> > > @@ -944,6 +966,34 @@ static int zram_slot_free_notify(struct block_device *bdev,
> > >  	return 0;
> > >  }
> > >  
> > > +static int zram_full(struct block_device *bdev, void *arg)
> > 
> > This could return a bool.  That implies that zram_swap_hint should
> > return bool too, but as we haven't been told what the zram_swap_hint
> > return value does, I'm a bit stumped.
> 
> Hmm, currently, SWAP_FREE doesn't use return and SWAP_FULL uses return
> as bool so in the end, we can change it as bool but I want to remain it
> as int for the future. At least, we might use it as propagating error
> in future. Instead, I will use *arg to return the result instead of
> return val. But I'm not strong so if you want to remove return val,
> I will do it. For clarifictaion, please tell me again if you want.

I'm easy, as long as it makes sense, is understandable by people other
than he-who-wrote-it and doesn't use argument names such as "arg".


