Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3CHUVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:21:09 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:34074 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3CHUVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:21:06 -0500
MIME-Version: 1.0
In-Reply-To: <20130308175918.GA26329@redhat.com>
References: <20130308175852.GA26300@redhat.com>
	<20130308175918.GA26329@redhat.com>
Date: Fri, 8 Mar 2013 12:21:05 -0800
X-Google-Sender-Auth: 1O8xoBPTjSzf_b8hvjnyBzFrRKg
Message-ID: <CACBanvqVkyHOgLPG197gkKQNs2KY1+kyveJtzTYFshHzV7g6bg@mail.gmail.com>
Subject: Re: [PATCH 2/3] coredump: factor out the setting of PF_DUMPCORE
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 9:59 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Cleanup. Every linux_binfmt->core_dump() sets PF_DUMPCORE,
> move this into zap_threads() called by do_coredump().
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Mandeep Singh Baines <msb@chromium.org>

> ---
>  arch/x86/ia32/ia32_aout.c |    1 -
>  fs/binfmt_aout.c          |    1 -
>  fs/binfmt_elf.c           |    3 +--
>  fs/binfmt_elf_fdpic.c     |    2 --
>  fs/coredump.c             |    1 +
>  5 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
> index a703af1..24b787c 100644
> --- a/arch/x86/ia32/ia32_aout.c
> +++ b/arch/x86/ia32/ia32_aout.c
> @@ -162,7 +162,6 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file,
>         fs = get_fs();
>         set_fs(KERNEL_DS);
>         has_dumped = 1;
> -       current->flags |= PF_DUMPCORE;
>         strncpy(dump.u_comm, current->comm, sizeof(current->comm));
>         dump.u_ar0 = offsetof(struct user32, regs);
>         dump.signal = signr;
> diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
> index 6043567..f70aea2 100644
> --- a/fs/binfmt_aout.c
> +++ b/fs/binfmt_aout.c
> @@ -62,7 +62,6 @@ static int aout_core_dump(struct coredump_params *cprm)
>         fs = get_fs();
>         set_fs(KERNEL_DS);
>         has_dumped = 1;
> -       current->flags |= PF_DUMPCORE;
>                 strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
>         dump.u_ar0 = offsetof(struct user, regs);
>         dump.signal = cprm->siginfo->si_signo;
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 0c42cdb..1f52be1 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -2082,8 +2082,7 @@ static int elf_core_dump(struct coredump_params *cprm)
>                 goto cleanup;
>
>         has_dumped = 1;
> -       current->flags |= PF_DUMPCORE;
> -
> +
>         fs = get_fs();
>         set_fs(KERNEL_DS);
>
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index dc84732..8f2c03d 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -1684,8 +1684,6 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
>         fill_elf_fdpic_header(elf, e_phnum);
>
>         has_dumped = 1;
> -       current->flags |= PF_DUMPCORE;
> -
>         /*
>          * Set up the notes in similar form to SVR4 core dumps made
>          * with info from their /proc.
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 66f65f0..477f393 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -299,6 +299,7 @@ static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
>         if (unlikely(nr < 0))
>                 return nr;
>
> +       tsk->flags = PF_DUMPCORE;
>         if (atomic_read(&mm->mm_users) == nr + 1)
>                 goto done;
>         /*
> --
> 1.5.5.1
>
