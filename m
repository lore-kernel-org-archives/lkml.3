Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaBXXRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:17:49 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:45997 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaBXXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:17:48 -0500
Date: Tue, 25 Feb 2014 02:14:13 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 3/6] zram: factor out single stream compression
Message-ID: <20140224231413.GA2293@swordfish>
References: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392983443-9807-4-git-send-email-sergey.senozhatsky@gmail.com>
 <20140224023157.GF16240@bbox>
 <20140224083151.GA2384@swordfish.minsk.epam.com>
 <20140224230756.GA24325@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224230756.GA24325@bbox>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning Minchan,

On (02/25/14 08:07), Minchan Kim wrote:
> Hello Sergey,
> 
> On Mon, Feb 24, 2014 at 11:31:52AM +0300, Sergey Senozhatsky wrote:
> > Hello Minchan,
> > 
> > thanks for your review.
> > 
> > On (02/24/14 11:31), Minchan Kim wrote:
> > > Hello Sergey,
> > > 
> > > On Fri, Feb 21, 2014 at 02:50:40PM +0300, Sergey Senozhatsky wrote:
> > > > This is preparation patch to add multi stream support to zcomp.
> > > > 
> > > > Introduce struct zcomp_strm_single and a set of functions to manage zcomp_strm
> > > > stream access. zcomp_strm_single implements single compession stream, same way
> > > > as current zcomp implementation. This moves zcomp_strm stream control and
> > > > locking from zcomp, so compressing backend zcomp is not aware of required
> > > > locking (single and multi streams require different locking schemes).
> > > > 
> > > > The following set of functions added:
> > > > - zcomp_strm_single_get()/zcomp_strm_single_put()
> > > >   get and put compression stream, implement required locking
> > > > - zcomp_strm_single_create()/zcomp_strm_single_destroy()
> > > >   create and destroy zcomp_strm_single
> > > > 
> > > > New ->strm_get() and ->strm_put() callbacks added to zcomp, which are set to
> > > > zcomp_strm_single_get() and zcomp_strm_single_put() during initialisation.
> > > > Instead of direct locking and zcomp_strm access from zcomp_strm_get() and
> > > > zcomp_strm_put(), zcomp now calls ->strm_get() and ->strm_put()
> > > > correspondingly.
> > > > 
> > > > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > > 
> > > It's actually not what I expect.
> > > What I want was to separate implementation to different files
> > > whether it enalbles CONFIG_ZRAM_ZCOMP_MULTI or not so that
> > > popular users who want to use zram as only swap with small
> > > memory system have little side effect about performance and
> > > code size.
> > 
> > am I right to guess that you multi stream implementation replaces single
> > stream. in other words, CONFIG_ZRAM_ZCOMP_MULTI turns zcomp into just a
> > multi stream backend?
> > 
> > the reasoning behind this indirection is that it allows us to have
> > CONFIG_ZRAM_ZCOMP_MULTI as additional functionality. if user selects
> > CONFIG_ZRAM_ZCOMP_MULTI then there is a possibility for user to have both
> > single (e.g. if he uses zram as a swap device) and multi implemetation
> > (e.g. if he also uses it as a compressed block device with fs) on his
> > system. in other words, user may create N zram devices: one swap device
> > (with single stream inplementation) and N-1 multi stream.
> > 
> > so CONFIG_ZRAM_ZCOMP_MULTI is additional functionality, not the replacing
> > one. otherwise, there is a small foot print (IMHO. just several function
> > pointers, other than that it's just a single stream mutex-based implementation).
> > sounds sane?
> 
> Sounds good to me. That was from my laziness that I just didn't read your
> entire patchset. Then, I think we don't need to separate it with new CONFIG
> option(and I know you wanted ;-) ) because it just increase small memory
> footprint but it could remove maintainace headache and confusing from zram
> users.
> 
> add/remove: 4/0 grow/shrink: 2/0 up/down: 772/0 (772)
> function                                     old     new   delta
> zcomp_strm_multi_get                           -     189    +189
> max_comp_streams_store                        14     155    +141
> zcomp_strm_alloc                               -     127    +127
> zcomp_create                                 313     439    +126
> zcomp_strm_multi_put                           -      95     +95
> zcomp_strm_multi_destroy                       -      94     +94
> 
> So, let's remove new CONFIG and go with only option but it would work
> with mutex if stream is only one so there would be no regression but
> a little code size overhead but it's good deal, IMO.

ok, sounds good. will remove CONFIG option and make zram both single and
multi stream ready out of the box (max_comp_streams == 1 -- single stream and
mutex-based locking, max_comp_streams > 1 -- multi stream, wait queue and spin
lock based locking). will publish patches as soon as possible.

> I will review other patches in v6.
> 
> Thanks.
> 

thank you.

	-ss

