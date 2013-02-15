Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3BOXNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 18:13:12 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:54064 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3BOXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 18:13:11 -0500
MIME-Version: 1.0
In-Reply-To: <20130215215946.GX4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk> <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk>
From: Shentino <shentino@gmail.com>
Date: Fri, 15 Feb 2013 15:12:30 -0800
Message-ID: <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 1:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Feb 15, 2013 at 12:02:50PM -0800, Linus Torvalds wrote:
>> On Wed, Feb 13, 2013 at 9:36 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >
>> >         The only problem is that some suicides do SIGKILL, some SIGSEGV.
>> > AFAICS, it started as SIGSEGV and had been switched to SIGKILL for a.out
>> > (without any comments) in 1.1.62.
>>
>> Ok, I really don't think it matters which one we do - either SIGSEGV
>> or SIGKILL is fine for a execve() that fails in those rare "impossible
>> to recover from" circumstances. And no, I have no memory what the
>> reason for the switch was, it's much too long ago..
>
> How about this, then:
>
> handle suicide on late failure exits in execve() in search_binary_handler()
>
> ... rather than doing that in the guts of ->load_binary().  And send
> SIGSEGV in all cases.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
> index bbc8f88..a1c236d 100644
> --- a/fs/binfmt_aout.c
> +++ b/fs/binfmt_aout.c
> @@ -260,11 +260,8 @@ static int load_aout_binary(struct linux_binprm * bprm)
>         current->mm->cached_hole_size = 0;
>
>         retval = setup_arg_pages(bprm, STACK_TOP, EXSTACK_DEFAULT);
> -       if (retval < 0) {
> -               /* Someone check-me: is this error path enough? */
> -               send_sig(SIGKILL, current, 0);
> +       if (retval < 0)
>                 return retval;
> -       }
>
>         install_exec_creds(bprm);
>
> @@ -282,19 +279,15 @@ static int load_aout_binary(struct linux_binprm * bprm)
>                 map_size = ex.a_text+ex.a_data;
>  #endif
>                 error = vm_brk(text_addr & PAGE_MASK, map_size);
> -               if (error != (text_addr & PAGE_MASK)) {
> -                       send_sig(SIGKILL, current, 0);
> +               if (error != (text_addr & PAGE_MASK))
>                         return error;
> -               }
>
>                 error = bprm->file->f_op->read(bprm->file,
>                           (char __user *)text_addr,
>                           ex.a_text+ex.a_data, &pos);
> -               if ((signed long)error < 0) {
> -                       send_sig(SIGKILL, current, 0);
> +               if ((signed long)error < 0)
>                         return error;
> -               }
> -
> +
>                 flush_icache_range(text_addr, text_addr+ex.a_text+ex.a_data);
>         } else {
>                 if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
> @@ -327,28 +320,22 @@ static int load_aout_binary(struct linux_binprm * bprm)
>                         MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
>                         fd_offset);
>
> -               if (error != N_TXTADDR(ex)) {
> -                       send_sig(SIGKILL, current, 0);
> +               if (error != N_TXTADDR(ex))
>                         return error;
> -               }
>
>                 error = vm_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
>                                 PROT_READ | PROT_WRITE | PROT_EXEC,
>                                 MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
>                                 fd_offset + ex.a_text);
> -               if (error != N_DATADDR(ex)) {
> -                       send_sig(SIGKILL, current, 0);
> +               if (error != N_DATADDR(ex))
>                         return error;
> -               }
>         }
>  beyond_if:
>         set_binfmt(&aout_format);
>
>         retval = set_brk(current->mm->start_brk, current->mm->brk);
> -       if (retval < 0) {
> -               send_sig(SIGKILL, current, 0);
> +       if (retval < 0)
>                 return retval;
> -       }
>
>         current->mm->start_stack =
>                 (unsigned long) create_aout_tables((char __user *) bprm->p, bprm);
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 11e078a..50e9194 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -734,10 +734,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
>         current->mm->cached_hole_size = 0;
>         retval = setup_arg_pages(bprm, randomize_stack_top(STACK_TOP),
>                                  executable_stack);
> -       if (retval < 0) {
> -               send_sig(SIGKILL, current, 0);
> +       if (retval < 0)
>                 goto out_free_dentry;
> -       }
>
>         current->mm->start_stack = bprm->p;
>
> @@ -759,10 +757,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
>                            and clear the area.  */
>                         retval = set_brk(elf_bss + load_bias,
>                                          elf_brk + load_bias);
> -                       if (retval) {
> -                               send_sig(SIGKILL, current, 0);
> +                       if (retval)
>                                 goto out_free_dentry;
> -                       }
>                         nbyte = ELF_PAGEOFFSET(elf_bss);
>                         if (nbyte) {
>                                 nbyte = ELF_MIN_ALIGN - nbyte;
> @@ -815,7 +811,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
>                 error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
>                                 elf_prot, elf_flags, 0);
>                 if (BAD_ADDR(error)) {
> -                       send_sig(SIGKILL, current, 0);
>                         retval = IS_ERR((void *)error) ?
>                                 PTR_ERR((void*)error) : -EINVAL;
>                         goto out_free_dentry;
> @@ -846,7 +841,6 @@ static int load_elf_binary(struct linux_binprm *bprm)
>                     elf_ppnt->p_memsz > TASK_SIZE ||
>                     TASK_SIZE - elf_ppnt->p_memsz < k) {
>                         /* set_brk can never work. Avoid overflows. */
> -                       send_sig(SIGKILL, current, 0);
>                         retval = -EINVAL;
>                         goto out_free_dentry;
>                 }
> @@ -878,12 +872,10 @@ static int load_elf_binary(struct linux_binprm *bprm)
>          * up getting placed where the bss needs to go.
>          */
>         retval = set_brk(elf_bss, elf_brk);
> -       if (retval) {
> -               send_sig(SIGKILL, current, 0);
> +       if (retval)
>                 goto out_free_dentry;
> -       }
> +
>         if (likely(elf_bss != elf_brk) && unlikely(padzero(elf_bss))) {
> -               send_sig(SIGSEGV, current, 0);
>                 retval = -EFAULT; /* Nobody gets to see this, but.. */
>                 goto out_free_dentry;
>         }
> @@ -929,19 +921,15 @@ static int load_elf_binary(struct linux_binprm *bprm)
>
>  #ifdef ARCH_HAS_SETUP_ADDITIONAL_PAGES
>         retval = arch_setup_additional_pages(bprm, !!elf_interpreter);
> -       if (retval < 0) {
> -               send_sig(SIGKILL, current, 0);
> +       if (retval < 0)
>                 goto out;
> -       }
>  #endif /* ARCH_HAS_SETUP_ADDITIONAL_PAGES */
>
>         install_exec_creds(bprm);
>         retval = create_elf_tables(bprm, &loc->elf_ex,
>                           load_addr, interp_load_addr);
> -       if (retval < 0) {
> -               send_sig(SIGKILL, current, 0);
> +       if (retval < 0)
>                 goto out;
> -       }
>         /* N.B. passed_fileno might not be initialized? */
>         current->mm->end_code = end_code;
>         current->mm->start_code = start_code;
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 30de01c..5c03732 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -317,8 +317,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>                 goto error;
>
>         /* there's now no turning back... the old userspace image is dead,
> -        * defunct, deceased, etc. after this point we have to exit via
> -        * error_kill */
> +        * defunct, deceased, etc. */
>         set_personality(PER_LINUX_FDPIC);
>         if (elf_read_implies_exec(&exec_params.hdr, executable_stack))
>                 current->personality |= READ_IMPLIES_EXEC;
> @@ -343,24 +342,22 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>
>         retval = setup_arg_pages(bprm, current->mm->start_stack,
>                                  executable_stack);
> -       if (retval < 0) {
> -               send_sig(SIGKILL, current, 0);
> -               goto error_kill;
> -       }
> +       if (retval < 0)
> +               goto error;
>  #endif
>
>         /* load the executable and interpreter into memory */
>         retval = elf_fdpic_map_file(&exec_params, bprm->file, current->mm,
>                                     "executable");
>         if (retval < 0)
> -               goto error_kill;
> +               goto error;
>
>         if (interpreter_name) {
>                 retval = elf_fdpic_map_file(&interp_params, interpreter,
>                                             current->mm, "interpreter");
>                 if (retval < 0) {
>                         printk(KERN_ERR "Unable to load interpreter\n");
> -                       goto error_kill;
> +                       goto error;
>                 }
>
>                 allow_write_access(interpreter);
> @@ -397,7 +394,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>         if (IS_ERR_VALUE(current->mm->start_brk)) {
>                 retval = current->mm->start_brk;
>                 current->mm->start_brk = 0;
> -               goto error_kill;
> +               goto error;
>         }
>
>         current->mm->brk = current->mm->start_brk;
> @@ -410,7 +407,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
>         install_exec_creds(bprm);
>         if (create_elf_fdpic_tables(bprm, current->mm,
>                                     &exec_params, &interp_params) < 0)
> -               goto error_kill;
> +               goto error;
>
>         kdebug("- start_code  %lx", current->mm->start_code);
>         kdebug("- end_code    %lx", current->mm->end_code);
> @@ -449,12 +446,6 @@ error:
>         kfree(interp_params.phdrs);
>         kfree(interp_params.loadmap);
>         return retval;
> -
> -       /* unrecoverable error - kill the process */
> -error_kill:
> -       send_sig(SIGSEGV, current, 0);
> -       goto error;
> -
>  }
>
>  /*****************************************************************************/
> diff --git a/fs/exec.c b/fs/exec.c
> index 7b6f4d5..027b2de 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1416,28 +1416,28 @@ int search_binary_handler(struct linux_binprm *bprm)
>                         }
>                         read_lock(&binfmt_lock);
>                         put_binfmt(fmt);
> -                       if (retval != -ENOEXEC || bprm->mm == NULL)
> -                               break;
> -                       if (!bprm->file) {
> +                       if (bprm->mm == NULL) {
> +                               /* we got to flush_old_exec() and failed after it */
> +                               send_sig(SIGSEGV, current, 0);

This might be a stupid miscue on my part, but shouldn't it be
force_sig instead of send_sig?

I've got this crazy hunch that having SEGV masked might muck something up.

> +                               read_unlock(&binfmt_lock);
> +                               return retval;
> +                       }
> +                       if (retval != -ENOEXEC || !bprm->file) {
>                                 read_unlock(&binfmt_lock);
>                                 return retval;
>                         }
>                 }
>                 read_unlock(&binfmt_lock);
>  #ifdef CONFIG_MODULES
> -               if (retval != -ENOEXEC || bprm->mm == NULL) {
> -                       break;
> -               } else {
>  #define printable(c) (((c)=='\t') || ((c)=='\n') || (0x20<=(c) && (c)<=0x7e))
> -                       if (printable(bprm->buf[0]) &&
> -                           printable(bprm->buf[1]) &&
> -                           printable(bprm->buf[2]) &&
> -                           printable(bprm->buf[3]))
> -                               break; /* -ENOEXEC */
> -                       if (try)
> -                               break; /* -ENOEXEC */
> -                       request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
> -               }
> +               if (printable(bprm->buf[0]) &&
> +                   printable(bprm->buf[1]) &&
> +                   printable(bprm->buf[2]) &&
> +                   printable(bprm->buf[3]))
> +                       break; /* -ENOEXEC */
> +               if (try)
> +                       break; /* -ENOEXEC */
> +               request_module("binfmt-%04x", *(unsigned short *)(&bprm->buf[2]));
>  #else
>                 break;
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
