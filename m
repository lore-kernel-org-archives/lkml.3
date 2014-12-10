Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbaLJCLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 21:11:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbaLJCLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 21:11:33 -0500
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        mpe@ellerman.id.au, anton@samba.org, sgrubb@redhat.com,
        eparis@parisplace.org, tonyj@suse.de
Subject: Re: [PATCH V4] powerpc: add little endian flag to syscall_get_arch()
Date: Tue, 09 Dec 2014 21:11:19 -0500
Message-ID: <1557787.lOBez6GG22@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <24fcd2ea2c7633152e74a7a92abab1dd1782745d.1418157273.git.rgb@redhat.com>
References: <24fcd2ea2c7633152e74a7a92abab1dd1782745d.1418157273.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 09, 2014 03:37:07 PM Richard Guy Briggs wrote:
> Since both ppc and ppc64 have LE variants which are now reported by uname,
> add that flag (__AUDIT_ARCH_LE) to syscall_get_arch() and add
> AUDIT_ARCH_PPC64LE variant.
> 
> Without this,  perf trace and auditctl fail.
> 
> Mainline kernel reports ppc64le (per a058801) but there is no matching
> AUDIT_ARCH_PPC64LE.
> 
> Since 32-bit PPC LE is not supported by audit, don't advertise it in
> AUDIT_ARCH_PPC* variants.
> 
> See:
> 	https://www.redhat.com/archives/linux-audit/2014-August/msg00082.html
> 	https://www.redhat.com/archives/linux-audit/2014-December/msg00004.html
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  arch/powerpc/include/asm/syscall.h |    6 +++++-
>  include/uapi/linux/audit.h         |    2 ++
>  2 files changed, 7 insertions(+), 1 deletions(-)

The audit changes look fine to me, but as I mentioned earlier, this should go 
in via the ppc tree and not the audit tree.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/arch/powerpc/include/asm/syscall.h
> b/arch/powerpc/include/asm/syscall.h index 6fa2708..d1934e5 100644
> --- a/arch/powerpc/include/asm/syscall.h
> +++ b/arch/powerpc/include/asm/syscall.h
> @@ -90,6 +90,10 @@ static inline void syscall_set_arguments(struct
> task_struct *task,
> 
>  static inline int syscall_get_arch(void)
>  {
> -	return is_32bit_task() ? AUDIT_ARCH_PPC : AUDIT_ARCH_PPC64;
> +	int arch = is_32bit_task() ? AUDIT_ARCH_PPC : AUDIT_ARCH_PPC64;
> +#ifdef __LITTLE_ENDIAN__
> +	arch |= __AUDIT_ARCH_LE;
> +#endif
> +	return arch;
>  }
>  #endif	/* _ASM_SYSCALL_H */
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 4d100c8..d82beec 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -364,7 +364,9 @@ enum {
>  #define AUDIT_ARCH_PARISC	(EM_PARISC)
>  #define AUDIT_ARCH_PARISC64	(EM_PARISC|__AUDIT_ARCH_64BIT)
>  #define AUDIT_ARCH_PPC		(EM_PPC)
> +/* do not define AUDIT_ARCH_PPCLE since it is not supported by audit */
>  #define AUDIT_ARCH_PPC64	(EM_PPC64|__AUDIT_ARCH_64BIT)
> +#define AUDIT_ARCH_PPC64LE	(EM_PPC64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
>  #define AUDIT_ARCH_S390		(EM_S390)
>  #define AUDIT_ARCH_S390X	(EM_S390|__AUDIT_ARCH_64BIT)
>  #define AUDIT_ARCH_SH		(EM_SH)

-- 
paul moore
security and virtualization @ redhat

