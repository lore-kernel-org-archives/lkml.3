Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbaEIPT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:19:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaEIPTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:19:54 -0400
Message-ID: <536CF165.3080809@redhat.com>
Date: Fri, 09 May 2014 11:16:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement
 on complex NUMA topologies
References: <1399569811-14362-1-git-send-email-riel@redhat.com> <1399569811-14362-3-git-send-email-riel@redhat.com> <20140509100346.GS30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140509100346.GS30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 06:03 AM, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
>>   static inline unsigned long task_weight(struct task_struct *p, int nid)
>>   {
>> -	unsigned long total_faults;
>> +	unsigned long total_faults, score;
>>
>>   	if (!p->numa_faults_memory)
>>   		return 0;
>> @@ -940,15 +997,32 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
>>   	if (!total_faults)
>>   		return 0;
>>
>> -	return 1000 * task_faults(p, nid) / total_faults;
>> +	score = 1000 * task_faults(p, nid);
>> +	score += nearby_nodes_score(p, nid, true);
>> +
>> +	score /= total_faults;
>> +
>> +	return score;
>>   }
>
> So you add an O(nr_nodes) loop to task_weight(), but that in itself is
> already called from O(nr_nodes) loops, yielding a total complexity of
> O(nr_nodes^2).

However, it only does actual calculations for nodes that
are closer by than the furthest away nodes in the system.

Hopefully on even the largest systems, that will mean an
"island" of a handful of nodes, with everything else being
at the same large distance.

> This might be fine, but algorithmic complexity should very much be a
> part of the changelog I think.

Agreed, I do need to document this kind of thing better,
if only because it gives people a chance to verify my
assumptions.

