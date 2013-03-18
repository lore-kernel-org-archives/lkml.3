Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3CRIol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:44:41 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33975 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab3CRIoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:44:37 -0400
Date: Mon, 18 Mar 2013 09:44:29 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.9-rc4
Message-ID: <20130318094429.0512621d@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031808-4966-0000-0000-0000052F407F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
A couple of bug fixes, the most hairy on is the flush_tlb_kernel_range
fix. Another case of "how could this ever have worked?".

Heiko Carstens (3):
      s390/mm: fix vmemmap size calculation
      s390/mm: fix flush_tlb_kernel_range()
      drivers/i2c: remove !S390 dependency, add missing GENERIC_HARDIRQS dependencies

Martin Schwidefsky (1):
      s390: critical section cleanup vs. machine checks

Michael Holzheu (1):
      s390/kdump: Do not add standby memory for kdump

Sebastian Ott (4):
      s390/scm_blk: fix request number accounting
      s390/scm_drv: extend notify callback
      s390/scm_blk: suspend writes
      s390/scm: process availability

 arch/s390/include/asm/eadm.h     |    6 +++-
 arch/s390/include/asm/tlbflush.h |    2 --
 arch/s390/kernel/entry.S         |    3 +-
 arch/s390/kernel/entry64.S       |    5 +--
 arch/s390/kernel/setup.c         |    2 ++
 drivers/i2c/Kconfig              |    2 +-
 drivers/i2c/busses/Kconfig       |    6 ++--
 drivers/s390/block/scm_blk.c     |   69 ++++++++++++++++++++++++++++++++++----
 drivers/s390/block/scm_blk.h     |    2 ++
 drivers/s390/block/scm_drv.c     |   23 +++++++++----
 drivers/s390/char/sclp_cmd.c     |    2 ++
 drivers/s390/cio/chsc.c          |   17 ++++++++++
 drivers/s390/cio/chsc.h          |    2 ++
 drivers/s390/cio/scm.c           |   18 +++++++++-
 14 files changed, 136 insertions(+), 23 deletions(-)

diff --git a/arch/s390/include/asm/eadm.h b/arch/s390/include/asm/eadm.h
index 8d48471..dc9200c 100644
--- a/arch/s390/include/asm/eadm.h
+++ b/arch/s390/include/asm/eadm.h
@@ -34,6 +34,8 @@ struct arsb {
 	u32 reserved[4];
 } __packed;
 
