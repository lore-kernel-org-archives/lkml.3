Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaCCH3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:29:07 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63055 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaCCH3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:29:04 -0500
Date: Mon, 3 Mar 2014 07:30:56 +0000
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, ngupta@vflare.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: zram: lockdep spew for zram->init_lock
Message-ID: <20140303073056.GB3704@gmail.com>
References: <530F5045.1010604@oracle.com>
 <20140227235629.GF31407@bbox>
 <20140228163206.f772a6f4ceb876f2f9a58031@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228163206.f772a6f4ceb876f2f9a58031@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

I'm not in office now and I would be off in this week, maybe
so I don't have source code on top of Sergey's recent change
but it seems below code has same problem.

Pz, Sergey or Jerome Could you confirm it instead of me?

On Fri, Feb 28, 2014 at 04:32:06PM -0800, Andrew Morton wrote:
> On Fri, 28 Feb 2014 08:56:29 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > Sasha reported following below lockdep spew of zram.
> > 
> > It was introduced by [1] in recent linux-next but it's false positive
> > because zram_meta_alloc with down_write(init_lock) couldn't be called
> > during zram is working as swap device so we could annotate the lock.
> > 
> > But I don't think it's worthy because it would make greate lockdep
> > less effective. Instead, move zram_meta_alloc out of the lock as good
> > old day so we could do unnecessary allocation/free of zram_meta for
> > initialied device as Sergey claimed in [1] but it wouldn't be common
> > and be harmful if someone might do it. Rather than, I'd like to respect
> > lockdep which is great tool to prevent upcoming subtle bugs.
> > 
> > [1] zram: delete zram_init_device
> >
> > ...
> >
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -537,26 +537,27 @@ static ssize_t disksize_store(struct device *dev,
> >  		struct device_attribute *attr, const char *buf, size_t len)
> >  {
> >  	u64 disksize;
> > +	struct zram_meta *meta;
> >  	struct zram *zram = dev_to_zram(dev);
> >  
> >  	disksize = memparse(buf, NULL);
> >  	if (!disksize)
> >  		return -EINVAL;
> >  
> > +	disksize = PAGE_ALIGN(disksize);
> > +	meta = zram_meta_alloc(disksize);
> > +	if (!meta)
> > +		return -ENOMEM;
> > +
> >  	down_write(&zram->init_lock);
> >  	if (init_done(zram)) {
> > +		zram_meta_free(meta);
> >  		up_write(&zram->init_lock);
> >  		pr_info("Cannot change disksize for initialized device\n");
> >  		return -EBUSY;
> >  	}
> >  
> > -	disksize = PAGE_ALIGN(disksize);
> > -	zram->meta = zram_meta_alloc(disksize);
> > -	if (!zram->meta) {
> > -		up_write(&zram->init_lock);
> > -		return -ENOMEM;
> > -	}
> > -
> > +	zram->meta = meta;
> >  	zram->disksize = disksize;
> >  	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
> >  	up_write(&zram->init_lock);
> 
> When applying zram-use-zcomp-compressing-backends.patch on top of this
> we get a bit of a mess, and simple conflict resolution results in a
> leak.
> 
> disksize_store() was one of those nasty functions which does multiple
> "return" statements after performing locking and resource allocation. 
> As usual, this led to a resource leak.  Remember folks, "return" is a
> goto in disguise.
> 
> 
> Here's what I ended up with.  Please review.
> 
> static ssize_t disksize_store(struct device *dev,
> 		struct device_attribute *attr, const char *buf, size_t len)
> {
> 	u64 disksize;
> 	struct zram_meta *meta;
> 	struct zram *zram = dev_to_zram(dev);
> 	int err;
> 
> 	disksize = memparse(buf, NULL);
> 	if (!disksize)
> 		return -EINVAL;
> 
> 	disksize = PAGE_ALIGN(disksize);
> 	meta = zram_meta_alloc(disksize);
> 	if (!meta)
> 		return -ENOMEM;
> 
> 	down_write(&zram->init_lock);
> 	if (init_done(zram)) {
> 		pr_info("Cannot change disksize for initialized device\n");
> 		err = -EBUSY;
> 		goto out_free_meta;
> 	}
> 
> 	zram->comp = zcomp_create(default_compressor);

AFAIR, zcomp_create try to allocate memory with GFP_KERNEL so it could
make a same problem. If so, let's allocate it out of the lock.

Please check it.

> 	if (!zram->comp) {
> 		pr_info("Cannot initialise %s compressing backend\n",
> 				default_compressor);
> 		err = -EINVAL;
> 		goto out_free_meta;
> 	}
> 
> 	zram->meta = meta;
> 	zram->disksize = disksize;
> 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
> 	up_write(&zram->init_lock);
> 
> 	return len;
> 
> out_free_meta:
> 	up_write(&zram->init_lock);
> 	zram_meta_free(meta);
> 	return err;
> }
> 
