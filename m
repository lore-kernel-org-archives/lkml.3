Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaAOVwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:52:04 -0500
Received: from ozlabs.org ([203.10.76.45]:54078 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbaAOVv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:51:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: powerpc: possible access beyond TASK_SIZE in start_thread
In-Reply-To: <40484806.5780.1389328452206.JavaMail.zimbra@efficios.com>
References: <40484806.5780.1389328452206.JavaMail.zimbra@efficios.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Jan 2014 15:26:00 +1030
Message-ID: <87bnzdx2qn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> Hi Rusty,
>
> I was looking at the diff between kernel v3.12 and recent master (after 3.13-rc7),
> and noticed that in the following commit:

Cool!

        I just moved the code, so any problem exists before this, too.

> commit 94af3abf995b17f6a008b00152c94841242ec6c7
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Wed Nov 20 22:15:02 2013 +1100
>
>     powerpc: ELF2 binaries launched directly.
>
> on powerpc, those lines appear in start_thread():
>
> +                       /* start is a relocated pointer to the function
> +                        * descriptor for the elf _start routine.  The first
> +                        * entry in the function descriptor is the entry
> +                        * address of _start and the second entry is the TOC
> +                        * value we need to use.
> +                        */
> +                       __get_user(entry, (unsigned long __user *)start);
> +                       __get_user(toc, (unsigned long __user *)start+1);
>
> Note the "__" before get_user(), which bypass any kind of validation on the
> addresses.
>
> Amongst the callers, if we look at fs/binfmt_elf.c:load_elf_binary(), we see:
>
>                 elf_entry = loc->elf_ex.e_entry;
>                 if (BAD_ADDR(elf_entry)) {
>                         force_sig(SIGSEGV, current);
>                         retval = -EINVAL;
>                         goto out_free_dentry;
>                 }
>
> and the elf_entry gets passed to start_thread().
>
> If we craft a binary with elf_entry address of
>
> TASK_SIZE - 1  (1 byte before TASK_SIZE), then I think we could make both
> __get_user() calls access data beyond TASK_SIZE, because elf_entry address
> is verified, but there is no validation on its range AFAIU. Is it expected ?
> Am I missing something ?

Yes, looks like we can read the first 15 bytes of kernel space.  That's
not likely to be interesting, but we should probably check anyway.

Thanks!
Rusty.
===
Subject: powerpc: don't allow entry point to be read from kernel.

Mathieu points out that while start is checked, it could be TASK_SIZE-1,
which means this code could read the first 15 bytes of kernel space.
That's text for now, but let's be paranoid.

start_thread() doesn't have a return value, so easiest to use get_user:
you'll get a jump to zero if it fails.

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 4a96556fd2d4..b4ca298a5536 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1113,8 +1113,8 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
 			 * address of _start and the second entry is the TOC
 			 * value we need to use.
 			 */
-			__get_user(entry, (unsigned long __user *)start);
-			__get_user(toc, (unsigned long __user *)start+1);
+			get_user(entry, (unsigned long __user *)start);
+			get_user(toc, (unsigned long __user *)start+1);
 
 			/* Check whether the e_entry function descriptor entries
 			 * need to be relocated before we can use them.
