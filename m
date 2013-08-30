Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab3H3TxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:53:09 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40819 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3H3TxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:53:07 -0400
Message-ID: <5220F811.9060902@hp.com>
Date: Fri, 30 Aug 2013 15:52:49 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
References: <1377751465.4028.20.camel@pasglop> <20130829070012.GC27322@gmail.com> <CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com> <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com> <CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com> <52200DAE.2020303@hp.com> <CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com> <5220E56A.80603@hp.com> <CA+55aFzv9BZ2+B2NrNRRtTqnfgbH3LRSvSsUZVsy-g9OpM-8HA@mail.gmail.com> <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk>
In-Reply-To: <20130830194059.GC13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 03:40 PM, Al Viro wrote:
> On Fri, Aug 30, 2013 at 03:20:48PM -0400, Waiman Long wrote:
>
>> There are more contention in the lglock than I remember for the run
>> in 3.10. This is an area that I need to look at. In fact, lglock is
>> becoming a problem for really large machine with a lot of cores. We
>> have a prototype 16-socket machine with 240 cores under development.
>> The cost of doing a lg_global_lock will be very high in that type of
>> machine given that it is already high in this 80-core machine. I
>> have been thinking about instead of per-cpu spinlocks, we could
>> change the locking to per-node level. While there will be more
>> contention for lg_local_lock, the cost of doing a lg_global_lock
>> will be much lower and contention within the local die should not be
>> too bad. That will require either a per-node variable infrastructure
>> or simulated with the existing per-cpu subsystem.
> Speaking of lglock, there's a low-hanging fruit in that area: we have
> no reason whatsoever to put anything but regular files with FMODE_WRITE
> on the damn per-superblock list - the *only* thing it's used for is
> mark_files_ro(), which will skip everything except those.  And since
> read opens normally outnumber the writes quite a bit...  Could you
> try the diff below and see if it changes the picture?  files_lglock
> situation ought to get better...
>
>

Sure. I will try that out, but it probably won't help too much in this 
test case. The perf profile that I sent out in my previous mail is only 
partial. The actual one for lg_global_lock was:

      1.01%            reaim  [kernel.kallsyms]        [k] lg_global_lock
                       |
                       --- lg_global_lock
                           mntput_no_expire
                           mntput
                           __fput
                           ____fput
                           task_work_run
                           do_notify_resume
                           int_signal
                          |
                          |--51.62%-- __shmdt
                          |
                           --48.38%-- __shmctl

So it is the mnput_no_expire() function that is doing all the 
lg_global_lock() calls.

Regards,
Longman
