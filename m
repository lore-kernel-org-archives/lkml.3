Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3CVFAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:00:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60632 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab3CVFAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:00:10 -0400
Message-ID: <514BE54C.4050106@gmail.com>
Date: Fri, 22 Mar 2013 12:59:56 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] mm: vmscan: Limit the number of pages kswapd reclaims
 at each priority
References: <1363525456-10448-1-git-send-email-mgorman@suse.de> <1363525456-10448-2-git-send-email-mgorman@suse.de> <20130321155705.GA27848@cmpxchg.org> <514BA04D.2090002@gmail.com> <514BD56F.6050709@redhat.com> <514BD665.5020803@gmail.com>
In-Reply-To: <514BD665.5020803@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,
On 03/22/2013 11:56 AM, Will Huck wrote:
> Hi Rik,
> On 03/22/2013 11:52 AM, Rik van Riel wrote:
>> On 03/21/2013 08:05 PM, Will Huck wrote:
>>
>>> One offline question, how to understand this in function balance_pgdat:
>>> /*
>>>   * Do some background aging of the anon list, to give
>>>   * pages a chance to be referenced before reclaiming.
>>>   */
>>> age_acitve_anon(zone, &sc);
>>
>> The anon lrus use a two-handed clock algorithm. New anonymous pages
>> start off on the active anon list. Older anonymous pages get moved
>> to the inactive anon list.
>
> The file lrus also use the two-handed clock algorithm, correct?

After reinvestigate the codes, the answer is no. But why have this 
difference? I think you are the expert for this question, expect your 
explanation. :-)

>
>>
>> If they get referenced before they reach the end of the inactive anon
>> list, they get moved back to the active list.
>>
>> If we need to swap something out and find a non-referenced page at the
>> end of the inactive anon list, we will swap it out.
>>
>> In order to make good pageout decisions, pages need to stay on the
>> inactive anon list for a longer time, so they have plenty of time to
>> get referenced, before the reclaim code looks at them.
>>
>> To achieve that, we will move some active anon pages to the inactive
>> anon list even when we do not want to swap anything out - as long as
>> the inactive anon list is below its target size.
>>
>> Does that make sense?
>
> Make sense, thanks.
>

