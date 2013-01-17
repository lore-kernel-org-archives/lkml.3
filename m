Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3AQPgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:36:36 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:55475 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab3AQPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:36:34 -0500
Date: Thu, 17 Jan 2013 16:36:27 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] more s390 patches for 3.8-rc4
Message-ID: <20130117163627.1b2f3d22@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 13011715-4966-0000-0000-000004A60A5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
A couple of bug fixes: one of the transparent huge page primitives
is broken, the sched_clock function overflows after 417 days,
the XFS module has grown too large for -fpic and the new pci code
has broken normal channel subsystem notifications.

Gerald Schaefer (1):
      s390/mm: fix pmd_pfn() for thp

Heiko Carstens (1):
      s390/time: fix sched_clock() overflow

Martin Schwidefsky (1):
      s390: use -fPIC for module compile

Sebastian Ott (1):
      s390/chsc: fix SEI usage

 arch/s390/Makefile              |    4 ++--
 arch/s390/include/asm/pgtable.h |    5 +----
 arch/s390/include/asm/timex.h   |   28 ++++++++++++++++++++++++++++
 arch/s390/kernel/time.c         |    2 +-
 arch/s390/kvm/interrupt.c       |    2 +-
 drivers/s390/cio/chsc.c         |   31 ++++++++++++-------------------
 6 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 4b8e08b..7e3ce78 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -24,8 +24,8 @@ CHECKFLAGS	+= -D__s390__ -msize-long
 else
 LD_BFD		:= elf64-s390
 LDFLAGS		:= -m elf64_s390
-KBUILD_AFLAGS_MODULE += -fpic -D__PIC__
-KBUILD_CFLAGS_MODULE += -fpic -D__PIC__
+KBUILD_AFLAGS_MODULE += -fPIC
+KBUILD_CFLAGS_MODULE += -fPIC
 KBUILD_CFLAGS	+= -m64
 KBUILD_AFLAGS	+= -m64
 UTS_MACHINE	:= s390x
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index c928dc1..c1d7930 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1387,10 +1387,7 @@ static inline int has_transparent_hugepage(void)
 
 static inline unsigned long pmd_pfn(pmd_t pmd)
 {
-	if (pmd_trans_huge(pmd))
-		return pmd_val(pmd) >> HPAGE_SHIFT;
-	else
-		return pmd_val(pmd) >> PAGE_SHIFT;
+	return pmd_val(pmd) >> PAGE_SHIFT;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index fba4d66..4c060bb 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -128,4 +128,32 @@ static inline unsigned long long get_clock_monotonic(void)
 	return get_clock_xt() - sched_clock_base_cc;
 }
 
+/**
+ * tod_to_ns - convert a TOD format value to nanoseconds
+ * @todval: to be converted TOD format value
+ * Returns: number of nanoseconds that correspond to the TOD format value
+ *
+ * Converting a 64 Bit TOD format value to nanoseconds means that the value
+ * must be divided by 4.096. In order to achieve that we multiply with 125
+ * and divide by 512:
+ *
+ *    ns = (todval * 125) >> 9;
+ *
+ * In order to avoid an overflow with the multiplication we can rewrite this.
+ * With a split todval == 2^32 * th + tl (th upper 32 bits, tl lower 32 bits)
+ * we end up with
+ *
+ *    ns = ((2^32 * th + tl) * 125 ) >> 9;
+ * -> ns = (2^23 * th * 125) + ((tl * 125) >> 9);
+ *
+ */
+static inline unsigned long long tod_to_ns(unsigned long long todval)
+{
+	unsigned long long ns;
+
+	ns = ((todval >> 32) << 23) * 125;
+	ns += ((todval & 0xffffffff) * 125) >> 9;
+	return ns;
+}
+
 #endif
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index aff0e35..a5f4f5a 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -63,7 +63,7 @@ static DEFINE_PER_CPU(struct clock_event_device, comparators);
  */
 unsigned long long notrace __kprobes sched_clock(void)
 {
-	return (get_clock_monotonic() * 125) >> 9;
+	return tod_to_ns(get_clock_monotonic());
 }
 
 /*
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index c30615e..82c481d 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -408,7 +408,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	sltime = ((vcpu->arch.sie_block->ckc - now)*125)>>9;
+	sltime = tod_to_ns(vcpu->arch.sie_block->ckc - now);
 
 	hrtimer_start(&vcpu->arch.ckc_timer, ktime_set (0, sltime) , HRTIMER_MODE_REL);
 	VCPU_EVENT(vcpu, 5, "enabled wait via clock comparator: %llx ns", sltime);
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 68e80e2..10729bb 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -283,7 +283,7 @@ struct chsc_sei_nt2_area {
 	u8  ccdf[PAGE_SIZE - 24 - 56];	/* content-code dependent field */
 } __packed;
 
-#define CHSC_SEI_NT0	0ULL
+#define CHSC_SEI_NT0	(1ULL << 63)
 #define CHSC_SEI_NT2	(1ULL << 61)
 
 struct chsc_sei {
@@ -291,7 +291,8 @@ struct chsc_sei {
 	u32 reserved1;
 	u64 ntsm;			/* notification type mask */
 	struct chsc_header response;
-	u32 reserved2;
+	u32 :24;
+	u8 nt;
 	union {
 		struct chsc_sei_nt0_area nt0_area;
 		struct chsc_sei_nt2_area nt2_area;
@@ -496,17 +497,17 @@ static int __chsc_process_crw(struct chsc_sei *sei, u64 ntsm)
 				css_schedule_eval_all();
 			}
 
-			switch (sei->ntsm) {
-			case CHSC_SEI_NT0:
+			switch (sei->nt) {
+			case 0:
 				chsc_process_sei_nt0(&sei->u.nt0_area);
-				return 1;
-			case CHSC_SEI_NT2:
+				break;
+			case 2:
 				chsc_process_sei_nt2(&sei->u.nt2_area);
-				return 1;
+				break;
 			default:
-				CIO_CRW_EVENT(2, "chsc: unhandled nt (nt=%08Lx)\n",
-					      sei->ntsm);
-				return 0;
+				CIO_CRW_EVENT(2, "chsc: unhandled nt=%d\n",
+					      sei->nt);
+				break;
 			}
 		} else {
 			CIO_CRW_EVENT(2, "chsc: sei failed (rc=%04x)\n",
@@ -537,15 +538,7 @@ static void chsc_process_crw(struct crw *crw0, struct crw *crw1, int overflow)
 	sei = sei_page;
 
 	CIO_TRACE_EVENT(2, "prcss");
-
-	/*
-	 * The ntsm does not allow to select NT0 and NT2 together. We need to
-	 * first check for NT2, than additionally for NT0...
-	 */
-#ifdef CONFIG_PCI
-	if (!__chsc_process_crw(sei, CHSC_SEI_NT2))
-#endif
-		__chsc_process_crw(sei, CHSC_SEI_NT0);
+	__chsc_process_crw(sei, CHSC_SEI_NT0 | CHSC_SEI_NT2);
 }
 
 void chsc_chp_online(struct chp_id chpid)