+#define EQC_WR_PROHIBIT 22
+
 struct msb {
 	u8 fmt:4;
 	u8 oc:4;
@@ -96,11 +98,13 @@ struct scm_device {
 #define OP_STATE_TEMP_ERR	2
 #define OP_STATE_PERM_ERR	3
 
+enum scm_event {SCM_CHANGE, SCM_AVAIL};
+
 struct scm_driver {
 	struct device_driver drv;
 	int (*probe) (struct scm_device *scmdev);
 	int (*remove) (struct scm_device *scmdev);
-	void (*notify) (struct scm_device *scmdev);
+	void (*notify) (struct scm_device *scmdev, enum scm_event event);
 	void (*handler) (struct scm_device *scmdev, void *data, int error);
 };
 
diff --git a/arch/s390/include/asm/tlbflush.h b/arch/s390/include/asm/tlbflush.h
index 1d8fe2b..6b32af3 100644
--- a/arch/s390/include/asm/tlbflush.h
+++ b/arch/s390/include/asm/tlbflush.h
@@ -74,8 +74,6 @@ static inline void __tlb_flush_idte(unsigned long asce)
 
 static inline void __tlb_flush_mm(struct mm_struct * mm)
 {
-	if (unlikely(cpumask_empty(mm_cpumask(mm))))
-		return;
 	/*
 	 * If the machine has IDTE we prefer to do a per mm flush
 	 * on all cpus instead of doing a local flush if the mm
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 5502285..94feff7 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -636,7 +636,8 @@ ENTRY(mcck_int_handler)
 	UPDATE_VTIME %r14,%r15,__LC_MCCK_ENTER_TIMER
 mcck_skip:
 	SWITCH_ASYNC __LC_GPREGS_SAVE_AREA+32,__LC_PANIC_STACK,PAGE_SHIFT
-	mvc	__PT_R0(64,%r11),__LC_GPREGS_SAVE_AREA
+	stm	%r0,%r7,__PT_R0(%r11)
+	mvc	__PT_R8(32,%r11),__LC_GPREGS_SAVE_AREA+32
 	stm	%r8,%r9,__PT_PSW(%r11)
 	xc	__SF_BACKCHAIN(4,%r15),__SF_BACKCHAIN(%r15)
 	l	%r1,BASED(.Ldo_machine_check)
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 9c837c1..2e6d60c 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -678,8 +678,9 @@ ENTRY(mcck_int_handler)
 	UPDATE_VTIME %r14,__LC_MCCK_ENTER_TIMER
 	LAST_BREAK %r14
 mcck_skip:
-	lghi	%r14,__LC_GPREGS_SAVE_AREA
-	mvc	__PT_R0(128,%r11),0(%r14)
+	lghi	%r14,__LC_GPREGS_SAVE_AREA+64
+	stmg	%r0,%r7,__PT_R0(%r11)
+	mvc	__PT_R8(64,%r11),0(%r14)
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index a5360de..2926885 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -571,6 +571,8 @@ static void __init setup_memory_end(void)
 
 	/* Split remaining virtual space between 1:1 mapping & vmemmap array */
 	tmp = VMALLOC_START / (PAGE_SIZE + sizeof(struct page));
+	/* vmemmap contains a multiple of PAGES_PER_SECTION struct pages */
+	tmp = SECTION_ALIGN_UP(tmp);
 	tmp = VMALLOC_START - tmp * sizeof(struct page);
 	tmp &= ~((vmax >> 11) - 1);	/* align to page table level */
 	tmp = min(tmp, 1UL << MAX_PHYSMEM_BITS);
diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 46cde09..e380c6e 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig I2C
 	tristate "I2C support"
-	depends on !S390
 	select RT_MUTEXES
 	---help---
 	  I2C (pronounce: I-squared-C) is a slow serial bus protocol used in
@@ -76,6 +75,7 @@ config I2C_HELPER_AUTO
 
 config I2C_SMBUS
 	tristate "SMBus-specific protocols" if !I2C_HELPER_AUTO
+	depends on GENERIC_HARDIRQS
 	help
 	  Say Y here if you want support for SMBus extensions to the I2C
 	  specification. At the moment, the only supported extension is
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index a3725de..adfee98 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -114,7 +114,7 @@ config I2C_I801
 
 config I2C_ISCH
 	tristate "Intel SCH SMBus 1.0"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select LPC_SCH
 	help
 	  Say Y here if you want to use SMBus controller on the Intel SCH
@@ -543,6 +543,7 @@ config I2C_NUC900
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
+	depends on GENERIC_HARDIRQS
 	help
 	  If you say yes to this option, support will be included for the
 	  OpenCores I2C controller. For details see
@@ -777,7 +778,7 @@ config I2C_DIOLAN_U2C
 
 config I2C_PARPORT
 	tristate "Parallel port adapter"
-	depends on PARPORT
+	depends on PARPORT && GENERIC_HARDIRQS
 	select I2C_ALGOBIT
 	select I2C_SMBUS
 	help
@@ -802,6 +803,7 @@ config I2C_PARPORT
 
 config I2C_PARPORT_LIGHT
 	tristate "Parallel port adapter (light)"
+	depends on GENERIC_HARDIRQS
 	select I2C_ALGOBIT
 	select I2C_SMBUS
 	help
diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
index 9978ad4..5ac9c93 100644
--- a/drivers/s390/block/scm_blk.c
+++ b/drivers/s390/block/scm_blk.c
@@ -135,6 +135,11 @@ static const struct block_device_operations scm_blk_devops = {
 	.release = scm_release,
 };
 
+static bool scm_permit_request(struct scm_blk_dev *bdev, struct request *req)
+{
+	return rq_data_dir(req) != WRITE || bdev->state != SCM_WR_PROHIBIT;
+}
+
 static void scm_request_prepare(struct scm_request *scmrq)
 {
 	struct scm_blk_dev *bdev = scmrq->bdev;
@@ -195,14 +200,18 @@ void scm_request_requeue(struct scm_request *scmrq)
 
 	scm_release_cluster(scmrq);
 	blk_requeue_request(bdev->rq, scmrq->request);
+	atomic_dec(&bdev->queued_reqs);
 	scm_request_done(scmrq);
 	scm_ensure_queue_restart(bdev);
 }
 
 void scm_request_finish(struct scm_request *scmrq)
 {
+	struct scm_blk_dev *bdev = scmrq->bdev;
+
 	scm_release_cluster(scmrq);
 	blk_end_request_all(scmrq->request, scmrq->error);
+	atomic_dec(&bdev->queued_reqs);
 	scm_request_done(scmrq);
 }
 
@@ -218,6 +227,10 @@ static void scm_blk_request(struct request_queue *rq)
 		if (req->cmd_type != REQ_TYPE_FS)
 			continue;
 
+		if (!scm_permit_request(bdev, req)) {
+			scm_ensure_queue_restart(bdev);
+			return;
+		}
 		scmrq = scm_request_fetch();
 		if (!scmrq) {
 			SCM_LOG(5, "no request");
@@ -231,11 +244,13 @@ static void scm_blk_request(struct request_queue *rq)
 			return;
 		}
 		if (scm_need_cluster_request(scmrq)) {
+			atomic_inc(&bdev->queued_reqs);
 			blk_start_request(req);
 			scm_initiate_cluster_request(scmrq);
 			return;
 		}
 		scm_request_prepare(scmrq);
+		atomic_inc(&bdev->queued_reqs);
 		blk_start_request(req);
 
 		ret = scm_start_aob(scmrq->aob);
@@ -244,7 +259,6 @@ static void scm_blk_request(struct request_queue *rq)
 			scm_request_requeue(scmrq);
 			return;
 		}
-		atomic_inc(&bdev->queued_reqs);
 	}
 }
 
