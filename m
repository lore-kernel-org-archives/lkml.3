Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaCDVlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:41:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22321 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981AbaCDVkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:40:39 -0500
Message-ID: <53164824.3000704@oracle.com>
Date: Tue, 04 Mar 2014 14:39:48 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com>
In-Reply-To: <531641A8.40306@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 02:12 PM, H. Peter Anvin wrote:
>
> Shades of the Android wakelocks, no?
>
> This seems to effectively give userspace an option to turn preemptive
> multitasking into cooperative multitasking, which of course is
> unacceptable for a privileged process (the same reason why unprivileged
> processes aren't allowed to run at above-normal priority, including RT
> priority.)
>
> I have several issues with this interface:
>
> 1. First, a process needs to know if it *should* have been preempted
> before it calls sched_yield().  So there needs to be a second flag set
> by the scheduler when granting amnesty.

Good idea. I like it. I will add it.

>
> 2. A process which fails to call sched_yield() after being granted
> amnesty must be penalized.

I agree. Is it fair to say that such a process sees the penalty by being 
charged that extra timeslice and being pushed to the right side of RB 
tree since its p->se.vruntime would have gone up, which then delays the 
time when it can get CPU again? I am open to adding a more explicit 
penalty - maybe deny its next preemption delay request if it failed to 
call sched_yield() the last time when it should have?

>
> 3. I'm not keen on occupying a full page for this.  I'm wondering if
> doing a pointer into user space, futex-style, might make more sense.
> The downside, of course, is what happens if the page being pointed to is
> swapped out.

Using a full page for what is effectively a single bit flag does not sit 
well with me either. Doing it through proc forces minimum size of a page 
(please correct me there if I am wrong). I will explore your idea some 
more to see if that can be made to work.

>
> Keep in mind this HAS to be per thread.
>

Thanks, hpa!

--
Khalid

