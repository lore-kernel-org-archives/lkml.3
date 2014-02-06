Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaBFSho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:37:44 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30865 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbaBFShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:37:43 -0500
Message-ID: <52F3D65D.3030200@hp.com>
Date: Thu, 06 Feb 2014 13:37:17 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to spin_on_owner
 if need_resched() triggered while queued
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com>  <1390936396-3962-6-git-send-email-jason.low2@hp.com>  <20140128210753.GJ11314@laptop.programming.kicks-ass.net>  <1390949495.2807.52.camel@j-VirtualBox>  <20140129115142.GE9636@twins.programming.kicks-ass.net>  <52F2B0C2.8040408@hp.com> <1391708691.3971.73.camel@j-VirtualBox>
In-Reply-To: <1391708691.3971.73.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 12:44 PM, Jason Low wrote:
> On Wed, 2014-02-05 at 16:44 -0500, Waiman Long wrote:
>> On 01/29/2014 06:51 AM, Peter Zijlstra wrote:
>>> On Tue, Jan 28, 2014 at 02:51:35PM -0800, Jason Low wrote:
>>>>> But urgh, nasty problem. Lemme ponder this a bit.
>>> OK, please have a very careful look at the below. It survived a boot
>>> with udev -- which usually stresses mutex contention enough to explode
>>> (in fact it did a few time when I got the contention/cancel path wrong),
>>> however I have not ran anything else on it.
>>>
>>> The below is an MCS variant that allows relatively cheap unqueueing. But
>>> its somewhat tricky and I might have gotten a case wrong, esp. the
>>> double concurrent cancel case got my head hurting (I didn't attempt a
>>> tripple unqueue).
>>>
>>> Applies to tip/master but does generate a few (harmless) compile
>>> warnings because I didn't fully clean up the mcs_spinlock vs m_spinlock
>>> thing.
>>>
>>> Also, there's a comment in the slowpath that bears consideration.
>>>
>>>
>> I have an alternative way of breaking out of the MCS lock waiting queue
>> when need_resched() is set. I overload the locked flag to indicate a
>> skipped node if negative. I run the patch through the AIM7 high-systime
>> workload on a 4-socket server and it seemed to run fine.
>>
>> Please check the following POC patch to see if you have any comment.
> So one of the concerns I had with the approach of skipping nodes was
> that, under heavy contention, we potentially could cause optimistic
> spinning to be disabled on CPUs for a while since the nodes can't be
> used until they have been released. One advantage of the unqueuing
> method would be that nodes are usable after the spinners exit the MCS
> queue and go to sleep.
>
> Jason
>

Under heavy contention when many threads are trying to access the 
mutexes using optimistic spinning. This patch can actually reduce the 
number of wasted CPU cycles waiting in the MCS spin loop and let the 
CPUs do other useful work. So I don't see that as a negative. I think 
this kind of self-tuning is actually good for the overall throughput of 
the system.

-Longman
