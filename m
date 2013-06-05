Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3FENz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:55:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40439 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab3FENzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:55:22 -0400
Date: Wed, 5 Jun 2013 08:55:08 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Bob Liu <bob.liu@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@sr71.net>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv13 2/4] zbud: add to mm/
Message-ID: <20130605135508.GA25375@cerebellum>
References: <1370291585-26102-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1370291585-26102-3-git-send-email-sjenning@linux.vnet.ibm.com>
 <51AEDE10.4010108@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AEDE10.4010108@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060513-7182-0000-0000-0000072647B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 02:43:28PM +0800, Bob Liu wrote:
> Hi Seth,
> 
> On 06/04/2013 04:33 AM, Seth Jennings wrote:
> > +	/* Couldn't find unbuddied zbud page, create new one */
> 
> How about moving zswap_is_full() to here.
> 
> if (zswap_is_full()) {
> 	/* Don't alloc any new page, try to reclaim and direct use the
> reclaimed page instead */

Yes, this is at the top of the list for improvements.

I have already started on this work and it isn't quite as simple as it seems.
The difficulty rises from the fact that, for now, zswap uses per-cpu
compression buffers which require preemption to be disabled. This prevents the
calling zbud_reclaim_page() in zbud_alloc() because the eviction handler for
the user may do something that can wait; an allocation with GFP_WAIT for
example.

So it's going to take some massaging in the zswap layer to get that to work.

It's very doable.  Just not in this patchset without causing a lot of code
thrash.

> }
> 
> > +	spin_unlock(&pool->lock);
> > +	page = alloc_page(gfp);
> > +	if (!page)
> > +		return -ENOMEM;
> > +	spin_lock(&pool->lock);
> > +	pool->pages_nr++;
> > +	zhdr = init_zbud_page(page);
> > +	bud = FIRST;
<snip>
> 
> It looks good for me except two things.
> One is about what the performance might be after the zswap pool is full.
> The other is still about the 20% limit of zswap pool size.

Yep, working on both of them.

Seth

