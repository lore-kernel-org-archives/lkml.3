Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbaBFSqB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:46:01 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:2499 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaBFSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:45:59 -0500
Message-ID: <52F3D84D.5060309@hp.com>
Date: Thu, 06 Feb 2014 13:45:33 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Low <jason.low2@hp.com>, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to spin_on_owner
 if need_resched() triggered while queued
References: <1390936396-3962-1-git-send-email-jason.low2@hp.com> <1390936396-3962-6-git-send-email-jason.low2@hp.com> <20140128210753.GJ11314@laptop.programming.kicks-ass.net> <1390949495.2807.52.camel@j-VirtualBox> <20140129115142.GE9636@twins.programming.kicks-ass.net> <52F2B0C2.8040408@hp.com> <20140206140435.GU8874@twins.programming.kicks-ass.net>
In-Reply-To: <20140206140435.GU8874@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 09:04 AM, Peter Zijlstra wrote:
> On Wed, Feb 05, 2014 at 04:44:34PM -0500, Waiman Long wrote:
>> I have an alternative way of breaking out of the MCS lock waiting queue when
>> need_resched() is set. I overload the locked flag to indicate a skipped node
>> if negative.
> I'm not quite seeing how it works (then again, I've not really read the
> patch carefully).
>
> Suppose you break out; at that point you get queued and go to sleep.
> Suppose you got woken up while you MCS entry is still 'pending' and
> magically win the race and acquire the lock.
>
> At that point your MCS entry can be re-used while its still part of the
> list.

Actually the MCS node entry cannot be reused until an MCS queue head 
task traverses that entry and clear the locked flag. So it is possible 
that the affected CPU won't be able to participate in optimistic 
spinning for a while if the mutex is heavily contended.

> Its a fantastically small race window, but I don't see anything that
> makes it impossible.

I will send out an official patch with some performance data to solicit 
further feedback.

>> I run the patch through the AIM7 high-systime workload on a
>> 4-socket server and it seemed to run fine.
> How do people run this AIM7 piece of shit? I let it run for over an hour
> and it generated exactly 0 numbers, it just sits there eating cpu-time
> and creating a racket from my pantry.

AIM7 can be tricky to set up. Fortunately, someone in our team had done 
the ground work so I can just grab and run it.

-Longman
