Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046Ab3GLQbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 12:31:50 -0400
Received: from www.sr71.net ([198.145.64.142]:46632 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964992Ab3GLQbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 12:31:48 -0400
Message-ID: <51E02F6E.1060303@sr71.net>
Date: Fri, 12 Jul 2013 09:31:42 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] mm, page_alloc: support multiple pages allocation
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com> <1372840460-5571-2-git-send-email-iamjoonsoo.kim@lge.com> <51DDE5BA.9020800@intel.com> <20130711010248.GB7756@lge.com> <51DE44CC.2070700@sr71.net> <20130711061201.GA2400@lge.com>
In-Reply-To: <20130711061201.GA2400@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 11:12 PM, Joonsoo Kim wrote:
> On Wed, Jul 10, 2013 at 10:38:20PM -0700, Dave Hansen wrote:
>> You're probably right for small numbers of pages.  But, if we're talking
>> about things that are more than, say, 100 pages (isn't the pcp batch
>> size clamped to 128 4k pages?) you surely don't want to be doing
>> buffered_rmqueue().
> 
> Yes, you are right.
> Firstly, I thought that I can use this for readahead. On my machine,
> readahead reads (maximum) 32 pages in advance if faulted. And batch size
> of percpu pages list is close to or larger than 32 pages
> on today's machine. So I didn't consider more than 32 pages before.
> But to cope with a request for more pages, using rmqueue_bulk() is
> a right way. How about using rmqueue_bulk() conditionally?

How about you test it both ways and see what is faster?

> Hmm, rmqueue_bulk() doesn't stop until all requested pages are allocated.
> If we request too many pages (1024 pages or more), interrupt latency can
> be a problem.

OK, so only call it for the number of pages you believe allows it to
have acceptable interrupt latency.  If you want 200 pages, and you can
only disable interrupts for 100 pages, then just do it in two batches.

The point is that you want to avoid messing with the buffering by the
percpu structures.  They're just overhead in your case.