@@ -280,6 +294,38 @@ void scm_blk_irq(struct scm_device *scmdev, void *data, int error)
 	tasklet_hi_schedule(&bdev->tasklet);
 }
 
+static void scm_blk_handle_error(struct scm_request *scmrq)
+{
+	struct scm_blk_dev *bdev = scmrq->bdev;
+	unsigned long flags;
+
+	if (scmrq->error != -EIO)
+		goto restart;
+
+	/* For -EIO the response block is valid. */
+	switch (scmrq->aob->response.eqc) {
+	case EQC_WR_PROHIBIT:
+		spin_lock_irqsave(&bdev->lock, flags);
+		if (bdev->state != SCM_WR_PROHIBIT)
+			pr_info("%lu: Write access to the SCM increment is suspended\n",
+				(unsigned long) bdev->scmdev->address);
+		bdev->state = SCM_WR_PROHIBIT;
+		spin_unlock_irqrestore(&bdev->lock, flags);
+		goto requeue;
+	default:
+		break;
+	}
+
+restart:
+	if (!scm_start_aob(scmrq->aob))
+		return;
+
+requeue:
+	spin_lock_irqsave(&bdev->rq_lock, flags);
+	scm_request_requeue(scmrq);
+	spin_unlock_irqrestore(&bdev->rq_lock, flags);
+}
+
 static void scm_blk_tasklet(struct scm_blk_dev *bdev)
 {
 	struct scm_request *scmrq;
@@ -293,11 +339,8 @@ static void scm_blk_tasklet(struct scm_blk_dev *bdev)
 		spin_unlock_irqrestore(&bdev->lock, flags);
 
 		if (scmrq->error && scmrq->retries-- > 0) {
-			if (scm_start_aob(scmrq->aob)) {
-				spin_lock_irqsave(&bdev->rq_lock, flags);
-				scm_request_requeue(scmrq);
-				spin_unlock_irqrestore(&bdev->rq_lock, flags);
-			}
+			scm_blk_handle_error(scmrq);
+
 			/* Request restarted or requeued, handle next. */
 			spin_lock_irqsave(&bdev->lock, flags);
 			continue;
@@ -310,7 +353,6 @@ static void scm_blk_tasklet(struct scm_blk_dev *bdev)
 		}
 
 		scm_request_finish(scmrq);
-		atomic_dec(&bdev->queued_reqs);
 		spin_lock_irqsave(&bdev->lock, flags);
 	}
 	spin_unlock_irqrestore(&bdev->lock, flags);
