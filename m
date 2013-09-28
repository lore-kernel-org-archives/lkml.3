Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3I1XlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:41:14 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:41709 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab3I1XlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:41:12 -0400
MIME-Version: 1.0
In-Reply-To: <1380411144-9236-9-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
	<1380411144-9236-9-git-send-email-geyslan@gmail.com>
Date: Sat, 28 Sep 2013 20:41:11 -0300
Message-ID: <CAGG-pUSrrgzDgPcqrmhCRUswPGamZ5fEphz+NGCd-uq-Cnb_zw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] binfmt_aout: x86: Useless inode var, printks
 coding style fixes
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, disconsider this e-mail.

Geyslan Gregório Bem
hackingbits.com


2013/9/28 Geyslan G. Bem <geyslan@gmail.com>:
> file size used only once, so removed due its useless prior allocation.
> It's not necessary to verify f_op in the load_aout_library, since the
> prior kernel_read/vfs_read function already does.
> Made coding style fixes and printk replacements.
>
> Tested using qemu, a handcrafted a.out binary and an a.out linked with a
> cross-compiled ld.
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  fs/binfmt_aout.c | 98 +++++++++++++++++++++++++++-----------------------------
>  1 file changed, 48 insertions(+), 50 deletions(-)
>
> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
> index 89dec7f..c732b8e 100644
> --- a/fs/binfmt_aout.c
> +++ b/fs/binfmt_aout.c
> @@ -25,13 +25,14 @@
>  #include <linux/init.h>
>  #include <linux/coredump.h>
>  #include <linux/slab.h>
> +#include <linux/ratelimit.h>
> +#include <linux/uaccess.h>
>
> -#include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
>  #include <asm/a.out-core.h>
>
>  static int load_aout_binary(struct linux_binprm *);
> -static int load_aout_library(struct file*);
> +static int load_aout_library(struct file *);
>
>  #ifdef CONFIG_COREDUMP
>  /*
> @@ -62,7 +63,7 @@ static int aout_core_dump(struct coredump_params *cprm)
>         fs = get_fs();
>         set_fs(KERNEL_DS);
>         has_dumped = 1;
> -               strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
> +       strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
>         dump.u_ar0 = offsetof(struct user, regs);
>         dump.signal = cprm->siginfo->si_signo;
>         aout_dump_thread(cprm->regs, &dump);
> @@ -78,9 +79,11 @@ static int aout_core_dump(struct coredump_params *cprm)
>
>  /* make sure we actually have a data and stack area to dump */
>         set_fs(USER_DS);
> -       if (!access_ok(VERIFY_READ, START_DATA(dump), dump.u_dsize << PAGE_SHIFT))
> +       if (!access_ok(VERIFY_READ, START_DATA(dump),
> +                      dump.u_dsize << PAGE_SHIFT))
>                 dump.u_dsize = 0;
> -       if (!access_ok(VERIFY_READ, START_STACK(dump), dump.u_ssize << PAGE_SHIFT))
> +       if (!access_ok(VERIFY_READ, START_STACK(dump),
> +                      dump.u_ssize << PAGE_SHIFT))
>                 dump.u_ssize = 0;
>
>         set_fs(KERNEL_DS);
> @@ -142,7 +145,8 @@ static int set_brk(unsigned long start, unsigned long end)
>   * memory and creates the pointer tables from them, and puts their
>   * addresses on the "stack", returning the new stack pointer value.
>   */
> -static unsigned long __user *create_aout_tables(char __user *p, struct linux_binprm * bprm)
> +static unsigned long __user *create_aout_tables(char __user *p,
> +                                               struct linux_binprm *bprm)
>  {
>         char __user * __user *argv;
>         char __user * __user *envp;
> @@ -150,7 +154,8 @@ static unsigned long __user *create_aout_tables(char __user *p, struct linux_bin
>         int argc = bprm->argc;
>         int envc = bprm->envc;
>
> -       sp = (void __user *)((-(unsigned long)sizeof(char *)) & (unsigned long) p);
> +       sp = (void __user *) ((-(unsigned long) sizeof(char *))
> +                             & (unsigned long) p);
>  #ifdef __alpha__
>  /* whee.. test-programs are so much fun. */
>         put_user(0, --sp);
> @@ -169,28 +174,28 @@ static unsigned long __user *create_aout_tables(char __user *p, struct linux_bin
>         sp -= argc+1;
>         argv = (char __user * __user *) sp;
>  #ifndef __alpha__
> -       put_user((unsigned long) envp,--sp);
> -       put_user((unsigned long) argv,--sp);
> +       put_user((unsigned long) envp, --sp);
> +       put_user((unsigned long) argv, --sp);
>  #endif
> -       put_user(argc,--sp);
> +       put_user(argc, --sp);
>         current->mm->arg_start = (unsigned long) p;
> -       while (argc-->0) {
> +       while (argc-- > 0) {
>                 char c;
> -               put_user(p,argv++);
> +               put_user(p, argv++);
>                 do {
> -                       get_user(c,p++);
> +                       get_user(c, p++);
>                 } while (c);
>         }
> -       put_user(NULL,argv);
> +       put_user(NULL, argv);
>         current->mm->arg_end = current->mm->env_start = (unsigned long) p;
> -       while (envc-->0) {
> +       while (envc-- > 0) {
>                 char c;
> -               put_user(p,envp++);
> +               put_user(p, envp++);
>                 do {
> -                       get_user(c,p++);
> +                       get_user(c, p++);
>                 } while (c);
>         }
> -       put_user(NULL,envp);
> +       put_user(NULL, envp);
>         current->mm->env_end = (unsigned long) p;
>         return sp;
>  }
> @@ -200,7 +205,7 @@ static unsigned long __user *create_aout_tables(char __user *p, struct linux_bin
>   * libraries.  There is no binary dependent code anywhere else.
>   */
>
> -static int load_aout_binary(struct linux_binprm * bprm)
> +static int load_aout_binary(struct linux_binprm *bprm)
>  {
>         struct pt_regs *regs = current_pt_regs();
>         struct exec ex;
> @@ -213,7 +218,8 @@ static int load_aout_binary(struct linux_binprm * bprm)
>         if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != OMAGIC &&
>              N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
>             N_TRSIZE(ex) || N_DRSIZE(ex) ||
> -           i_size_read(file_inode(bprm->file)) < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
> +           i_size_read(file_inode(bprm->file)) <
> +           ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
>                 return -ENOEXEC;
>         }
>
> @@ -292,19 +298,12 @@ static int load_aout_binary(struct linux_binprm * bprm)
>                 }
>         } else {
>                 if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
> -                   (N_MAGIC(ex) != NMAGIC) && printk_ratelimit())
> -               {
> -                       printk(KERN_NOTICE "executable not page aligned\n");
> -               }
> -
> -               if ((fd_offset & ~PAGE_MASK) != 0 && printk_ratelimit())
> -               {
> -                       printk(KERN_WARNING
> -                              "fd_offset is not page aligned. Please convert program: %s\n",
> -                              bprm->file->f_path.dentry->d_name.name);
> -               }
> +                   (N_MAGIC(ex) != NMAGIC))
> +                       pr_notice_ratelimited("executable not page aligned\n");
>
> -               if (!bprm->file->f_op->mmap||((fd_offset & ~PAGE_MASK) != 0)) {
> +               if ((fd_offset & ~PAGE_MASK) != 0) {
> +                       pr_warn_ratelimited("fd_offset is not page aligned. Please convert program: %s\n",
> +                                           bprm->file->f_path.dentry->d_name.name);
>                         vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
>                         read_code(bprm->file, N_TXTADDR(ex), fd_offset,
>                                   ex.a_text + ex.a_data);
> @@ -312,9 +311,10 @@ static int load_aout_binary(struct linux_binprm * bprm)
>                 }
>
>                 error = vm_mmap(bprm->file, N_TXTADDR(ex), ex.a_text,
> -                       PROT_READ | PROT_EXEC,
> -                       MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
> -                       fd_offset);
> +                               PROT_READ | PROT_EXEC,
> +                               (MAP_FIXED | MAP_PRIVATE
> +                                | MAP_DENYWRITE | MAP_EXECUTABLE),
> +                               fd_offset);
>
>                 if (error != N_TXTADDR(ex)) {
>                         send_sig(SIGKILL, current, 0);
> @@ -323,8 +323,10 @@ static int load_aout_binary(struct linux_binprm * bprm)
>
>                 error = vm_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
>                                 PROT_READ | PROT_WRITE | PROT_EXEC,
> -                               MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
> +                               (MAP_FIXED | MAP_PRIVATE
> +                                | MAP_DENYWRITE | MAP_EXECUTABLE),
>                                 fd_offset + ex.a_text);
> +
>                 if (error != N_DATADDR(ex)) {
>                         send_sig(SIGKILL, current, 0);
>                         return error;
> @@ -340,7 +342,8 @@ beyond_if:
>         }
>
>         current->mm->start_stack =
> -               (unsigned long) create_aout_tables((char __user *) bprm->p, bprm);
> +               (unsigned long) create_aout_tables((char __user *) bprm->p,
> +                                                  bprm);
>  #ifdef __alpha__
>         regs->gp = ex.a_gpvalue;
>  #endif
> @@ -350,14 +353,11 @@ beyond_if:
>
>  static int load_aout_library(struct file *file)
>  {
> -       struct inode * inode;
>         unsigned long bss, start_addr, len;
>         unsigned long error;
>         int retval;
>         struct exec ex;
>
> -       inode = file_inode(file);
> -
>         retval = -ENOEXEC;
>         error = kernel_read(file, 0, (char *) &ex, sizeof(ex));
>         if (error != sizeof(ex))
> @@ -366,7 +366,8 @@ static int load_aout_library(struct file *file)
>         /* We come in here for the regular a.out style of shared libraries */
>         if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != QMAGIC) || N_TRSIZE(ex) ||
>             N_DRSIZE(ex) || ((ex.a_entry & 0xfff) && N_MAGIC(ex) == ZMAGIC) ||
> -           i_size_read(inode) < ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
> +           i_size_read(file_inode(file)) <
> +           ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
>                 goto out;
>         }
>
> @@ -374,7 +375,7 @@ static int load_aout_library(struct file *file)
>          * Requires a mmap handler. This prevents people from using a.out
>          * as part of an exploit attack against /proc-related vulnerabilities.
>          */
> -       if (!file->f_op || !file->f_op->mmap)
> +       if (!file->f_op->mmap)
>                 goto out;
>
>         if (N_FLAGS(ex))
> @@ -383,17 +384,14 @@ static int load_aout_library(struct file *file)
>         /* For  QMAGIC, the starting address is 0x20 into the page.  We mask
>            this off to get the starting address for the page */
>
> -       start_addr =  ex.a_entry & 0xfffff000;
> +       start_addr = ex.a_entry & 0xfffff000;
>
>         if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
> -               if (printk_ratelimit())
> -               {
> -                       printk(KERN_WARNING
> -                              "N_TXTOFF is not page aligned. Please convert library: %s\n",
> -                              file->f_path.dentry->d_name.name);
> -               }
> +               pr_warn_ratelimited("N_TXTOFF is not page aligned. Please convert library: %s\n",
> +                                   file->f_path.dentry->d_name.name);
> +
>                 vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
> -
> +
>                 read_code(file, start_addr, N_TXTOFF(ex),
>                           ex.a_text + ex.a_data);
>                 retval = 0;
> --
> 1.8.4
>
