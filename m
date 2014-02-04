Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaBDGDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:03:36 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38258 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaBDGDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:03:31 -0500
Message-ID: <1391493806.3692.11.camel@europa>
Subject: Re: [PATCH] Make math_state_restore() save and restore the
 interrupt flag
From: Suresh Siddha <sbsiddha@gmail.com>
Reply-To: sbsiddha@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Date: Mon, 03 Feb 2014 22:03:26 -0800
In-Reply-To: <CA+55aFyrUTshLPk=21H+6ySOeEVS_zVUAK=2QPrq0aqdQ=3_zg@mail.gmail.com>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	 <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	 <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	 <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	 <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	 <1391325599.6481.5.camel@europa>
	 <CA+55aFzz8a7K+KSB_TkGb1ih1hAg09-0TQusQgE5vwMJGegHDw@mail.gmail.com>
	 <1391410583.3801.6.camel@europa>
	 <CA+55aFyrUTshLPk=21H+6ySOeEVS_zVUAK=2QPrq0aqdQ=3_zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 10:20 -0800, Linus Torvalds wrote:
> Thinking about it some more, this patch is *almost* not needed at all.
> 
> I'm wondering if you should just change the first patch to just always
> initialize the fpu when it is allocated, and at execve() time (ie in
> flush_thread()).
> 

We already do this for eager-fpu case, in eager_fpu_init() during boot
and in drop_init_fpu() during flush_thread().

> If we do that, then this:
> 
> +       if (!tsk_used_math(tsk))
> +               init_fpu(tsk);
> 
> can be dropped entirely from math_state_restore(). 

yeah, probably for eager-fpu, but:

> And quite frankly,
> at that point, I think all the changes to __kernel_fpu_end() can go
> away, because at that point math_state_restore() really does the right
> thing - all the allocations are gone, and all the async task state
> games are gone, only the "restore state" remains.
> 
> Hmm? So the only thing needed would be to add that "init_fpu()" to the
> initial bootmem allocation path and to change flush_thread() (it
> currently does "drop_init_fpu()", let's just make it initialize the
> FPU state using fpu_finit()), and then we could remove the whole
> "used_math" bit entirely, and just say that the FPU is always
> initialized.
> 
> What do you guys think?

No. as I mentioned in the changelog, there is one more path which does
drop_fpu() and we still depend on this used_math bit for eager-fpu.

in signal restore path for 32-bit app, where we copy the sig-context
state from the user stack to the kernel manually (because of legacy
reasons where fsave state is followed by fxsave state etc in the 32-bit
signal handler context and we have to go through convert_to_fxsr() etc).

from __restore_xstate_sig() :

                /*
                 * Drop the current fpu which clears used_math(). This ensures
                 * that any context-switch during the copy of the new state,
                 * avoids the intermediate state from getting restored/saved.
                 * Thus avoiding the new restored state from getting corrupted.
                 * We will be ready to restore/save the state only after
                 * set_used_math() is again set.
                 */
                drop_fpu(tsk);


thanks,
suresh

