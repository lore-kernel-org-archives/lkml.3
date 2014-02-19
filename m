Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaBSGN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 01:13:58 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42170 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaBSGN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 01:13:56 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-8d-53044ba259cf
Date: Wed, 19 Feb 2014 15:14:01 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 0/4] add compressing abstraction and multi stream
 support
Message-ID: <20140219061401.GB1129@bbox>
References: <1392313402-5728-1-git-send-email-sergey.senozhatsky@gmail.com>
 <20140218060425.GA26133@bbox>
 <20140218092017.GA2098@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218092017.GA2098@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

On Tue, Feb 18, 2014 at 12:20:17PM +0300, Sergey Senozhatsky wrote:
> Hello,
> 
> On (02/18/14 15:04), Minchan Kim wrote:
> > Hello Sergey,
> > 
> > On Thu, Feb 13, 2014 at 08:43:18PM +0300, Sergey Senozhatsky wrote:
> > > This patchset introduces zcomp compression backend abstraction
> > > adding ability to support compression algorithms other than LZO;
> > > support for multi compression streams, making parallel compressions
> > > possible.
> > > 
> > > Diff from v4 (reviewed by Minchan Kim):
> > > -- renamed zcomp buffer_lock; removed src len and dst len from
> > >    compress() and decompress(); not using term `buffer' and
> > >    `workmem' in code and documentation; define compress() and
> > >    decompress() functions for LZO backend; not using goto's;
> > >    do not put idle zcomp_strm to idle list tail.
> > > 
> > > Diff from v3:
> > > -- renamed compression backend and working memory structs as requested
> > >    by Minchan Kim; fixed several issues noted by Minchan Kim.
> > > 
> > > Sergey Senozhatsky (4):
> > >   zram: introduce compressing backend abstraction
> > >   zram: use zcomp compressing backends
> > >   zram: zcomp support multi compressing streams
> > >   zram: document max_comp_streams
> > > 
> > >  Documentation/ABI/testing/sysfs-block-zram |   9 +-
> > >  Documentation/blockdev/zram.txt            |  20 +++-
> > >  drivers/block/zram/Makefile                |   2 +-
> > >  drivers/block/zram/zcomp.c                 | 155 +++++++++++++++++++++++++++++
> > >  drivers/block/zram/zcomp.h                 |  56 +++++++++++
> > >  drivers/block/zram/zcomp_lzo.c             |  48 +++++++++
> > >  drivers/block/zram/zram_drv.c              | 102 ++++++++++++-------
> > >  drivers/block/zram/zram_drv.h              |  10 +-
> > >  8 files changed, 355 insertions(+), 47 deletions(-)
> > >  create mode 100644 drivers/block/zram/zcomp.c
> > >  create mode 100644 drivers/block/zram/zcomp.h
> > >  create mode 100644 drivers/block/zram/zcomp_lzo.c
> > 
> > I reviewed patchset and implement looked good to me but
> > I found severe regression in my test which was one stream.
> > 
> > Base is current upstream and zcomp-multi is yours.
> > At last, zcom-single is where I tweaked to see schedule overhead
> > cause by event.
> >    
> >    Base                      zcomp-multi                      zcomp-single
> > 
> > ==Initial  write             ==Initial  write              ==Initial  write
> > records:   5                 records:   5                  records:   5
> > avg:       1642424.35        avg:       699610.40          avg:       1655583.71
> 
> wow... spinlock vs mutex 3 times slower? that's ugly.
> can you please provide iozone arg list?

iozone -t -T -l 12 -u 12 -r 16K -s 60M -I +Z -V 0

