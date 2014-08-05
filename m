Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaHER4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 13:56:22 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:14378 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbaHER4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 13:56:20 -0400
Message-ID: <53E11AC0.6030200@hp.com>
Date: Tue, 05 Aug 2014 13:56:16 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 3/7] locking/rwsem: check for active writer/spinner before
 wakeup
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>  <1407119782-41119-4-git-send-email-Waiman.Long@hp.com> <1407187217.11985.14.camel@j-VirtualBox>
In-Reply-To: <1407187217.11985.14.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 05:20 PM, Jason Low wrote:
> On Sun, 2014-08-03 at 22:36 -0400, Waiman Long wrote:
>> On a highly contended rwsem, spinlock contention due to the slow
>> rwsem_wake() call can be a significant portion of the total CPU cycles
>> used. With writer lock stealing and writer optimistic spinning, there
>> is also a pretty good chance that the lock may have been stolen
>> before the waker wakes up the waiters. The woken tasks, if any,
>> will have to go back to sleep again.
>>
>> This patch adds checking code at the beginning of the rwsem_wake()
>> and __rwsem_do_wake() function to look for spinner and active
>> writer respectively.  The presence of an active writer will abort the
>> wakeup operation.  The presence of a spinner will still allow wakeup
>> operation to proceed as long as the trylock operation succeeds. This
>> strikes a good balance between excessive spinlock contention especially
>> when there are a lot of active readers and a lot of failed fastpath
>> operations because there are tasks waiting in the queue.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>> ---
>>   include/linux/osq_lock.h    |    5 ++++
>>   kernel/locking/rwsem-xadd.c |   57 ++++++++++++++++++++++++++++++++++++++++++-
>>   2 files changed, 61 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/osq_lock.h b/include/linux/osq_lock.h
>> index 90230d5..79db546 100644
>> --- a/include/linux/osq_lock.h
>> +++ b/include/linux/osq_lock.h
>> @@ -24,4 +24,9 @@ static inline void osq_lock_init(struct optimistic_spin_queue *lock)
>>   	atomic_set(&lock->tail, OSQ_UNLOCKED_VAL);
>>   }
>>
>> +static inline bool osq_has_spinner(struct optimistic_spin_queue *lock)
>> +{
>> +	return atomic_read(&lock->tail) != OSQ_UNLOCKED_VAL;
>> +}
> Like with other locks, should we make this "osq_is_locked"? We can still
> add the rwsem has_spinner() abstractions which makes use of
> osq_is_locked() if we want.
>
>

Yes, that is a good idea. I will make the change in the next version.

-Longman
