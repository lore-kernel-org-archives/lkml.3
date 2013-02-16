Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3BPBu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 20:50:27 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34244 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3BPBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 20:50:26 -0500
Date: Sat, 16 Feb 2013 01:50:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Shentino <shentino@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
Message-ID: <20130216015024.GA4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk>
 <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk>
 <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk>
 <CAGDaZ_rqKR7Ea6SZ9JXmeVOvEBEk3gHaQEa1LAkzWxRHfJsHWw@mail.gmail.com>
 <CAGDaZ_p8Dm+Tco_famKmEzGpV6G+zo1xHLkA7LQCkzQJD_pxMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGDaZ_p8Dm+Tco_famKmEzGpV6G+zo1xHLkA7LQCkzQJD_pxMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 04:46:43PM -0800, Shentino wrote:
> On Fri, Feb 15, 2013 at 4:38 PM, Shentino <shentino@gmail.com> wrote:
> > On Fri, Feb 15, 2013 at 4:04 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> How would you manage to have it masked at that point?  setup_new_exec()
> >> is inevitable after success of flush_old_exec() and it will do
> >> flush_signal_handlers() for us.
> >
> > I wouldn't know for sure but I read somewhere that even if execve
> > resets handled signals, it didn't also say that ignored signals were
> > also reset.  (Source: execve man page.)
> 
> Also, apologies for the terminology mix-up.  By masked, I mean that
> the signal was ignored as directed by userspace a-la signal(SIGSEGV,
> SIG_IGN).
> 
> Plus I *think* that signal ignore masks are preserved across an exec.

You are correct.  OK, what it means is that we do need that force_sigsegv() -
either there or in all places in ->load_binary() where we currently have
send_sig_info(SIGSEGV).  I don't think that it's an urgent hole, but yes,
it is a bug.  Nice catch.

That said, I'd definitely prefer to fix it in one place, rather than in a bunch
of locations in ->load_binary() instances.  Updated diff follows:

handle suicide on late failure exits in execve() in search_binary_handler()

... rather than doing that in the guts of ->load_binary().

[updated to fix the bug spotted by Shentino - for SIGSEGV we really need
something stronger than send_sig_info(); again, better do that in one place]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 03abf9b..a8066b7 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -313,11 +313,8 @@ static int load_aout_binary(struct linux_binprm *bprm)
 	current->mm->cached_hole_size = 0;
 
 	retval = setup_arg_pages(bprm, IA32_STACK_TOP, EXSTACK_DEFAULT);
-	if (retval < 0) {
-		/* Someone check-me: is this error path enough? */
-		send_sig(SIGKILL, current, 0);
+	if (retval < 0)
 		return retval;
-	}
 
 	install_exec_creds(bprm);
 
@@ -332,18 +329,14 @@ static int load_aout_binary(struct linux_binprm *bprm)
 
 		error = vm_brk(text_addr & PAGE_MASK, map_size);
 
-		if (error != (text_addr & PAGE_MASK)) {
-			send_sig(SIGKILL, current, 0);
+		if (error != (text_addr & PAGE_MASK))
 			return error;
-		}
 
 		error = bprm->file->f_op->read(bprm->file,
 			 (char __user *)text_addr,
 			  ex.a_text+ex.a_data, &pos);
-		if ((signed long)error < 0) {
-			send_sig(SIGKILL, current, 0);
+		if ((signed long)error < 0)
 			return error;
-		}
 
 		flush_icache_range(text_addr, text_addr+ex.a_text+ex.a_data);
 	} else {
@@ -385,20 +378,16 @@ static int load_aout_binary(struct linux_binprm *bprm)
 				MAP_EXECUTABLE | MAP_32BIT,
 				fd_offset);
 
-		if (error != N_TXTADDR(ex)) {
-			send_sig(SIGKILL, current, 0);
+		if (error != N_TXTADDR(ex))
 			return error;
-		}
 
 		error = vm_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
 				PROT_READ | PROT_WRITE | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE |
 				MAP_EXECUTABLE | MAP_32BIT,
 				fd_offset + ex.a_text);
-		if (error != N_DATADDR(ex)) {
-			send_sig(SIGKILL, current, 0);
+		if (error != N_DATADDR(ex))
 			return error;
-		}
 	}
 beyond_if:
 	set_binfmt(&aout_format);
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index bbc8f88..a1c236d 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -260,11 +260,8 @@ static int load_aout_binary(struct linux_binprm * bprm)
 	current->mm->cached_hole_size = 0;
 
 	retval = setup_arg_pages(bprm, STACK_TOP, EXSTACK_DEFAULT);
