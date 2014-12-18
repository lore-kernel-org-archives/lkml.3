Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaLRVeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:34:13 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:56185 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRVeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:34:12 -0500
MIME-Version: 1.0
In-Reply-To: <54934487.3010608@mit.edu>
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
	<1417806247.4845.1@mail.thefacebook.com>
	<CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<CA+55aFwE3gY+ChZtBpPtt_eY9nCj6pgF_wd8utRN9cOgRe2xOQ@mail.gmail.com>
	<54934487.3010608@mit.edu>
Date: Thu, 18 Dec 2014 13:34:11 -0800
X-Google-Sender-Auth: ID6F8XpdWrR9tWPHlnO1e2k1Tfg
Message-ID: <CA+55aFwb00OB8Y4URv+KZETezz-_exQORmWPMqeFGex==pNs3g@mail.gmail.com>
Subject: Re: save_xstate_sig (Re: frequent lockups in 3.18rc4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 1:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I admit that my understanding of the disaster that is x86's FPU handling is
> limited, but I'm moderately confident that save_xstate_sig is broken.

Very possible. The FPU code *is* nasty.

> The code is:
>
>         if (user_has_fpu()) {
>                 /* Save the live register state to the user directly. */
>                 if (save_user_xstate(buf_fx))
>                         return -1;
>                 /* Update the thread's fxstate to save the fsave header. */
>                 if (ia32_fxstate)
>                         fpu_fxsave(&tsk->thread.fpu);
>         } else {
>                 sanitize_i387_state(tsk);
>                 if (__copy_to_user(buf_fx, xsave, xstate_size))
>                         return -1;
>         }
>
> Suppose that user_has_fpu() returns true, we call save_user_xstate, and the
> xsave instruction (or anything else in there, for that matter) causes a page
> fault.
>
> The page fault handler is well within its rights to schedule.

You don't even have to page fault. Preemption..

But that shouldn't actually be the bug. This is just an optimization.
If we have the FPU, we save it from the FP state, rather than copying
it from our kernel copy. If we schedule (page fault, preemption,
whatever) and lose the FPU, the code still works - we'll just take a
TS fault, and have to reload the information.

So I'm with you in that there can certainly be bugs in the FPU
handling, but I don't think this is one.

                        Linus
