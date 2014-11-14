Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965180AbaKNKAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:00:09 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48702 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054AbaKNKAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:00:07 -0500
MIME-Version: 1.0
In-Reply-To: <54647DA7.1070000@linux.vnet.ibm.com>
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
	<1415683597-22819-8-git-send-email-khandual@linux.vnet.ibm.com>
	<54647DA7.1070000@linux.vnet.ibm.com>
Date: Fri, 14 Nov 2014 14:00:05 +0400
Message-ID: <CAHj3AVna2H1VZvP0=Xjw9pqS+gRKR7_KH9FNhX3vUBFh7OU2wA@mail.gmail.com>
Subject: Re: [PATCH V4 7/8] powerpc, ptrace: Enable support for miscellaneous
 debug registers
From: Denis Kirjanov <kirjanov@gmail.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, mikey@neuling.org,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        peterz@infradead.org, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, tglx@linutronix.de, davej@redhat.com,
        akpm@linux-foundation.org, sukadev@linux.vnet.ibm.com,
        davem@davemloft.net, sam.bobroff@au1.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/14, Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:
> On 11/11/2014 10:56 AM, Anshuman Khandual wrote:
>> This patch enables get and set of miscellaneous debug registers through
>> ptrace PTRACE_GETREGSET-PTRACE_SETREGSET interface by implementing new
>> powerpc specific register set REGSET_MISC support corresponding to the
>> new ELF core note NT_PPC_MISC added previously in this regard.
>
> Right now this one does not compile for "ppc64e_defconfig" and
> "pmac32_defconfig" config options. The patch below will fix it
> and would be part of next revision.

It would be great to have a test tool for that under
tools/testing/selftests/ptrace/

> diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
> index 61a2581..be566eb 100644
> --- a/arch/powerpc/kernel/ptrace.c
> +++ b/arch/powerpc/kernel/ptrace.c
> @@ -1326,6 +1326,7 @@ static int tm_cvmx_set(struct task_struct *target,
>  }
>  #endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
>
> +#ifdef CONFIG_PPC64
>  /*
>   * get_misc_dbg
>   *
> @@ -1339,6 +1340,9 @@ static int tm_cvmx_set(struct task_struct *target,
>   *	unsigned long ppr;
>   *	unsigned long tar;
>   * };
> + *
> + * The data element 'tar' will be valid only if the
> + * kernel has CONFIG_PPC_BOOK3S_64 config option enabled.
>   */
>  static int get_misc_dbg(struct task_struct *target,
>  			const struct user_regset *regset, unsigned int pos,
> @@ -1348,7 +1352,10 @@ static int get_misc_dbg(struct task_struct *target,
>
>  	/* Build test */
>  	BUILD_BUG_ON(TSO(dscr) + 2 * sizeof(unsigned long) != TSO(ppr));
> +
> +#ifdef CONFIG_PPC_BOOK3S_64
>  	BUILD_BUG_ON(TSO(ppr) + sizeof(unsigned long) != TSO(tar));
> +#endif
>
>  	/* DSCR register */
>  	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
> @@ -1362,12 +1369,14 @@ static int get_misc_dbg(struct task_struct *target,
>  						sizeof(unsigned long),
>  						2 * sizeof(unsigned long));
>
> +#ifdef CONFIG_PPC_BOOK3S_64
>  	/* TAR register */
>  	if (!ret)
>  		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
>  						&target->thread.tar,
>  						2 * sizeof(unsigned long),
>  						3 * sizeof(unsigned long));
> +#endif
>  	return ret;
>  }
>
> @@ -1384,6 +1393,9 @@ static int get_misc_dbg(struct task_struct *target,
>   *	unsigned long ppr;
>   *	unsigned long tar;
>   * };
> + *
> + * The data element 'tar' will be valid only if the
> + * kernel has CONFIG_PPC_BOOK3S_64 config option enabled.
>   */
>  static int set_misc_dbg(struct task_struct *target,
>  			const struct user_regset *regset, unsigned int pos,
> @@ -1394,7 +1406,10 @@ static int set_misc_dbg(struct task_struct *target,
>
>  	/* Build test */
>  	BUILD_BUG_ON(TSO(dscr) + 2 * sizeof(unsigned long) != TSO(ppr));
> +
> +#ifdef CONFIG_PPC_BOOK3S_64
>  	BUILD_BUG_ON(TSO(ppr) + sizeof(unsigned long) != TSO(tar));
> +#endif
>
>  	/* DSCR register */
>  	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
> @@ -1407,15 +1422,17 @@ static int set_misc_dbg(struct task_struct *target,
>  						&target->thread.ppr,
>  						sizeof(unsigned long),
>  						2 * sizeof(unsigned long));
> -
> +#ifdef CONFIG_PPC_BOOK3S_64
>  	/* TAR register */
>  	if (!ret)
>  		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
>  						&target->thread.tar,
>  						2 * sizeof(unsigned long),
>  						3 * sizeof(unsigned long));
> +#endif
>  	return ret;
>  }
> +#endif /* CONFIG_PPC64 */
>
>  /*
>   * These are our native regset flavors.
> @@ -1438,7 +1455,9 @@ enum powerpc_regset {
>  	REGSET_TM_CFPR,		/* TM checkpointed FPR registers */
>  	REGSET_TM_CVMX,		/* TM checkpointed VMX registers */
>  #endif
> +#ifdef CONFIG_PPC64
>  	REGSET_MISC		/* Miscellaneous debug registers */
> +#endif
>  };
>
>  static const struct user_regset native_regsets[] = {
> @@ -1495,11 +1514,13 @@ static const struct user_regset native_regsets[] = {
>  		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
>  	},
>  #endif
> +#ifdef CONFIG_PPC64
>  	[REGSET_MISC] = {
>  		.core_note_type = NT_PPC_MISC, .n = ELF_NMISCREG,
>  		.size = sizeof(u64), .align = sizeof(u64),
>  		.get = get_misc_dbg, .set = set_misc_dbg
>  	},
> +#endif
>  };
>
>  static const struct user_regset_view user_ppc_native_view = {
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


-- 
Regards,
Denis