-	if (retval < 0) {
-		/* Someone check-me: is this error path enough? */
-		send_sig(SIGKILL, current, 0);
+	if (retval < 0)
 		return retval;
-	}
 
 	install_exec_creds(bprm);
 
@@ -282,19 +279,15 @@ static int load_aout_binary(struct linux_binprm * bprm)
 		map_size = ex.a_text+ex.a_data;
 #endif
 		error = vm_brk(text_addr & PAGE_MASK, map_size);
-		if (error != (text_addr & PAGE_MASK)) {
-			send_sig(SIGKILL, current, 0);
+		if (error != (text_addr & PAGE_MASK))
 			return error;
-		}
 
 		error = bprm->file->f_op->read(bprm->file,
 			  (char __user *)text_addr,
 			  ex.a_text+ex.a_data, &pos);
-		if ((signed long)error < 0) {
-			send_sig(SIGKILL, current, 0);
+		if ((signed long)error < 0)
 			return error;
-		}
-			 
+
 		flush_icache_range(text_addr, text_addr+ex.a_text+ex.a_data);
 	} else {
 		if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
@@ -327,28 +320,22 @@ static int load_aout_binary(struct linux_binprm * bprm)
 			MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
 			fd_offset);
 
-		if (error != N_TXTADDR(ex)) {
-			send_sig(SIGKILL, current, 0);
+		if (error != N_TXTADDR(ex))
 			return error;
-		}
 
 		error = vm_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
 				PROT_READ | PROT_WRITE | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
 				fd_offset + ex.a_text);
-		if (error != N_DATADDR(ex)) {
-			send_sig(SIGKILL, current, 0);
+		if (error != N_DATADDR(ex))
 			return error;
-		}
 	}
 beyond_if:
 	set_binfmt(&aout_format);
 
 	retval = set_brk(current->mm->start_brk, current->mm->brk);
-	if (retval < 0) {
-		send_sig(SIGKILL, current, 0);
+	if (retval < 0)
 		return retval;
-	}
 
 	current->mm->start_stack =
 		(unsigned long) create_aout_tables((char __user *) bprm->p, bprm);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 11e078a..50e9194 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -734,10 +734,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	current->mm->cached_hole_size = 0;
 	retval = setup_arg_pages(bprm, randomize_stack_top(STACK_TOP),
 				 executable_stack);
-	if (retval < 0) {
-		send_sig(SIGKILL, current, 0);
+	if (retval < 0)
 		goto out_free_dentry;
-	}
 	
 	current->mm->start_stack = bprm->p;
 
@@ -759,10 +757,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			   and clear the area.  */
 			retval = set_brk(elf_bss + load_bias,
 					 elf_brk + load_bias);
-			if (retval) {
-				send_sig(SIGKILL, current, 0);
+			if (retval)
 				goto out_free_dentry;
-			}
 			nbyte = ELF_PAGEOFFSET(elf_bss);
 			if (nbyte) {
 				nbyte = ELF_MIN_ALIGN - nbyte;
@@ -815,7 +811,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
 				elf_prot, elf_flags, 0);
 		if (BAD_ADDR(error)) {
-			send_sig(SIGKILL, current, 0);
 			retval = IS_ERR((void *)error) ?
 				PTR_ERR((void*)error) : -EINVAL;
 			goto out_free_dentry;
@@ -846,7 +841,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		    elf_ppnt->p_memsz > TASK_SIZE ||
 		    TASK_SIZE - elf_ppnt->p_memsz < k) {
 			/* set_brk can never work. Avoid overflows. */
-			send_sig(SIGKILL, current, 0);
 			retval = -EINVAL;
 			goto out_free_dentry;
 		}
@@ -878,12 +872,10 @@ static int load_elf_binary(struct linux_binprm *bprm)
 	 * up getting placed where the bss needs to go.
 	 */
 	retval = set_brk(elf_bss, elf_brk);
-	if (retval) {
-		send_sig(SIGKILL, current, 0);
+	if (retval)
 		goto out_free_dentry;
-	}
+
 	if (likely(elf_bss != elf_brk) && unlikely(padzero(elf_bss))) {
-		send_sig(SIGSEGV, current, 0);
 		retval = -EFAULT; /* Nobody gets to see this, but.. */
 		goto out_free_dentry;
 	}
@@ -929,19 +921,15 @@ static int load_elf_binary(struct linux_binprm *bprm)
 
 #ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
 	retval = arch_setup_additional_pages(bprm, !!elf_interpreter);