@@ -332,6 +374,7 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
 	}
 
 	bdev->scmdev = scmdev;
+	bdev->state = SCM_OPER;
 	spin_lock_init(&bdev->rq_lock);
 	spin_lock_init(&bdev->lock);
 	INIT_LIST_HEAD(&bdev->finished_requests);
@@ -396,6 +439,18 @@ void scm_blk_dev_cleanup(struct scm_blk_dev *bdev)
 	put_disk(bdev->gendisk);
 }
 
+void scm_blk_set_available(struct scm_blk_dev *bdev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&bdev->lock, flags);
+	if (bdev->state == SCM_WR_PROHIBIT)
+		pr_info("%lu: Write access to the SCM increment is restored\n",
+			(unsigned long) bdev->scmdev->address);
+	bdev->state = SCM_OPER;
+	spin_unlock_irqrestore(&bdev->lock, flags);
+}
+
 static int __init scm_blk_init(void)
 {
 	int ret = -EINVAL;
diff --git a/drivers/s390/block/scm_blk.h b/drivers/s390/block/scm_blk.h
index 3c1ccf4..8b387b3 100644
--- a/drivers/s390/block/scm_blk.h
+++ b/drivers/s390/block/scm_blk.h
@@ -21,6 +21,7 @@ struct scm_blk_dev {
 	spinlock_t rq_lock;	/* guard the request queue */
 	spinlock_t lock;	/* guard the rest of the blockdev */
 	atomic_t queued_reqs;
+	enum {SCM_OPER, SCM_WR_PROHIBIT} state;
 	struct list_head finished_requests;
 #ifdef CONFIG_SCM_BLOCK_CLUSTER_WRITE
 	struct list_head cluster_list;
@@ -48,6 +49,7 @@ struct scm_request {
 
 int scm_blk_dev_setup(struct scm_blk_dev *, struct scm_device *);
 void scm_blk_dev_cleanup(struct scm_blk_dev *);
+void scm_blk_set_available(struct scm_blk_dev *);
 void scm_blk_irq(struct scm_device *, void *, int);
 
 void scm_request_finish(struct scm_request *);
diff --git a/drivers/s390/block/scm_drv.c b/drivers/s390/block/scm_drv.c
index 9fa0a90..5f6180d 100644
--- a/drivers/s390/block/scm_drv.c
+++ b/drivers/s390/block/scm_drv.c
@@ -13,12 +13,23 @@
 #include <asm/eadm.h>
 #include "scm_blk.h"
 
-static void notify(struct scm_device *scmdev)
+static void scm_notify(struct scm_device *scmdev, enum scm_event event)
 {
-	pr_info("%lu: The capabilities of the SCM increment changed\n",
-		(unsigned long) scmdev->address);
-	SCM_LOG(2, "State changed");
-	SCM_LOG_STATE(2, scmdev);
+	struct scm_blk_dev *bdev = dev_get_drvdata(&scmdev->dev);
+
+	switch (event) {
+	case SCM_CHANGE:
+		pr_info("%lu: The capabilities of the SCM increment changed\n",
+			(unsigned long) scmdev->address);
+		SCM_LOG(2, "State changed");
+		SCM_LOG_STATE(2, scmdev);
+		break;
+	case SCM_AVAIL:
+		SCM_LOG(2, "Increment available");
+		SCM_LOG_STATE(2, scmdev);
+		scm_blk_set_available(bdev);
+		break;
+	}
 }
 
 static int scm_probe(struct scm_device *scmdev)
@@ -64,7 +75,7 @@ static struct scm_driver scm_drv = {
 		.name = "scm_block",
 		.owner = THIS_MODULE,
 	},
-	.notify = notify,
+	.notify = scm_notify,
 	.probe = scm_probe,
 	.remove = scm_remove,
 	.handler = scm_blk_irq,
diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 30a2255..cd79838 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -627,6 +627,8 @@ static int __init sclp_detect_standby_memory(void)
 	struct read_storage_sccb *sccb;
 	int i, id, assigned, rc;
 
+	if (OLDMEM_BASE) /* No standby memory in kdump mode */
+		return 0;
 	if (!early_read_info_sccb_valid)
 		return 0;
 	if ((sclp_facilities & 0xe00000000000ULL) != 0xe00000000000ULL)
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 31ceef1..e16c553 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -433,6 +433,20 @@ static void chsc_process_sei_scm_change(struct chsc_sei_nt0_area *sei_area)
 			      " failed (rc=%d).\n", ret);
 }
 
+static void chsc_process_sei_scm_avail(struct chsc_sei_nt0_area *sei_area)
+{
+	int ret;
+
+	CIO_CRW_EVENT(4, "chsc: scm available information\n");
+	if (sei_area->rs != 7)
+		return;
+
+	ret = scm_process_availability_information();
+	if (ret)
+		CIO_CRW_EVENT(0, "chsc: process availability information"
+			      " failed (rc=%d).\n", ret);
+}
+
 static void chsc_process_sei_nt2(struct chsc_sei_nt2_area *sei_area)
 {
 	switch (sei_area->cc) {
@@ -468,6 +482,9 @@ static void chsc_process_sei_nt0(struct chsc_sei_nt0_area *sei_area)
 	case 12: /* scm change notification */
 		chsc_process_sei_scm_change(sei_area);
 		break;
+	case 14: /* scm available notification */
+		chsc_process_sei_scm_avail(sei_area);
+		break;
 	default: /* other stuff */
 		CIO_CRW_EVENT(2, "chsc: sei nt0 unhandled cc=%d\n",
 			      sei_area->cc);
diff --git a/drivers/s390/cio/chsc.h b/drivers/s390/cio/chsc.h
index 227e05f..349d5fc 100644
--- a/drivers/s390/cio/chsc.h
+++ b/drivers/s390/cio/chsc.h
@@ -156,8 +156,10 @@ int chsc_scm_info(struct chsc_scm_info *scm_area, u64 token);
 
 #ifdef CONFIG_SCM_BUS
 int scm_update_information(void);
+int scm_process_availability_information(void);
 #else /* CONFIG_SCM_BUS */
 static inline int scm_update_information(void) { return 0; }
+static inline int scm_process_availability_information(void) { return 0; }
 #endif /* CONFIG_SCM_BUS */
 
 
diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index bcf20f3..46ec256 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -211,7 +211,7 @@ static void scmdev_update(struct scm_device *scmdev, struct sale *sale)
 		goto out;
 	scmdrv = to_scm_drv(scmdev->dev.driver);
 	if (changed && scmdrv->notify)
-		scmdrv->notify(scmdev);
+		scmdrv->notify(scmdev, SCM_CHANGE);
 out:
 	device_unlock(&scmdev->dev);
 	if (changed)
@@ -297,6 +297,22 @@ int scm_update_information(void)
 	return ret;
 }
 
+static int scm_dev_avail(struct device *dev, void *unused)
+{
+	struct scm_driver *scmdrv = to_scm_drv(dev->driver);
+	struct scm_device *scmdev = to_scm_dev(dev);
+
+	if (dev->driver && scmdrv->notify)
+		scmdrv->notify(scmdev, SCM_AVAIL);
+
+	return 0;
+}
+
+int scm_process_availability_information(void)
+{
+	return bus_for_each_dev(&scm_bus_type, NULL, NULL, scm_dev_avail);
+}
+
 static int __init scm_init(void)
 {
 	int ret;

