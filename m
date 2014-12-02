Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbaLBVyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:54:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932814AbaLBVyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:54:52 -0500
Message-ID: <547E3508.2080500@suse.de>
Date: Tue, 02 Dec 2014 13:54:16 -0800
From: Tony Jones <tonyj@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-api@vger.kernel.org
CC: sgrubb@redhat.com, eparis@parisplace.org, pmoore@redhat.com
Subject: Re: [PATCH] powerpc: add little endian flag to syscall_get_arch()
References: <fbe03529d720e75aa8663f8b521af5b11b33d52f.1417553967.git.rgb@redhat.com>
In-Reply-To: <fbe03529d720e75aa8663f8b521af5b11b33d52f.1417553967.git.rgb@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 01:27 PM, Richard Guy Briggs wrote:
> Since both ppc and ppc64 have LE variants which are now reported by uname, add
> that flag (__AUDIT_ARCH_LE) to syscall_get_arch() and add AUDIT_ARCH_PPC*LE
> variants.
> 
> Without this,  perf trace and auditctl fail.
> 
> Mainline kernel reports ppc64le (per a058801) but there is no matching
> AUDIT_ARCH_PPC64LE.
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
> 
> diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
> index 6fa2708..a58acab 100644
> --- a/arch/powerpc/include/asm/syscall.h
> +++ b/arch/powerpc/include/asm/syscall.h
> @@ -90,6 +90,10 @@ static inline void syscall_set_arguments(struct task_struct *task,
>  
>  static inline int syscall_get_arch(void)
>  {
> -	return is_32bit_task() ? AUDIT_ARCH_PPC : AUDIT_ARCH_PPC64;
> +	int arch = is_32bit_task() ? AUDIT_ARCH_PPC : AUDIT_ARCH_PPC64;
> +#ifdef __LITTLE_ENDIAN__
> +	arch |= __AUDIT_ARCH_LE
> +#endif
> +	return arch;
>  }
>  #endif	/* _ASM_SYSCALL_H */
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 4d100c8..fe29a99 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -364,7 +364,9 @@ enum {
>  #define AUDIT_ARCH_PARISC	(EM_PARISC)
>  #define AUDIT_ARCH_PARISC64	(EM_PARISC|__AUDIT_ARCH_64BIT)
>  #define AUDIT_ARCH_PPC		(EM_PPC)
> +#define AUDIT_ARCH_PPCLE	(EM_PPC|__AUDIT_ARCH_LE)
>  #define AUDIT_ARCH_PPC64	(EM_PPC64|__AUDIT_ARCH_64BIT)
> +#define AUDIT_ARCH_PPC64LE	(EM_PPC64|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
>  #define AUDIT_ARCH_S390		(EM_S390)
>  #define AUDIT_ARCH_S390X	(EM_S390|__AUDIT_ARCH_64BIT)
>  #define AUDIT_ARCH_SH		(EM_SH)

IBM would know for certain but I wasn't aware there was a PPCLE (32bit compat).

