Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab3DWUMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:12:06 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35175 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab3DWUMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:12:02 -0400
MIME-Version: 1.0
In-Reply-To: <5176B11E.6010908@schaufler-ca.com>
References: <5176ABB7.5080300@schaufler-ca.com>
	<5176B11E.6010908@schaufler-ca.com>
Date: Tue, 23 Apr 2013 13:12:01 -0700
X-Google-Sender-Auth: S0ryFUDpNnXQUQ_SxPYip067Bho
Message-ID: <CAGXu5jKrLTb0nf7_PXP4zar3KjGgCOfrVX8r4cgJdgAxoH1ZGw@mail.gmail.com>
Subject: Re: [PATCH v13 7/9] LSM: remove Yama special case stacking
From: Kees Cook <keescook@chromium.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 9:04 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> Subject: [PATCH v13 7/9] LSM: remove Yama special case stacking
>
> Remove the special case stacking for Yama.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>
> ---
>  security/security.c      |   21 ---------------------
>  security/yama/Kconfig    |    8 --------
>  security/yama/yama_lsm.c |   19 -------------------
>  3 files changed, 48 deletions(-)

In the 8/9 patch, the Yama externs are removed from
include/linux/security.h. That change should likely be moved to this
one, since the calls to those are being removed from
security/security.c in this patch:

> diff --git a/security/security.c b/security/security.c
> index d0b768c..67e435b 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -138,23 +138,11 @@ int __init register_security(struct security_operations *ops)
>
>  int security_ptrace_access_check(struct task_struct *child, unsigned int mode)
>  {
> -#ifdef CONFIG_SECURITY_YAMA_STACKED
> -       int rc;
> -       rc = yama_ptrace_access_check(child, mode);
> -       if (rc)
> -               return rc;
> -#endif
>         return security_ops->ptrace_access_check(child, mode);
>  }
>
>  int security_ptrace_traceme(struct task_struct *parent)
>  {
> -#ifdef CONFIG_SECURITY_YAMA_STACKED
> -       int rc;
> -       rc = yama_ptrace_traceme(parent);
> -       if (rc)
> -               return rc;
> -#endif
>         return security_ops->ptrace_traceme(parent);
>  }
>
> @@ -783,9 +771,6 @@ int security_task_create(unsigned long clone_flags)
>
>  void security_task_free(struct task_struct *task)
>  {
> -#ifdef CONFIG_SECURITY_YAMA_STACKED
> -       yama_task_free(task);
> -#endif
>         security_ops->task_free(task);
>  }
>
> @@ -911,12 +896,6 @@ int security_task_wait(struct task_struct *p)
>  int security_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>                          unsigned long arg4, unsigned long arg5)
>  {
> -#ifdef CONFIG_SECURITY_YAMA_STACKED
> -       int rc;
> -       rc = yama_task_prctl(option, arg2, arg3, arg4, arg5);
> -       if (rc != -ENOSYS)
> -               return rc;
> -#endif
>         return security_ops->task_prctl(option, arg2, arg3, arg4, arg5);
>  }
>
> diff --git a/security/yama/Kconfig b/security/yama/Kconfig
> index 20ef514..51d6709 100644
> --- a/security/yama/Kconfig
> +++ b/security/yama/Kconfig
> @@ -11,11 +11,3 @@ config SECURITY_YAMA
>           Further information can be found in Documentation/security/Yama.txt.
>
>           If you are unsure how to answer this question, answer N.
> -
> -config SECURITY_YAMA_STACKED
> -       bool "Yama stacked with other LSMs"
> -       depends on SECURITY_YAMA
> -       default n
> -       help
> -         When Yama is built into the kernel, force it to stack with the
> -         selected primary LSM.

Patch 8/9 removes a blank line from this Kconfig. It should probably
be moved to here.

> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
> index 13c88fbc..63ad9bb 100644
> --- a/security/yama/yama_lsm.c
> +++ b/security/yama/yama_lsm.c
> @@ -364,16 +364,6 @@ int yama_ptrace_traceme(struct task_struct *parent)
>         return rc;
>  }
>
> -#ifndef CONFIG_SECURITY_YAMA_STACKED
> -static struct security_operations yama_ops = {
> -       .name =                 "yama",
> -
> -       .ptrace_access_check =  yama_ptrace_access_check,
> -       .ptrace_traceme =       yama_ptrace_traceme,
> -       .task_prctl =           yama_task_prctl,
> -       .task_free =            yama_task_free,
> -};
> -#endif

The yama_ops (and the calls to security_module_enable and
register_security) shouldn't be removed (just the ifdefs). They're
added back in 8/9, so I think they should just stay in place. (Or
rather, they should stay in place in this patch, and 8/9 should only
remove the register_security call, as done with the others.)

>
>  #ifdef CONFIG_SYSCTL
>  static int yama_dointvec_minmax(struct ctl_table *table, int write,
> @@ -420,18 +410,9 @@ static struct ctl_table yama_sysctl_table[] = {
>
>  static __init int yama_init(void)
>  {
> -#ifndef CONFIG_SECURITY_YAMA_STACKED
> -       if (!security_module_enable(&yama_ops))
> -               return 0;
> -#endif
>
>         printk(KERN_INFO "Yama: becoming mindful.\n");
>
> -#ifndef CONFIG_SECURITY_YAMA_STACKED
> -       if (register_security(&yama_ops))
> -               panic("Yama: kernel registration failed.\n");
> -#endif
> -
>  #ifdef CONFIG_SYSCTL
>         if (!register_sysctl_paths(yama_sysctl_path, yama_sysctl_table))
>                 panic("Yama: sysctl registration failed.\n");

Regardless: yay! I'm looking forward to this series landing. :)

-Kees

--
Kees Cook
Chrome OS Security