> 
> > std:       39890.95(2.43%)   std:       232014.19(33.16%)  std:       52293.96(3.16%)
> > max:       1690170.94        max:       1163473.45         max:       1697164.75
> > min:       1568669.52        min:       573429.88          min:       1553410.23
> > ==Rewrite  ==Rewrite         ==Rewrite
> > records:   5                 records:   5                  records:   5
> > avg:       1611775.39        avg:       501406.64          avg:       1684419.11
> > std:       17144.58(1.06%)   std:       15354.41(3.06%)    std:       18367.42(1.09%)
> > max:       1641800.95        max:       531356.78          max:       1706445.84
> > min:       1593515.27        min:       488817.78          min:       1655335.73
> > ==Read     ==Read            ==Read
> > records:   5                 records:   5                  records:   5
> > avg:       2418916.31        avg:       2385573.68         avg:       2316542.26
> > std:       55324.98(2.29%)   std:       64475.37(2.70%)    std:       50621.10(2.19%)
> > max:       2517417.72        max:       2444138.89         max:       2383321.09
> > min:       2364690.92        min:       2263763.77         min:       2233198.12
> > ==Re-read  ==Re-read         ==Re-read
> > records:   5                 records:   5                  records:   5
> > avg:       2351292.92        avg:       2333131.90         avg:       2336306.89
> > std:       73358.82(3.12%)   std:       34726.09(1.49%)    std:       74001.47(3.17%)
> > max:       2444053.92        max:       2396357.19         max:       2432697.06
> > min:       2255477.41        min:       2299239.74         min:       2231400.94
> > ==Reverse  Read              ==Reverse  Read               ==Reverse  Read
> > records:   5                 records:   5                  records:   5
> > avg:       2383917.40        avg:       2267700.38         avg:       2328689.00
> > std:       51389.78(2.16%)   std:       57018.67(2.51%)    std:       44955.21(1.93%)
> > max:       2435560.11        max:       2346465.31         max:       2375047.77
> > min:       2290726.91        min:       2188208.84         min:       2251465.20
> > ==Stride   read              ==Stride   read               ==Stride   read
> > records:   5                 records:   5                  records:   5
> > avg:       2361656.52        avg:       2292182.65         avg:       2302384.26
> > std:       64730.61(2.74%)   std:       34649.38(1.51%)    std:       51145.23(2.22%)
> > max:       2471425.77        max:       2341282.19         max:       2375936.66
> > min:       2279913.31        min:       2242688.59         min:       2224134.48
> > ==Random   read              ==Random   read               ==Random   read
> > records:   5                 records:   5                  records:   5
> > avg:       2369086.95        avg:       2315431.27         avg:       2352314.50
> > std:       19870.36(0.84%)   std:       43020.16(1.86%)    std:       51677.02(2.20%)
> > max:       2391210.41        max:       2390286.89         max:       2415472.89
> > min:       2337092.91        min:       2266433.95         min:       2264088.05
> > ==Mixed    workload          ==Mixed    workload           ==Mixed    workload
> > records:   5                 records:   5                  records:   5
> > avg:       1822253.03        avg:       2006455.50         avg:       1918270.29
> > std:       95037.10(5.22%)   std:       67792.78(3.38%)    std:       45933.99(2.39%)
> > max:       1934495.87        max:       2079128.36         max:       1995693.03
> > min:       1694223.48        min:       1914532.49         min:       1856410.41
> > ==Random   write             ==Random   write              ==Random   write
> > records:   5                 records:   5                  records:   5
> > avg:       1626318.29        avg:       497250.78          avg:       1695582.06
> > std:       38550.23(2.37%)   std:       1405.42(0.28%)     std:       9211.98(0.54%)
> > max:       1665839.62        max:       498585.88          max:       1703808.22
> > min:       1562141.21        min:       494526.45          min:       1677664.94
> > ==Pwrite   ==Pwrite          ==Pwrite
> > records:   5                 records:   5                  records:   5
> > avg:       1654641.25        avg:       581709.22          avg:       1641452.34
> > std:       47202.59(2.85%)   std:       9670.46(1.66%)     std:       38963.62(2.37%)
> > max:       1740682.36        max:       591300.09          max:       1687387.69
> > min:       1611436.34        min:       564324.38          min:       1570496.11
> > ==Pread    ==Pread           ==Pread
> > records:   5                 records:   5                  records:   5
> > avg:       2308891.23        avg:       2381945.97         avg:       2347688.68
> > std:       192436.37(8.33%)  std:       22957.85(0.96%)    std:       31682.43(1.35%)
> > max:       2548482.56        max:       2415788.27         max:       2381937.58
> > min:       1960229.11        min:       2349188.16         min:       2292507.52
> > 
> > 
> > zcomp-single patch
> > 
> > From 99abaf9c185953c35b0e3cd12ebb90b57f3bbd50 Mon Sep 17 00:00:00 2001
> > From: Minchan Kim <minchan@kernel.org>
> > Date: Tue, 18 Feb 2014 11:41:11 +0900
> > Subject: [PATCH] zram: add single lock
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  drivers/block/zram/zcomp.c | 24 +++++-------------------
> >  drivers/block/zram/zcomp.h |  2 +-
> >  2 files changed, 6 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> > index a032f49a52e2..03f4241083ac 100644
> > --- a/drivers/block/zram/zcomp.c
> > +++ b/drivers/block/zram/zcomp.c
> > @@ -56,32 +56,18 @@ struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
> >  {
> >  	struct zcomp_strm *zstrm;
> >  
> > -	while (1) {
> > -		spin_lock(&comp->strm_lock);
> > -		if (list_empty(&comp->idle_strm)) {
> > -			spin_unlock(&comp->strm_lock);
> > -			wait_event(comp->strm_wait,
> > -					!list_empty(&comp->idle_strm));
> > -			continue;
> > -		}
> > -
> > -		zstrm = list_entry(comp->idle_strm.next,
> > +	mutex_lock(&comp->strm_lock);
> > +	zstrm = list_entry(comp->idle_strm.next,
> >  				struct zcomp_strm, list);
> > -		list_del(&zstrm->list);
> > -		spin_unlock(&comp->strm_lock);
> > -		break;
> > -	}
> > +	list_del(&zstrm->list);
> >  	return zstrm;
> >  }
> >  
> >  /* add zcomp_strm back to idle list and wake up waiter (if any) */
> >  void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> >  {
> > -	spin_lock(&comp->strm_lock);
> >  	list_add(&zstrm->list, &comp->idle_strm);
> > -	spin_unlock(&comp->strm_lock);
> > -
> > -	wake_up(&comp->strm_wait);
> > +	mutex_unlock(&comp->strm_lock);
> >  }
> 
> >  
> >  int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> > @@ -138,7 +124,7 @@ struct zcomp *zcomp_create(const char *compress, int num_strm)
> >  		return NULL;
> >  
> >  	comp->backend = backend;
> > -	spin_lock_init(&comp->strm_lock);
> > +	mutex_init(&comp->strm_lock);
> >  	INIT_LIST_HEAD(&comp->idle_strm);
> >  	init_waitqueue_head(&comp->strm_wait);
> >  
> > diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> > index 52899de40ca5..bfcec1cf7d2e 100644
> > --- a/drivers/block/zram/zcomp.h
> > +++ b/drivers/block/zram/zcomp.h
> > @@ -35,7 +35,7 @@ struct zcomp_backend {
> >  /* dynamic per-device compression frontend */
> >  struct zcomp {
> >  	/* protect strm list */
> > -	spinlock_t strm_lock;
> > +	struct mutex strm_lock;
> >  	/* list of available strms */
> >  	struct list_head idle_strm;
> >  	wait_queue_head_t strm_wait;
> > -- 
> > 1.8.5.3
> > 
> > As you can see, your patch made zram too much regressed when it
> > used one stream buffer. The reason I guessed is overhead of
> > scheduling by sleep/wakeup when others couldn't find a idle stream
> > so I had an experiment with below simple patch to restore old behavior
> > so it works well again.
> 
> yes, could be.
> 
> > The reason old behaivor was really good is
> > it uses mutex with spin_on_owner so that it could avoid frequent
> > sleep/wakeup.
> > 
> 
> zcomp_strm_get()
> 	-> mutex_lock(&comp->strm_lock);
> 
> zcomp_strm_put()
> 	-> mutex_unlock(&comp->strm_lock);
> 
> semantics was supposed to be a default single zstrm policy, while spinlock
> based was meant to be multi zstrm policy. though, I agree, that zstrm policy
> concept complicates implementation.
> 
> 
> > A solution I could think is that we could grow up the number of
> > buffer dynamically up to max_buffers(ex, 2 * number of CPU) so we
> > could grab a idle stream easily for each CPU while we could release
> > buffers by shrinker when the memory pressure is severe.
> > Of course, we should keep one buffer to work.
> > 
> 
> yes, we had this behaviour in v1. I'm afraid 2 * online cpus() zstrms
> can be tough on systems with big number of cpus, taking in account workmem
> requirements, e.g. LZO1X_1_MEM_COMPRESS is 8192 * sizeof(unsigned short).
> 
> > Another solution I can imagaine is to define CONFIG_ZRAM_MULTI_STREAM
> > and CONFIG_ZRAM_SINGLE_STREAM(ie, default) so we couldn't break good
> > performance for old cases and new users who want write parallel
> > could use ZRAM_MULTI which should be several streams at a default
> > rather than a stream. And we could ehhacne it further by dynamic control
> > as I mentioned.
> >
> > Thoughts?
> > 
> 
> well, (my opinion) I'd rather avoid adding .config options.
> 
> we can force zram to support only multi zstrm. during initialisation one zstrm (default)
> is allocated, which is guaranteed to be there. now, if write didn't get idle zstrm AND
> current number of allocated zstrms is less that N * online CPUs (N could be 1 or 2)
> it attempts to allocate a new one. otherwise, it waits. if it failed to allocate a
> new one (low memory case) it waits, and eventually will receive idle zstrm (either
> one of previously allocated zstrms or, in the worst case possible, the default one.
> so we guarantee write to complete).
> 
> on put() we add zstrm to idle list or free it if the number of online CPUs has changed.

It would introduce regression again by wait/wakeup if we couldn't increase
the number of stream dynamically which would be very likely for zram-swap
usecase with multiple CPU and even frequent allocation request which would
be failed is obviously overhead. Of course, we could control the congestion
with backoff but it would require more code so I doubt we could do it clearly
rather than separating it with another configs.

Another idea is to put single_mode in zcomp so if max_buffer is only 1,
we could use comp->mutex_lock instead of strm_lock in zcomp_strm_get.
It might work but it would add unnecessary code for only zram-swap use
case for small memory embedded system so it's not a choice, either.

There is another zram-swap use cases for desktop people that I've ever
heard. He has enough ram but his usage scenario was really extreme so
sometime it happens swapping so it ends up system lag so what he want
was to make zram I/O very fast. I guess he wouldn't have a concern
to reserve more meory for zstream of each cpu if zram could perform
well in parallel. For that case, it would be better to resevere
stream for each CPU when initial time of zram, which might introduce
CONFIG_ZRAM_COMP_PERCPU rather than CONFIG_ZRAM_COMP_MULTI.

In summary, there are several usecases and I don't think we could meet
every usecases as only *a* config without regression so I'd like to
separate them. But if you could handle it no regression but clean code,
I'm okay. Otherwise, I'd like to go with multiple config to prevent
regression for most popular usecase zram-swap these days.

> 
> thoughts?
> 
> 	-ss
> > 
> > > 
> > > -- 
> > > 1.9.0.rc3.260.g4cf525c
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > -- 
> > Kind regards,
> > Minchan Kim
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
