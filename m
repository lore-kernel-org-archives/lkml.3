Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3AYUsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:48:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51656 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3AYUsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:48:19 -0500
MIME-Version: 1.0
Message-ID: <54da1c87-93f9-4643-8f71-597c1ff30e33@default>
Date: Fri, 25 Jan 2013 12:47:44 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org,
        Konrad Wilk <konrad.wilk@oracle.com>, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org
Subject: RE: [PATCH 2/2] staging: zcache: optional support for zsmalloc as
 alternate allocator
References: <1358977591-24485-1-git-send-email-dan.magenheimer@oracle.com>
 <1358977591-24485-2-git-send-email-dan.magenheimer@oracle.com>
 <20130125192617.GA26634@kroah.com>
In-Reply-To: <20130125192617.GA26634@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Subject: Re: [PATCH 2/2] staging: zcache: optional support for zsmalloc as alternate allocator
> 
> On Wed, Jan 23, 2013 at 01:46:31PM -0800, Dan Magenheimer wrote:
> > "New" zcache uses zbud for all sub-page allocation which is more flexible but
> > results in lower density.  "Old" zcache supported zsmalloc for frontswap
> > pages.  Add zsmalloc to "new" zcache as a compile-time and run-time option
> > for backwards compatibility in case any users wants to use zcache with
> > highest possible density.
> >
> > Note that most of the zsmalloc stats in old zcache are not included here
> > because old zcache used sysfs and new zcache has converted to debugfs.
> > These stats may be added later.
> >
> > Note also that ramster is incompatible with zsmalloc as the two use
> > the least significant bits in a pampd differently.
> >
> > Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> > ---
> >  drivers/staging/zcache/Kconfig       |   11 ++
> >  drivers/staging/zcache/zcache-main.c |  210 ++++++++++++++++++++++++++++++++--
> >  drivers/staging/zcache/zcache.h      |    3 +
> >  3 files changed, 215 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
> > index c1dbd04..116f8d5 100644
> > --- a/drivers/staging/zcache/Kconfig
> > +++ b/drivers/staging/zcache/Kconfig
> > @@ -10,6 +10,17 @@ config ZCACHE
> >  	  memory to store clean page cache pages and swap in RAM,
> >  	  providing a noticeable reduction in disk I/O.
> >
> > +config ZCACHE_ZSMALLOC
> > +	bool "Allow use of zsmalloc allocator for compression of swap pages"
> > +	depends on ZSMALLOC=y && !RAMSTER
> > +	default n
> > +	help
> > +	  Zsmalloc is a much more efficient allocator for compresssed
> > +	  pages but currently has some design deficiencies in that it
> > +	  does not support reclaim nor compaction.  Select this if
> > +	  you are certain your workload will fit or has mostly short
> > +	  running processes.  Zsmalloc is incompatible with RAMster.
> 
> How can anyone be "certain"?
> 
> 
> > --- a/drivers/staging/zcache/zcache-main.c
> > +++ b/drivers/staging/zcache/zcache-main.c
> > @@ -26,6 +26,12 @@
> >  #include <linux/cleancache.h>
> >  #include <linux/frontswap.h>
> >  #include "tmem.h"
> > +#ifdef CONFIG_ZCACHE_ZSMALLOC
> > +#include "../zsmalloc/zsmalloc.h"
> 
> Don't #ifdef .h files in .c files.
> 
> > +static int zsmalloc_enabled;
> > +#else
> > +#define zsmalloc_enabled 0
> > +#endif
> 
> That should have been your only ifdef in this .c file, all of the ones
> you have after this should not be needed, so I can't take this patch,
> sorry.

Yep.  Sorry, I was just trying to refresh this from when
I posted the proof-of-concept last summer.  I should have
spent more time cleaning it up.  Will be away for
a few days so will try to repost in a week or two,
hopefully not too late for this cycle.

Sorry for the noise.
Dan