> > 
> > > 
> > > > ---
> > > >  drivers/block/zram/zcomp.c | 63 ++++++++++++++++++++++++++++++++++++++++------
> > > >  drivers/block/zram/zcomp.h |  7 ++++--
> > > >  2 files changed, 60 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> > > > index db72f3d..9661226 100644
> > > > --- a/drivers/block/zram/zcomp.c
> > > > +++ b/drivers/block/zram/zcomp.c
> > > > @@ -15,6 +15,14 @@
> > > >  
> > > >  #include "zcomp.h"
> > > >  
> > > > +/*
> > > > + * single zcomp_strm backend private part
> > > > + */
> > > > +struct zcomp_strm_single {
> > > > +	struct mutex strm_lock;
> > > > +	struct zcomp_strm *zstrm;
> > > > +};
> > > > +
> > > >  extern struct zcomp_backend zcomp_lzo;
> > > >  
> > > >  static struct zcomp_backend *find_backend(const char *compress)
> > > > @@ -55,17 +63,58 @@ static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
> > > >  	return zstrm;
> > > >  }
> > > >  
> > > > +static struct zcomp_strm *zcomp_strm_single_get(struct zcomp *comp)
> > > > +{
> > > > +	struct zcomp_strm_single *zp = comp->private;
> > > > +	mutex_lock(&zp->strm_lock);
> > > > +	return zp->zstrm;
> > > > +}
> > > > +
> > > > +static void zcomp_strm_single_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> > > > +{
> > > > +	struct zcomp_strm_single *zp = comp->private;
> > > > +	mutex_unlock(&zp->strm_lock);
> > > > +}
> > > > +
> > > > +static void zcomp_strm_single_destroy(struct zcomp *comp)
> > > > +{
> > > > +	struct zcomp_strm_single *zp = comp->private;
> > > > +	zcomp_strm_free(comp, zp->zstrm);
> > > > +	kfree(zp);
> > > > +}
> > > > +
> > > > +static int zcomp_strm_single_create(struct zcomp *comp)
> > > > +{
> > > > +	struct zcomp_strm_single *zp;
> > > > +
> > > > +	comp->destroy = zcomp_strm_single_destroy;
> > > > +	comp->strm_get = zcomp_strm_single_get;
> > > > +	comp->strm_put = zcomp_strm_single_put;
> > > > +	zp = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
> > > > +	comp->private = zp;
> > > > +	if (!zp)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	mutex_init(&zp->strm_lock);
> > > > +	zp->zstrm = zcomp_strm_alloc(comp);
> > > > +	if (!zp->zstrm) {
> > > > +		zcomp_strm_single_destroy(comp);
> > > > +		return -ENOMEM;
> > > > +	}
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
> > > >  {
> > > > -	mutex_lock(&comp->strm_lock);
> > > > -	return comp->zstrm;
> > > > +	return comp->strm_get(comp);
> > > >  }
> > > >  
> > > >  void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> > > >  {
> > > > -	mutex_unlock(&comp->strm_lock);
> > > > +	comp->strm_put(comp, zstrm);
> > > >  }
> > > >  
> > > > +/* compress page */
> > > >  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > > >  		const unsigned char *src, size_t *dst_len)
> > > >  {
> > > > @@ -73,6 +122,7 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > > >  			zstrm->private);
> > > >  }
> > > >  
> > > > +/* decompress page */
> > > >  int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> > > >  		size_t src_len, unsigned char *dst)
> > > >  {
> > > > @@ -81,7 +131,7 @@ int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> > > >  
> > > >  void zcomp_destroy(struct zcomp *comp)
> > > >  {
> > > > -	zcomp_strm_free(comp, comp->zstrm);
> > > > +	comp->destroy(comp);
> > > >  	kfree(comp);
> > > >  }
> > > >  
> > > > @@ -105,10 +155,7 @@ struct zcomp *zcomp_create(const char *compress)
> > > >  		return NULL;
> > > >  
> > > >  	comp->backend = backend;
> > > > -	mutex_init(&comp->strm_lock);
> > > > -
> > > > -	comp->zstrm = zcomp_strm_alloc(comp);
> > > > -	if (!comp->zstrm) {
> > > > +	if (zcomp_strm_single_create(comp) != 0) {
> > > >  		zcomp_destroy(comp);
> > > >  		return NULL;
> > > >  	}
> > > > diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> > > > index 5106f8e..8dc1d7f 100644
> > > > --- a/drivers/block/zram/zcomp.h
> > > > +++ b/drivers/block/zram/zcomp.h
> > > > @@ -34,9 +34,12 @@ struct zcomp_backend {
> > > >  
> > > >  /* dynamic per-device compression frontend */
> > > >  struct zcomp {
> > > > -	struct mutex strm_lock;
> > > > -	struct zcomp_strm *zstrm;
> > > > +	void *private;
> > > >  	struct zcomp_backend *backend;
> > > > +
> > > > +	struct zcomp_strm *(*strm_get)(struct zcomp *comp);
> > > > +	void (*strm_put)(struct zcomp *comp, struct zcomp_strm *zstrm);
> > > > +	void (*destroy)(struct zcomp *comp);
> > > 
> > > I don't think we need indirection for get/put/destroy.
> > > zram_drv.c just calls zcomp_strm_get and zcomp.c could implement it
> > > 
> > > zcomp_strm_get()
> > > {
> > >         mutex_lock
> > >         return strm;
> > > }
> > > 
> > > and zcomp_multi.c can do it
> > > 
> > > zcomp_strm_get()
> > > {
> > >         spin_lock
> > >         spin_unlock
> > >         wait_event
> > >         return strm;
> > > }
> > 
> > so we have only one option -- it either only single stream based zram or
> > only multi stream based zram. I can move in this direction.
> > 
> > my implemtation allowed two options:
> > 
> > 	-- single stream zram
> > or
> > 	-- (CONFIG_ZRAM_ZCOMP_MULTI selected) single stream and multi stream,
> > 	depending of user set max_comp_streams.
> > 
> > > It seems that you live in my opposite country(ie, you start to dump patches
> > > when I am about leaving office so ping-pong gap of patch is at least
> > > one day round. It makes us collaboration very hard so eaieist method I can
> > > think is just I can implement my thought by myself but I don't want it.
> > > You thought this idea firstly and I want that you have all credit although
> > > it waste our time)
> > > 
> > > If I made you annoying, I'm really sorry to you.
> > > Again, thanks for looking at this, Sergey!
> > > 
> > 
> > I really appreciate and value all your input and review. Thank you. And
> > sorry if it consumes a lot of your time.
> > 
> > 	-ss
> > 
> > > -- 
> > > Kind regards,
> > > Minchan Kim
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Kind regards,
> Minchan Kim
> 
