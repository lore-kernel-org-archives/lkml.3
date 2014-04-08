Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbaDHSBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:01:04 -0400
Received: from mx6-phx2.redhat.com ([209.132.183.39]:41946 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbaDHSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:00:57 -0400
X-Greylist: delayed 3452 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 14:00:57 EDT
Date: Tue, 8 Apr 2014 13:03:11 -0400 (EDT)
From: Jan Stancek <jstancek@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Message-ID: <1669675952.1688479.1396976591124.JavaMail.zimbra@redhat.com>
In-Reply-To: <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
References: <b60ab13f8ae8fea64591670b017f1fe697cce7c9.1396945474.git.jstancek@redhat.com> <CA+55aFxCc2SON-aEz-nex=1yOi9HMCV5ued1G=Otwkw8jyHZ4A@mail.gmail.com>
Subject: Re: [PATCH] futex: avoid race between requeue and wake
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF28 (Win)/8.0.6_GA_5922)
Thread-Topic: futex: avoid race between requeue and wake
Thread-Index: NUieAM6vX96u0+7sg8wVmvIxGt+x/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
> From: "Linus Torvalds" <torvalds@linux-foundation.org>
> To: "Jan Stancek" <jstancek@redhat.com>
> Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>,
> "Davidlohr Bueso" <davidlohr@hp.com>, "Ingo Molnar" <mingo@kernel.org>, "Larry Woodman" <lwoodman@redhat.com>
> Sent: Tuesday, 8 April, 2014 6:20:42 PM
> Subject: Re: [PATCH] futex: avoid race between requeue and wake
> 
> Davidlohr, comments?
> 
> On Tue, Apr 8, 2014 at 1:47 AM, Jan Stancek <jstancek@redhat.com> wrote:
> > pthread_cond_broadcast/4-1.c testcase from openposix testsuite (LTP)
> > occasionally fails, because some threads fail to wake up.
> 
> Jan, I _assume_ this is on x86(-64), but can you please confirm?

I was able to reproduce this on x86-64 and s390x. I used mostly
s390x system with 2 CPUs, because I could reproduce it there
a lot faster (usually in seconds).

My reproducer is modified pthread_cond_broadcast/4-1.c testcase,
with some sleeps removed/shortened:
  http://jan.stancek.eu/tmp/futex_race/pcb.c
  gcc pcb.c -o pcb -lpthread
I'm running it in loop until retcode != 0.

I also experimented with this patch when trying to make it
more visible (so I could capture some strace logs):

diff --git a/kernel/futex.c b/kernel/futex.c
index 5ff12f5..290a67f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -47,6 +47,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
+#include <linux/delay.h>
 #include <linux/file.h>
 #include <linux/jhash.h>
 #include <linux/init.h>
@@ -1554,6 +1555,7 @@ retry_private:
                 */
                if (++task_count <= nr_wake && !requeue_pi) {
                        wake_futex(this);
+                       udelay(10000);
                        continue;
                }

> 
> Because if it's on anything else, the whole situation changes.
> 
> > Taking hb->lock in this situation will ensure that thread A needs to wait
> > in futex_wake() until main thread finishes requeue operation.
> 
> So the argument was that doing *both* spin_is_locked() and
> atomic_read(&hb->waiters) _should_ be unnecessary, because
> hb_waiters_inc() is done *before* getting the spinlock
> 
> However, one exception to this is "requeue_futex()". Which is in fact
> the test-case that Jan points to. There, when we move a futex from one
> hash bucket to another, we do the increment inside the spinlock.
> 
> So I think the change is correct, although the commit message might
> need a bit of improvement. I also hate that "if/else" thing, since
> there's no point in an "else" if the if-statement did a "return". So
> either make it just
> 
>     if (spin_is_locked(&hb->lock))
>         return 1;
>     return atomic_read(&hb->waiters);
> 
> or (perhaps preferably) make it
> 
>     return spin_is_locked(&hb->lock) || atomic_read(&hb->waiters);
> 
> but that "if/else" just makes me go "why?".

Understood, I can submit v2 if Davidlohr will also be in favor.
If not, I'm happy to test different patch proposal with my setup.

Regards,
Jan

> 
> But I'd also like to have Davidlohr look at this, because I have a few
> questions:
> 
>  - how did this never show up in the original loads? No requeueing
> under those test-loads?
> 
>  - would we be better off incrementing the waiter count at the top of
> futex_requeue(), at the retry_private label?
> 
> That would make us follow the "has to be incremented before taking the
> lock" rule, but at the expense of making the error case handling more
> complex. Although maybe we could do it as part of
> "double_lock/unlock_hb()" and just mark both hb1/hb2 busy?
> 
>                       Linus
> 
