Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbaLBWIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:08:47 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43702 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980AbaLBWIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:08:46 -0500
MIME-Version: 1.0
In-Reply-To: <fbe03529d720e75aa8663f8b521af5b11b33d52f.1417553967.git.rgb@redhat.com>
References: <fbe03529d720e75aa8663f8b521af5b11b33d52f.1417553967.git.rgb@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 2 Dec 2014 14:08:24 -0800
Message-ID: <CALCETrX_9zg_ZYZCSpB5Fu6xrC8vtHdSAs=2afZ=jeoek8dz6A@mail.gmail.com>
Subject: Re: [PATCH] powerpc: add little endian flag to syscall_get_arch()
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, Linux API <linux-api@vger.kernel.org>,
        Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@parisplace.org>,
        Paul Moore <pmoore@redhat.com>, Tony Jones <tonyj@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 1:27 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Since both ppc and ppc64 have LE variants which are now reported by uname, add
> that flag (__AUDIT_ARCH_LE) to syscall_get_arch() and add AUDIT_ARCH_PPC*LE
> variants.
>
> Without this,  perf trace and auditctl fail.
>
> Mainline kernel reports ppc64le (per a058801) but there is no matching
> AUDIT_ARCH_PPC64LE.
>

There's no seccomp filter support for powerpc, so there's no risk that
this breaks it.

--Andy

> See:
>         https://www.redhat.com/archives/linux-audit/2014-August/msg00082.html
>         https://www.redhat.com/archives/linux-audit/2014-December/msg00004.html
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  arch/powerpc/include/asm/syscall.h |    6 +++++-
>  include/uapi/linux/audit.h         |    2 ++
>  2 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
> index 6fa2708..a58acab 100644
> --- a/arch/powerpc/include/asm/syscall.h
> +++ b/arch/powerpc/include/asm/syscall.h
> @@ -90,6 +90,10 @@ static inline void syscall_set_arguments(struct task_struct *task,
>
>  static inline int syscall_get_arch(void)
>  {
> -       return is_32bit_task() ? AUDIT_ARCH_PPC : AUDIT_ARCH_PPC64;
> +       int arch = is_32bit_task() ? AUDIT_ARCH_PPC : AUDIT_ARCH_PPC64;
> +#ifdef __LITTLE_ENDIAN__
> +       arch |= __AUDIT_ARCH_LE
> +#endif
> +       return arch;
>  }
>  #endif /* _ASM_SYSCALL_H */
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 4d100c8..fe29a99 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -364,7 +364,9 @@ enum {
>  #define AUDIT_ARCH_PARISC      (EM_PARISC)
>  #define AUDIT_ARCH_PARISC64    (EM_PARISC|__AUDIT_ARCH_64BIT)
>  #define AUDIT_ARCH_PPC         (EM_PPC)
> +#define AUDIT_ARCH_PPCLE       (EM_PPC|__AUDIT_ARCH_LE)
>  #define AUDIT_ARCH_PPC64       (EM_PPC64|__AUDIT_ARCH_64BIT)
> +#define AUDIT_ARCH_PPC64LE     (EM_PPC64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
>  #define AUDIT_ARCH_S390                (EM_S390)
>  #define AUDIT_ARCH_S390X       (EM_S390|__AUDIT_ARCH_64BIT)
>  #define AUDIT_ARCH_SH          (EM_SH)
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
