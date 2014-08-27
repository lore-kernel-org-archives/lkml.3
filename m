Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaH0Bcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:32:48 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:44952 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaH0Bco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:32:44 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 26 Aug 2014 18:32:23 -0700
Message-ID: <CALCETrUaZ8w92g96SmFEZDE0Jr+0Moeo+S24-TyW8crrK5reSg@mail.gmail.com>
Subject: Post-merge-window ping (Re: [PATCH v4 0/5] x86: two-phase syscall
 tracing and seccomp fastpath)
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 8:38 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This applies to:
> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git seccomp-fastpath
>
> Gitweb:
> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=seccomp/fastpath

Hi all-

AFAIK the only thing that's changed since I submitted it is that the
3.17 merge window is closed.  Kees rebased the tree this applies to,
but I think the patches all still apply.  What, if anything, do I need
to do to help this along for 3.18?

--Andy

>
> This is both a cleanup and a speedup.  It reduces overhead due to
> installing a trivial seccomp filter by 87%.  The speedup comes from
> avoiding the full syscall tracing mechanism for filters that don't
> return SECCOMP_RET_TRACE.
>
> This series depends on splitting the seccomp hooks into two phases.
> The first phase evaluates the filter; it can skip syscalls, allow
> them, kill the calling task, or pass a u32 to the second phase.  The
> second phase requires a full tracing context, and it sends ptrace
> events if necessary.  The seccomp core part is in Kees' seccomp/fastpath
> tree.
>
> These patches implement a similar split for the x86 syscall
> entry work.  The C callback is invoked in two phases: the first has
> only a partial frame, and it can request phase 2 processing with a
> full frame.
>
> Finally, I switch the 64-bit system_call code to use the new split
> entry work.  This is a net deletion of assembly code: it replaces
> all of the audit entry muck.
>
> In the process, I fixed some bugs.
>
> If this is acceptable, someone can do the same tweak for the
> ia32entry and entry_32 code.
>
> This passes all seccomp tests that I know of.
>
> Changes from v3:
>  - Dropped the core seccomp changes from the email -- Kees has applied them.
>  - Add patch 2 (the TIF_NOHZ change).
>  - Fix TIF_NOHZ in the two-phase entry code (thanks, Oleg).
>
> Changes from v2:
>  - Fixed 32-bit x86 build (and the tests pass).
>  - Put the doc patch where it belongs.
>
> Changes from v1:
>  - Rebased on top of Kees' shiny new seccomp tree (no effect on the x86
>    part).
>  - Improved patch 6 vs patch 7 split (thanks Alexei!)
>  - Fixed bogus -ENOSYS in patch 5 (thanks Kees!)
>  - Improved changelog message in patch 6.
>
> Changes from RFC version:
>  - The first three patches are more or less the same
>  - The rest is more or less a rewrite
>
>
> Andy Lutomirski (5):
>   x86,x32,audit: Fix x32's AUDIT_ARCH wrt audit
>   x86,entry: Only call user_exit if TIF_NOHZ
>   x86: Split syscall_trace_enter into two phases
>   x86_64,entry: Treat regs->ax the same in fastpath and slowpath
>     syscalls
>   x86_64,entry: Use split-phase syscall_trace_enter for 64-bit syscalls
>
>  arch/x86/include/asm/calling.h |   6 +-
>  arch/x86/include/asm/ptrace.h  |   5 ++
>  arch/x86/kernel/entry_64.S     |  51 +++++--------
>  arch/x86/kernel/ptrace.c       | 159 ++++++++++++++++++++++++++++++++++-------
>  4 files changed, 161 insertions(+), 60 deletions(-)
>
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
