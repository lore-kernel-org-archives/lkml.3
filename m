Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab3CASwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:52:14 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:59481 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3CASwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:52:13 -0500
MIME-Version: 1.0
In-Reply-To: <1362161912.12277.10.camel@buesod1.americas.hpqcorp.net>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
	<511C24A6.8020409@redhat.com>
	<CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
	<512E376D.70105@redhat.com>
	<CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com>
	<512E6443.9050603@redhat.com>
	<CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com>
	<512E80E3.7060800@redhat.com>
	<CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com>
	<512EC7F0.60103@redhat.com>
	<1362024397.1867.28.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com>
	<512F7429.4020103@redhat.com>
	<CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com>
	<CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com>
	<512FC89B.6030507@redhat.com>
	<CA+55aFxbm83Oc2g55868HA2xCytsJzTxWGE0w_pMUzKaU5mJMw@mail.gmail.com>
	<512FDC82.2060606@redhat.com>
	<CA+55aFyitxgooTYq27eK4fO___R4uRrNhoPwDWxULeUkejH0ZA@mail.gmail.com>
	<51304DDA.40808@redhat.com>
	<1362161912.12277.10.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 1 Mar 2013 10:52:12 -0800
X-Google-Sender-Auth: 13lBbCuqOB2ImroFSCSeVwHQh60
Message-ID: <CA+55aFxPgGZ2k81Leo-xVVBPThmh29GoCXeq3-iK88KhFNuPdQ@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 10:18 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> On Fri, 2013-03-01 at 01:42 -0500, Rik van Riel wrote:
>>
>> Checking try_atomic_semop and do_smart_update, it looks like neither
>> is using atomic operations. That part of the semaphore code would
>> still benefit from spinlocks.
>
> Agreed.

Yup. As mentioned, I hadn't even looked at that part of the code, but
yes, it definitely wants the spinlock.

> How about splitting ipc_lock()/ipc_lock_control() in two calls: one to
> obtain the ipc object (rcu_read_lock + idr_find), which can be called
> when performing the permissions and security checks, and another to
> obtain the ipcp->lock [q_]spinlock when necessary.

That sounds like absolutely the right thing to do. And we can leave
the old helper functions that do both of them around, and only use the
split case for just a few places.

And if we make the RCU read-lock be explicit too, we could get rid of
some of the ugliness. Right now we have semtimedop() do things like a
conditional "find_alloc_undo()", which will get the RCU lock. It would
be much nicer if we just cleaned up the interfaces a tiny bit, said
that the *caller* has to get the RCU lock, and just do this
unconditionally before calling any of it. Because right now the RCU
details are quite messy, and we have code like

                if (un)
                        rcu_read_unlock();
                error = PTR_ERR(sma);
                goto out_free;

etc, when it would actually be much simpler to just do the RCU read
locking unconditionally (we'll need it for the semaphore lookup
anyway) and just have the exit paths unlock unconditionally like we
usually do (ie a few different exit goto's that just nest the
unlocking properly).

It would simplify the odd locking both for humans and for code
generation. Right now we actually nest those RCU read locks two deep,
as far as I can see.

And it looks like this could be done in fairly small independent steps
("add explicit RCU locking", "split up helper functions", "start using
the simplified helper functions in selected paths that care").

It won't *solve* the locking issues, and I'm sure we'll still see
contention, but it should clean the code up and probably helps the
contention numbers visibly. Even if it's only 10% (which, judging by
my profiles, would be a safe lower bound from just moving the security
callback out of the spinlock - and it could easily be 20% of more
because contention often begets more contention) that would be in the
same kind of ballpark as the spinlock improvements. And using Michel's
work would be a largely independent scalability improvement on top.

Anybody willing to give it a try? I suspect Rik's benchmark, some
"perf record", and concentrating on just semtimedop() to begin with
would be a fairly good starting point.

                 Linus
