Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3IIKFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:05:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57405 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab3IIKF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:05:28 -0400
Date: Mon, 9 Sep 2013 10:59:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "behanw@converseincode.com" <behanw@converseincode.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Mark Charlebois <charlebm@gmail.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] arm: LLVMLinux: use current_stack_pointer for percpu
Message-ID: <20130909095912.GA5426@mudshark.cambridge.arm.com>
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
 <1378502899-1241-3-git-send-email-behanw@converseincode.com>
 <alpine.LFD.2.03.1309070101330.20709@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.03.1309070101330.20709@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Sat, Sep 07, 2013 at 06:12:03AM +0100, Nicolas Pitre wrote:
> On Fri, 6 Sep 2013, behanw@converseincode.com wrote:
> > From: Behan Webster <behanw@converseincode.com>
> > 
> > The existing code uses named registers to get the value of the stack pointer.
> > The new current_stack_pointer macro is more readable and allows for a central
> > portable implementation of how to get the stack pointer with ASM.  This change
> > supports being able to compile the kernel with both gcc and Clang.
> > 
> > Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> > Signed-off-by: Behan Webster <behanw@converseincode.com>
> > Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
> > ---
> >  arch/arm/include/asm/percpu.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
> > index 209e650..629a975 100644
> > --- a/arch/arm/include/asm/percpu.h
> > +++ b/arch/arm/include/asm/percpu.h
> > @@ -30,14 +30,14 @@ static inline void set_my_cpu_offset(unsigned long off)
> >  static inline unsigned long __my_cpu_offset(void)
> >  {
> >  	unsigned long off;
> > -	register unsigned long *sp asm ("sp");
> > +	unsigned long sp = current_stack_pointer;
> >  
> >  	/*
> >  	 * Read TPIDRPRW.
> >  	 * We want to allow caching the value, so avoid using volatile and
> >  	 * instead use a fake stack read to hazard against barrier().
> >  	 */
> > -	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (*sp));
> > +	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (sp));
> 
> This change doesn't look to be equivalent.  Previously the *sp implied a 
> memory location which doesn't appear to be the case anymore.

Having looked at the other comments in this thread, I had a crack with the
following diff:

diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
index 209e650..ae0ac4e 100644
--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -30,7 +30,8 @@ static inline void set_my_cpu_offset(unsigned long off)
 static inline unsigned long __my_cpu_offset(void)
 {
        unsigned long off;
-       register unsigned long *sp asm ("sp");
+//     register unsigned long *sp asm ("sp");
+       unsigned long *sp = (unsigned long *)current_stack_pointer;
 
        /*
         * Read TPIDRPRW.
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 2b8114f..88a587c 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -89,6 +89,15 @@ struct thread_info {
 #define init_stack             (init_thread_union.stack)
 
 /*
+ * how to get the current stack pointer from C
+ */
+#define current_stack_pointer ({ \
+       unsigned long current_sp; \
+       asm ("mov %0, r13" : "=r" (current_sp)); \
+       current_sp; \
+})
+
+/*
  * how to get the thread information struct from C
  */
 static inline struct thread_info *current_thread_info(void) __attribute_const__;

> this sp trickery was introduced in commit 509eb76ebf97 to solve bad code 
> generation (the commit log has the details).  It would be good if Will 
> Deacon could confirm that his test case still works fine with your 
> change.

I resurrected your original test case for the patch in question (see below)
and the code is worse with the new sp accessor, since it insists on moving
sp into r3, which forces us to push r4 onto the stack:

Before:

c001ce6c:       ee1d3f90        mrc     15, 0, r3, cr13, cr0, {4}
c001ce70:       e790c103        ldr     ip, [r0, r3, lsl #2]
c001ce74:       ee1d3f90        mrc     15, 0, r3, cr13, cr0, {4}
c001ce78:       e7911103        ldr     r1, [r1, r3, lsl #2]
c001ce7c:       e7d22003        ldrb    r2, [r2, r3]
c001ce80:       ee1d3f90        mrc     15, 0, r3, cr13, cr0, {4}
c001ce84:       e7903103        ldr     r3, [r0, r3, lsl #2]
c001ce88:       e08c0001        add     r0, ip, r1
c001ce8c:       e0800002        add     r0, r0, r2
c001ce90:       e0800003        add     r0, r0, r3
c001ce94:       e12fff1e        bx      lr

After:

c001ce74:       e52d4004        push    {r4}            ; (str r4, [sp, #-4]!)
c001ce78:       e1a0300d        mov     r3, sp
c001ce7c:       ee1dcf90        mrc     15, 0, ip, cr13, cr0, {4}
c001ce80:       e790410c        ldr     r4, [r0, ip, lsl #2]
c001ce84:       ee1dcf90        mrc     15, 0, ip, cr13, cr0, {4}
c001ce88:       e791110c        ldr     r1, [r1, ip, lsl #2]
c001ce8c:       e7d2200c        ldrb    r2, [r2, ip]
c001ce90:       ee1d3f90        mrc     15, 0, r3, cr13, cr0, {4}
c001ce94:       e7903103        ldr     r3, [r0, r3, lsl #2]
c001ce98:       e0840001        add     r0, r4, r1
c001ce9c:       e0800002        add     r0, r0, r2
c001cea0:       e0800003        add     r0, r0, r3
c001cea4:       e8bd0010        pop     {r4}
c001cea8:       e12fff1e        bx      lr

Will

--->8

int foo(int *a, int *b, char *c)
{
	int x, y, z;

	x = a[__my_cpu_offset];
	barrier();
	y = b[__my_cpu_offset];
	z = c[__my_cpu_offset];
	barrier();
	return  x + y + z + a[__my_cpu_offset];
}

