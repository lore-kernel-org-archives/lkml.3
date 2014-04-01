Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaDAARH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:17:07 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57537 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDAARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:17:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140331230347.GH32556@tassilo.jf.intel.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
	<CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
	<20140331230347.GH32556@tassilo.jf.intel.com>
Date: Mon, 31 Mar 2014 17:17:03 -0700
X-Google-Sender-Auth: xkY92OB6m2nVkgKCjw3n3mrahU4
Message-ID: <CA+55aFyOPkCO7Cpf7pG1wD3QL0CVwKrcf+zKVka51ROABFGn-w@mail.gmail.com>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Anvin <hpa@zytor.com>, hubicka@ucw.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 4:03 PM, Andi Kleen <ak@linux.intel.com> wrote:
>
> However with LTO pretty much all asmlinkages have to become
> visible, as they are used by assembler code and we need to
> tell that to the compiler, otherwise it'll optimize it away.
>
> So I abused asmlinkage for this.

I see why you did it, but I suspect it's not really necessary.

As far as I can tell, *most* of our current asmlinkage use is for the
system call declarations (both compat and regular), and the actual
*definition* of those system calls should pretty much universally use
the SYSCALL_DEFINEx() and COMPAT_SYSCALL_DEFINEx() macros.

So what I would propose is:

 - don't do the __visible as part of asmlinkage, because it really is
conceptually wrong

 - add the visible to the SYSCALL_DEFINEx() macros

and after that I strongly suspect that there will be only a handful of
cases left that are called from assembly language and that aren't
system calls. Things like "printk()" and friends that are really
special. They'd need a few manual "__visible" annotations.

> If you prefer to do it explicitely  I can send
> patches (it would be a very mechanic, long and boring
> tree sweep ...).

See above: I can pretty much guarantee that you should *not* need do
any crazy automated sweeps.  Because you shouldn't need "__visible" at
the declarations in the header files, only at the definition of the
function, right? So SYSCALL_DEFINEx() really should catch all the
normal cases.

                       Linus
