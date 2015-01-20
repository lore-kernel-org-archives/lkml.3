Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbbATNbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:31:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbbATNbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:31:48 -0500
Message-ID: <54BE58C0.2050801@suse.cz>
Date: Tue, 20 Jan 2015 14:31:44 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/5] mm, compaction: simplify handling restart position
 in free pages scanner
References: <1421661920-4114-1-git-send-email-vbabka@suse.cz> <1421661920-4114-3-git-send-email-vbabka@suse.cz> <54BE57D7.6080501@gmail.com>
In-Reply-To: <54BE57D7.6080501@gmail.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 02:27 PM, Zhang Yanfei wrote:
> Hello,
> 
> ÔÚ 2015/1/19 18:05, Vlastimil Babka Ð´µÀ:
>> @@ -883,6 +883,8 @@ static void isolate_freepages(struct compact_control *cc)
>>  		nr_freepages += isolated;
>>  
>>  		/*
>> +		 * If we isolated enough freepages, or aborted due to async
>> +		 * compaction being contended, terminate the loop.
>>  		 * Remember where the free scanner should restart next time,
>>  		 * which is where isolate_freepages_block() left off.
>>  		 * But if it scanned the whole pageblock, isolate_start_pfn
>> @@ -891,28 +893,30 @@ static void isolate_freepages(struct compact_control *cc)
>>  		 * In that case we will however want to restart at the start
>>  		 * of the previous pageblock.
>>  		 */
>> -		cc->free_pfn = (isolate_start_pfn < block_end_pfn) ?
>> -				isolate_start_pfn :
>> -				block_start_pfn - pageblock_nr_pages;
>> -
>> -		/*
>> -		 * isolate_freepages_block() might have aborted due to async
>> -		 * compaction being contended
>> -		 */
>> -		if (cc->contended)
>> +		if ((nr_freepages > cc->nr_migratepages) || cc->contended) {
> 
> Shouldn't this be nr_freepages >= cc->nr_migratepages?

Ah, of course. Thanks for catching that!

