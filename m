Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaHDGiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 02:38:00 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57979 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaHDGh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 02:37:58 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 4 Aug 2014 15:45:06 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 02/14] mm, compaction: defer each zone individually
 instead of preferred zone
Message-ID: <20140804064505.GA22835@js1304-P5Q-DELUXE>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>
 <1406553101-29326-3-git-send-email-vbabka@suse.cz>
 <20140729063840.GA1610@js1304-P5Q-DELUXE>
 <53D76592.10105@suse.cz>
 <53D91BC9.7080506@suse.cz>
 <53DB54FB.6050100@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DB54FB.6050100@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 10:51:07AM +0200, Vlastimil Babka wrote:
> On 07/30/2014 06:22 PM, Vlastimil Babka wrote:
> >On 07/29/2014 11:12 AM, Vlastimil Babka wrote:
> >>On 07/29/2014 08:38 AM, Joonsoo Kim wrote:
> >>>
> >>>I still don't understand why defer_compaction() is needed here.
> >>>defer_compaction() is intended for not struggling doing compaction on
> >>>the zone where we already have tried compaction and found that it
> >>>isn't suitable for compaction. Allocation failure doesn't tell us
> >>>that we have tried compaction for all the zone range so we shouldn't
> >>>make a decision here to defer compaction on this zone carelessly.
> >>
> >>OK I can remove that, it should make the code nicer anyway.
> >
> >Weird, that removal of this defer_compaction() call seems ho have
> >quadrupled compact_stall and compact_fail counts. The scanner pages
> >counters however increased by only 10% so that could indicate the
> >problem is occuring only in a small zone such as DMA. Could be another
> >case of mismatch between watermark checking in compaction and
> >allocation? Perhaps the lack of proper classzone_idx in the compaction
> >check? Sigh.
> 
> Yep so it was the DMA zone returning COMPACT_PARTIAL from the
> compaction_suitable() check done at the very beginning of
> compact_zone(). The meaning of that is "the allocation should
> succeed without compaction", so compaction is not done at all. Yet
> the COMPACT_PARTIAL return value means it counts as a stall, even
> with the patch that doesn't count COMPACT_SKIPPED as stalls.
> The watermark check in try_to_compact_pages() also apparently
> succeeds as the compaction is not being deferred. With deferral
> removed from __alloc_pages_direct_compact(), this zone will be
> attempted uselessly each time, and deferred_compaction is
> practically never reported back.
> 
> So for now I think it would be best to leave the defer_compaction()
> call in __alloc_pages_direct_compact() as it is. Fixing this in a
> better way would require more investigation (I guess the lack of
> classzone_idx in compaction makes the difference for the watermark
> checks here) and another patch(es), which I'll attempt, but I don't
> want to further grow this series with new patches right now.

Okay. compaction has many inconsistent watermark check so we cannot
easily understand how/why it works. Cleaning it up looks really good
topic to investigate. :)

Thanks.
