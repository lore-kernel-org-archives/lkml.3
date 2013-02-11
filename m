Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868Ab3BKTQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:16:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41484 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab3BKTP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:15:59 -0500
MIME-Version: 1.0
Message-ID: <c12553f9-2472-4dc2-b19e-ff17e5e462af@default>
Date: Mon, 11 Feb 2013 11:13:38 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Lord Glauber Costa of Sealand <glommer@parallels.com>
Cc: Rik van Riel <riel@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCHv2 8/9] zswap: add to mm/
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <1357590280-31535-9-git-send-email-sjenning@linux.vnet.ibm.com>
 <51030ADA.8030403@redhat.com> <510698F5.5060205@linux.vnet.ibm.com>
 <5107A2B8.4070505@parallels.com> <5113D291.2020903@linux.vnet.ibm.com>
In-Reply-To: <5113D291.2020903@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCHv2 8/9] zswap: add to mm/
> 
> On 01/29/2013 04:21 AM, Lord Glauber Costa of Sealand wrote:
> > On 01/28/2013 07:27 PM, Seth Jennings wrote:
> >> Yes, I prototyped a shrinker interface for zswap, but, as we both
> >> figured, it shrinks the zswap compressed pool too aggressively to the
> >> point of being useless.
> > Can't you advertise a smaller number of objects that you actively have?
> 
> Thanks for looking at the code!
> 
> An interesting idea.  I'm just not sure how you would manage the
> underlying policy of how aggressively does zswap allow itself to be
> shrunk?  The fact that zswap _only_ operates under memory pressure
> makes that policy difficult, because it is under continuous shrinking
> pressure, unlike other shrinkable caches in the kernel that spend most
> of their time operating in unconstrained or lightly/intermittently
> strained conditions.

Hi Seth --

Zswap (as well as zcache) doesn't "_only_ operate under memory
pressure".  It _grows_ only under memory pressure but can get
smaller via frontswap_loads and frontswap_invalidates
at other times.  I agree that writeback (from zswap to the
real swap disk, what zswap calls "flush") need only occur
when under memory pressure, but that's when a shrinker is called.

FYI, the way that zcache does this (for swap pages) is the
zcache shrinker drives the number of wholepages used to store
zpages down to match the number of wholepages used for anonymous
pages.  In zswap terms, that means you would call zswap_flush_entry
in a zswap shrinker thread continually until

 zswap_pool_pages <= global_page_state(NR_LRU_BASE + LRU_ACTIVE_ANON) +
                     global_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON)

The zcache shrinker (currently) ignores nr_to_scan entirely;
the fact that the zcache shrinker is called is the signal for
zswap/zcache to start flush/writeback (moving compressed pages out to
swap disk).  This isn't a great match for the system shrinker
API but it seems to avoid the "aggressively to the point of
being useless" problem so is at least a step in the right direction.

Dan
