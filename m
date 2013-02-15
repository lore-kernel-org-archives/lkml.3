Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935154Ab3BOABn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 19:01:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935101Ab3BOABm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 19:01:42 -0500
Message-ID: <511D7ADA.7040104@redhat.com>
Date: Fri, 15 Feb 2013 00:01:30 +0000
From: Andrew Price <anprice@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Whitehouse <swhiteho@redhat.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        adas@redhat.com, hch@lst.de, npiggin@gmail.com
Subject: Re: rcu: fix hlist_bl_set_first_rcu annotation
References: <1359572877.2719.50.camel@menhir> <20130203183958.GO2632@linux.vnet.ibm.com>
In-Reply-To: <20130203183958.GO2632@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/02/13 18:39, Paul E. McKenney wrote:
> On Wed, Jan 30, 2013 at 07:07:57PM +0000, Steven Whitehouse wrote:
>>
>> Abhi noticed that we were getting a complaint from the RCU subsystem
>> about access of an RCU protected list under the write side bit lock.
>> This patch adds additional annotation to check both the RCU read
>> lock and the write side bit lock before printing a message.
>>
>> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
>> Reported-by: Abhijith Das <adas@redhat.com>
>> Tested-by: Abhijith Das <adas@redhat.com>
>
> Looks plausible to me on first glance, copying Nick Piggin and Christoph
> Hellwig.  If they have no objections, I will queue this.
>
> 							Thanx, Paul

Has this had any attention yet? I'm also seeing the complaint quite
frequently:

[   68.738811] ===============================
[   68.741380] [ INFO: suspicious RCU usage. ]
[   68.748785] 3.8.0-0.rc7.git1.1.fc19.x86_64 #1 Not tainted
[   68.750841] -------------------------------
[   68.752418] include/linux/rculist_bl.h:23 suspicious 
rcu_dereference_check() usage!
[   68.755264]
[   68.755264] other info that might help us debug this:
[   68.755264]
[   68.758030]
[   68.758030] rcu_scheduler_active = 1, debug_locks = 0
[   68.760316] 1 lock held by mount/476:
[   68.761896]  #0:  (&type->s_umount_key#38/1){+.+.+.}, at: 
[<ffffffff811dbbee>] sget+0x39e/0x670
[   68.767115]
[   68.767115] stack backtrace:
[   68.769529] Pid: 476, comm: mount Not tainted 
3.8.0-0.rc7.git1.1.fc19.x86_64 #1
[   68.772095] Call Trace:
[   68.772995]  [<ffffffff810d73b7>] lockdep_rcu_suspicious+0xe7/0x120
[   68.775184]  [<ffffffffa00e3238>] search_bucket+0x118/0x160 [gfs2]
[   68.777559]  [<ffffffffa00e47c3>] gfs2_glock_get+0x603/0x7b0 [gfs2]
[   68.780749]  [<ffffffffa00e41c5>] ? gfs2_glock_get+0x5/0x7b0 [gfs2]
[   68.784173]  [<ffffffffa00e6db9>] gfs2_glock_nq_num+0x29/0x90 [gfs2]
[   68.786551]  [<ffffffffa00f2b79>] gfs2_mount+0x869/0xf30 [gfs2]
[   68.788672]  [<ffffffff810ad428>] ? sched_clock_cpu+0xa8/0x100
[   68.790739]  [<ffffffff810d561d>] ? trace_hardirqs_off+0xd/0x10
[   68.793042]  [<ffffffff810ad56f>] ? local_clock+0x5f/0x70
[   68.794940]  [<ffffffff81702500>] ? __mutex_unlock_slowpath+0x80/0x170
[   68.798236]  [<ffffffff811dcb49>] mount_fs+0x39/0x1b0
[   68.800409]  [<ffffffff811879c0>] ? __alloc_percpu+0x10/0x20
[   68.803692]  [<ffffffff811fa8e3>] vfs_kern_mount+0x63/0xf0
[   68.806773]  [<ffffffff811fcfb5>] do_mount+0x205/0xa90
[   68.809669]  [<ffffffff8118c8ec>] ? might_fault+0x5c/0xb0
[   68.812717]  [<ffffffff811819fb>] ? strndup_user+0x4b/0xf0
[   68.816066]  [<ffffffff811fd8c3>] sys_mount+0x83/0xc0
[   68.818284]  [<ffffffff8170ead9>] system_call_fastpath+0x16/0x1b

It would be good to have this silenced for 3.8 but I think there's not 
long to go.

Thanks,
Andy

>> diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
>> index 31f9d75..2eb8855 100644
>> --- a/include/linux/list_bl.h
>> +++ b/include/linux/list_bl.h
>> @@ -125,6 +125,11 @@ static inline void hlist_bl_unlock(struct hlist_bl_head *b)
>>   	__bit_spin_unlock(0, (unsigned long *)b);
>>   }
>>
>> +static inline bool hlist_bl_is_locked(struct hlist_bl_head *b)
>> +{
>> +	return bit_spin_is_locked(0, (unsigned long *)b);
>> +}
>> +
>>   /**
>>    * hlist_bl_for_each_entry	- iterate over list of given type
>>    * @tpos:	the type * to use as a loop cursor.
>> diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
>> index cf1244f..4f216c5 100644
>> --- a/include/linux/rculist_bl.h
>> +++ b/include/linux/rculist_bl.h
>> @@ -20,7 +20,7 @@ static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
>>   static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
>>   {
>>   	return (struct hlist_bl_node *)
>> -		((unsigned long)rcu_dereference(h->first) & ~LIST_BL_LOCKMASK);
>> +		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
>>   }
>>
>>   /**
>>
>>
