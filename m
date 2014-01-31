Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbaAaHdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 02:33:22 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:43760 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaAaHdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 02:33:20 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
Date: Thu, 30 Jan 2014 23:33:18 -0800
Message-ID: <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Suresh Siddha <sbsiddha@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Thu, Jan 30, 2014 at 2:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> I'm adding in some people here, because I think in the end this bug
> was introduced by commit 304bceda6a18 ("x86, fpu: use non-lazy fpu
> restore for processors supporting xsave") that introduced that
> math_state_restore() in kernel_fpu_end(), but we have other commits
> (like 5187b28ff08: "x86: Allow FPU to be used at interrupt time even
> with eagerfpu") that seem tangential too and might be part of why it
> actually *triggers* now.
>
> Comments?

I haven't been following the recent changes closely, so before I get a
chance to review the current bug and the relevant commits, wanted to
added that:

a. delayed dynamic allocation of FPU state area was not a good idea
(from me). Given most of the future cases will be anyway using eager
FPU (because of processor features like xsaveopt etc, applications
implicitly using FPU because of optimizations in commonly used
libraries etc), we should probably go back to allocation of FPU state
area during thread creation for everyone (including non-eager cases).
Memory savings will be small anyways and the code complexity
introducing subtle bugs like this in not worth it.

b. with the above change, kernel_fpu_begin() will just save any user
live math state and be ready for kernel math operations. And
kernel_fpu_end() will drop the kernel math state and for  eager-fpu
case restore the user math state.

We will avoid worrying about any memory allocations in the
math_state_restore() with interrupts disabled etc.

If there are no objections, I will see if I can come up with a quick
patch. or will ask HPA to help fill me in.

thanks,
suresh
