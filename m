Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaCZEyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:54:10 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:59413 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156AbaCZEyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:54:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:1801:1981:2110:2194:2199:2393:2559:2562:2828:2896:3138:3139:3140:3141:314
X-HE-Tag: kiss60_5d66892a33a0b
X-Filterd-Recvd-Size: 6154
Message-ID: <1395809640.3726.7.camel@joe-AO722>
Subject: Re: [RFC PATCH] Remove CONFIG_DCACHE_WORD_ACCESS
From: Joe Perches <joe@perches.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>
Cc: linux-arch <linux-arch@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Tue, 25 Mar 2014 21:54:00 -0700
In-Reply-To: <1394570240.4840.48.camel@pasglop>
References: <1393964591.20435.58.camel@joe-AO722>
	 <1394570240.4840.48.camel@pasglop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 07:37 +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2014-03-04 at 12:23 -0800, Joe Perches wrote:
> > It seems to duplicate CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > so use that instead.
> > 
> > This changes the !CPU_LITTLE_ENDIAN powerpc arch to use unaligned
> > accesses in fs/dcache.c and fs/namei.c as
> > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is enabled for that arch.
> > 
> > Remove the now unused DCACHE_WORD_ACCESS defines & uses.
> 
> Interesting.. we have word-at-a-time but we never enabled
> DCACHE_WORD_ACCESS, I wonder why that is. In fact, we should
> probably do it for LE as well for P8 if we can make a P8
> only config option...
> 
> Anton, what do you reckon here ?

Anton, do you have an opinion here?

> Cheers,
> Ben.
> 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  arch/arm/Kconfig                      | 1 -
> >  arch/arm/include/asm/word-at-a-time.h | 4 ++--
> >  arch/arm64/Kconfig                    | 1 -
> >  arch/x86/Kconfig                      | 1 -
> >  fs/Kconfig                            | 4 ----
> >  fs/dcache.c                           | 2 +-
> >  fs/namei.c                            | 2 +-
> >  7 files changed, 4 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 623a272..d5a2e60 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -12,7 +12,6 @@ config ARM
> >  	select BUILDTIME_EXTABLE_SORT if MMU
> >  	select CLONE_BACKWARDS
> >  	select CPU_PM if (SUSPEND || CPU_IDLE)
> > -	select DCACHE_WORD_ACCESS if HAVE_EFFICIENT_UNALIGNED_ACCESS
> >  	select GENERIC_ATOMIC64 if (CPU_V7M || CPU_V6 || !CPU_32v6K || !AEABI)
> >  	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
> >  	select GENERIC_IDLE_POLL_SETUP
> > diff --git a/arch/arm/include/asm/word-at-a-time.h b/arch/arm/include/asm/word-at-a-time.h
> > index a6d0a29..778b2ad 100644
> > --- a/arch/arm/include/asm/word-at-a-time.h
> > +++ b/arch/arm/include/asm/word-at-a-time.h
> > @@ -54,7 +54,7 @@ static inline unsigned long find_zero(unsigned long mask)
> >  #include <asm-generic/word-at-a-time.h>
> >  #endif
> >  
> > -#ifdef CONFIG_DCACHE_WORD_ACCESS
> > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> >  
> >  /*
> >   * Load an unaligned word from kernel space.
> > @@ -94,5 +94,5 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
> >  	return ret;
> >  }
> >  
> > -#endif	/* DCACHE_WORD_ACCESS */
> > +#endif	/* HAVE_EFFICIENT_UNALIGNED_ACCESS */
> >  #endif /* __ASM_ARM_WORD_AT_A_TIME_H */
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 764d682..2d6978c 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -13,7 +13,6 @@ config ARM64
> >  	select CLONE_BACKWARDS
> >  	select COMMON_CLK
> >  	select CPU_PM if (SUSPEND || CPU_IDLE)
> > -	select DCACHE_WORD_ACCESS
> >  	select GENERIC_CLOCKEVENTS
> >  	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
> >  	select GENERIC_IOMAP
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index abb261e..60cfa073 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -98,7 +98,6 @@ config X86
> >  	select CLKEVT_I8253
> >  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
> >  	select GENERIC_IOMAP
> > -	select DCACHE_WORD_ACCESS
> >  	select GENERIC_SMP_IDLE_THREAD
> >  	select ARCH_WANT_IPC_PARSE_VERSION if X86_32
> >  	select HAVE_ARCH_SECCOMP_FILTER
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index 312393f..7511271 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -4,10 +4,6 @@
> >  
> >  menu "File systems"
> >  
> > -# Use unaligned word dcache accesses
> > -config DCACHE_WORD_ACCESS
> > -       bool
> > -
> >  if BLOCK
> >  
> >  source "fs/ext2/Kconfig"
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 265e0ce..4e3c195 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -163,7 +163,7 @@ int proc_nr_dentry(ctl_table *table, int write, void __user *buffer,
> >   * Compare 2 name strings, return 0 if they match, otherwise non-zero.
> >   * The strings are both count bytes long, and count is non-zero.
> >   */
> > -#ifdef CONFIG_DCACHE_WORD_ACCESS
> > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> >  
> >  #include <asm/word-at-a-time.h>
> >  /*
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 385f781..1ee33ca 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -1618,7 +1618,7 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
> >   *   the final mask". Again, that could be replaced with a
> >   *   efficient population count instruction or similar.
> >   */
> > -#ifdef CONFIG_DCACHE_WORD_ACCESS
> > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> >  
> >  #include <asm/word-at-a-time.h>



