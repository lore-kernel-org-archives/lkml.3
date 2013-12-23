Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab3LWM3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 07:29:33 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63126 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3LWM3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 07:29:32 -0500
MIME-Version: 1.0
In-Reply-To: <20131222143427.GA12544@redhat.com>
References: <CAJ8eaTzkKtwM2Xvw_GYRrefUVJg0uzaqFNPJcNc_ffSayQiDUA@mail.gmail.com>
	<CA+55aFyVrrvDzUt0OU4d9YZM8C-N+ycSKEa3+-5nowUoZ=rb8w@mail.gmail.com>
	<20131222143427.GA12544@redhat.com>
Date: Mon, 23 Dec 2013 17:59:30 +0530
Message-ID: <CAJ8eaTxq5tL1WT_2rsDg5nKwW4xxW_Md6ZTgk9f5DX75cN=pRg@mail.gmail.com>
Subject: Re: [PATCH] secure unlock_task_sighand() call
From: naveen yadav <yad.naveen@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vaibhav Shinde <v.bhav.shinde@gmail.com>,
        Ajeet Yadav <ajeet.yadav.77@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Happy Christmas !!!


Thanks Oleg and Linus for your reply.


We are facing OOPS during core dump on kernel 3.8.x on ARM target.

So we were doing core review and found this. We do not know whether
its big issue but thought to share this considering the problem


 Also I think in zap_process() there is no need to send SIGKILL to
ZOMBIE or DEAD process.

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -271,17 +271,19 @@ static int zap_process(struct task_struct
*start, int exit_code)

-               if (t != current && t->mm) {
+               if (t->exit_state) {
+                       nr++;
+               } else if (t != current && t->mm) {
                        sigaddset(&t->pending.signal, SIGKILL);
                        signal_wake_up(t, 1);

Regards
Naveen



On Sun, Dec 22, 2013 at 8:04 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> Naveen,
>
> sorry for the terse and neglectful reply yesterday.
>
> Actually, when I re-read the Linus's email, I think he already explained
> everything, so let me repeat:
>
> On 12/21, Linus Torvalds wrote:
>>
>> Did you actually *see* the problem, or was this just from looking at the code?
>
> Yes. Because this code assumes that lock_task_sighand() must not fail.
> If it fails, we have a problem which should be fixed.
>
>> We have coredump serialization in exit_mm() that I think *should* make
>> this all ok - if we still see p->mm matching our mm, I don't think it
>> should be able to get to __exit_signal() and make the sighand go away,
>> so the lock_task_sighand() shouldn't ever fail.
>
> Yes, exactly.
>
> Note that if we ignore exec, we do not need lock_task_sighand() at all,
> we could simply do spin_lock_irq(p->sighand->siglock).
>
> The caller holds mm->mmap_sem for writing, if we see p->mm == mm it
> simply can not pass exit_mm() which does down_read(&mm->mmap_sem), so
> this task can not exit.
>
> The problem is, this task can change its ->sighand in de_thread(), that
> is why we need lock_task_sighand(). But if it does exec, it can't pass
> exec_mmap() by the same reason, we hold mmap_sem.
>
>> >                         if (p->mm) {
>> >                                 if (unlikely(p->mm == mm)) {
>> > -                                       lock_task_sighand(p, &flags);
>> > -                                       nr += zap_process(p, exit_code);
>> > -                                       unlock_task_sighand(p, &flags);
>> > +                                       if (lock_task_sighand(p, &flags) {
>> > +                                               nr += zap_process(p, exit_code);
>
> But we can't silently skip a process with the same ->mm. We can't even
> skip the execing thread task if it is going to change its ->mm, even if
> it is single-threaded. Note that exec_mmap() will notice mm->core_state
> and fail. So every task with the same mm should be accounted because it
> will play with core_state->nr_threads in exit_mm(). And it should be
> killed because otherwise coredump_wait() can sleep "forever".
>
> So this is not the right change in any case. If lock_task_sighand() can
> fail we should fix something else.
>
> Oleg.
>
