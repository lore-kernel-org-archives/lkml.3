Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab3CVDyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:54:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376Ab3CVDyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:54:01 -0400
Message-ID: <514BD56F.6050709@redhat.com>
Date: Thu, 21 Mar 2013 23:52:15 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Huck <will.huckk@gmail.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de> <20130321155705.GA27848@cmpxchg.org> <514BA04D.2090002@gmail.com>
In-Reply-To: <514BA04D.2090002@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 08:05 PM, Will Huck wrote:

> One offline question, how to understand this in function balance_pgdat:
> /*
>   * Do some background aging of the anon list, to give
>   * pages a chance to be referenced before reclaiming.
>   */
> age_acitve_anon(zone, &sc);

The anon lrus use a two-handed clock algorithm. New anonymous pages
start off on the active anon list. Older anonymous pages get moved
to the inactive anon list.

If they get referenced before they reach the end of the inactive anon
list, they get moved back to the active list.

If we need to swap something out and find a non-referenced page at the
end of the inactive anon list, we will swap it out.

In order to make good pageout decisions, pages need to stay on the
inactive anon list for a longer time, so they have plenty of time to
get referenced, before the reclaim code looks at them.

To achieve that, we will move some active anon pages to the inactive
anon list even when we do not want to swap anything out - as long as
the inactive anon list is below its target size.

Does that make sense?

-- 
All rights reversed
