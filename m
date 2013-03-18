Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3CRUjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:39:24 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:46416 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3CRUjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:39:22 -0400
Message-ID: <51477B76.1080005@gmail.com>
Date: Mon, 18 Mar 2013 16:39:18 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, sri@us.ibm.com,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sctp: hang in sctp_remaddr_seq_show
References: <51434D78.9030308@oracle.com> <20130318110415.GA9478@hmsreliant.think-freely.org> <1363620340.29475.132.camel@edumazet-glaptop> <5147333A.3010907@gmail.com> <20130318203202.GB9478@hmsreliant.think-freely.org>
In-Reply-To: <20130318203202.GB9478@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 04:32 PM, Neil Horman wrote:
> On Mon, Mar 18, 2013 at 11:31:06AM -0400, Vlad Yasevich wrote:
>> On 03/18/2013 11:25 AM, Eric Dumazet wrote:
>>> On Mon, 2013-03-18 at 07:04 -0400, Neil Horman wrote:
>>>
>>>> I'm not sure why the process would never get back to the schedule, but looking
>>>> at the sctp_remaddr_seq_show function, I think that we should convert this
>>>> sequence:
>>>> 	sctp_local_bh_disable();
>>>> 	read_lock(&head->lock);
>>>> 	rcu_read_lock();
>>>>
>>>> to this:
>>>> 	read_lock(&head->lock);
>>>> 	rcu_read_lock_bh();
>>>>
>>>> Neil
>>>
>>> I dont think so.
>>>
>>> BH needs to be disabled before read_lock(&head->lock);
>>>
>>> or else, write_lock() could deadlock (assuming it can be called from BH)
>>>
>>>
>>
>> If anything, this should probably be done like this:
>>
>> rcu_read_lock();
>> read_lock_bh(&head->lock)
>> ...
>>
>> read_unlock_bh(&head->lock)
>> rcu_read_unlock();
>>
> Vlads, right.  We need to grab the rcu lock before the read lock, but we should
> probably use the rcu_read_lock_bh variant, since we're going to disable bottom
> halves anyway.

I don't think disabling bh as part of rcu gains us anything.  The main 
thing that has to happen is that it needs to be disabled before the hash 
read_lock().  Doing it my way means that we wouldn't have to touch 
call_rcu() sites.  If we change to rcu_read_lock_bh(), we could have to 
convert to call_rcu_bh() and still wouldn't see any gain.

In any case, this is all completely theoretical as the code the way it 
is now should still work and not hang in bh_enable.

Sasha, if you can trigger it easily enough, could you try the above 
alternatives.

Thanks
-vlad

> Neil
>
>> -vlad
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

