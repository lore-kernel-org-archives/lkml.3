Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaCJHyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:54:40 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:44717 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaCJHyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:54:39 -0400
Date: Mon, 10 Mar 2014 10:50:52 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH] zram: propagate error to user
Message-ID: <20140310075052.GA2233@swordfish.minsk.epam.com>
References: <1394157378-7718-1-git-send-email-minchan@kernel.org>
 <20140307092045.GA2571@swordfish.minsk.epam.com>
 <20140307095134.GG3787@bbox>
 <20140309165851.GA2185@swordfish.minsk.epam.com>
 <20140310020122.GD14370@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310020122.GD14370@bbox>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On (03/10/14 11:01), Minchan Kim wrote:
> Hello Sergey,
> 
> On Sun, Mar 09, 2014 at 07:58:51PM +0300, Sergey Senozhatsky wrote:
> > Hello Minchan,
> > 
> > On (03/07/14 18:51), Minchan Kim wrote:
> > > Hello Sergey!
> > > 
> > > On Fri, Mar 07, 2014 at 12:20:45PM +0300, Sergey Senozhatsky wrote:
> > > > On (03/07/14 10:56), Minchan Kim wrote:
> > > > > When we initialized zcomp with single, we couldn't change
> > > > > max_comp_streams without zram reset but current interface doesn't
> > > > > show any error to user and even it changes max_comp_streams's value
> > > > > without any effect so it would make user very confusing.
> > > > > 
> > > > > This patch prevents max_comp_streams's change when zcomp was
> > > > > initialized as single zcomp and emit the error to user(ex, echo).
> > > > > 
> > > > > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > > > > ---
> > > > >  Documentation/blockdev/zram.txt |  9 +++++----
> > > > >  drivers/block/zram/zcomp.c      | 10 +++++-----
> > > > >  drivers/block/zram/zcomp.h      |  4 ++--
> > > > >  drivers/block/zram/zram_drv.c   | 15 +++++++++++----
> > > > >  4 files changed, 23 insertions(+), 15 deletions(-)
> > > > > 
> > > > > diff --git a/Documentation/blockdev/zram.txt b/Documentation/blockdev/zram.txt
> > > > > index 2604ffed51db..0595c3f56ccf 100644
> > > > > --- a/Documentation/blockdev/zram.txt
> > > > > +++ b/Documentation/blockdev/zram.txt
> > > > > @@ -37,10 +37,11 @@ Note:
> > > > >  In order to enable compression backend's multi stream support max_comp_streams
> > > > >  must be initially set to desired concurrency level before ZRAM device
> > > > >  initialisation. Once the device initialised as a single stream compression
> > > > > -backend (max_comp_streams equals to 0) changing the value of max_comp_streams
> > > > > -will not take any effect, because single stream compression backend implemented
> > > > > -as a special case and does not support dynamic max_comp_streams. Only multi
> > > > > -stream backend supports dynamic max_comp_streams adjustment.
> > > > > +backend (max_comp_streams equals to 1), you will see error if you try to change
> > > > > +the value of max_comp_streams because single stream compression backend
> > > > > +implemented as a special case by lock overhead issue and does not support
> > > > > +dynamic max_comp_streams. Only multi stream backend supports dynamic
> > > > > +max_comp_streams adjustment.
> > > > >  
> > > > >  3) Select compression algorithm
> > > > >  	Using comp_algorithm device attribute one can see available and
> > > > > diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> > > > > index 92a83df40a27..15fe6a27781b 100644
> > > > > --- a/drivers/block/zram/zcomp.c
> > > > > +++ b/drivers/block/zram/zcomp.c
> > > > > @@ -152,7 +152,7 @@ static void zcomp_strm_multi_release(struct zcomp *comp, struct zcomp_strm *zstr
> > > > >  }
> > > > >  
> > > > >  /* change max_strm limit */
> > > > > -static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
> > > > > +static bool zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
> > > > >  {
> > > > >  	struct zcomp_strm_multi *zs = comp->stream;
> > > > >  	struct zcomp_strm *zstrm;
> > > > > @@ -171,7 +171,7 @@ static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
> > > > >  		zs->avail_strm--;
> > > > >  	}
> > > > >  	spin_unlock(&zs->strm_lock);
> > > > > -	return 0;
> > > > > +	return true;
> > > > >  }
> > > > >  
> > > > >  static void zcomp_strm_multi_destroy(struct zcomp *comp)
> > > > > @@ -231,10 +231,10 @@ static void zcomp_strm_single_release(struct zcomp *comp,
> > > > >  	mutex_unlock(&zs->strm_lock);
> > > > >  }
> > > > >  
> > > > > -static int zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
> > > > > +static bool zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
> > > > >  {
> > > > >  	/* zcomp_strm_single support only max_comp_streams == 1 */
> > > > > -	return -ENOTSUPP;
> > > > > +	return 0;
> > > > >  }
> > > > 
> > > > IMHO, -ENOTSUPP for unsupported operation fits better than `false'.
> > > > yes, currently there are only two possible returns:
> > > > 	0 -- success
> > > > 	-ENOTSUPP - not supported operation
> > > > 
> > > > though, we can extend functions later and return additional codes, other
> > > > than `false' and `true'.
> > > 
> > > Thing to expose to user isn't true and false but EINVAL.
> > > 
> > 
> > sure. I mean we can return actual zcomp_set_max_streams() error (if any)
> > back to user from max_comp_streams_store():
> > 
> > 	[..]
> > 	ret = zcomp_set_max_streams(...);
> > 	[..]
> > 	return ret;
> > 
> > > > 
> > > > for example, -E2BIG if user requested extremly large number of streams,
> > > > like 5000 streams.
> > > 
> > > I'm not sure it's right example for E2BIG.
> > > When I read the comment, it says "argument list too long".
> > > Anyway, when I tried ENOTSUPP, echo doesn't show meaningful error to user
> > > and I dont' know it's casual err number for userspace.
> > > Pz, comment about that.
> > > 
> > 
> > E2BIG (introduced by POSIX.1-2001) was a quick example and, probably, not
> > the perfect one. In general, I'm not against this change and I can live
> > with zcomp_set_max_streams() returning bool.
> 
> Then, could you give me Acked-by?
> I am hungry with that. :)
> 

sure :)

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


	-ss
> -- 
> Kind regards,
> Minchan Kim
> 
