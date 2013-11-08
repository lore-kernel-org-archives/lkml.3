Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab3KHWmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:42:43 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:32976 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab3KHWmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:42:40 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Nov 2013 17:42:40 EST
Message-ID: <527D68DC.10902@hp.com>
Date: Fri, 08 Nov 2013 17:42:36 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, "" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v5 4/4] qrwlock: Use the mcs_spinlock helper functions
 for MCS queuing
References: <1383585440-4391-1-git-send-email-Waiman.Long@hp.com> <1383585440-4391-5-git-send-email-Waiman.Long@hp.com> <20131108212107.GI18245@linux.vnet.ibm.com>
In-Reply-To: <20131108212107.GI18245@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 04:21 PM, Paul E. McKenney wrote:
> On Mon, Nov 04, 2013 at 12:17:20PM -0500, Waiman Long wrote:
>> There is a pending patch in the rwsem patch series that adds a generic
>> MCS locking helper functions to do MCS-style locking. This patch
>> will enable the queue rwlock to use that generic MCS lock/unlock
>> primitives for internal queuing. This patch should only be merged
>> after the merging of that generic MCS locking patch.
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
> This one does might address at least some of the earlier memory-barrier
> issues, at least assuming that the MCS lock is properly memory-barriered.
>
> Then again, maybe not.  Please see below.
>
> 							Thanx, Paul
>
>>   	/*
>>   	 * At the head of the wait queue now, try to increment the reader
>> @@ -172,12 +103,36 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
>>   		while (ACCESS_ONCE(lock->cnts.writer))
>>   			cpu_relax();
>>   	}
>> -	rspin_until_writer_unlock(lock, 1);
>> -	signal_next(lock,&node);
>> +	/*
>> +	 * Increment reader count&  wait until writer unlock
>> +	 */
>> +	cnts.rw = xadd(&lock->cnts.rw, QRW_READER_BIAS);
>> +	rspin_until_writer_unlock(lock, cnts);
>> +	mcs_spin_unlock(&lock->waitq,&node);
> But mcs_spin_unlock() is only required to do a RELEASE barrier, which
> could still allow critical-section leakage.

Yes, that is a problem. I will try to add an ACQUIRE barrier in reading 
the writer byte.

-Longman

