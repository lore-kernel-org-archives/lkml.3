Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaBATqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 14:46:17 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:54497 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaBATqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 14:46:16 -0500
MIME-Version: 1.0
In-Reply-To: <52ED4C96.6020703@zytor.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<52ED4C96.6020703@zytor.com>
Date: Sat, 1 Feb 2014 11:46:15 -0800
X-Google-Sender-Auth: QMXkG1Ug3WUYM-hGi-0jKGsnINg
Message-ID: <CA+55aFxex2ymO3k_udRL=yT9xF5PtRx=O2O2vtL76PBUE0fNtg@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <sbsiddha@gmail.com>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 11:35 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> This will obviously not protect eageronly features (MPX, LWP, ...) so this
> means those features are permanently unavailable to the kernel, even inside
> kernel_fpu_begin/end.  Now, currently I don't think we have any plans to use
> those in the kernel (at least not in a way where kernel_fpu_begin/end makes
> sense as bracketing), but it is something worth keeping in mind.

Hmm. If there are features that (silently) depend on the FPU state
being on, then the plain "stts" doesn't work at all, because we'd be
returning to user space too (not just kernel space) with TS turned
off.

.. which *does* actually bring up something that might work, and might
be a good idea: remove the "restore math state or set TS" from the
normal kernel paths *entirely*, and move it to the "return to user
space" phase.

We could do that with the whole "task_work" thing (or perhaps just
do_notify_resume(), especially after merging the "don't necessarily
return with iret" patch I sent out earlier), with additionally making
sure that scheduling does the right thing wrt a "currently dirty math
state due to kernel use".

The advantage of that would be that we really could do a *lot* of FP
math very cheaply in the kernel, because we'd pay the overhead of
kernel_fpu_begin/end() just once (well, the "end" part would be just
setting the bit that we now have dirty state, the cost would be in the
return-to-user-space-and-restore-fp-state part).

Comments? That would be much more invasive than just changing
__kernel_fpu_end(), but would bring in possibly quite noticeable
advantages under loads that use the FP/vector resources in the kernel.

                Linus
