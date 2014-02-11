Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaBKIIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:08:02 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:33706 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaBKIH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:07:59 -0500
Date: Tue, 11 Feb 2014 09:07:50 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 bug fixes for the 3.14-rc3
Message-ID: <20140211090750.416a440e@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021108-3548-0000-0000-00000807BF27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
A collection a bug fixes. Most of them are minor but two of them are
more severe. The linkage stack bug can be used by user space to force
an oops, with panic_on_oops this is a denial-of-service. And the dump
memory detection issue can cause incomplete memory dumps.

Gerald Schaefer (1):
      s390/appldata: restore missing init_virt_timer()

Jose Alonso (1):
      s390/qdio: for_each macro correctness

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Sebastian Ott (1):
      s390/cio: improve cio_commit_config

Ursula Braun (1):
      s390/qdio: correct program-controlled interruption checking

 arch/s390/appldata/appldata_base.c |    1 +
 arch/s390/kernel/head64.S          |    7 +++++--
 arch/s390/mm/page-states.c         |   10 +++++++++
 drivers/s390/cio/cio.c             |   40 +++++++++++++-----------------------
 drivers/s390/cio/qdio.h            |   14 ++++++-------
 drivers/s390/cio/qdio_main.c       |    2 +-
 6 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 4c4a1ce..47c8630 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -529,6 +529,7 @@ static int __init appldata_init(void)
 {
 	int rc;
 
+	init_virt_timer(&appldata_timer);
 	appldata_timer.function = appldata_timer_function;
 	appldata_timer.data = (unsigned long) &appldata_work;
 
diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index b9e25ae..d7c0050 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -59,7 +59,7 @@ ENTRY(startup_continue)
 	.quad	0			# cr12: tracing off
 	.quad	0			# cr13: home space segment table
 	.quad	0xc0000000		# cr14: machine check handling off
-	.quad	0			# cr15: linkage stack operations
+	.quad	.Llinkage_stack		# cr15: linkage stack operations
 .Lpcmsk:.quad	0x0000000180000000
 .L4malign:.quad 0xffffffffffc00000
 .Lscan2g:.quad	0x80000000 + 0x20000 - 8	# 2GB + 128K - 8
@@ -67,12 +67,15 @@ ENTRY(startup_continue)
 .Lparmaddr:
 	.quad	PARMAREA
 	.align	64
-.Lduct: .long	0,0,0,0,.Lduald,0,0,0
+.Lduct: .long	0,.Laste,.Laste,0,.Lduald,0,0,0
 	.long	0,0,0,0,0,0,0,0
+.Laste:	.quad	0,0xffffffffffffffff,0,0,0,0,0,0
 	.align	128
 .Lduald:.rept	8
 	.long	0x80000000,0,0,0	# invalid access-list entries
 	.endr
+.Llinkage_stack:
+	.long	0,0,0x89000000,0,0,0,0x8a000000,0
 
 ENTRY(_ehead)
 
diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
index a90d45e..27c50f4 100644
--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -12,6 +12,8 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
+#include <asm/setup.h>
+#include <asm/ipl.h>
 
 #define ESSA_SET_STABLE		1
 #define ESSA_SET_UNUSED		2
@@ -41,6 +43,14 @@ void __init cmma_init(void)
 
 	if (!cmma_flag)
 		return;
+	/*
+	 * Disable CMM for dump, otherwise  the tprot based memory
+	 * detection can fail because of unstable pages.
+	 */
+	if (OLDMEM_BASE || ipl_info.type == IPL_TYPE_FCP_DUMP) {
+		cmma_flag = 0;
+		return;
+	}
 	asm volatile(
 		"       .insn rrf,0xb9ab0000,%1,%1,0,0\n"
 		"0:     la      %0,0\n"
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index 88e35d8..8ee88c4 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -342,8 +342,9 @@ static int cio_check_config(struct subchannel *sch, struct schib *schib)
  */
 int cio_commit_config(struct subchannel *sch)
 {
-	struct schib schib;
 	int ccode, retry, ret = 0;
+	struct schib schib;
+	struct irb irb;
 
 	if (stsch_err(sch->schid, &schib) || !css_sch_is_valid(&schib))
 		return -ENODEV;
@@ -367,7 +368,10 @@ int cio_commit_config(struct subchannel *sch)
 			ret = -EAGAIN;
 			break;
 		case 1: /* status pending */
-			return -EBUSY;
+			ret = -EBUSY;
+			if (tsch(sch->schid, &irb))
+				return ret;
+			break;
 		case 2: /* busy */
 			udelay(100); /* allow for recovery */
 			ret = -EBUSY;
@@ -403,7 +407,6 @@ EXPORT_SYMBOL_GPL(cio_update_schib);
  */
 int cio_enable_subchannel(struct subchannel *sch, u32 intparm)
 {
-	int retry;
 	int ret;
 
 	CIO_TRACE_EVENT(2, "ensch");
@@ -418,20 +421,14 @@ int cio_enable_subchannel(struct subchannel *sch, u32 intparm)
 	sch->config.isc = sch->isc;
 	sch->config.intparm = intparm;
 
-	for (retry = 0; retry < 3; retry++) {
+	ret = cio_commit_config(sch);
+	if (ret == -EIO) {
+		/*
+		 * Got a program check in msch. Try without
+		 * the concurrent sense bit the next time.
+		 */
+		sch->config.csense = 0;
 		ret = cio_commit_config(sch);
-		if (ret == -EIO) {
-			/*
-			 * Got a program check in msch. Try without
-			 * the concurrent sense bit the next time.
-			 */
-			sch->config.csense = 0;
-		} else if (ret == -EBUSY) {
-			struct irb irb;
-			if (tsch(sch->schid, &irb) != 0)
-				break;
-		} else
-			break;
 	}
 	CIO_HEX_EVENT(2, &ret, sizeof(ret));
 	return ret;
@@ -444,7 +441,6 @@ EXPORT_SYMBOL_GPL(cio_enable_subchannel);
  */
 int cio_disable_subchannel(struct subchannel *sch)
 {
-	int retry;
 	int ret;
 
 	CIO_TRACE_EVENT(2, "dissch");
@@ -456,16 +452,8 @@ int cio_disable_subchannel(struct subchannel *sch)
 		return -ENODEV;
 
 	sch->config.ena = 0;
+	ret = cio_commit_config(sch);
 
-	for (retry = 0; retry < 3; retry++) {
-		ret = cio_commit_config(sch);
-		if (ret == -EBUSY) {
-			struct irb irb;
-			if (tsch(sch->schid, &irb) != 0)
-				break;
-		} else
-			break;
-	}
 	CIO_HEX_EVENT(2, &ret, sizeof(ret));
 	return ret;
 }
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 8acaae1..a563e4c 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -359,14 +359,12 @@ static inline int multicast_outbound(struct qdio_q *q)
 #define need_siga_sync_out_after_pci(q)	\
 	(unlikely(q->irq_ptr->siga_flag.sync_out_after_pci))
 
-#define for_each_input_queue(irq_ptr, q, i)	\
-	for (i = 0, q = irq_ptr->input_qs[0];	\
-		i < irq_ptr->nr_input_qs;	\
-		q = irq_ptr->input_qs[++i])
-#define for_each_output_queue(irq_ptr, q, i)	\
-	for (i = 0, q = irq_ptr->output_qs[0];	\
-		i < irq_ptr->nr_output_qs;	\
-		q = irq_ptr->output_qs[++i])
+#define for_each_input_queue(irq_ptr, q, i)		\
+	for (i = 0; i < irq_ptr->nr_input_qs &&		\
+		({ q = irq_ptr->input_qs[i]; 1; }); i++)
+#define for_each_output_queue(irq_ptr, q, i)		\
+	for (i = 0; i < irq_ptr->nr_output_qs &&	\
+		({ q = irq_ptr->output_qs[i]; 1; }); i++)
 
 #define prev_buf(bufnr)	\
 	((bufnr + QDIO_MAX_BUFFERS_MASK) & QDIO_MAX_BUFFERS_MASK)
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index c883a08..77466c4 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -996,7 +996,7 @@ static void qdio_int_handler_pci(struct qdio_irq *irq_ptr)
 		}
 	}
 
-	if (!pci_out_supported(q))
+	if (!(irq_ptr->qib.ac & QIB_AC_OUTBOUND_PCI_SUPPORTED))
 		return;
 
 	for_each_output_queue(irq_ptr, q, i) {

