Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab3H3UPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:15:32 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:2102 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3H3UPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:15:31 -0400
Message-ID: <5220FD51.2010709@hp.com>
Date: Fri, 30 Aug 2013 16:15:13 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <1375758759-29629-1-git-send-email-Waiman.Long@hp.com> <1375758759-29629-2-git-send-email-Waiman.Long@hp.com> <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com> <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com> <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com> <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com> <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com> <52200DAE.2020303@hp.com> <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com> <5220E56A.80603@hp.com> <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com> <5220F090.5050908@hp.com> <CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
In-Reply-To: <CA+55aFzqJ5So9Hj1H0C86e4s13FuEEC_n6ubgJ6SexEDB5rYHg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 03:33 PM, Linus Torvalds wrote:
> On Fri, Aug 30, 2013 at 12:20 PM, Waiman Long<waiman.long@hp.com>  wrote:
>> Below is the perf data of my short workloads run in an 80-core DL980:
> Ok, that doesn't look much like d_lock any more. Sure, there's a small
> amount of spinlocking going on with lockref being involved, but on the
> whole even that looks more like getcwd and other random things.

Yes, d_lock contention isn't a major one in the perf profile. However, 
sometimes a small improvement can lead to a noticeable improvement in 
performance.
> I do agree that getcwd() can probably be hugely optimized. Nobody has
> ever bothered, because it's never really performance-critical, and I
> think AIM7 ends up just doing something really odd. I bet we could fix
> it entirely if we cared enough.
The prepend_path() isn't all due to getcwd. The correct profile should be


|--12.81%-- prepend_path
                          |          |
                          |          |--67.35%-- d_path
                          |          |          |
                          |          |          |--60.72%-- 
proc_pid_readlink
                          |          |          |          sys_readlinkat
                          |          |          |          sys_readlink
                          |          |          |          
system_call_fastpath
                          |          |          |          __GI___readlink
                          |          |          |          0x302f64662f666c
                          |          |          |
                          |          |           --39.28%-- 
perf_event_mmap_event
                          |          |
                          |           --32.65%-- sys_getcwd
                          |                     system_call_fastpath
                          |                     __getcwd

Yes, the perf subsystem itself can contribute a sizeable portion of the 
spinlock contention. In fact, I have also applied my seqlock patch that 
was sent a while ago to the test kernel in order to get a more accurate 
perf profile. The seqlock patch will allow concurrent d_path() calls 
without one blocking the others. In the 240-core prototype machine, it 
was not possible to get an accurate perf profile for some workloads 
because more than 50% of the time was spent in spinlock contention due 
to the use of perf. An accurate perf profile can only be obtained in 
those cases by applying my lockref and seqlock patches. I hope someone 
will have the time to review my seqlock patch to see what additional 
changes will be needed. I really like to see it merged in some form to 
3.12.

> I just wonder if it's even worth it (I assume AIM7 is something HP
> uses internally, because I've never really heard of anybody else
> caring)

Our performance group is actually pretty new. It was formed 2 years ago 
and we began actively participating in the Linux kernel development just 
in the past year.

We use the AIM7 benchmark internally primarily because it is easy to run 
and cover quite a lot of different areas in the kernel. We are also 
using specJBB and SwingBench for performance benchmarking problem. We 
are also trying to look for more benchmarks to use in the future.

Regards,
Longman