-	if (retval < 0) {
-		send_sig(SIGKILL, current, 0);
+	if (retval < 0)
 		goto out;
-	}
 #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */
 
 	install_exec_creds(bprm);
 	retval = create_elf_tables(bprm, &loc->elf_ex,
 			  load_addr, interp_load_addr);
-	if (retval < 0) {
-		send_sig(SIGKILL, current, 0);
+	if (retval < 0)
 		goto out;
-	}
 	/* N.B. passed_fileno might not be initialized? */
 	current->mm->end_code = end_code;
 	current->mm->start_code = start_code;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 30de01c..5c03732 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -317,8 +317,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 		goto error;
 
 	/* there's now no turning back... the old userspace image is dead,
-	 * defunct, deceased, etc. after this point we have to exit via
-	 * error_kill */
+	 * defunct, deceased, etc. */
 	set_personality(PER_LINUX_FDPIC);
 	if (elf_read_implies_exec(&exec_params.hdr, executable_stack))
 		current->personality |= READ_IMPLIES_EXEC;
@@ -343,24 +342,22 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 
 	retval = setup_arg_pages(bprm, current->mm->start_stack,
 				 executable_stack);
-	if (retval < 0) {
-		send_sig(SIGKILL, current, 0);
-		goto error_kill;
-	}
+	if (retval < 0)
+		goto error;
 #endif
 
 	/* load the executable and interpreter into memory */
 	retval = elf_fdpic_map_file(&exec_params, bprm->file, current->mm,
 				    "executable");
 	if (retval < 0)
-		goto error_kill;
+		goto error;
 
 	if (interpreter_name) {
 		retval = elf_fdpic_map_file(&interp_params, interpreter,
 					    current->mm, "interpreter");
 		if (retval < 0) {
 			printk(KERN_ERR "Unable to load interpreter\n");
-			goto error_kill;
+			goto error;
 		}
 
 		allow_write_access(interpreter);
@@ -397,7 +394,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	if (IS_ERR_VALUE(current->mm->start_brk)) {
 		retval = current->mm->start_brk;
 		current->mm->start_brk = 0;
-		goto error_kill;
+		goto error;
 	}
 
 	current->mm->brk = current->mm->start_brk;
@@ -410,7 +407,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	install_exec_creds(bprm);
 	if (create_elf_fdpic_tables(bprm, current->mm,
 				    &exec_params, &interp_params) < 0)
-		goto error_kill;
+		goto error;
 
 	kdebug("- start_code  %lx", current->mm->start_code);
 	kdebug("- end_code    %lx", current->mm->end_code);
@@ -449,12 +446,6 @@ error:
 	kfree(interp_params.phdrs);
 	kfree(interp_params.loadmap);
 	return retval;
-
-	/* unrecoverable error - kill the process */
-error_kill:
-	send_sig(SIGSEGV, current, 0);
-	goto error;
-
 }
 
 /*****************************************************************************/
diff --git a/fs/exec.c b/fs/exec.c
index 7b6f4d5..6a6ddd4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1416,28 +1416,28 @@ int search_binary_handler(struct linux_binprm *bprm)
 			}
 			read_lock(&binfmt_lock);
 			put_binfmt(fmt);
-			if (retval != -ENOEXEC || bprm->mm == NULL)
-				break;
-			if (!bprm->file) {
+			if (bprm->mm == NULL) {
+				/* we got to flush_old_exec() and failed after it */
+				force_sigsegv(SIGSEGV, current);
+				read_unlock(&binfmt_lock);
+				return retval;
+			}
+			if (retval != -ENOEXEC || !bprm->file) {
 				read_unlock(&binfmt_lock);
 				return retval;
 			}
 		}
 		read_unlock(&binfmt_lock);
 #ifdef CONFIG_MODULES
-		if (retval != -ENOEXEC || bprm->mm == NULL) {
-			break;
-		} else {
 #define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
-			if (printable(bprm->buf[0]) &&
-			    printable(bprm->buf[1]) &&
-			    printable(bprm->buf[2]) &&
-			    printable(bprm->buf[3]))
-				break; /* -ENOEXEC */
-			if (try)
-				break; /* -ENOEXEC */
-			request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
-		}
+		if (printable(bprm->buf[0]) &&
+		    printable(bprm->buf[1]) &&
+		    printable(bprm->buf[2]) &&
+		    printable(bprm->buf[3]))
+			break; /* -ENOEXEC */
+		if (try)
+			break; /* -ENOEXEC */
+		request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
 #else
 		break;
 #endif
