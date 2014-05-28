Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaE1U6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:58:50 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43562 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaE1U6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <53864B66.8030100@amacapital.net>
References: <1401279583-1027-1-git-send-email-pkern@google.com> <53864B66.8030100@amacapital.net>
From: Philipp Kern <pkern@google.com>
Date: Wed, 28 May 2014 22:58:27 +0200
Message-ID: <CAA2ZrUTHPoqOK8j+VD5ekQQ_AYvURFjt7Py6_8B3RUu--CGvkw@mail.gmail.com>
Subject: Re: [PATCH] x32: Mask away the x32 syscall bit in the ptrace codepath
To: Andy Lutomirski <luto@amacapital.net>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:47 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 05/28/2014 05:19 AM, Philipp Kern wrote:
> > audit_filter_syscall uses the syscall number to reference into a
> > bitmask (e->rule.mask[word]). Not removing the x32 bit before passing
> > the number to this architecture independent codepath will fail to
> > lookup the proper audit bit. Furthermore it will cause an invalid memory
> > access in the kernel if the out of bound location is not mapped:
> >
> >   BUG: unable to handle kernel paging request at ffff8800e5446630
> >   IP: [<ffffffff810fcdd0>] audit_filter_syscall+0x90/0xf0
> >
> > Together with the entrypoint in entry_64.S this change causes x32
> > programs to pass in both AUDIT_ARCH_X86_64 and AUDIT_ARCH_I386 depending
> > on the syscall path.
> >
> > Cc: linux-kernel@vger.kernel.org
> > Cc: H. J. Lu <hjl.tools@gmail.com>
> > Cc: Eric Paris <eparis@redhat.com>
> > Signed-off-by: Philipp Kern <pkern@google.com>
> > ---
> >  arch/x86/kernel/ptrace.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
> > index 678c0ad..166a3c7 100644
> > --- a/arch/x86/kernel/ptrace.c
> > +++ b/arch/x86/kernel/ptrace.c
> > @@ -1489,7 +1489,7 @@ long syscall_trace_enter(struct pt_regs *regs)
> >
> >       if (IS_IA32)
> >               audit_syscall_entry(AUDIT_ARCH_I386,
> > -                                 regs->orig_ax,
> > +                                 regs->orig_ax & __SYSCALL_MASK,
>
> This is weird.  Three questions:
>
> 1. How can this happen?  I thought that x32 syscalls always came in
> through the syscall path, which doesn't set is_compat_task.  (Can
> someone rename is_compat_task to in_compat_syscall?  Pretty please?)

The other patch is this one: https://lkml.org/lkml/2014/5/26/209

But I agree: IS_IA32 is confusing but it does trigger on x32 tasks. I
put that into a bug report but apparently not into the patch
description, I'm sorry. is_compat_task is defined as is_ia32_task() ||
is_x32_task().

> 2. Now audit can't tell whether a syscall is x32 or i386.  And audit is
> inconsistent with seccomp.  This seems wrong.

I'm not sure where seccomp is hooked in. Can you point me to the entry
points here? ptrace still requires that userspace sees the x32 bit so
it cannot be masked beforehand. The path the other patch fixes masks
the bit away directly after the audit call.

> 3. The OOPS you're fixing doesn't seem like it's fixed.  What if some
> other random high bits are set?

Fair point. I guess we should check against AUDIT_BITMASK_SIZE as that
is the size of the array we are referencing into. But what would we do
in case it's larger? Those are not ENOSYS'ed yet in the entry_64.S
path. That's after tracing and auditing.

Kind regards and thanks
Philipp Kern
