Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645AbaCFNYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:24:50 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:43167 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaCFNYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:24:48 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Organization: D03
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
	<531641A8.40306@zytor.com>
X-Hashcash: 1:20:140306:akpm@linux-foundation.org::0fEfFhzId2rrDq/3:0000000000000000000000000000000000000FOe
X-Hashcash: 1:20:140306:hpa@zytor.com::aqlBni4b2+hjywC6:000009ol
X-Hashcash: 1:20:140306:rob@landley.net::7i9c0gmJmrtaKyiW:001G5a
X-Hashcash: 1:20:140306:oleg@redhat.com::/QrrIQxGqtADbQZl:001TGv
X-Hashcash: 1:20:140306:mingo@kernel.org::362FUMch6yIfSdi0:01Fz3
X-Hashcash: 1:20:140306:viro@zeniv.linux.org.uk::LYOoH1PKGMgVG8Z5:000000000000000000000000000000000000001uOb
X-Hashcash: 1:20:140306:peterz@infradead.org::aDK5ztwYMFSZjDcd:000000000000000000000000000000000000000002FB5
X-Hashcash: 1:20:140306:tglx@linutronix.de::QVjoTuTuhLIpe4GA:00000000000000000000000000000000000000000002PQ7
X-Hashcash: 1:20:140306:khalid.aziz@oracle.com::OZSq8ADGJH3D8Ytq:0000000000000000000000000000000000000003Vyv
X-Hashcash: 1:20:140306:venki@google.com::N8OtGF9f/Y45Sk0k:02voJ
X-Hashcash: 1:20:140306:linux-kernel@vger.kernel.org::419g7LIwa2ExS3T1:0000000000000000000000000000000006eix
X-Hashcash: 1:20:140306:andi.kleen@intel.com::VNux5SGIn9pk5uGG:000000000000000000000000000000000000000009zCL
Date: Thu, 06 Mar 2014 14:24:43 +0100
In-Reply-To: <531641A8.40306@zytor.com> (H. Peter Anvin's message of "Tue, 04
	Mar 2014 13:12:08 -0800")
Message-ID: <87ob1jbgtg.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> I have several issues with this interface:
>
> 1. First, a process needs to know if it *should* have been preempted
> before it calls sched_yield().  So there needs to be a second flag set
> by the scheduler when granting amnesty.
>
> 2. A process which fails to call sched_yield() after being granted
> amnesty must be penalized.
>
> 3. I'm not keen on occupying a full page for this.  I'm wondering if
> doing a pointer into user space, futex-style, might make more sense.
> The downside, of course, is what happens if the page being pointed to is
> swapped out.

Is it possible to implement non-sleeping versions of {get,put}_user()?
That is, use the same basic approach (let the MMU do the hard work) but use
different, and simpler, "fixup" code (return -ESOMETHING on a major
fault).

If so, I think an extra pointer (->amnesty) and an extra bit
(->amnesty_granted) in task_struct suffices:

If the scheduler runs and tsk->amnesty_granted is true, penalize the
current task (and possibly clear tsk->amnesty_granted).

Otherwise, the task is granted amnesty provided these conditions are
met:

tsk->amnesty is non-NULL
get_user_nosleep(j, tsk->amnesty) succeeds
j is now 1
put_user_nosleep(YOU_WERE_LUCKY, tsk->amnesty) succeeds

If so, set amnesty_granted and let the thread continue; otherwise reschedule.

The userspace side would be something like

void *thread_func(void*)
{
     int Im_busy = 0;
     sched_need_amnesty(&Im_busy); /* better name needed */
     /* -EPERM if not allowed (new capability?) */

     /* go critical */
     Im_busy = 1;
     LOCK();
     do_stuff();
     UNLOCK();
     if (Im_busy != 1) {
          /* better play nice with the others */
          sched_yield();
     }
     Im_busy = 0;

     /* If the thread doesn't need the amnesty feature anymore, it can just do
     sched_need_amnesty(NULL); */
}


Rasmus
