Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaBYAjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:39:45 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54403 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaBYAjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:39:44 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-97-530be64e5bc9
Date: Tue, 25 Feb 2014 09:40:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 5/6] zram: enalbe multi stream compression support in
 zram
Message-ID: <20140225004010.GA27093@bbox>
References: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1392983443-9807-6-git-send-email-sergey.senozhatsky@gmail.com>
 <20140224235315.GE24325@bbox>
 <20140224235824.GC2293@swordfish>
 <20140225001252.GG24325@bbox>
 <20140225002522.GD2293@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225002522.GD2293@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 03:25:22AM +0300, Sergey Senozhatsky wrote:
> On (02/25/14 09:12), Minchan Kim wrote:
> > On Tue, Feb 25, 2014 at 02:58:24AM +0300, Sergey Senozhatsky wrote:
> > > On (02/25/14 08:53), Minchan Kim wrote:
> > > > On Fri, Feb 21, 2014 at 02:50:42PM +0300, Sergey Senozhatsky wrote:
> > > > > 1) Add ZRAM_MULTI_STREAM configuration option and make multi stream
> > > > > zcomp support available.
> > > > > 
> > > > > 2) Introduce zram device attribute max_comp_streams to show and store
> > > > > current zcomp's max number of zcomp streams (num_strm).
> > > > > 
> > > > > 3) Extend zcomp zcomp_create() with `num_strm' parameter. `num_strm'
> > > > > limits the number of zcomp_strm structs in compression backend's idle
> > > > > list (max_comp_streams).
> > > > > 
> > > > > If ZRAM_MULTI_STREAM option selected:
> > > > > -- user can change max number of compression streams (max_comp_streams),
> > > > >    otherwise, attempt to change its default value (1) will be ignored.
> > > > > -- passing to zcomp_create() num_strm equals to 1 will initialise zcomp
> > > > >    using single compression stream zcomp_strm_single (mutex-based locking)
> > > > > -- passing to zcomp_create() num_strm greater than 1 will initialise zcomp
> > > > >    using multi compression stream zcomp_strm_multi (spinlock-based locking)
> > > > > 
> > > > > If ZRAM_MULTI_STREAM has not been selected, only single compression stream
> > > > > support available.
> > > > > 
> > > > > iozone -t 3 -R -r 16K -s 60M -I +Z
> > > > > 
> > > > >        test           base       1 strm (mutex)     3 strm (spinlock)
> > > > > -----------------------------------------------------------------------
> > > > >  Initial write      589286.78       583518.39          718011.05
> > > > >        Rewrite      604837.97       596776.38         1515125.72
> > > > >   Random write      584120.11       595714.58         1388850.25
> > > > >         Pwrite      535731.17       541117.38          739295.27
> > > > >         Fwrite     1418083.88      1478612.72         1484927.06
> > > > > 
> > > > > Usage example:
> > > > > set max_comp_streams to 4
> > > > >         echo 4 > /sys/block/zram0/max_comp_streams
> > > > > 
> > > > > show current max_comp_streams (default value is 1).
> > > > >         cat /sys/block/zram0/max_comp_streams
> > > > > 
> > > > > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > > > > ---
> > > > >  drivers/block/zram/Kconfig    | 10 ++++++++++
> > > > >  drivers/block/zram/zcomp.c    | 13 +++++++++++--
> > > > >  drivers/block/zram/zcomp.h    |  2 +-
> > > > >  drivers/block/zram/zram_drv.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> > > > >  drivers/block/zram/zram_drv.h |  2 +-
> > > > >  5 files changed, 65 insertions(+), 5 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
> > > > > index 3450be8..a2ba9a9 100644
> > > > > --- a/drivers/block/zram/Kconfig
> > > > > +++ b/drivers/block/zram/Kconfig
> > > > > @@ -15,6 +15,16 @@ config ZRAM
> > > > >  
> > > > >  	  See zram.txt for more information.
> > > > >  
> > > > > +config ZRAM_MULTI_STREAM
> > > > > +	bool "Multi stream compression support"
> > > > > +	depends on ZRAM
> > > > > +	default n
> > > > > +	help
> > > > > +	  This option adds additional functionality to ZRAM, that enables
> > > > > +	  multi compression stream support and provides ability to control
> > > > > +	  maximum number of parallel compressions using max_comp_streams
> > > > > +	  device attribute.
> > > > > +
> > > > >  config ZRAM_DEBUG
> > > > >  	bool "Compressed RAM block device debug support"
> > > > >  	depends on ZRAM
> > > > > diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> > > > > index 41325ed..7faa6bd 100644
> > > > > --- a/drivers/block/zram/zcomp.c
> > > > > +++ b/drivers/block/zram/zcomp.c
> > > > > @@ -240,8 +240,9 @@ void zcomp_destroy(struct zcomp *comp)
> > > > >   * if requested algorithm is not supported or in case
> > > > >   * of init error
> > > > >   */
> > > > > -struct zcomp *zcomp_create(const char *compress)
> > > > > +struct zcomp *zcomp_create(const char *compress, int num_strm)
> > > > >  {
> > > > > +	int ret;
> > > > >  	struct zcomp *comp;
> > > > >  	struct zcomp_backend *backend;
> > > > >  
> > > > > @@ -254,7 +255,15 @@ struct zcomp *zcomp_create(const char *compress)
> > > > >  		return NULL;
> > > > >  
> > > > >  	comp->backend = backend;
> > > > > -	if (zcomp_strm_single_create(comp) != 0) {
> > > > > +#ifdef CONFIG_ZRAM_MULTI_STREAM
> > > > > +	if (num_strm > 1)
> > > > > +		ret = zcomp_strm_multi_create(comp, num_strm);
> > > > > +	else
> > > > > +		ret = zcomp_strm_single_create(comp);
> > > > > +#else
> > > > > +	ret = zcomp_strm_single_create(comp);
> > > > > +#endif
> > > > > +	if (ret != 0) {
> > > > >  		zcomp_destroy(comp);
> > > > >  		return NULL;
> > > > >  	}
> > > > > diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> > > > > index 8dc1d7f..d7e1229 100644
> > > > > --- a/drivers/block/zram/zcomp.h
> > > > > +++ b/drivers/block/zram/zcomp.h
> > > > > @@ -42,7 +42,7 @@ struct zcomp {
> > > > >  	void (*destroy)(struct zcomp *comp);
> > > > >  };
> > > > >  
> > > > > -struct zcomp *zcomp_create(const char *comp);
> > > > > +struct zcomp *zcomp_create(const char *comp, int num_strm);
> > > > >  void zcomp_destroy(struct zcomp *comp);
> > > > >  
> > > > >  struct zcomp_strm *zcomp_strm_get(struct zcomp *comp);
> > > > > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > > > > index 200c12a..c147e6f 100644
> > > > > --- a/drivers/block/zram/zram_drv.c
> > > > > +++ b/drivers/block/zram/zram_drv.c
> > > > > @@ -107,6 +107,42 @@ static ssize_t mem_used_total_show(struct device *dev,
> > > > >  	return sprintf(buf, "%llu\n", val);
> > > > >  }
> > > > >  
> > > > > +static ssize_t max_comp_streams_show(struct device *dev,
> > > > > +		struct device_attribute *attr, char *buf)
> > > > > +{
> > > > > +	long val;
> > > > 
> > > > Why 'long'?
> > > > 
> > > > > +	struct zram *zram = dev_to_zram(dev);
> > > > > +
> > > > > +	down_read(&zram->init_lock);
> > > > > +	val = zram->max_comp_streams;
> > > > > +	up_read(&zram->init_lock);
> > > > > +
> > > > > +	return sprintf(buf, "%ld\n", val);
> > > > > +}
> > > > > +
> > > > > +static ssize_t max_comp_streams_store(struct device *dev,
> > > > > +		struct device_attribute *attr, const char *buf, size_t len)
> > > > > +{
> > > > > +#ifdef CONFIG_ZRAM_MULTI_STREAM
> > > > > +	long num;
> > > > > +	struct zram *zram = dev_to_zram(dev);
> > > > > +
> > > > > +	if (kstrtol(buf, 0, &num))
> > > > > +		return -EINVAL;
> > > > > +	if (num < 1)
> > > > > +		return -EINVAL;
> > > > > +	down_write(&zram->init_lock);
> > > > > +	if (init_done(zram)) {
> > > > > +		up_write(&zram->init_lock);
> > > > > +		pr_info("Can't set max_comp_streams for initialized device\n");
> > > > > +		return -EBUSY;
> > > > > +	}
> > > > > +	zram->max_comp_streams = num;
> > > > > +	up_write(&zram->init_lock);
> > > > 
> > > > If user decrease max stream in runtime, who care of freeing streams?
> > > > 
> > > 
> > > at the moment (to make it simpler), user can set max stream number
> > > only for un-initialised device. once zcomp created and initialised
> > > user cannot change max streams
> > 
> > Hmm, I hope we have the abilitiy in the first place because I think
> > it's not complicate and make test very handy. Please.
> > 
> 
> ok, I'll take a look. I'm not sure that I'll finish it tonight.
> I need to think about it for a moment. probably it will require
> several additional counters in zcomp_strm_multi -- max_strms
> and num_strms (num_strms equals to number of currently allocated
> streams). user may decrease (for example) max streams while every
> available stream is busy (idle list is empty), so we need to check
> max_strms and avail_strms while we _put() stream. and we definitely
> don't want max_strms for zcomp_strm_multi to be less than 2  :-)
> 
> so far I've address your notes and concerns -- no CONFIG option,
> both multi and single streams options, etc.

Thanks!

-- 
Kind regards,
Minchan Kim
