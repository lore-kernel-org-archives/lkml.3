Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3FDXbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:31:18 -0400
Received: from www.sr71.net ([198.145.64.142]:44362 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3FDXbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:31:16 -0400
Message-ID: <51AE78C3.1040500@sr71.net>
Date: Tue, 04 Jun 2013 16:31:15 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de, tim.c.chen@linux.intel.com
Subject: Re: [v5][PATCH 6/6] mm: vmscan: drain batch list during long operations
References: <20130603200202.7F5FDE07@viggo.jf.intel.com> <20130603200210.259954C3@viggo.jf.intel.com> <20130604060553.GF14719@blaptop> <51AE06B6.3030009@sr71.net> <20130604232315.GA31006@blaptop>
In-Reply-To: <20130604232315.GA31006@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 04:23 PM, Minchan Kim wrote:
> On Tue, Jun 04, 2013 at 08:24:38AM -0700, Dave Hansen wrote:
>> On 06/03/2013 11:05 PM, Minchan Kim wrote:
>>>>> This ensures that we drain the batch if we are about to perform a
>>>>> pageout() or congestion_wait(), either of which will take some
>>>>> time.  We expect this to help mitigate the worst of the latency
>>>>> increase that the batching could cause.
>>> Nice idea but I could see drain before pageout but congestion_wait?
>>
>> That comment managed to bitrot a bit :(
>>
>> The first version of these had the drain before pageout() only.  Then,
>> Mel added a congestion_wait() call, and I modified the series to also
>> drain there.  But, some other patches took the congestion_wait() back
>> out, so I took that drain back out.
> 
> I am looking next-20130530 and it has still a congestion_wait.
> I'm confusing. :(
> 
> 
>                 if (PageWriteback(page)) {
> 			/* Case 1 above */
> 			if (current_is_kswapd() &&
> 			    PageReclaim(page) &&
> 			    zone_is_reclaim_writeback(zone)) {
> 				congestion_wait(BLK_RW_ASYNC, HZ/10);
> 				zone_clear_flag(zone, ZONE_WRITEBACK);
>>
>> I _believe_ the only congestion_wait() left in there is a cgroup-related
>> one that we didn't think would cause very much harm.
> 
> The congestion_wait I am seeing is not cgroup-related one.

Yeah, sorry for the confusion.  There's been a whole lot of activity in
there.  My set is also done on top of a couple of fixes that Mel posted
later on, including this one:

	https://patchwork.kernel.org/patch/2619901/

*That* one removes the congestion_wait() you noticed.
