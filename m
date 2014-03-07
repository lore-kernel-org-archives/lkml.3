Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaCGJvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:51:43 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60034 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaCGJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:51:36 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-23-531996a5dbb9
Date: Fri, 7 Mar 2014 18:51:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH] zram: propagate error to user
Message-ID: <20140307095134.GG3787@bbox>
References: <1394157378-7718-1-git-send-email-minchan@kernel.org>
 <20140307092045.GA2571@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307092045.GA2571@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey!

On Fri, Mar 07, 2014 at 12:20:45PM +0300, Sergey Senozhatsky wrote:
> On (03/07/14 10:56), Minchan Kim wrote:
> > When we initialized zcomp with single, we couldn't change
> > max_comp_streams without zram reset but current interface doesn't
> > show any error to user and even it changes max_comp_streams's value
> > without any effect so it would make user very confusing.
> > 
> > This patch prevents max_comp_streams's change when zcomp was
> > initialized as single zcomp and emit the error to user(ex, echo).
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  Documentation/blockdev/zram.txt |  9 +++++----
> >  drivers/block/zram/zcomp.c      | 10 +++++-----
> >  drivers/block/zram/zcomp.h      |  4 ++--
> >  drivers/block/zram/zram_drv.c   | 15 +++++++++++----
> >  4 files changed, 23 insertions(+), 15 deletions(-)
> > 
> > diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
> > index 2604ffed51db..0595c3f56ccf 100644
> > --- a/Documentation/blockdev/zram.txt
> > +++ b/Documentation/blockdev/zram.txt
> > @@ -37,10 +37,11 @@ Note:
> >  In order to enable compression backend's multi stream support max_comp_streams
> >  must be initially set to desired concurrency level before ZRAM device
> >  initialisation. Once the device initialised as a single stream compression
> > -backend (max_comp_streams equals to 0) changing the value of max_comp_streams
> > -will not take any effect, because single stream compression backend implemented
> > -as a special case and does not support dynamic max_comp_streams. Only multi
> > -stream backend supports dynamic max_comp_streams adjustment.
> > +backend (max_comp_streams equals to 1), you will see error if you try to change
> > +the value of max_comp_streams because single stream compression backend
> > +implemented as a special case by lock overhead issue and does not support
> > +dynamic max_comp_streams. Only multi stream backend supports dynamic
> > +max_comp_streams adjustment.
> >  
> >  3) Select compression algorithm
> >  	Using comp_algorithm device attribute one can see available and
> > diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> > index 92a83df40a27..15fe6a27781b 100644
> > --- a/drivers/block/zram/zcomp.c
> > +++ b/drivers/block/zram/zcomp.c
> > @@ -152,7 +152,7 @@ static void zcomp_strm_multi_release(struct zcomp *comp, struct zcomp_strm *zstr
> >  }
> >  
> >  /* change max_strm limit */
> > -static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
> > +static bool zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
> >  {
> >  	struct zcomp_strm_multi *zs = comp->stream;
> >  	struct zcomp_strm *zstrm;
> > @@ -171,7 +171,7 @@ static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
> >  		zs->avail_strm--;
> >  	}
> >  	spin_unlock(&zs->strm_lock);
> > -	return 0;
> > +	return true;
> >  }
> >  
> >  static void zcomp_strm_multi_destroy(struct zcomp *comp)
> > @@ -231,10 +231,10 @@ static void zcomp_strm_single_release(struct zcomp *comp,
> >  	mutex_unlock(&zs->strm_lock);
> >  }
> >  
> > -static int zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
> > +static bool zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
> >  {
> >  	/* zcomp_strm_single support only max_comp_streams == 1 */
> > -	return -ENOTSUPP;
> > +	return 0;
> >  }
> 
> IMHO, -ENOTSUPP for unsupported operation fits better than `false'.
> yes, currently there are only two possible returns:
> 	0 -- success
> 	-ENOTSUPP - not supported operation
> 
> though, we can extend functions later and return additional codes, other
> than `false' and `true'.

Thing to expose to user isn't true and false but EINVAL.

> 
> for example, -E2BIG if user requested extremly large number of streams,
> like 5000 streams.

I'm not sure it's right example for E2BIG.
When I read the comment, it says "argument list too long".
Anyway, when I tried ENOTSUPP, echo doesn't show meaningful error to user
and I dont' know it's casual err number for userspace.
Pz, comment about that.

> 
> >  
> >  static void zcomp_strm_single_destroy(struct zcomp *comp)
> > @@ -283,7 +283,7 @@ ssize_t zcomp_available_show(const char *comp, char *buf)
> >  	return sz;
> >  }
> >  
> > -int zcomp_set_max_streams(struct zcomp *comp, int num_strm)
> > +bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
> >  {
> >  	return comp->set_max_streams(comp, num_strm);
> >  }
> > diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
> > index 8b8997f8613b..c59d1fca72c0 100644
> > --- a/drivers/block/zram/zcomp.h
> > +++ b/drivers/block/zram/zcomp.h
> > @@ -46,7 +46,7 @@ struct zcomp {
> >  
> >  	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
> >  	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
> > -	int (*set_max_streams)(struct zcomp *comp, int num_strm);
> > +	bool (*set_max_streams)(struct zcomp *comp, int num_strm);
> >  	void (*destroy)(struct zcomp *comp);
> >  };
> >  
> > @@ -64,5 +64,5 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
> >  int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
> >  		size_t src_len, unsigned char *dst);
> >  
> > -int zcomp_set_max_streams(struct zcomp *comp, int num_strm);
> > +bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
> >  #endif /* _ZCOMP_H_ */
> > diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> > index 7631ef0cbc41..eead9db9b100 100644
> > --- a/drivers/block/zram/zram_drv.c
> > +++ b/drivers/block/zram/zram_drv.c
> > @@ -128,17 +128,24 @@ static ssize_t max_comp_streams_store(struct device *dev,
> >  	struct zram *zram = dev_to_zram(dev);
> >  
> >  	if (kstrtoint(buf, 0, &num))
> > -		return -EINVAL;
> > +		goto out;
> >  	if (num < 1)
> > -		return -EINVAL;
> > +		goto out;
> > +
> >  	down_write(&zram->init_lock);
> >  	if (init_done(zram)) {
> > -		if (zcomp_set_max_streams(zram->comp, num))
> > +		if (!zcomp_set_max_streams(zram->comp, num)) {
> >  			pr_info("Cannot change max compression streams\n");
> > +			goto out_unlock;
> > +		}
> >  	}
> > +
> >  	zram->max_comp_streams = num;
> 
> agree, better to avoid this for a single stream.

Yeb.

-- 
Kind regards,
Minchan Kim
