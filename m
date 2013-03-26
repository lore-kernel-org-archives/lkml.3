Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040Ab3CZSI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:08:28 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31555 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3CZSI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:08:27 -0400
Message-ID: <5151E3D2.1070103@oracle.com>
Date: Tue, 26 Mar 2013 14:07:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Rik van Riel <riel@surriel.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hhuang@redhat.com, jason.low2@hp.com, walken@google.com,
        lwoodman@redhat.com, chegu_vinod@hp.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: ipc,sem: sysv semaphore scalability
References: <1363809337-29718-1-git-send-email-riel@surriel.com>  <5151DBD3.6080201@oracle.com> <1364320297.5146.7.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1364320297.5146.7.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2013 01:51 PM, Davidlohr Bueso wrote:
> On Tue, 2013-03-26 at 13:33 -0400, Sasha Levin wrote:
>> On 03/20/2013 03:55 PM, Rik van Riel wrote:
>>> This series makes the sysv semaphore code more scalable,
>>> by reducing the time the semaphore lock is held, and making
>>> the locking more scalable for semaphore arrays with multiple
>>> semaphores.
>>
>> Hi Rik,
>>
>> Another issue that came up is:
>>
>> [   96.347341] ================================================
>> [   96.348085] [ BUG: lock held when returning to user space! ]
>> [   96.348834] 3.9.0-rc4-next-20130326-sasha-00011-gbcb2313 #318 Tainted: G        W
>> [   96.360300] ------------------------------------------------
>> [   96.361084] trinity-child9/7583 is leaving the kernel with locks still held!
>> [   96.362019] 1 lock held by trinity-child9/7583:
>> [   96.362610]  #0:  (rcu_read_lock){.+.+..}, at: [<ffffffff8192eafb>] SYSC_semtimedop+0x1fb/0xec0
>>
>> It seems that we can leave semtimedop without releasing the rcu read lock.
>>
>> I'm a bit confused by what's going on in semtimedop with regards to rcu read lock, it
>> seems that this behaviour is actually intentional?
>>
>>         rcu_read_lock();
>>         sma = sem_obtain_object_check(ns, semid);
>>         if (IS_ERR(sma)) {
>>                 if (un)
>>                         rcu_read_unlock();
>>                 error = PTR_ERR(sma);
>>                 goto out_free;
>>         }
>>
>> When I've looked at that it seems that not releasing the read lock was (very)
>> intentional.
> 
> This logic was from the original code, which I also found to be quite
> confusing.

I wasn't getting this warning with the old code, so there was probably something
else that triggers this now.

>>
>> After that, the only code path that would release the lock starts with:
>>
>>         if (un) {
>> 		...
>>
>> So we won't release the lock at all if un is NULL?
>>
> 
> Not necessarily, we do release everything at the end of the function: 
> 
> out_unlock_free:
> 	sem_unlock(sma, locknum);

Ow, there's a rcu_read_unlock() in sem_unlock()? This complicates things even
more I suspect. If un is non-NULL we'll be unlocking rcu lock twice?

	if (un->semid == -1) {
		rcu_read_unlock();
		goto out_unlock_free;
	}
[...]
	out_unlock_free:
	        sem_unlock(sma, locknum);


Thanks,
Sasha
