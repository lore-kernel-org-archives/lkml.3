Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3KNP5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:57:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060Ab3KNP5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:57:11 -0500
Message-ID: <5284F2B0.1080708@redhat.com>
Date: Thu, 14 Nov 2013 10:56:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] mm: thrash detection-based file cache sizing v5
References: <1381441622-26215-1-git-send-email-hannes@cmpxchg.org> <5264F353.1080603@suse.cz>
In-Reply-To: <5264F353.1080603@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 05:26 AM, Vlastimil Babka wrote:
> On 10/10/2013 11:46 PM, Johannes Weiner wrote:
>> Hi everyone,
>>
>> here is an update to the cache sizing patches for 3.13.
>>
>> 	Changes in this revision
>>
>> o Drop frequency synchronization between refaulted and demoted pages
>>    and just straight up activate refaulting pages whose access
>>    frequency indicates they could stay in memory.  This was suggested
>>    by Rik van Riel a looong time ago but misinterpretation of test
>>    results during early stages of development took me a while to
>>    overcome.  It's still the same overall concept, but a little simpler
>>    and with even faster cache adaptation.  Yay!
>
> Oh, I liked the previous approach with direct competition between the
> refaulted and demoted page :) Doesn't the new approach favor the
> refaulted page too much? No wonder it leads to faster cache adaptation,
> but could it also cause degradations for workloads that don't benefit
> from it? Were there any tests for performance regressions on workloads
> that were not the target of the patchset?

This is a good question, and one that is probably
best settled through experimentation.

Even with the first scheme (fault refaulted page to
the inactive list), those pages only need 2 accesses
to be promoted to the active list.

That is because a refault tends to immediately be
followed by an access (after all, the attempted
access causes the page to get loaded back into memory).
