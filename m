Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab3BFXsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:48:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17902 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593Ab3BFXs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:48:28 -0500
MIME-Version: 1.0
Message-ID: <a06fbc6b-8731-4bfe-82ff-05e8d14d8595@default>
Date: Wed, 6 Feb 2013 15:47:29 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv3 5/6] zswap: add to mm/
References: <1359409767-30092-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1359409767-30092-6-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130129062756.GH4752@blaptop> <51080658.7060709@linux.vnet.ibm.com>
In-Reply-To: <51080658.7060709@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCHv3 5/6] zswap: add to mm/
> 
> On 01/29/2013 12:27 AM, Minchan Kim wrote:
> > First feeling is it's simple and nice approach.
> > Although we have some problems to decide policy, it could solve by later patch
> > so I hope we make basic infrasture more solid by lots of comment.
> 
> Thanks very much for the review!
> >
> > Another question.
> >
> > What's the benefit of using mempool for zsmalloc?
> > As you know, zsmalloc doesn't use mempool as default.
> > I guess you see some benefit. if so, zram could be changed.
> > If we can change zsmalloc's default scheme to use mempool,
> > all of customer of zsmalloc could be enhanced, too.
> 
> In the case of zswap, through experimentation, I found that adding a
> mempool behind the zsmalloc pool added some elasticity to the pool.
> Fewer stores failed if we kept a small reserve of pages around instead
> of having to go back to the buddy allocator who, under memory
> pressure, is more likely to reject our request.
> 
> I don't see this situation being applicable to all zsmalloc users
> however.  I don't think we want incorporate it directly into zsmalloc
> for now.  The ability to register custom page alloc/free functions at
> pool creation time allows users to do something special, like back
> with a mempool, if they want to do that.

(sorry, still catching up on backlog after being gone last week)

IIUC, by using mempool, you are essentially setting aside a
special cache of pageframes that only zswap can use (or other
users of mempool, I don't know what other subsystems use it).
So one would expect that fewer stores would fail if more
pageframes are available to zswap, the same as if you had
increased zswap_max_pool_percent by some small fraction.

But by setting those pageframes aside, you are keeping them from
general use, which may be a use with a higher priority as determined
by the mm system.

This seems wrong to me.  Should every subsystem hide a bunch of
pageframes away in case it might need them?

Or am I missing something?

Dan
