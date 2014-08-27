Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936029AbaH0VgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:36:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54898 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935548AbaH0VgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:36:07 -0400
Date: Wed, 27 Aug 2014 14:35:59 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, davej@redhat.com, davem@davemloft.net
Subject: Re: [PATCH V3 3/3] powerpc, ptrace: Enable support for miscellaneous
 registers
Message-ID: <20140827213559.GB11489@us.ibm.com>
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
 <1400858138-3939-4-git-send-email-khandual@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400858138-3939-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082721-5806-0000-0000-000000522458
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Anshuman Khandual [khandual@linux.vnet.ibm.com] wrote:
| This patch enables get and set of miscellaneous registers through ptrace
| PTRACE_GETREGSET/PTRACE_SETREGSET interface by implementing new powerpc
| specific register set REGSET_MISC support corresponding to the new ELF
| core note NT_PPC_MISC added previously in this regard.
| 
| Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
| ---
|  arch/powerpc/kernel/ptrace.c | 81 ++++++++++++++++++++++++++++++++++++++++++++
|  1 file changed, 81 insertions(+)
| 
| diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
| index 17642ef..63b883a 100644
| --- a/arch/powerpc/kernel/ptrace.c
| +++ b/arch/powerpc/kernel/ptrace.c
| @@ -1149,6 +1149,76 @@ static int tm_cvmx_set(struct task_struct *target, const struct user_regset *reg
|  #endif	/* CONFIG_PPC_TRANSACTIONAL_MEM */
|  
|  /*
| + * Miscellaneous Registers
| + *
| + * struct {
| + * 	unsigned long dscr;
| + *	unsigned long ppr;
| + * 	unsigned long tar;
| + * };
| + */
| +static int misc_get(struct task_struct *target, const struct user_regset *regset,
| +		   unsigned int pos, unsigned int count,
| +		   void *kbuf, void __user *ubuf)
| +{
| +	int ret;
| +
| +	/* DSCR register */
| +	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
| +					&target->thread.dscr, 0,
| +					sizeof(unsigned long));
| +
| +	BUILD_BUG_ON(offsetof(struct thread_struct, dscr) + sizeof(unsigned long) +
| +				sizeof(unsigned long) != offsetof(struct thread_struct, ppr));


I see these in  arch/powerpc/include/asm/processor.h

#ifdef CONFIG_PPC64
        unsigned long   dscr;
        int             dscr_inherit;
        unsigned long   ppr;    /* used to save/restore SMT priority */
#endif

where there is an 'int' between ppr and dscr. So, should one of
the above sizeof(unsigned long) be changed to sizeof(int) ?

Also, since we use offsetof(struct thread_struct, field) heavily, a
macro local to the file, may simplify the code.

#define	TSO(f)	(offsetof(struct thread_struct, f))

| +
| +	/* PPR register */
| +	if (!ret)
| +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
| +					  &target->thread.ppr, sizeof(unsigned long),
| +					  2 * sizeof(unsigned long));
| +
| +	BUILD_BUG_ON(offsetof(struct thread_struct, ppr) + sizeof(unsigned long)
| +						!= offsetof(struct thread_struct, tar));
| +	/* TAR register */
| +	if (!ret)
| +		ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
| +					  &target->thread.tar, 2 * sizeof(unsigned long),
| +					  3 * sizeof(unsigned long));
| +	return ret;
| +}
| +
| +static int misc_set(struct task_struct *target, const struct user_regset *regset,
| +		   unsigned int pos, unsigned int count,
| +		   const void *kbuf, const void __user *ubuf)
| +{
| +	int ret;
| +
| +	/* DSCR register */
| +	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
| +					&target->thread.dscr, 0,
| +					sizeof(unsigned long));
| +
| +	BUILD_BUG_ON(offsetof(struct thread_struct, dscr) + sizeof(unsigned long) +
| +			sizeof(unsigned long) != offsetof(struct thread_struct, ppr));
| +
| +	/* PPR register */
| +	if (!ret)
| +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
| +						&target->thread.ppr, sizeof(unsigned long),
| +						2 * sizeof(unsigned long));
| +
| +	BUILD_BUG_ON(offsetof(struct thread_struct, ppr) + sizeof(unsigned long)
| +						!= offsetof(struct thread_struct, tar));
| +
| +	/* TAR register */
| +	if (!ret)
| +		ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
| +						&target->thread.tar, 2 * sizeof(unsigned long),
| +						3 * sizeof(unsigned long));
| +	return ret;
| +}
| +
| +/*
|   * These are our native regset flavors.
|   */
|  enum powerpc_regset {
| @@ -1169,6 +1239,7 @@ enum powerpc_regset {
|  	REGSET_TM_CFPR,		/* TM checkpointed FPR */
|  	REGSET_TM_CVMX,		/* TM checkpointed VMX */
|  #endif
| +	REGSET_MISC		/* Miscellaneous */
|  };
|  
|  static const struct user_regset native_regsets[] = {
| @@ -1225,6 +1296,11 @@ static const struct user_regset native_regsets[] = {
|  		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
|  	},
|  #endif
| +	[REGSET_MISC] = {
| +		.core_note_type = NT_PPC_MISC, .n = 3,
| +		.size = sizeof(u64), .align = sizeof(u64),
| +		.get = misc_get, .set = misc_set
| +	},
|  };
|  
|  static const struct user_regset_view user_ppc_native_view = {
| @@ -1566,6 +1642,11 @@ static const struct user_regset compat_regsets[] = {
|  		.active = tm_cvmx_active, .get = tm_cvmx_get, .set = tm_cvmx_set
|  	},
|  #endif
| +	[REGSET_MISC] = {
| +		.core_note_type = NT_PPC_MISC, .n = 3,
| +		.size = sizeof(u64), .align = sizeof(u64),
| +		.get = misc_get, .set = misc_set
| +	},

Since the .n = 3 is used more than once, how about a macro for the
number of misc registers ?

|  };
|  
|  static const struct user_regset_view user_ppc_compat_view = {
| -- 
| 1.7.11.7
| 
| _______________________________________________
| Linuxppc-dev mailing list
| Linuxppc-dev@lists.ozlabs.org
| https://lists.ozlabs.org/listinfo/linuxppc-dev

