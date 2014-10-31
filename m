Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaJaHsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:48:18 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48467 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJaHsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:48:17 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 31 Oct 2014 16:49:45 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/5] mm, compaction: pass classzone_idx and alloc_flags
 to watermark checking
Message-ID: <20141031074944.GA14642@js1304-P5Q-DELUXE>
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz>
 <1412696019-21761-2-git-send-email-vbabka@suse.cz>
 <20141027064651.GA23379@js1304-P5Q-DELUXE>
 <544E0C43.3030009@suse.cz>
 <20141028071625.GB27813@js1304-P5Q-DELUXE>
 <5450F0CF.3030504@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5450F0CF.3030504@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 02:51:11PM +0100, Vlastimil Babka wrote:
> On 10/28/2014 08:16 AM, Joonsoo Kim wrote:> On Mon, Oct 27, 2014 at
> 10:11:31AM +0100, Vlastimil Babka wrote:
> >> On 10/27/2014 07:46 AM, Joonsoo Kim wrote:
> >>> On Tue, Oct 07, 2014 at 05:33:35PM +0200, Vlastimil Babka wrote:
> >>>
> >>> Hello,
> >>>
> >>> compaction_suitable() has one more zone_watermark_ok(). Why is it
> >>> unchanged?
> >>
> >> Hi,
> >>
> >> it's a check whether there are enough free pages to perform compaction,
> >> which means enough migration targets and temporary copies during
> >> migration. These allocations are not affected by the flags of the
> >> process that makes the high-order allocation.
> >
> > Hmm...
> >
> > To check whether enough free page is there or not needs zone index and
> > alloc flag. What we need to ignore is just order information, IMO.
> > If there is not enough free page in that zone, compaction progress
> > doesn't have any meaning. It will fail due to shortage of free page
> > after successful compaction.
> 
> I thought that the second check in compaction_suitable() makes sure
> of this, but now I see it's in fact not.
> But i'm not sure if we should just put the flags in the first check,
> as IMHO the flags should only affect the final high-order
> allocation, not also the temporary pages needed for migration?

I don't think so.
As mentioned before, if we don't have not enough freepages, compaction
will fail due to shortage of freepage at final high-order watermark
check. Maybe it failes due to not enough freepage rather than ordered
freepage. Proper flags and index make us avoid useless compaction so
I prefer put the flags in the first check.

> 
> BTW now I'm not even sure that the 2UL << order part makes sense
> anymore. The number of pages migrated at once is always restricted
> by COMPACT_CLUSTER_MAX, so why would we need more than that to cover
> migration?

In fact, any values seems to be wrong. We can isolate high order freepage
for this temporary use. I don't have any idea what the proper value is.

> Also the order of checks seems wrong. It should return
> COMPACT_PARTIAL "If the allocation would succeed without compaction"
> but that only can happen after passing the check if the zone has the
> extra 1UL << order for migration. Do you agree?

Yes, agree!

> > I guess that __isolate_free_page() is also good candidate to need this
> > information in order to prevent compaction from isolating too many
> > freepage in low memory condition.
> 
> I don't see how it would help here. It's temporary allocations for
> page migration. How would passing classzone_idx and alloc_flags
> prevent isolating too many?

It is temporary allocation, but, anyway, it could holds many freepage
in some duration. As mentioned above, if we isolate high order freepage,
we can hold 1MB or more freepage at once. I guess that passing flags helps
system stability.

Thanks.
