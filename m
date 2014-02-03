Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaBCSUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:20:25 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:36558 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaBCSUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:20:20 -0500
MIME-Version: 1.0
In-Reply-To: <1391410583.3801.6.camel@europa>
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>
	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>
	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>
	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
	<1391325599.6481.5.camel@europa>
	<CA+55aFzz8a7K+KSB_TkGb1ih1hAg09-0TQusQgE5vwMJGegHDw@mail.gmail.com>
	<1391410583.3801.6.camel@europa>
Date: Mon, 3 Feb 2014 10:20:19 -0800
X-Google-Sender-Auth: U7m_dtY5kZEk3ne0PGFKgNbtgAw
Message-ID: <CA+55aFyrUTshLPk=21H+6ySOeEVS_zVUAK=2QPrq0aqdQ=3_zg@mail.gmail.com>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Suresh Siddha <sbsiddha@gmail.com>
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

On Sun, Feb 2, 2014 at 10:56 PM, Suresh Siddha <sbsiddha@gmail.com> wrote:
>
> Other patch which cleans up the irq_enable/disable logic in
> math_state_restore() has been sent yesterday. You can run your
> experiments with both these patches if you want. But your issue should
> get fixed with just the appended patch here.
>
> Peter, Please push both these patches through normal channels depending
> on the results.

Thinking about it some more, this patch is *almost* not needed at all.

I'm wondering if you should just change the first patch to just always
initialize the fpu when it is allocated, and at execve() time (ie in
flush_thread()).

If we do that, then this:

+       if (!tsk_used_math(tsk))
+               init_fpu(tsk);

can be dropped entirely from math_state_restore(). And quite frankly,
at that point, I think all the changes to __kernel_fpu_end() can go
away, because at that point math_state_restore() really does the right
thing - all the allocations are gone, and all the async task state
games are gone, only the "restore state" remains.

Hmm? So the only thing needed would be to add that "init_fpu()" to the
initial bootmem allocation path and to change flush_thread() (it
currently does "drop_init_fpu()", let's just make it initialize the
FPU state using fpu_finit()), and then we could remove the whole
"used_math" bit entirely, and just say that the FPU is always
initialized.

What do you guys think?

                Linus
