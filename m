Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaATPeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:34:01 -0500
Received: from smtp.citrix.com ([66.165.176.89]:6209 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbaATPd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:33:57 -0500
X-IronPort-AV: E=Sophos;i="4.95,691,1384300800"; 
   d="scan'208";a="94525667"
Date: Mon, 20 Jan 2014 15:32:48 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Will Deacon <will.deacon@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gang.chen@asianux.com" <gang.chen@asianux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jaccon.bastiaansen@gmail.com" <jaccon.bastiaansen@gmail.com>
Subject: Re: [PATCH v3] arm: remove !CPU_V6 and !GENERIC_ATOMIC64 build
 dependencies for XEN
In-Reply-To: <20140116193123.GB22105@mudshark.cambridge.arm.com>
Message-ID: <alpine.DEB.2.02.1401201523240.21510@kaball.uk.xensource.com>
References: <1389204023-26912-1-git-send-email-stefano.stabellini@eu.citrix.com> <20140109103004.GB11089@mudshark.cambridge.arm.com> <201401091204.17932.arnd@arndb.de> <alpine.DEB.2.02.1401091247000.21510@kaball.uk.xensource.com> <20140109184251.GL17838@mudshark.cambridge.arm.com>
 <alpine.DEB.2.02.1401161622570.21510@kaball.uk.xensource.com> <20140116193123.GB22105@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Will Deacon wrote:
> Hi Stefano,
> 
> On Thu, Jan 16, 2014 at 04:27:55PM +0000, Stefano Stabellini wrote:
> > On Thu, 9 Jan 2014, Will Deacon wrote:
> > > Ok, thanks for the explanation. Looking at the patch, I wonder whether it's
> > > not cleaner just to implement xchg code separately for Xen? The Linux code
> > > isn't always sufficient (due to the GENERIC_ATOMIC64 stuff) and most of the
> > > churn coming out of this patch is an attempt to provide some small code
> > > reuse at the cost of code readability.
> > > 
> > > What do others think?
> > 
> > I am OK with that, in fact my first version of the patch did just that:
> > 
> > http://marc.info/?l=linux-arm-kernel&m=138436406724990&w=2
> > 
> > Is that what you had in mind?
> 
> For the xchg part, yes, that looks a lot better. I don't like the #undef
> CONFIG_CPU_V6 though, can that be rewritten to use __LINUX_ARM_ARCH__?

The problem is that the 1 and 2 byte parameter size cases in __cmpxchg
are ifdef'ed CONFIG_CPU_V6 but drivers/xen/grant-table.c needs them.

So we can either undef CONFIG_CPU_V6 in grant-table.c or call a
different function.

If I switch from ifdef CONFIG_CPU_V6 to if __LINUX_ARM_ARCH__ > 6 in
__cmpxchg, we still have the problem that if __LINUX_ARM_ARCH__ == 6,
grant-table.c doesn't compile.

Maybe the approach taken by the other patch for cmpxchg is better, see
below.


diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7e..ae54ae0 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1881,8 +1881,7 @@ config XEN_DOM0
 config XEN
 	bool "Xen guest support on ARM (EXPERIMENTAL)"
 	depends on ARM && AEABI && OF
-	depends on CPU_V7 && !CPU_V6
-	depends on !GENERIC_ATOMIC64
+	depends on CPU_V7
 	select ARM_PSCI
 	select SWIOTLB_XEN
 	help
diff --git a/arch/arm/include/asm/cmpxchg.h b/arch/arm/include/asm/cmpxchg.h
index df2fbba..cc8a4a2 100644
--- a/arch/arm/include/asm/cmpxchg.h
+++ b/arch/arm/include/asm/cmpxchg.h
@@ -133,6 +133,44 @@ extern void __bad_cmpxchg(volatile void *ptr, int size);
  * cmpxchg only support 32-bits operands on ARMv6.
  */
 
+static inline unsigned long __cmpxchg8(volatile void *ptr, unsigned long old,
+				      unsigned long new)
+{
+	unsigned long oldval, res;
+
+	do {
+		asm volatile("@ __cmpxchg1\n"
+		"	ldrexb	%1, [%2]\n"
+		"	mov	%0, #0\n"
+		"	teq	%1, %3\n"
+		"	strexbeq %0, %4, [%2]\n"
+			: "=&r" (res), "=&r" (oldval)
+			: "r" (ptr), "Ir" (old), "r" (new)
+			: "memory", "cc");
+	} while (res);
+
+	return oldval;
+}
+
+static inline unsigned long __cmpxchg16(volatile void *ptr, unsigned long old,
+				      unsigned long new)
+{
+	unsigned long oldval, res;
+
+	do {
+		asm volatile("@ __cmpxchg1\n"
+		"	ldrexh	%1, [%2]\n"
+		"	mov	%0, #0\n"
+		"	teq	%1, %3\n"
+		"	strexheq %0, %4, [%2]\n"
+			: "=&r" (res), "=&r" (oldval)
+			: "r" (ptr), "Ir" (old), "r" (new)
+			: "memory", "cc");
+	} while (res);
+
+	return oldval;
+}
+
 static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 				      unsigned long new, int size)
 {
@@ -141,28 +179,10 @@ static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 	switch (size) {
 #ifndef CONFIG_CPU_V6	/* min ARCH >= ARMv6K */
 	case 1:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexb	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexbeq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
+		oldval = __cmpxchg8(ptr, old, new);
 		break;
 	case 2:
-		do {
-			asm volatile("@ __cmpxchg1\n"
-			"	ldrexh	%1, [%2]\n"
-			"	mov	%0, #0\n"
-			"	teq	%1, %3\n"
-			"	strexheq %0, %4, [%2]\n"
-				: "=&r" (res), "=&r" (oldval)
-				: "r" (ptr), "Ir" (old), "r" (new)
-				: "memory", "cc");
-		} while (res);
+		oldval = __cmpxchg16(ptr, old, new);
 		break;
 #endif
 	case 4:
diff --git a/arch/arm/include/asm/sync_bitops.h b/arch/arm/include/asm/sync_bitops.h
index 63479ee..942659a 100644
--- a/arch/arm/include/asm/sync_bitops.h
+++ b/arch/arm/include/asm/sync_bitops.h
@@ -21,7 +21,29 @@
 #define sync_test_and_clear_bit(nr, p)	_test_and_clear_bit(nr, p)
 #define sync_test_and_change_bit(nr, p)	_test_and_change_bit(nr, p)
 #define sync_test_bit(nr, addr)		test_bit(nr, addr)
-#define sync_cmpxchg			cmpxchg
 
+static inline unsigned long sync_cmpxchg(volatile void *ptr,
+										 unsigned long old,
+										 unsigned long new)
+{
+	unsigned long oldval;
+	int size = sizeof(*(ptr));
+
+	smp_mb();
+	switch (size) {
+	case 1:
+		oldval = __cmpxchg8(ptr, old, new);
+		break;
+	case 2:
+		oldval = __cmpxchg16(ptr, old, new);
+		break;
+	default:
+		oldval = __cmpxchg(ptr, old, new, size);
+		break;
+	}
+	smp_mb();
+
+	return oldval;
+}
 
 #endif
diff --git a/arch/arm/include/asm/xen/events.h b/arch/arm/include/asm/xen/events.h
index 8b1f37b..2032ee6 100644
--- a/arch/arm/include/asm/xen/events.h
+++ b/arch/arm/include/asm/xen/events.h
@@ -16,7 +16,37 @@ static inline int xen_irqs_disabled(struct pt_regs *regs)
 	return raw_irqs_disabled_flags(regs->ARM_cpsr);
 }
 
-#define xchg_xen_ulong(ptr, val) atomic64_xchg(container_of((ptr),	\
+#ifdef CONFIG_GENERIC_ATOMIC64
+/* if CONFIG_GENERIC_ATOMIC64 is defined we cannot use the generic
+ * atomic64_xchg function because it is implemented using spin locks.
+ * Here we need proper atomic instructions to read and write memory
+ * shared with the hypervisor.
+ */
+static inline u64 xen_atomic64_xchg(atomic64_t *ptr, u64 new)
+{
+	u64 result;
+	unsigned long tmp;
+
+	smp_mb();
+
+	__asm__ __volatile__("@ xen_atomic64_xchg\n"
+"1:	ldrexd	%0, %H0, [%3]\n"
+"	strexd	%1, %4, %H4, [%3]\n"
+"	teq	%1, #0\n"
+"	bne	1b"
+	: "=&r" (result), "=&r" (tmp), "+Qo" (ptr->counter)
+	: "r" (&ptr->counter), "r" (new)
+	: "cc");
+
+	smp_mb();
+
+	return result;
+}
+#else
+#define xen_atomic64_xchg atomic64_xchg
+#endif
+
+#define xchg_xen_ulong(ptr, val) xen_atomic64_xchg(container_of((ptr),	\
 							    atomic64_t,	\
 							    counter), (val))
 
