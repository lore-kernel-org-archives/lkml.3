Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521AbaFQPn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:43:26 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25146 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932989AbaFQPnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:43:24 -0400
Date: Tue, 17 Jun 2014 16:43:10 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/24] Allow for some signal structures to be the same
 between a 32bit ABI and the 64bit ABI.
Message-ID: <20140617154310.GD21752@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
 <1400914939-9708-7-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400914939-9708-7-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 12:02:01AM -0700, Andrew Pinski wrote:
> diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
> index ba5be7f..553aca9 100644
> --- a/include/uapi/asm-generic/siginfo.h
> +++ b/include/uapi/asm-generic/siginfo.h
> @@ -4,9 +4,17 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  
> +#ifndef __SIGINFO_VOIDPOINTER
> +#define __SIGINFO_VOIDPOINTER(field) void __user *field
> +#endif

Nitpick: maybe a shorter name like __SIGINFO_VOIDPTR (or VOID_PTR).

> +
> +#ifndef __SIGINFO_BAND
> +#define __SIGINFO_BAND(field) __ARCH_SI_BAND_T field
> +#endif
> +
>  typedef union sigval {
>  	int sival_int;
> -	void __user *sival_ptr;
> +	__SIGINFO_VOIDPOINTER(sival_ptr);
>  } sigval_t;

I'll discuss this further in a subsequent patch. I assume here you'll
enforce the alignment via the __SIGINFO_VOIDPOINTER definition. The
alternative would be another macro for structure attributes.

>  /*
> @@ -86,7 +94,7 @@ typedef struct siginfo {
>  
>  		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
>  		struct {
> -			void __user *_addr; /* faulting insn/memory ref. */
> +			__SIGINFO_VOIDPOINTER(_addr); /* faulting insn/memory ref. */
>  #ifdef __ARCH_SI_TRAPNO
>  			int _trapno;	/* TRAP # which caused the signal */
>  #endif
> @@ -95,13 +103,13 @@ typedef struct siginfo {
>  
>  		/* SIGPOLL */
>  		struct {
> -			__ARCH_SI_BAND_T _band;	/* POLL_IN, POLL_OUT, POLL_MSG */
> +			__SIGINFO_BAND(_band);	/* POLL_IN, POLL_OUT, POLL_MSG */
>  			int _fd;
>  		} _sigpoll;
>  
>  		/* SIGSYS */
>  		struct {
> -			void __user *_call_addr; /* calling user insn */
> +			__SIGINFO_VOIDPOINTER(_call_addr); /* calling user insn */
>  			int _syscall;	/* triggering system call number */
>  			unsigned int _arch;	/* AUDIT_ARCH_* of syscall */
>  		} _sigsys;
> @@ -283,6 +291,7 @@ typedef struct sigevent {
>  		int _pad[SIGEV_PAD_SIZE];
>  		 int _tid;
>  
> +		/* Note these two are handled only in userspace */
>  		struct {
>  			void (*_function)(sigval_t);
>  			void *_attribute;	/* really pthread_attr_t */

SIGEV_PAD_SIZE would be the same with ILP32 because sizeof(sigval_t)
would not change. So I think that's fine.

> diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-generic/signal.h
> index 9df61f1..c4ce238 100644
> --- a/include/uapi/asm-generic/signal.h
> +++ b/include/uapi/asm-generic/signal.h
> @@ -4,7 +4,9 @@
>  #include <linux/types.h>
>  
>  #define _NSIG		64
> +#ifndef _NSIG_BPW
>  #define _NSIG_BPW	__BITS_PER_LONG
> +#endif
>  #define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
>  
>  #define SIGHUP		 1
> @@ -83,9 +85,13 @@
>  #define MINSIGSTKSZ	2048
>  #define SIGSTKSZ	8192
>  
> +#ifndef __SIGSET_INNER_TYPE
> +#define __SIGSET_INNER_TYPE unsigned long
> +#endif
> +
>  #ifndef __ASSEMBLY__
>  typedef struct {
> -	unsigned long sig[_NSIG_WORDS];
> +	__SIGSET_INNER_TYPE sig[_NSIG_WORDS];
>  } sigset_t;

Would the default not work? The sigset_t structure ends up with the same
number of bits between LP64 and ILP32, whether you patch it or not.

>  
>  /* not actually used, but required for linux/syscalls.h */
> @@ -98,11 +104,24 @@ typedef unsigned long old_sigset_t;
>  #endif
>  
>  #ifndef __KERNEL__
> +
> +#ifndef __SIGACTION_HANDLER
> +#define __SIGACTION_HANDLER(field)	__sighandler_t field
> +#endif
> +
> +#ifndef __SIGACTION_FLAGS
> +#define __SIGACTION_FLAGS(field)	unsigned long field
> +#endif
> +
> +#ifndef __SIGACTION_RESTORER
> +#define __SIGACTION_RESTORER(field)	__sigrestore_t field
> +#endif
> +
>  struct sigaction {
> -	__sighandler_t sa_handler;
> -	unsigned long sa_flags;
> +	__SIGACTION_HANDLER(sa_handler);
> +	__SIGACTION_FLAGS(sa_flags);
>  #ifdef SA_RESTORER
> -	__sigrestore_t sa_restorer;
> +	__SIGACTION_RESTORER(sa_restorer);
>  #endif
>  	sigset_t sa_mask;		/* mask last for extensibility */
>  };

Same comment here about the need for attributes (to clarify in
subsequent patch).

-- 
Catalin
