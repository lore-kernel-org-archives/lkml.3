Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759746AbaEMIud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:50:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188AbaEMIub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:50:31 -0400
Message-ID: <5371DCD2.8030602@suse.cz>
Date: Tue, 13 May 2014 10:50:26 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm, compaction: properly signal and act upon lock and
 need_sched() contention
References: <20140508051747.GA9161@js1304-P5Q-DELUXE> <1399904111-23520-1-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1405121326080.961@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1405121326080.961@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 10:28 PM, David Rientjes wrote:
> On Mon, 12 May 2014, Vlastimil Babka wrote:
>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index 83ca6f9..b34ab7c 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -222,6 +222,27 @@ static bool compact_checklock_irqsave(spinlock_t *lock, unsigned long *flags,
>>   	return true;
>>   }
>>
>> +/*
>> + * Similar to compact_checklock_irqsave() (see its comment) for places where
>> + * a zone lock is not concerned.
>> + *
>> + * Returns false when compaction should abort.
>> + */
>
> I think we should have some sufficient commentary in the code that
> describes why we do this.

Well I can of course mostly duplicate the comment of 
compact_checklock_irqsave() instead of referring to it, if you think 
that's better.

>> +static inline bool compact_check_resched(struct compact_control *cc)
>> +{
>
> I'm not sure that compact_check_resched() is the appropriate name.  Sure,
> it specifies what the current implementation is, but what it's really
> actually doing is determining when compaction should abort prematurely.
>
> Something like compact_should_abort()?

I tried to be somewhat analogous to the name of 
compact_checklock_irqsave(). compact_should_abort() doesn't indicate 
that there might be a resched().
