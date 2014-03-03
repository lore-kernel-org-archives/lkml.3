Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaCCXao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 18:30:44 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48847 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaCCXan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 18:30:43 -0500
Message-ID: <53151077.5090905@oracle.com>
Date: Mon, 03 Mar 2014 16:29:59 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <1393883493.30648.5.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1393883493.30648.5.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 02:51 PM, Davidlohr Bueso wrote:
> On Mon, 2014-03-03 at 11:07 -0700, Khalid Aziz wrote:
>> I am working on a feature that has been requested by database folks that
>> helps with performance. Some of the oft executed database code uses
>> mutexes to lock other threads out of a critical section. They often see
>> a situation where a thread grabs the mutex, runs out of its timeslice
>> and gets switched out which then causes another thread to run which
>> tries to grab the same mutex, spins for a while and finally gives up.
>
> This strikes me more of a feature for a real-time kernel. It is
> definitely an interesting concept but wonder about it being abused.
> Also, what about just using a voluntary preemption model instead? I'd
> think that systems where this is really a problem would opt for that.

That was my first thought as well when I was asked to implement this 
feature :) Designing a system as a real-time system indeed gives the 
designer good control over pre-emption but the database folks do not 
really want or need a full real-time system espcially since they may 
have to run on the same server as other database related services. JVM 
certainly can not expect to be run as a realtime process. Database folks 
are perfectly happy running with CFS scheduler all the time except 
during this kind of critical section. This approach gives them some 
control to get extra timeslice when they need it. As for the abuse, it 
is no different from a realtime process that can lock up a processor 
much worse than this approach. As is the case when using realtime 
schedulers, one must use the tools wisely. I have thought about allowing 
sysadmins to lock this functionality down some but that does add more 
complexity. I am open to doing that if most people feel it is necessary.

>
>> This can happen with multiple threads until original lock owner gets the
>> CPU again and can complete executing its critical section. This queueing
>> and subsequent CPU cycle wastage can be avoided if the locking thread
>> could request to be granted an additional timeslice if its current
>> timeslice runs out before it gives up the lock. Other operating systems
>> have implemented this functionality and is used by databases as well as
>> JVM. This functionality has been shown to improve performance by 3%-5%.
>
> Could you elaborate more on those performance numbers? What
> benchmark/workload?
>
> Thanks,
> Davidlohr
>

This was with tpc-c.

Thanks,
Khalid

