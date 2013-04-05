Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161729Ab3DEHGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:06:04 -0400
Received: from ozlabs.org ([203.10.76.45]:40536 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3DEHGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:06:02 -0400
Date: Fri, 5 Apr 2013 18:06:00 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, michaele@au1.ibm.com,
        Steve Munroe <sjmunroe@us.ibm.com>, linux-kernel@vger.kernel.org,
        paulus@samba.org, Ryan Arnold <ryanarn@us.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, akpm@linux-foundation.org,
        vda.linux@googlemail.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] powerpc: Add HWCAP2 aux entry
Message-ID: <20130405070559.GE5082@concordia>
References: <20130402212204.GA30438@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402212204.GA30438@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Added some folks to CC, blame scripts/get_maintainer.pl.

Comment below ..


On Tue, Apr 02, 2013 at 02:22:05PM -0700, Nishanth Aravamudan wrote:
> From: Michael Neuling <michael.neuling@au1.ibm.com>
> 
> We are currently out of free bits in AT_HWCAP. With POWER8, we have
> several hardware features that we need to advertise. Tested on POWER and
> x86.
> 
> Signed-off-by: Michael Neuling <michael.neuling@au1.ibm.com>
> Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> 
> diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
> index fb3245e..ccadad6 100644
> --- a/arch/powerpc/include/asm/cputable.h
> +++ b/arch/powerpc/include/asm/cputable.h
> @@ -52,6 +52,7 @@ struct cpu_spec {
>  	char		*cpu_name;
>  	unsigned long	cpu_features;		/* Kernel features */
>  	unsigned int	cpu_user_features;	/* Userland features */
> +	unsigned int	cpu_user_features2;	/* Userland features v2 */
>  	unsigned int	mmu_features;		/* MMU features */
>  
>  	/* cache line sizes */
> diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
> index ac9790f..cc0655a 100644
> --- a/arch/powerpc/include/asm/elf.h
> +++ b/arch/powerpc/include/asm/elf.h
> @@ -61,6 +61,7 @@ typedef elf_vrregset_t elf_fpxregset_t;
>     instruction set this cpu supports.  This could be done in userspace,
>     but it's not easy, and we've already done it here.  */
>  # define ELF_HWCAP	(cur_cpu_spec->cpu_user_features)
> +# define ELF_HWCAP2	(cur_cpu_spec->cpu_user_features2)
>  
>  /* This yields a string that ld.so will use to load implementation
>     specific libraries for optimization.  This is more specific in
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 3939829..51adc23 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -140,6 +140,13 @@ static int padzero(unsigned long elf_bss)
>  #define ELF_BASE_PLATFORM NULL
>  #endif
>  
> +/*
> + * Most archs don't need this
> + */
> +#ifndef ELF_HWCAP2
> +#define ELF_HWCAP2 (0)
> +#endif
> +
>  static int
>  create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  		unsigned long load_addr, unsigned long interp_load_addr)
> @@ -240,6 +247,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
>  	NEW_AUX_ENT(AT_EGID, from_kgid_munged(cred->user_ns, cred->egid));
>   	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
>  	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
> +	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);


Wouldn't it be safer to not emit AT_HWCAP2 unless it is defined by the arch?

That way the change would only impact powerpc.


cheers



> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 9c13e02..0b553d3 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -469,6 +469,13 @@ error_kill:
>  #endif
>  
>  /*
> + * Most archs don't need this
> + */
> +#ifndef ELF_HWCAP2
> +#define ELF_HWCAP2 (0)
> +#endif
> +
> +/*
>   * present useful information to the program by shovelling it onto the new
>   * process's stack
>   */
> @@ -483,7 +490,6 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
>  	size_t platform_len = 0, len;
>  	char *k_platform, *k_base_platform;
>  	char __user *u_platform, *u_base_platform, *p;
> -	long hwcap;
>  	int loop;
>  	int nr;	/* reset for each csp adjustment */
>  
> @@ -502,8 +508,6 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
>  		return -EFAULT;
>  #endif
>  
> -	hwcap = ELF_HWCAP;
> -
>  	/*
>  	 * If this architecture has a platform capability string, copy it
>  	 * to userspace.  In some cases (Sparc), this info is impossible
> @@ -617,7 +621,8 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
>  
>  	nr = 0;
>  	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
> -	NEW_AUX_ENT(AT_HWCAP,	hwcap);
> +	NEW_AUX_ENT(AT_HWCAP,	ELF_HWCAP);
> +	NEW_AUX_ENT(AT_HWCAP2,	ELF_HWCAP2);
>  	NEW_AUX_ENT(AT_PAGESZ,	PAGE_SIZE);
>  	NEW_AUX_ENT(AT_CLKTCK,	CLOCKS_PER_SEC);
>  	NEW_AUX_ENT(AT_PHDR,	exec_params->ph_addr);
> diff --git a/include/uapi/linux/auxvec.h b/include/uapi/linux/auxvec.h
> index 61594d5..835c065 100644
> --- a/include/uapi/linux/auxvec.h
> +++ b/include/uapi/linux/auxvec.h
> @@ -28,6 +28,7 @@
>  #define AT_BASE_PLATFORM 24	/* string identifying real platform, may
>  				 * differ from AT_PLATFORM. */
>  #define AT_RANDOM 25	/* address of 16 random bytes */
> +#define AT_HWCAP2 26	/* extension of AT_HWCAP */
>  
>  #define AT_EXECFN  31	/* filename of program */
>  
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
