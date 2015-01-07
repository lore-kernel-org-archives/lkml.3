Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbbAGK6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:58:08 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33375 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbbAGK5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:57:52 -0500
Date: Wed, 7 Jan 2015 11:57:49 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH V4 4/4] mm: microoptimize zonelist operations
Message-ID: <20150107105749.GC16553@dhcp22.suse.cz>
References: <1420478263-25207-1-git-send-email-vbabka@suse.cz>
 <1420478263-25207-5-git-send-email-vbabka@suse.cz>
 <20150106150920.GE20860@dhcp22.suse.cz>
 <54ACF93B.3060801@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ACF93B.3060801@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-01-15 10:15:39, Vlastimil Babka wrote:
> On 01/06/2015 04:09 PM, Michal Hocko wrote:
> > On Mon 05-01-15 18:17:43, Vlastimil Babka wrote:
> >> The function next_zones_zonelist() returns zoneref pointer, as well as zone
> >> pointer via extra parameter. Since the latter can be trivially obtained by
> >> dereferencing the former, the overhead of the extra parameter is unjustified.
> >> 
> >> This patch thus removes the zone parameter from next_zones_zonelist(). Both
> >> callers happen to be in the same header file, so it's simple to add the
> >> zoneref dereference inline. We save some bytes of code size.
> > 
> > Dunno. It makes first_zones_zonelist and next_zones_zonelist look
> > different which might be a bit confusing. It's not a big deal but
> > I am not sure it is worth it.
> 
> Yeah I thought that nobody uses them directly anyway thanks to
> for_each_zone_zonelist* so it's not a big deal.

OK, I have checked why we need the whole struct zoneref when it
only caches zone_idx. dd1a239f6f2d (mm: have zonelist contains
structs with both a zone pointer and zone_idx) claims this will
reduce cache contention by reducing pointer chasing because we
do not have to dereference pgdat so often in hot paths. Fair
enough but I do not see any numbers in the changelog nor in the
original discussion (https://lkml.org/lkml/2007/11/20/547 resp.
https://lkml.org/lkml/2007/9/28/170). Maybe Mel remembers what was the
benchmark which has shown the difference so that we can check whether
this is still relevant and caching the index is still worth it.

-- 
Michal Hocko
SUSE Labs
