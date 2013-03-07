Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab3CGXOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:14:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22084 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab3CGXOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:14:42 -0500
MIME-Version: 1.0
Message-ID: <cd5fb4ff-094c-430c-94fb-a7416de0d332@default>
Date: Thu, 7 Mar 2013 15:11:06 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, Dave Hansen <dave@sr71.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joe Perches <joe@perches.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv7 4/8] zswap: add to mm/
References: <1362585143-6482-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1362585143-6482-5-git-send-email-sjenning@linux.vnet.ibm.com>
 <5138E3C7.9080205@sr71.net> <513904F2.50607@linux.vnet.ibm.com>
In-Reply-To: <513904F2.50607@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> To: Dave Hansen
> Subject: Re: [PATCHv7 4/8] zswap: add to mm/
> 
> On 03/07/2013 01:00 PM, Dave Hansen wrote:
> > On 03/06/2013 07:52 AM, Seth Jennings wrote:
> > ...
> >> +**********************************/
> >> +/* attempts to compress and store an single page */
> >> +static int zswap_frontswap_store(unsigned type, pgoff_t offset,
> >> +				struct page *page)
> >> +{
> > ...
> >> +	/* store */
> >> +	handle = zs_malloc(tree->pool, dlen,
> >> +		__GFP_NORETRY | __GFP_HIGHMEM | __GFP_NOMEMALLOC |
> >> +			__GFP_NOWARN);
> >> +	if (!handle) {
> >> +		zswap_reject_zsmalloc_fail++;
> >> +		ret = -ENOMEM;
> >> +		goto putcpu;
> >> +	}
> >> +
> >
> > I think there needs to at least be some strong comments in here about
> > why you're doing this kind of allocation.  From some IRC discussion, it
> > seems like you found some pathological case where zswap wasn't helping
> > make reclaim progress and ended up draining the reserve pools and you
> > did this to avoid draining the reserve pools.
> 
> I'm currently doing some tests with fewer zsmalloc class sizes and
> removing __GFP_NOMEMALLOC to see the effect.

Zswap/zcache/frontswap are greedy, at times almost violently so.
Using emergency reserves seems like a sure way to OOM depending
on the workload (and luck).

I did some class size experiments too without seeing much advantage.
But without a range of "representative" data streams, it's very
hard to claim any experiment is successful.

I've got some ideas on combining the best of zsmalloc and zbud
but they are still a little raw.

> > I think the lack of progress doing reclaim is really the root cause you
> > should be going after here instead of just working around the symptom.

Dave, agreed.  See http://marc.info/?l=linux-mm&m=136147977602561&w=2 
and the PAGEFRAME EVACUATION subsection of
http://marc.info/?l=linux-mm&m=136200745931284&w=2
