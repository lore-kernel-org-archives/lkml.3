Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaHHSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 14:16:26 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:45710 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaHHSQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 14:16:24 -0400
Message-ID: <53E513EA.7010003@hp.com>
Date: Fri, 08 Aug 2014 14:16:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2 0/7] locking/rwsem: enable reader opt-spinning & writer
 respin
References: <1407450408-11679-1-git-send-email-Waiman.Long@hp.com> <1407455524.2513.10.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1407455524.2513.10.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 07:52 PM, Davidlohr Bueso wrote:
> On Thu, 2014-08-07 at 18:26 -0400, Waiman Long wrote:
>> v1->v2:
>>   - Remove patch 1 which changes preempt_enable() to
>>     preempt_enable_no_resched().
>>   - Remove the RWSEM_READ_OWNED macro and assume readers own the lock
>>     when owner is NULL.
>>   - Reduce the spin threshold to 64.
> So I still don't like this, and the fact that it is used in some
> virtualization locking bits doesn't really address the concerns about
> arbitrary logic in our general locking code.

As I said in the comments, there is no easy way to figure if all the 
readers are running. I set the spin count to a relatively small number 
to catch those readers with a short critical sections. For those that 
hold the lock for a relatively long time, the spin will end and the task 
will be put to sleep. I know the solution is not elegant, but it is 
simple. I thought about using more elaborate scheme, but there is no 
guarantee that that it will be better than a simple spin count while 
greatly complicating the code.

> Also, why did you reduce it from 100 to 64? This very much wants to be
> commented.

In the v1 patch, the 100 spin threshold was for the whole spinning 
period. In the v2 patch, I reset the count when a writer is there. There 
is why I reduce the spin count a bit.

-Longman
