Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaF0AIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 20:08:10 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36741 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaF0AII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 20:08:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406270027300.5170@nanos>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com> <alpine.DEB.2.10.1406270027300.5170@nanos>
From: Austin Schuh <austin@peloton-tech.com>
Date: Thu, 26 Jun 2014 17:07:47 -0700
Message-ID: <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 3:35 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 26 Jun 2014, Austin Schuh wrote:
>> On Wed, May 21, 2014 at 12:33 AM, Richard Weinberger
>> <richard.weinberger@gmail.com> wrote:
>> > CC'ing RT folks
>> >
>> > On Wed, May 21, 2014 at 8:23 AM, Austin Schuh <austin@peloton-tech.com> wrote:
>> >> On Tue, May 13, 2014 at 7:29 PM, Austin Schuh <austin@peloton-tech.com> wrote:
>> >>> Hi,
>> >>>
>> >>> I am observing a filesystem lockup with XFS on a CONFIG_PREEMPT_RT
>> >>> patched kernel.  I have currently only triggered it using dpkg.  Dave
>> >>> Chinner on the XFS mailing list suggested that it was a rt-kernel
>> >>> workqueue issue as opposed to a XFS problem after looking at the
>> >>> kernel messages.
>>
>> I've got a 100% reproducible test case that doesn't involve a
>> filesystem.  I wrote a module that triggers the bug when the device is
>> written to, making it easy to enable tracing during the event and
>> capture everything.
>>
>> It looks like rw_semaphores don't trigger wq_worker_sleeping to run
>> when work goes to sleep on a rw_semaphore.  This only happens with the
>> RT patches, not with the mainline kernel.  I'm foreseeing a second
>> deadlock/bug coming into play shortly.  If a task holding the work
>> pool spinlock gets preempted, and we need to schedule more work from
>> another worker thread which was just blocked by a mutex, we'll then
>> end up trying to go to sleep on 2 locks at once.
>
> I remember vaguely, that I've seen and analyzed that quite some time
> ago. I can't page in all the gory details right now, but I have a look
> how the related code changed in the last couple of years tomorrow
> morning with an awake brain.
>
> Steven, you did some analysis on that IIRC, or was that just related
> to rw_locks?
>
> Thanks,
>
>         tglx

If I'm reading the rt patch correctly, wq_worker_sleeping was moved
out of __schedule to sched_submit_work.  It looks like that changes
the conditions under which wq_worker_sleeping is called.  It used to
be called whenever a task was going to sleep (I think).  It looks like
it is called now if the task is going to sleep, and if the task isn't
blocked on a PI mutex (I think).

If I try the following experiment

 static inline void sched_submit_work(struct task_struct *tsk)
 {
+   if (tsk->state && tsk->flags & PF_WQ_WORKER) {
+     wq_worker_sleeping(tsk);
+     return;
+   }

and then remove the call later in the function, I am able to pass my test.

Unfortunately, I then get a recursive pool spinlock BUG_ON after a
while (as I would expect), and it all blows up.

I'm not sure where to go from there.  Any changes to the workpool to
try to fix that will be hard, or could affect latency significantly.

Austin
