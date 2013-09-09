Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3IIIdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:33:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20826 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3IIIdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:33:40 -0400
Date: Mon, 9 Sep 2013 11:33:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 1/2] staging: zram: minimize `slot_free_lock' usage
Message-ID: <20130909083327.GX6329@mwanda>
References: <20130906134706.GA2238@swordfish.minsk.epam.com>
 <5229E9BF.5020604@redhat.com>
 <20130906145545.GC2238@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906145545.GC2238@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:55:45PM +0300, Sergey Senozhatsky wrote:
> On (09/06/13 16:42), Jerome Marchand wrote:
> > On 09/06/2013 03:47 PM, Sergey Senozhatsky wrote:
> > > Calling handle_pending_slot_free() for every RW operation may
> > > cause unneccessary slot_free_lock locking, because most likely
> > > process will see NULL slot_free_rq. handle_pending_slot_free()
> > > only when current detects that slot_free_rq is not NULL.
> > > 
> > > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > > 
> > > ---
> > > 
> > >  drivers/staging/zram/zram_drv.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> > > index 91d94b5..17386e2 100644
> > > --- a/drivers/staging/zram/zram_drv.c
> > > +++ b/drivers/staging/zram/zram_drv.c
> > > @@ -532,14 +532,15 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
> > >  {
> > >  	int ret;
> > >  
> > > +	if (zram->slot_free_rq)
> > > +		handle_pending_slot_free(zram);
> > > +
> > 
> > Calling handle_pending_slot_free() without holding zram->lock?
> > That's racy.
> 
> sorry, my bad. it should take down_write() lock.
> 

Or down_read() on the read path.  We leave the original as-is?

regards,
dan carpenter

