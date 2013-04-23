Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3DWAoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 20:44:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:39173 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab3DWAox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 20:44:53 -0400
Message-ID: <1366677702.2886.9.camel@pasglop>
Subject: Re: [PATCH] powerpc: Add HWCAP2 aux entry
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michael Neuling <mikey@neuling.org>
Cc: akpm@linux-foundation.org, vda.linux@googlemail.com,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Steve Munroe <sjmunroe@us.ibm.com>, linux-kernel@vger.kernel.org,
        paulus@samba.org, viro@zeniv.linux.org.uk,
        Ryan Arnold <ryanarn@us.ibm.com>, linuxppc-dev@lists.ozlabs.org
Date: Tue, 23 Apr 2013 10:41:42 +1000
In-Reply-To: <32253.1366256478@ale.ozlabs.ibm.com>
References: <20130402212204.GA30438@linux.vnet.ibm.com>
	 <20130405070559.GE5082@concordia> <27144.1366001074@ale.ozlabs.ibm.com>
	 <31546.1366255991@ale.ozlabs.ibm.com> <32253.1366256478@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 13:41 +1000, Michael Neuling wrote:
> akpm,
> 
> If you're happy with this, is it something you can take in your tree?

Andrew ? Or give me an ack ? :-) I'm happy to carry this, we need that
rather urgently and we have the glibc folks on board.

Cheers,
Ben.

> Mikey
> 
> Michael Neuling <mikey@neuling.org> wrote:
> > We are currently out of free bits in AT_HWCAP. With POWER8, we have
> > several hardware features that we need to advertise. 
> > 
> > Tested on POWER and x86.
> > 
> > Signed-off-by: Michael Neuling <michael@neuling.org>
> > Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
> > ---
> > 
> > > Wouldn't it be safer to not emit AT_HWCAP2 unless it is defined by the arch?
> > > 
> > > That way the change would only impact powerpc.
> > 
> > Should be addressed with this version.
> > 
> > Mikey
> > 
> > diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
> > index fb3245e..ccadad6 100644
> > --- a/arch/powerpc/include/asm/cputable.h
> > +++ b/arch/powerpc/include/asm/cputable.h
> > @@ -52,6 +52,7 @@ struct cpu_spec {
> >  	char		*cpu_name;
> >  	unsigned long	cpu_features;		/* Kernel features */
> >  	unsigned int	cpu_user_features;	/* Userland features */
> > +	unsigned int	cpu_user_features2;	/* Userland features v2 */
> >  	unsigned int	mmu_features;		/* MMU features */
> >  
> >  	/* cache line sizes */
> > diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
> > index ac9790f..cc0655a 100644
> > --- a/arch/powerpc/include/asm/elf.h
> > +++ b/arch/powerpc/include/asm/elf.h
> > @@ -61,6 +61,7 @@ typedef elf_vrregset_t elf_fpxregset_t;
> >     instruction set this cpu supports.  This could be done in userspace,
> >     but it's not easy, and we've already done it here.  */
> >  # define ELF_HWCAP	(cur_cpu_spec->cpu_user_features)
> > +# define ELF_HWCAP2	(cur_cpu_spec->cpu_user_features2)
> >  
> >  /* This yields a string that ld.so will use to load implementation
> >     specific libraries for optimization.  This is more specific in
> > diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> > index 3939829..1f8b5d5 100644
> > --- a/fs/binfmt_elf.c
> > +++ b/fs/binfmt_elf.c
> > @@ -240,6 +240,9 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
> >  	NEW_AUX_ENT(AT_EGID, from_kgid_munged(cred->user_ns, cred->egid));
> >   	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
> >  	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
> > +#ifdef ELF_HWCAP2
> > +	NEW_AUX_ENT(AT_HWCAP2, ELF_HWCAP2);
> > +#endif
> >  	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
> >  	if (k_platform) {
> >  		NEW_AUX_ENT(AT_PLATFORM,
> > diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> > index 9c13e02..bf2381d 100644
> > --- a/fs/binfmt_elf_fdpic.c
> > +++ b/fs/binfmt_elf_fdpic.c
> > @@ -483,7 +483,6 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
> >  	size_t platform_len = 0, len;
> >  	char *k_platform, *k_base_platform;
> >  	char __user *u_platform, *u_base_platform, *p;
> > -	long hwcap;
> >  	int loop;
> >  	int nr;	/* reset for each csp adjustment */
> >  
> > @@ -502,8 +501,6 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
> >  		return -EFAULT;
> >  #endif
> >  
> > -	hwcap = ELF_HWCAP;
> > -
> >  	/*
> >  	 * If this architecture has a platform capability string, copy it
> >  	 * to userspace.  In some cases (Sparc), this info is impossible
> > @@ -617,7 +614,10 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
> >  
> >  	nr = 0;
> >  	csp -= DLINFO_ITEMS * 2 * sizeof(unsigned long);
> > -	NEW_AUX_ENT(AT_HWCAP,	hwcap);
> > +	NEW_AUX_ENT(AT_HWCAP,	ELF_HWCAP);
> > +#ifdef ELF_HWCAP2
> > +	NEW_AUX_ENT(AT_HWCAP2,	ELF_HWCAP2);
> > +#endif
> >  	NEW_AUX_ENT(AT_PAGESZ,	PAGE_SIZE);
> >  	NEW_AUX_ENT(AT_CLKTCK,	CLOCKS_PER_SEC);
> >  	NEW_AUX_ENT(AT_PHDR,	exec_params->ph_addr);
> > diff --git a/include/uapi/linux/auxvec.h b/include/uapi/linux/auxvec.h
> > index 61594d5..835c065 100644
> > --- a/include/uapi/linux/auxvec.h
> > +++ b/include/uapi/linux/auxvec.h
> > @@ -28,6 +28,7 @@
> >  #define AT_BASE_PLATFORM 24	/* string identifying real platform, may
> >  				 * differ from AT_PLATFORM. */
> >  #define AT_RANDOM 25	/* address of 16 random bytes */
> > +#define AT_HWCAP2 26	/* extension of AT_HWCAP */
> >  
> >  #define AT_EXECFN  31	/* filename of program */
> >  
> > _______________________________________________
> > Linuxppc-dev mailing list
> > Linuxppc-dev@lists.ozlabs.org
> > https://lists.ozlabs.org/listinfo/linuxppc-dev
> > 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


