Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453AbaBDXv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:51:26 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:62760 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419AbaBDXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:51:21 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 4 Feb 2014 15:50:46 -0800
Message-ID: <CALCETrU6M=Abo1z2cRoZy07-=3bwKiK84gCSMcBPLA1TkXPb8A@mail.gmail.com>
Subject: [ARCH question] Do syscall_get_nr and syscall_get_arguments always work?
To: Oleg Nesterov <oleg@redhat.com>, linux-arch <linux-arch@vger.kernel.org>
Cc: linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 11:32 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> Now we get rid of __audit_syscall_entry.  (This speeds up even the
> auditing-is-on case.)  Instead we have __audit_start_record, which
> does more or less the same thing, except that (a) it doesn't BUG if
> in_syscall and (b) it *sets* TIF_SYSCALL_AUDIT.  This relies on the
> fact that syscall_get_nr and syscall_get_arguments are reliable on
> x86_64.  I suspect that they're reliable everywhere else, too.  The
> idea is that there's nothing wrong with calling __audit_start_record
> more than once.  (Maybe it should be called
> __audit_record_this_syscall.)

I'd like to make a change that can result in syscall_get_nr and
syscall_get_arguments being called (on current and
task_pt_regs(current)) from any system call (as opposed to being
called only from the audit/trace slowpaths).  Is this safe?

Here's my somewhat clueless analysis:

On x86_64, I've tested it, and it works.  The entry code saves all of
the argument registers, even in the fast path.

i386 and ia32_compat look okay, too.

If "stmia    sp, {r0 - r12}            @ Calling r0 - r12" does what I
think it does, then arm should be okay.

I'm totally guessing here, but e10_sync on aarch64 seems to save
enough registers.  I admit to being a little bit surprised, though --
aarch64 is new, and if I were designing an ABI, I specify that
syscalls *don't* save registers.

ia64 has a comment in ivt.S that streamlined syscalls save nr in r15.
The rest come from unwind info (!).  I assume this has something to do
with the magic ia64 register rotation thing.  I have no idea what
happens if there's a NaT in an argument register.

I can't even find the system call entry point on mips.


Is there a semi-official answer here?


--Andy
