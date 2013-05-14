Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab3ENQk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:40:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26708 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab3ENQkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:40:25 -0400
MIME-Version: 1.0
Message-ID: <b9131728-5cf8-4979-a6de-ac14cc409b28@default>
Date: Tue, 14 May 2013 09:37:08 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>,
        Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
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
Subject: RE: [PATCHv11 3/4] zswap: add to mm/
References: <1368448803-2089-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1368448803-2089-4-git-send-email-sjenning@linux.vnet.ibm.com>
 <51920197.9070105@oracle.com> <20130514160040.GB4024@medulla>
In-Reply-To: <20130514160040.GB4024@medulla>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCHv11 3/4] zswap: add to mm/
> 
> On Tue, May 14, 2013 at 05:19:19PM +0800, Bob Liu wrote:
> > Hi Seth,
> 
> Hi Bob, thanks for the review!
> 
> >
> > > +	/* reclaim space if needed */
> > > +	if (zswap_is_full()) {
> > > +		zswap_pool_limit_hit++;
> > > +		if (zbud_reclaim_page(tree->pool, 8)) {
> >
> > My idea is to wake up a kernel thread here to do the reclaim.
> > Once zswap is full(20% percent of total mem currently), the kernel
> > thread should reclaim pages from it. Not only reclaim one page, it
> > should depend on the current memory pressure.
> > And then the API in zbud may like this:
> > zbud_reclaim_page(pool, nr_pages_to_reclaim, nr_retry);
> 
> So kswapd for zswap.  I'm not opposed to the idea if a case can be
> made for the complexity.  I must say, I don't see that case though.
> 
> The policy can evolve as deficiencies are demonstrated and solutions are
> found.

Hmmm... it is fairly easy to demonstrate the deficiency if
one tries.  I actually first saw it occur on a real (though
early) EL6 system which started some graphics-related service
that caused a very brief swapstorm that was invisible during
normal boot but clogged up RAM with compressed pages which
later caused reduced weird benchmarking performance.

I think Mel's unpredictability concern applies equally here...
this may be a "long-term source of bugs and strange memory
management behavior."

> Can I get your ack on this pending the other changes?

I'd like to hear Mel's feedback about this, but perhaps
a compromise to allow for zswap merging would be to add
something like the following to zswap's Kconfig comment:

"Zswap reclaim policy is still primitive.  Until it improves,
zswap should be considered experimental and is not recommended
for production use."

If Mel agrees with the unpredictability and also agrees
with the Kconfig compromise, I am willing to ack.
