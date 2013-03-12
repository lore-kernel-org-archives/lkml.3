Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3CLPCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:02:52 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:40985 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3CLPCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:02:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130312143853.GD3725@linux.vnet.ibm.com>
References: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
	<CAFTL4hyO7HxGYOL=Fvq-g3LY37PY2f+xR6+stA7-wNkh3wkV=Q@mail.gmail.com>
	<CACVXFVMu9FNTghOQjNryY59S6xkRqg9DR5=OshngUDEZ5Fb=4w@mail.gmail.com>
	<20130312033906.GA3725@linux.vnet.ibm.com>
	<CACVXFVMuhFoPat7FAznr4ji5vXeeVBNCWya=JdYGLYqBv5SFUQ@mail.gmail.com>
	<20130312143853.GD3725@linux.vnet.ibm.com>
Date: Tue, 12 Mar 2013 16:02:47 +0100
Message-ID: <CAFTL4hxHV+htjCsk1w-78kAg3WopfJ=CYH_kx-k7uFNiEC=pzw@mail.gmail.com>
Subject: Re: [PATCH] atomic: improve atomic_inc_unless_negative/atomic_dec_unless_positive
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Ming Lei <tom.leiming@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/12 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Tue, Mar 12, 2013 at 12:03:23PM +0800, Ming Lei wrote:
>> On Tue, Mar 12, 2013 at 11:39 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> >
>> > Atomic operations that return a value are required to act as full memory
>> > barriers.  This means that code relying on ordering provided by these
>> > atomic operations must also do ordering, either by using an explicit
>> > memory barrier or by relying on guarantees from atomic operations.
>> >
>> > For example:
>> >
>> >         CPU 0                                   CPU 1
>> >
>> >         X = 1;                                  r1 = Z;
>> >         if (atomic_inc_unless_negative(&Y)      smp_mb();
>> >                 do_something();
>> >         Z = 1;                                  r2 = X;
>> >
>> > Assuming X and Z are initially zero, if r1==1, we are guaranteed
>> > that r2==1.  However, CPU 1 needs its smp_mb() in order to pair with
>> > the barrier implicit in atomic_inc_unless_negative().
>> >
>> > Make sense?
>>
>> Yes, it does, and thanks for the explanation.
>>
>> But looks the above example is not what Frederic described:
>>
>> "the above atomic_read() might return -1 because there is no
>> guarantee it's seeing the recent update on the remote CPU."
>>
>> Even I am not sure if adding one smp_mb() around atomic_read()
>> can guarantee that too.
>
> Frederic was likely thinking of some other scenario that would be
> broken by atomic_inc_unless_negative() failing to act as a full
> memory barrier.  Here is another example:
>
>
>         CPU 0                                   CPU 1
>
>                                                 X = 1;
>         if (atomic_inc_unless_negative(&Y)      r1 = atomic_xchg(&Y, -1);
>                 r2 = X;
>
> If atomic_inc_unless_negative() acts as a full memory barrier, then
> if CPU 0 reaches the assignment from X, the results will be guaranteed
> to be 1.  Otherwise, there is no guarantee.

Your scenarios show an interesting guarantee I did not think about.
But my concern was on such a situation:

  CPU 0                            CPU 1

  atomic_set(&X, -1)
                                       atomic_inc(&X)
  atomic_add_unless_negative(&X, 5)

On the above situation, CPU 0 may still see X == -1 and thus not add
the 5. Of course all that only make sense with datas coming along.
