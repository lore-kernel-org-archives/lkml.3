Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3IRXPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:15:40 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:43126 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3IRXPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <1379545947-9377-1-git-send-email-geyslan@gmail.com>
References: <1379545947-9377-1-git-send-email-geyslan@gmail.com>
Date: Wed, 18 Sep 2013 20:15:38 -0300
Message-ID: <CAGG-pUTEWNi2m+wej1wYDprs=8aGO5Z2szdc+E6Gw51HK98ExA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86_64: Add safe check in a.out loaders and some
 coding style
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Geyslan G. Bem" <geyslan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now it's ok.

Geyslan Gregório Bem
hackingbits.com


2013/9/18 Geyslan G. Bem <geyslan@gmail.com>:
> ia32_aout had no safe checks concerning the mmap and f_op in this module.
> It's not necessary to verify f_op in the load_aout_library, since the
> prior kernel_read/vfs_read function already does.
> Coding style and printks fixes.
>
> Tested using qemu, a handcrafted a.out binary and a a.out linked with a
> cross-compiled ld.
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  arch/x86/ia32/ia32_aout.c | 51 +++++++++++++++++++++++------------------------
>  1 file changed, 25 insertions(+), 26 deletions(-)
>
> diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
> index bae3aba..a5f3e66 100644
> --- a/arch/x86/ia32/ia32_aout.c
> +++ b/arch/x86/ia32/ia32_aout.c
> @@ -24,7 +24,7 @@
>  #include <linux/binfmts.h>
>  #include <linux/personality.h>
>  #include <linux/init.h>
> -#include <linux/jiffies.h>
> +#include <linux/ratelimit.h>
>
>  #include <asm/uaccess.h>
>  #include <asm/pgalloc.h>
> @@ -271,10 +271,17 @@ static int load_aout_binary(struct linux_binprm *bprm)
>              N_MAGIC(ex) != QMAGIC && N_MAGIC(ex) != NMAGIC) ||
>             N_TRSIZE(ex) || N_DRSIZE(ex) ||
>             i_size_read(file_inode(bprm->file)) <
> -           ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
> +           ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
>                 return -ENOEXEC;
>         }
>
> +       /*
> +        * Requires a mmap handler. This prevents people from using a.out
> +        * as part of an exploit attack against /proc-related vulnerabilities.
> +        */
> +       if (!bprm->file->f_op || !bprm->file->f_op->mmap)
> +               return -ENOEXEC;
> +
>         fd_offset = N_TXTOFF(ex);
>
>         /* Check initial limits. This avoids letting people circumvent
> @@ -339,25 +346,16 @@ static int load_aout_binary(struct linux_binprm *bprm)
>                 }
>         } else {
>  #ifdef WARN_OLD
> -               static unsigned long error_time, error_time2;
>                 if ((ex.a_text & 0xfff || ex.a_data & 0xfff) &&
> -                   (N_MAGIC(ex) != NMAGIC) &&
> -                               time_after(jiffies, error_time2 + 5*HZ)) {
> -                       printk(KERN_NOTICE "executable not page aligned\n");
> -                       error_time2 = jiffies;
> -               }
> +                   (N_MAGIC(ex) != NMAGIC))
> +                       pr_notice_ratelimited("executable not page aligned\n");
>
> -               if ((fd_offset & ~PAGE_MASK) != 0 &&
> -                           time_after(jiffies, error_time + 5*HZ)) {
> -                       printk(KERN_WARNING
> -                              "fd_offset is not page aligned. Please convert "
> -                              "program: %s\n",
> -                              bprm->file->f_path.dentry->d_name.name);
> -                       error_time = jiffies;
> -               }
> +               if ((fd_offset & ~PAGE_MASK) != 0)
> +                       pr_warn_ratelimited("fd_offset is not page aligned. Please convert program: %s\n",
> +                                           bprm->file->f_path.dentry->d_name.name);
>  #endif
>
> -               if (!bprm->file->f_op->mmap || (fd_offset & ~PAGE_MASK) != 0) {
> +               if ((fd_offset & ~PAGE_MASK) != 0) {
>                         vm_brk(N_TXTADDR(ex), ex.a_text+ex.a_data);
>                         read_code(bprm->file, N_TXTADDR(ex), fd_offset,
>                                         ex.a_text+ex.a_data);
> @@ -424,10 +422,17 @@ static int load_aout_library(struct file *file)
>         if ((N_MAGIC(ex) != ZMAGIC && N_MAGIC(ex) != QMAGIC) || N_TRSIZE(ex) ||
>             N_DRSIZE(ex) || ((ex.a_entry & 0xfff) && N_MAGIC(ex) == ZMAGIC) ||
>             i_size_read(file_inode(file)) <
> -           ex.a_text+ex.a_data+N_SYMSIZE(ex)+N_TXTOFF(ex)) {
> +           ex.a_text + ex.a_data + N_SYMSIZE(ex) + N_TXTOFF(ex)) {
>                 goto out;
>         }
>
> +       /*
> +        * Requires a mmap handler. This prevents people from using a.out
> +        * as part of an exploit attack against /proc-related vulnerabilities.
> +        */
> +       if (!file->f_op->mmap)
> +               goto out;
> +
>         if (N_FLAGS(ex))
>                 goto out;
>
> @@ -438,14 +443,8 @@ static int load_aout_library(struct file *file)
>
>         if ((N_TXTOFF(ex) & ~PAGE_MASK) != 0) {
>  #ifdef WARN_OLD
> -               static unsigned long error_time;
> -               if (time_after(jiffies, error_time + 5*HZ)) {
> -                       printk(KERN_WARNING
> -                              "N_TXTOFF is not page aligned. Please convert "
> -                              "library: %s\n",
> -                              file->f_path.dentry->d_name.name);
> -                       error_time = jiffies;
> -               }
> +               pr_warn_ratelimited("N_TXTOFF is not page aligned. Please convert library: %s\n",
> +                                   file->f_path.dentry->d_name.name);
>  #endif
>                 vm_brk(start_addr, ex.a_text + ex.a_data + ex.a_bss);
>
> --
> 1.8.4
>
