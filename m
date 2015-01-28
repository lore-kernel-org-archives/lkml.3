Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbbA2BPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:15:49 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57653 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbA2BPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:15:45 -0500
Date: Thu, 29 Jan 2015 08:33:43 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: Re: [PATCH v1 2/2] zram: remove init_lock in zram_make_request
Message-ID: <20150128233343.GC4706@blaptop>
References: <1422432945-6764-1-git-send-email-minchan@kernel.org>
 <1422432945-6764-2-git-send-email-minchan@kernel.org>
 <20150128145651.GB965@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128145651.GB965@swordfish>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:56:51PM +0900, Sergey Senozhatsky wrote:
> On (01/28/15 17:15), Minchan Kim wrote:
> > Admin could reset zram during I/O operation going on so we have
> > used zram->init_lock as read-side lock in I/O path to prevent
> > sudden zram meta freeing.
> > 
> > However, the init_lock is really troublesome.
> > We can't do call zram_meta_alloc under init_lock due to lockdep splat
> > because zram_rw_page is one of the function under reclaim path and
> > hold it as read_lock while other places in process context hold it
> > as write_lock. So, we have used allocation out of the lock to avoid
> > lockdep warn but it's not good for readability and fainally, I met
> > another lockdep splat between init_lock and cpu_hotpulug from
> > kmem_cache_destroy during wokring zsmalloc compaction. :(
> > 
> > Yes, the ideal is to remove horrible init_lock of zram in rw path.
> > This patch removes it in rw path and instead, put init_done bool
> > variable to check initialization done with smp_[wmb|rmb] and
> > srcu_[un]read_lock to prevent sudden zram meta freeing
> > during I/O operation.
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  drivers/block/zram/zram_drv.c | 85 +++++++++++++++++++++++++++++++------------
> >  drivers/block/zram/zram_drv.h |  5 +++
> >  2 files changed, 66 insertions(+), 24 deletions(-)
> > 
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index a598ada817f0..b33add453027 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -32,6 +32,7 @@
> >  #include <linux/string.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/err.h>
> > +#include <linux/srcu.h>
> >  
> >  #include "zram_drv.h"
> >  
> > @@ -53,9 +54,31 @@ static ssize_t name##_show(struct device *d,		\
> >  }									\
> >  static DEVICE_ATTR_RO(name);
> >  
> > -static inline int init_done(struct zram *zram)
> > +static inline bool init_done(struct zram *zram)
> >  {
> > -	return zram->meta != NULL;
> > +	/*
> > +	 * init_done can be used without holding zram->init_lock in
> > +	 * read/write handler(ie, zram_make_request) but we should make sure
> > +	 * that zram->init_done should set up after meta initialization is
> > +	 * done. Look at setup_init_done.
> > +	 */
> > +	bool ret = zram->init_done;
> 
> I don't like re-introduced ->init_done.
> another idea... how about using `zram->disksize == 0' instead of
> `->init_done' (previously `->meta != NULL')? should do the trick.

It could be.

> 
> 
> and I'm not sure I get this rmb...

What makes you not sure?
I think it's clear and common pattern for smp_[wmb|rmb]. :)


> 
> 	-ss

-- 
Kind regards,
Minchan Kim
