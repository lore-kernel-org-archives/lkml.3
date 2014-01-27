Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaA0KIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:08:10 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:23470 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaA0KIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:08:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,728,1384300800"; 
   d="scan'208";a="94729680"
Message-ID: <1390817282.9890.23.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen-blkback: fix memory leak when
 persistent grants are used
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Matt Wilson <msw@linux.com>
CC: Matt Wilson <msw@amazon.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, Matt Rushton <mrushton@amazon.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>,
        Roger Pau =?ISO-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Date: Mon, 27 Jan 2014 10:08:02 +0000
In-Reply-To: <20140125210659.GA15756@u109add4315675089e695.ant.amazon.com>
References: <1390505326-9368-1-git-send-email-msw@linux.com>
	 <1390555293.2124.6.camel@kazak.uk.xensource.com>
	 <1390577782.13513.8.camel@kazak.uk.xensource.com>
	 <20140125210659.GA15756@u109add4315675089e695.ant.amazon.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-25 at 13:07 -0800, Matt Wilson wrote:
> On Fri, Jan 24, 2014 at 03:36:22PM +0000, Ian Campbell wrote:
> > On Fri, 2014-01-24 at 09:21 +0000, Ian Campbell wrote:
> > > On Thu, 2014-01-23 at 11:28 -0800, Matt Wilson wrote:
> > > > From: Matt Rushton <mrushton@amazon.com>
> > > > 
> > > > Currently shrink_free_pagepool() is called before the pages used for
> > > > persistent grants are released via free_persistent_gnts(). This
> > > > results in a memory leak when a VBD that uses persistent grants is
> > > > torn down.
> > > 
> > > This may well be the explanation for the memory leak I was observing on
> > > ARM last night. I'll give it a go and let you know.
> > 
> > Results are a bit inconclusive unfortunately, it seems like I am seeing
> > some other leak too (or instead).
> > 
> > Totally unscientifically it does seem to be leaking more slowly than
> > before, so perhaps this patch has helped, but nothing conclusive I'm
> > afraid.
> 
> Testing here looks good. I don't know if perhaps something else is
> going on with ARM...
> 
> > I don't think that quite qualifies for a Tested-by though, sorry.
> 
> How about an Acked-by? ;-)

I'm not at all familiar with the modern blkback code base so I'm afraid
it would be a pretty hollow Ack.

> 
> --msw
> 
> > Ian. 
> > 
> > > 
> > > > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > Cc: "Roger Pau Monné" <roger.pau@citrix.com>
> > > > Cc: Ian Campbell <Ian.Campbell@citrix.com>
> > > > Cc: David Vrabel <david.vrabel@citrix.com>
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Cc: xen-devel@lists.xen.org
> > > > Cc: Anthony Liguori <aliguori@amazon.com>
> > > > Signed-off-by: Matt Rushton <mrushton@amazon.com>
> > > > Signed-off-by: Matt Wilson <msw@amazon.com>
> > > > ---
> > > >  drivers/block/xen-blkback/blkback.c |    6 +++---
> > > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> > > > index 6620b73..30ef7b3 100644
> > > > --- a/drivers/block/xen-blkback/blkback.c
> > > > +++ b/drivers/block/xen-blkback/blkback.c
> > > > @@ -625,9 +625,6 @@ purge_gnt_list:
> > > >  			print_stats(blkif);
> > > >  	}
> > > >  
> > > > -	/* Since we are shutting down remove all pages from the buffer */
> > > > -	shrink_free_pagepool(blkif, 0 /* All */);
> > > > -
> > > >  	/* Free all persistent grant pages */
> > > >  	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
> > > >  		free_persistent_gnts(blkif, &blkif->persistent_gnts,
> > > > @@ -636,6 +633,9 @@ purge_gnt_list:
> > > >  	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
> > > >  	blkif->persistent_gnt_c = 0;
> > > >  
> > > > +	/* Since we are shutting down remove all pages from the buffer */
> > > > +	shrink_free_pagepool(blkif, 0 /* All */);
> > > > +
> > > >  	if (log_stats)
> > > >  		print_stats(blkif);
> > > >  
> > > 
> > > 
> > > 
> > > _______________________________________________
> > > Xen-devel mailing list
> > > Xen-devel@lists.xen.org
> > > http://lists.xen.org/xen-devel
> > 
> > 


