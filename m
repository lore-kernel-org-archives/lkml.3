Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3BYRP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:15:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:20365 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3BYRPZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:15:25 -0500
MIME-Version: 1.0
Message-ID: <69936094-e2fc-44bd-b179-f567e8681bec@default>
Date: Mon, 25 Feb 2013 09:05:38 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: RE: [PATCHv5 1/8] zsmalloc: add to mm/
References: <1360780731-11708-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1360780731-11708-2-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130219091804.GA13989@lge.com> <5123BC4D.1010404@linux.vnet.ibm.com>
 <20130219233733.GA16950@blaptop> <20130222092420.GA8077@lge.com>
 <5127CF34.9040302@linux.vnet.ibm.com>
In-Reply-To: <5127CF34.9040302@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Friday, February 22, 2013 1:04 PM
> To: Joonsoo Kim
> Subject: Re: [PATCHv5 1/8] zsmalloc: add to mm/
> 
> On 02/22/2013 03:24 AM, Joonsoo Kim wrote:
> >
> > It's my quick thought. So there is no concrete idea.
> > As Seth said, with a FULL list, zsmalloc always access all zspage.
> > So, if we want to know what pages are for zsmalloc, we can know it.
> > The EMPTY list can be used for pool of zsmalloc itself. With it, we don't
> > need to free zspage directly, we can keep zspages, so can reduce
> > alloc/free overhead. But, I'm not sure whether it is useful.
> 
> I think it's a good idea.  zswap actually does this "keeping some free
> pages around for later allocations" outside zsmalloc in a mempool that
> zswap manages.  Minchan once mentioned bringing that inside zsmalloc
> and this would be a way we could do it.

I think it's a very bad idea.  If I understand, the suggestion will
hide away some quantity (possibly a very large quantity) of pages
for the sole purpose of zswap, in case zswap gets around to using them
sometime in the future.  In the meantime, those pages are not available
for use by any other kernel subsystems or by userland processes.
An idle page is a wasted page.

While you might defend the mempool use for a handful of pages,
frontswap writes/reads thousands of pages in a bursty way,
and then can go idle for a very long time.  This may not be
readily apparent with artificially-created memory pressure
from kernbench with -jN (high N).  Leaving thousands
of pages in zswap's personal free list may cause memory pressure
that would otherwise never have existed.

> Just want to be clear that I'd be in favor of looking at this after
> the merge.

I disagree... I think this is exactly the kind of fundamental
MM interaction that should be well understood and resolved
BEFORE anything gets merged.
