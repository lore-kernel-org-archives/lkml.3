Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaELTJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaELTJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:09:38 -0400
Message-ID: <1399921766.3068.3.camel@localhost>
Subject: Re: [PATCH 3.15] MIPS: Add new AUDIT_ARCH token for the N32 ABI on
 MIPS64
From: Eric Paris <eparis@redhat.com>
To: Paul Moore <pmoore@redhat.com>
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Ralf Baechle <ralf@linux-mips.org>
Date: Mon, 12 May 2014 15:09:26 -0400
In-Reply-To: <2398159.J868kTHAKn@sifl>
References: <1397550996-14805-1-git-send-email-markos.chandras@imgtec.com>
	 <1398177636-10442-1-git-send-email-markos.chandras@imgtec.com>
	 <2398159.J868kTHAKn@sifl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 14:53 -0400, Paul Moore wrote:
> On Tuesday, April 22, 2014 03:40:36 PM Markos Chandras wrote:
> > A MIPS64 kernel may support ELF files for all 3 MIPS ABIs
> > (O32, N32, N64). Furthermore, the AUDIT_ARCH_MIPS{,EL}64 token
> > does not provide enough information about the ABI for the 64-bit
> > process. As a result of which, userland needs to use complex
> > seccomp filters to decide whether a syscall belongs to the o32 or n32
> > or n64 ABI. Therefore, a new arch token for MIPS64/n32 is added so it
> > can be used by seccomp to explicitely set syscall filters for this ABI.
> > 
> > Link: http://sourceforge.net/p/libseccomp/mailman/message/32239040/
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: Eric Paris <eparis@redhat.com>
> > Cc: Paul Moore <pmoore@redhat.com>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> > Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
> > ---
> > Ralf, can we please have this in 3.15 (Assuming it's ACK'd)?
> > 
> > Thanks a lot!
> > ---
> >  arch/mips/include/asm/syscall.h |  2 ++
> >  include/uapi/linux/audit.h      | 12 ++++++++++++
> >  2 files changed, 14 insertions(+)
> 
> [NOTE: Adding lkml to the To line to hopefully spur discussion/acceptance as 
> this *really* should be in 3.15]
> 
> I'm re-replying to this patch and adding lkml to the To line because I believe 
> it is very important we get this patch into 3.15.  For those who don't follow 
> the MIPS architecture very closely, the upcoming 3.15 is the first release to 
> include support for seccomp filters, the latest generation of syscall 
> filtering which used a BPF based filter language.  For reason that are easy to 
> understand, the syscall filters are ABI specific (e.g. syscall tables, word 
> length, endianness) and those generating syscall filters in userspace (e.g. 
> libseccomp) need to take great care to ensure that the generated filters take 
> the ABI into account and fail safely in the case where a different ABI is used 
> (e.g. x86, x86_64, x32).
> 
> The patch below corrects, what is IMHO, an omission in the original MIPS 
> seccomp filter patch, allowing userspace to easily separate MIPS and MIPS64.  
> Without this patch we will be forced to handle MIPS/MIPS64 like we handle 
> x86_64/x32 which is a royal pain and not something I want to have deal with 
> again.
> 
> Further, while I don't want to speak for the audit folks, it is my 
> understanding that they want this patch for similar reasons.

Audit would also like to see this patch.  We can survive without it, but
having this patch lets us write a better/easier userspace.

Acked-by: Eric Paris <eparis@redhat.com>

> 
> Please merge this patch for 3.15 or at least provide some feedback as to why 
> this isn't a viable solution for upstream.  Once 3.15 ships, fixing this will 
> require breaking the MIPS ABI which isn't something any of us want.
> 
> Thanks,
> -Paul
> 
> > diff --git a/arch/mips/include/asm/syscall.h
> > b/arch/mips/include/asm/syscall.h index c6e9cd2..17960fe 100644
> > --- a/arch/mips/include/asm/syscall.h
> > +++ b/arch/mips/include/asm/syscall.h
> > @@ -133,6 +133,8 @@ static inline int syscall_get_arch(void)
> >  #ifdef CONFIG_64BIT
> >  	if (!test_thread_flag(TIF_32BIT_REGS))
> >  		arch |= __AUDIT_ARCH_64BIT;
> > +	if (test_thread_flag(TIF_32BIT_ADDR))
> > +		arch |= __AUDIT_ARCH_CONVENTION_MIPS64_N32;
> >  #endif
> >  #if defined(__LITTLE_ENDIAN)
> >  	arch |=  __AUDIT_ARCH_LE;
> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index 11917f7..1b1efdd 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -331,9 +331,17 @@ enum {
> >  #define AUDIT_FAIL_PRINTK	1
> >  #define AUDIT_FAIL_PANIC	2
> > 
> > +/*
> > + * These bits disambiguate different calling conventions that share an
> > + * ELF machine type, bitness, and endianness
> > + */
> > +#define __AUDIT_ARCH_CONVENTION_MASK 0x30000000
> > +#define __AUDIT_ARCH_CONVENTION_MIPS64_N32 0x20000000
> > +
> >  /* distinguish syscall tables */
> >  #define __AUDIT_ARCH_64BIT 0x80000000
> >  #define __AUDIT_ARCH_LE	   0x40000000
> > +
> >  #define AUDIT_ARCH_ALPHA	(EM_ALPHA|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
> >  #define AUDIT_ARCH_ARM		(EM_ARM|__AUDIT_ARCH_LE)
> >  #define AUDIT_ARCH_ARMEB	(EM_ARM)
> > @@ -346,7 +354,11 @@ enum {
> >  #define AUDIT_ARCH_MIPS		(EM_MIPS)
> >  #define AUDIT_ARCH_MIPSEL	(EM_MIPS|__AUDIT_ARCH_LE)
> >  #define AUDIT_ARCH_MIPS64	(EM_MIPS|__AUDIT_ARCH_64BIT)
> > +#define AUDIT_ARCH_MIPS64N32	(EM_MIPS|__AUDIT_ARCH_64BIT|\
> > +				 __AUDIT_ARCH_CONVENTION_MIPS64_N32)
> >  #define AUDIT_ARCH_MIPSEL64	(EM_MIPS|__AUDIT_ARCH_64BIT|__AUDIT_ARCH_LE)
> > +#define AUDIT_ARCH_MIPSEL64N32	(EM_MIPS|__AUDIT_ARCH_64BIT|
> __AUDIT_ARCH_LE\
> > +				 __AUDIT_ARCH_CONVENTION_MIPS64_N32)
> >  #define AUDIT_ARCH_OPENRISC	(EM_OPENRISC)
> >  #define AUDIT_ARCH_PARISC	(EM_PARISC)
> >  #define AUDIT_ARCH_PARISC64	(EM_PARISC|__AUDIT_ARCH_64BIT)
> 


