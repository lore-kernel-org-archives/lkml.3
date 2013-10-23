Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab3JWHJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:09:48 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:48323 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3JWHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:09:46 -0400
Date: Wed, 23 Oct 2013 09:08:26 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.12-rc7
Message-ID: <20131023090826.5920ccf2@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102307-0342-0000-0000-000006A2A96B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Several last minute bug fixes. Two of them are on the larger side
for rc7, the dasd format patch for older storage devices and the
store-clock-fast patch where we have been to optimistic with an
optimization.

Heiko Carstens (2):
      s390/compat,signal: fix return value of copy_siginfo_(to|from)_user32()
      s390/vmlogrdr: fix array access in vmlogrdr_open()

Martin Schwidefsky (2):
      s390/mm,kvm: fix software dirty bits vs. kvm for old machines
      s390/time: correct use of store clock fast

Stefan Haberland (1):
      s390/dasd: check for availability of prefix command during format

 arch/s390/include/asm/pgtable.h  |    4 +-
 arch/s390/include/asm/timex.h    |   28 +++++------
 arch/s390/kernel/compat_signal.c |    4 +-
 arch/s390/kernel/debug.c         |    2 +-
 arch/s390/kvm/interrupt.c        |    6 +--
 arch/s390/lib/delay.c            |   14 +++---
 drivers/s390/block/dasd_eckd.c   |   98 +++++++++++++++++++++++++++-----------
 drivers/s390/char/sclp.c         |    4 +-
 drivers/s390/char/vmlogrdr.c     |    2 +-
 drivers/s390/cio/cio.c           |    4 +-
 drivers/s390/cio/qdio_main.c     |   10 ++--
 11 files changed, 111 insertions(+), 65 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 9b60a36..2204400 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -748,7 +748,9 @@ static inline void pgste_set_key(pte_t *ptep, pgste_t pgste, pte_t entry)
 
 static inline void pgste_set_pte(pte_t *ptep, pte_t entry)
 {
-	if (!MACHINE_HAS_ESOP && (pte_val(entry) & _PAGE_WRITE)) {
+	if (!MACHINE_HAS_ESOP &&
+	    (pte_val(entry) & _PAGE_PRESENT) &&
+	    (pte_val(entry) & _PAGE_WRITE)) {
 		/*
 		 * Without enhanced suppression-on-protection force
 		 * the dirty bit on for all writable ptes.
diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 8ad8af9..819b94d 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -71,30 +71,30 @@ static inline void local_tick_enable(unsigned long long comp)
 
 typedef unsigned long long cycles_t;
 
-static inline unsigned long long get_tod_clock(void)
-{
-	unsigned long long clk;
-
-#ifdef CONFIG_HAVE_MARCH_Z9_109_FEATURES
-	asm volatile(".insn s,0xb27c0000,%0" : "=Q" (clk) : : "cc");
-#else
-	asm volatile("stck %0" : "=Q" (clk) : : "cc");
-#endif
-	return clk;
-}
-
 static inline void get_tod_clock_ext(char *clk)
 {
 	asm volatile("stcke %0" : "=Q" (*clk) : : "cc");
 }
 
-static inline unsigned long long get_tod_clock_xt(void)
+static inline unsigned long long get_tod_clock(void)
 {
 	unsigned char clk[16];
 	get_tod_clock_ext(clk);
 	return *((unsigned long long *)&clk[1]);
 }
 
+static inline unsigned long long get_tod_clock_fast(void)
+{
+#ifdef CONFIG_HAVE_MARCH_Z9_109_FEATURES
+	unsigned long long clk;
+
+	asm volatile("stckf %0" : "=Q" (clk) : : "cc");
+	return clk;
+#else
+	return get_tod_clock();
+#endif
+}
+
 static inline cycles_t get_cycles(void)
 {
 	return (cycles_t) get_tod_clock() >> 2;
@@ -125,7 +125,7 @@ extern u64 sched_clock_base_cc;
  */
 static inline unsigned long long get_tod_clock_monotonic(void)
 {
-	return get_tod_clock_xt() - sched_clock_base_cc;
+	return get_tod_clock() - sched_clock_base_cc;
 }
 
 /**
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 1389b63..adaa9e9 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -99,7 +99,7 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 			break;
 		}
 	}
-	return err;
+	return err ? -EFAULT : 0;
 }
 
 int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
@@ -148,7 +148,7 @@ int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 			break;
 		}
 	}
-	return err;
+	return err ? -EFAULT : 0;
 }
 
 static int save_sigregs32(struct pt_regs *regs, _sigregs32 __user *sregs)
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index f1279dc..17d62fe 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -867,7 +867,7 @@ static inline void
 debug_finish_entry(debug_info_t * id, debug_entry_t* active, int level,
 			int exception)
 {
-	active->id.stck = get_tod_clock();
+	active->id.stck = get_tod_clock_fast();
 	active->id.fields.cpuid = smp_processor_id();
 	active->caller = __builtin_return_address(0);
 	active->id.fields.exception = exception;
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 7f35cb3..7f1f7ac 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -385,7 +385,7 @@ static int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu)
 	}
 
 	if ((!rc) && (vcpu->arch.sie_block->ckc <
-		get_tod_clock() + vcpu->arch.sie_block->epoch)) {
+		get_tod_clock_fast() + vcpu->arch.sie_block->epoch)) {
 		if ((!psw_extint_disabled(vcpu)) &&
 			(vcpu->arch.sie_block->gcr[0] & 0x800ul))
 			rc = 1;
@@ -425,7 +425,7 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 		goto no_timer;
 	}
 
-	now = get_tod_clock() + vcpu->arch.sie_block->epoch;
+	now = get_tod_clock_fast() + vcpu->arch.sie_block->epoch;
 	if (vcpu->arch.sie_block->ckc < now) {
 		__unset_cpu_idle(vcpu);
 		return 0;
@@ -515,7 +515,7 @@ void kvm_s390_deliver_pending_interrupts(struct kvm_vcpu *vcpu)
 	}
 
 	if ((vcpu->arch.sie_block->ckc <
-		get_tod_clock() + vcpu->arch.sie_block->epoch))
+		get_tod_clock_fast() + vcpu->arch.sie_block->epoch))
 		__try_deliver_ckc_interrupt(vcpu);
 
 	if (atomic_read(&fi->active)) {
diff --git a/arch/s390/lib/delay.c b/arch/s390/lib/delay.c
index 57c87d7..a9f3d00 100644
--- a/arch/s390/lib/delay.c
+++ b/arch/s390/lib/delay.c
@@ -44,7 +44,7 @@ static void __udelay_disabled(unsigned long long usecs)
 	do {
 		set_clock_comparator(end);
 		vtime_stop_cpu();
-	} while (get_tod_clock() < end);
+	} while (get_tod_clock_fast() < end);
 	lockdep_on();
 	__ctl_load(cr0, 0, 0);
 	__ctl_load(cr6, 6, 6);
@@ -55,7 +55,7 @@ static void __udelay_enabled(unsigned long long usecs)
 {
 	u64 clock_saved, end;
 
-	end = get_tod_clock() + (usecs << 12);
+	end = get_tod_clock_fast() + (usecs << 12);
 	do {
 		clock_saved = 0;
 		if (end < S390_lowcore.clock_comparator) {
@@ -65,7 +65,7 @@ static void __udelay_enabled(unsigned long long usecs)
 		vtime_stop_cpu();
 		if (clock_saved)
 			local_tick_enable(clock_saved);
-	} while (get_tod_clock() < end);
+	} while (get_tod_clock_fast() < end);
 }
 
 /*
@@ -109,8 +109,8 @@ void udelay_simple(unsigned long long usecs)
 {
 	u64 end;
 
-	end = get_tod_clock() + (usecs << 12);
-	while (get_tod_clock() < end)
+	end = get_tod_clock_fast() + (usecs << 12);
+	while (get_tod_clock_fast() < end)
 		cpu_relax();
 }
 
@@ -120,10 +120,10 @@ void __ndelay(unsigned long long nsecs)
 
 	nsecs <<= 9;
 	do_div(nsecs, 125);
-	end = get_tod_clock() + nsecs;
+	end = get_tod_clock_fast() + nsecs;
 	if (nsecs & ~0xfffUL)
 		__udelay(nsecs >> 12);
-	while (get_tod_clock() < end)
+	while (get_tod_clock_fast() < end)
 		barrier();
 }
 EXPORT_SYMBOL(__ndelay);
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 5adb204..cee7e27 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2077,6 +2077,7 @@ dasd_eckd_build_format(struct dasd_device *base,
 	int intensity = 0;
 	int r0_perm;
 	int nr_tracks;
+	int use_prefix;
 
 	startdev = dasd_alias_get_start_dev(base);
 	if (!startdev)
@@ -2106,28 +2107,46 @@ dasd_eckd_build_format(struct dasd_device *base,
 		intensity = fdata->intensity;
 	}
 
+	use_prefix = base_priv->features.feature[8] & 0x01;
+
 	switch (intensity) {
 	case 0x00:	/* Normal format */
 	case 0x08:	/* Normal format, use cdl. */
 		cplength = 2 + (rpt*nr_tracks);
-		datasize = sizeof(struct PFX_eckd_data) +
-			sizeof(struct LO_eckd_data) +
-			rpt * nr_tracks * sizeof(struct eckd_count);
+		if (use_prefix)
+			datasize = sizeof(struct PFX_eckd_data) +
+				sizeof(struct LO_eckd_data) +
+				rpt * nr_tracks * sizeof(struct eckd_count);
+		else
+			datasize = sizeof(struct DE_eckd_data) +
+				sizeof(struct LO_eckd_data) +
+				rpt * nr_tracks * sizeof(struct eckd_count);
 		break;
 	case 0x01:	/* Write record zero and format track. */
 	case 0x09:	/* Write record zero and format track, use cdl. */
 		cplength = 2 + rpt * nr_tracks;
-		datasize = sizeof(struct PFX_eckd_data) +
-			sizeof(struct LO_eckd_data) +
-			sizeof(struct eckd_count) +
-			rpt * nr_tracks * sizeof(struct eckd_count);
+		if (use_prefix)
+			datasize = sizeof(struct PFX_eckd_data) +
+				sizeof(struct LO_eckd_data) +
+				sizeof(struct eckd_count) +
+				rpt * nr_tracks * sizeof(struct eckd_count);
+		else
+			datasize = sizeof(struct DE_eckd_data) +
+				sizeof(struct LO_eckd_data) +
+				sizeof(struct eckd_count) +
+				rpt * nr_tracks * sizeof(struct eckd_count);
 		break;
 	case 0x04:	/* Invalidate track. */
 	case 0x0c:	/* Invalidate track, use cdl. */
 		cplength = 3;
-		datasize = sizeof(struct PFX_eckd_data) +
-			sizeof(struct LO_eckd_data) +
-			sizeof(struct eckd_count);
+		if (use_prefix)
+			datasize = sizeof(struct PFX_eckd_data) +
+				sizeof(struct LO_eckd_data) +
+				sizeof(struct eckd_count);
+		else
+			datasize = sizeof(struct DE_eckd_data) +
+				sizeof(struct LO_eckd_data) +
+				sizeof(struct eckd_count);
 		break;
 	default:
 		dev_warn(&startdev->cdev->dev,
@@ -2147,14 +2166,25 @@ dasd_eckd_build_format(struct dasd_device *base,
 
 	switch (intensity & ~0x08) {
 	case 0x00: /* Normal format. */
-		prefix(ccw++, (struct PFX_eckd_data *) data,
-		       fdata->start_unit, fdata->stop_unit,
-		       DASD_ECKD_CCW_WRITE_CKD, base, startdev);
-		/* grant subsystem permission to format R0 */
-		if (r0_perm)
-			((struct PFX_eckd_data *)data)
-				->define_extent.ga_extended |= 0x04;
-		data += sizeof(struct PFX_eckd_data);
+		if (use_prefix) {
+			prefix(ccw++, (struct PFX_eckd_data *) data,
+			       fdata->start_unit, fdata->stop_unit,
+			       DASD_ECKD_CCW_WRITE_CKD, base, startdev);
+			/* grant subsystem permission to format R0 */
+			if (r0_perm)
+				((struct PFX_eckd_data *)data)
+					->define_extent.ga_extended |= 0x04;
+			data += sizeof(struct PFX_eckd_data);
+		} else {
+			define_extent(ccw++, (struct DE_eckd_data *) data,
+				      fdata->start_unit, fdata->stop_unit,
+				      DASD_ECKD_CCW_WRITE_CKD, startdev);
+			/* grant subsystem permission to format R0 */
+			if (r0_perm)
+				((struct DE_eckd_data *) data)
+					->ga_extended |= 0x04;
+			data += sizeof(struct DE_eckd_data);
+		}
 		ccw[-1].flags |= CCW_FLAG_CC;
 		locate_record(ccw++, (struct LO_eckd_data *) data,
 			      fdata->start_unit, 0, rpt*nr_tracks,
@@ -2163,11 +2193,18 @@ dasd_eckd_build_format(struct dasd_device *base,
 		data += sizeof(struct LO_eckd_data);
 		break;
 	case 0x01: /* Write record zero + format track. */
-		prefix(ccw++, (struct PFX_eckd_data *) data,
-		       fdata->start_unit, fdata->stop_unit,
-		       DASD_ECKD_CCW_WRITE_RECORD_ZERO,
-		       base, startdev);
-		data += sizeof(struct PFX_eckd_data);
+		if (use_prefix) {
+			prefix(ccw++, (struct PFX_eckd_data *) data,
+			       fdata->start_unit, fdata->stop_unit,
+			       DASD_ECKD_CCW_WRITE_RECORD_ZERO,
+			       base, startdev);
+			data += sizeof(struct PFX_eckd_data);
+		} else {
+			define_extent(ccw++, (struct DE_eckd_data *) data,
+			       fdata->start_unit, fdata->stop_unit,
+			       DASD_ECKD_CCW_WRITE_RECORD_ZERO, startdev);
+			data += sizeof(struct DE_eckd_data);
+		}
 		ccw[-1].flags |= CCW_FLAG_CC;
 		locate_record(ccw++, (struct LO_eckd_data *) data,
 			      fdata->start_unit, 0, rpt * nr_tracks + 1,
@@ -2176,10 +2213,17 @@ dasd_eckd_build_format(struct dasd_device *base,
 		data += sizeof(struct LO_eckd_data);
 		break;
 	case 0x04: /* Invalidate track. */
-		prefix(ccw++, (struct PFX_eckd_data *) data,
-		       fdata->start_unit, fdata->stop_unit,
-		       DASD_ECKD_CCW_WRITE_CKD, base, startdev);
-		data += sizeof(struct PFX_eckd_data);
+		if (use_prefix) {
+			prefix(ccw++, (struct PFX_eckd_data *) data,
+			       fdata->start_unit, fdata->stop_unit,
+			       DASD_ECKD_CCW_WRITE_CKD, base, startdev);
+			data += sizeof(struct PFX_eckd_data);
+		} else {
+			define_extent(ccw++, (struct DE_eckd_data *) data,
+			       fdata->start_unit, fdata->stop_unit,
+			       DASD_ECKD_CCW_WRITE_CKD, startdev);
+			data += sizeof(struct DE_eckd_data);
+		}
 		ccw[-1].flags |= CCW_FLAG_CC;
 		locate_record(ccw++, (struct LO_eckd_data *) data,
 			      fdata->start_unit, 0, 1,
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index a3aa374..1fe2643 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -486,7 +486,7 @@ sclp_sync_wait(void)
 	timeout = 0;
 	if (timer_pending(&sclp_request_timer)) {
 		/* Get timeout TOD value */
-		timeout = get_tod_clock() +
+		timeout = get_tod_clock_fast() +
 			  sclp_tod_from_jiffies(sclp_request_timer.expires -
 						jiffies);
 	}
@@ -508,7 +508,7 @@ sclp_sync_wait(void)
 	while (sclp_running_state != sclp_running_state_idle) {
 		/* Check for expired request timer */
 		if (timer_pending(&sclp_request_timer) &&
-		    get_tod_clock() > timeout &&
+		    get_tod_clock_fast() > timeout &&
 		    del_timer(&sclp_request_timer))
 			sclp_request_timer.function(sclp_request_timer.data);
 		cpu_relax();
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index 9b3a24e..cf31d33 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -313,7 +313,7 @@ static int vmlogrdr_open (struct inode *inode, struct file *filp)
 	int ret;
 
 	dev_num = iminor(inode);
-	if (dev_num > MAXMINOR)
+	if (dev_num >= MAXMINOR)
 		return -ENODEV;
 	logptr = &sys_ser[dev_num];
 
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index d7da67a..88e35d8 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -878,9 +878,9 @@ static void css_reset(void)
 			atomic_inc(&chpid_reset_count);
 	}
 	/* Wait for machine check for all channel paths. */
-	timeout = get_tod_clock() + (RCHP_TIMEOUT << 12);
+	timeout = get_tod_clock_fast() + (RCHP_TIMEOUT << 12);
 	while (atomic_read(&chpid_reset_count) != 0) {
-		if (get_tod_clock() > timeout)
+		if (get_tod_clock_fast() > timeout)
 			break;
 		cpu_relax();
 	}
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 8ed52aa..bbd3e51 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -338,10 +338,10 @@ again:
 		retries++;
 
 		if (!start_time) {
-			start_time = get_tod_clock();
+			start_time = get_tod_clock_fast();
 			goto again;
 		}
-		if ((get_tod_clock() - start_time) < QDIO_BUSY_BIT_PATIENCE)
+		if (get_tod_clock_fast() - start_time < QDIO_BUSY_BIT_PATIENCE)
 			goto again;
 	}
 	if (retries) {
@@ -504,7 +504,7 @@ static int get_inbound_buffer_frontier(struct qdio_q *q)
 	int count, stop;
 	unsigned char state = 0;
 
-	q->timestamp = get_tod_clock();
+	q->timestamp = get_tod_clock_fast();
 
 	/*
 	 * Don't check 128 buffers, as otherwise qdio_inbound_q_moved
@@ -595,7 +595,7 @@ static inline int qdio_inbound_q_done(struct qdio_q *q)
 	 * At this point we know, that inbound first_to_check
 	 * has (probably) not moved (see qdio_inbound_processing).
 	 */
-	if (get_tod_clock() > q->u.in.timestamp + QDIO_INPUT_THRESHOLD) {
+	if (get_tod_clock_fast() > q->u.in.timestamp + QDIO_INPUT_THRESHOLD) {
 		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "in done:%02x",
 			      q->first_to_check);
 		return 1;
@@ -728,7 +728,7 @@ static int get_outbound_buffer_frontier(struct qdio_q *q)
 	int count, stop;
 	unsigned char state = 0;
 
-	q->timestamp = get_tod_clock();
+	q->timestamp = get_tod_clock_fast();
 
 	if (need_siga_sync(q))
 		if (((queue_type(q) != QDIO_IQDIO_QFMT) &&

