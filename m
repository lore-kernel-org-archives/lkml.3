Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaGKQg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:36:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbaGKQg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:36:26 -0400
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32 filter
Date: Fri, 11 Jul 2014 12:36:23 -0400
Message-ID: <8897229.50V8e7SIxg@sifl>
Organization: Red Hat
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com>
References: <cover.1405023592.git.rgb@redhat.com> <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 10, 2014 11:38:13 PM Richard Guy Briggs wrote:
> Commit
> 	fca460f hpa@zytor.com 2012-02-19 07:56:26 -0800
> 	x32: Handle the x32 system call flag
> 
> provided a method to multiplex architecture with the syscall number for X32
> calls.
> 
> Commit
> 	8b4b9f2 pmoore@redhat.com 2013-02-15 12:21:43 -0500
> 	x86: remove the x32 syscall bitmask from syscall_get_nr()
> 
> broke audit and potentially other users of syscall_get_nr() which depend on
> that call as named.

Arguably audit is broken anyway by not correctly treating syscall numbers as 
32 bit integers like everyone else.

The commit above, 8b4b9f2, changed syscall_get_nr() so that it returned the 
same syscall number that is used by the architecture's ABI; just like every* 
other architecture in the kernel.

* Admittedly I didn't check every architecture's implementation, but after a 
half dozen I stopped checking as there was a definite trend.

{snip}

> diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
> index d6a756a..d58b6be 100644
> --- a/arch/x86/include/asm/syscall.h
> +++ b/arch/x86/include/asm/syscall.h
> @@ -236,6 +236,10 @@ static inline int syscall_get_arch(void)
>  		return AUDIT_ARCH_I386;
>  #endif
>  	/* Both x32 and x86_64 are considered "64-bit". */
> +#ifdef CONFIG_X86_X32_ABI
> +	if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
> +		return AUDIT_ARCH_X86_X32;
> +#endif

No.  See my comments above and in other parts of this thread.

>  	return AUDIT_ARCH_X86_64;
>  }
>  #endif	/* CONFIG_X86_32 */
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index b35c215..bc18214 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -73,6 +73,12 @@ static void populate_seccomp_data(struct seccomp_data
> *sd)
> 
>  	sd->nr = syscall_get_nr(task, regs);
>  	sd->arch = syscall_get_arch();
> +#ifdef CONFIG_X86_X32_ABI
> +	if (sd->arch == AUDIT_ARCH_X86_X32) {
> +		sd->arch = AUDIT_ARCH_X86_64;
> +		sd->nr |= __X32_SYSCALL_BIT;
> +	}
> +#endif

Once again, I'm not really sure I need to comment further here, but don't 
change syscall_get_nr(), it should return the same syscall number as was used 
by userspace to initiate the syscall.  If you really want to use the new 
AUDIT_ARCH_X86_X32 macro/define, go ahead, but make sure you rewrite it to the 
x86-64 value here so as to not break compatibility with existing seccomp 
filter users.

-- 
paul moore
security and virtualization @ redhat

