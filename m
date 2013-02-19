Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3BSD4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:56:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab3BSD4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:56:47 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=iodXMSZFl-sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PTMZTI5fD8IA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=RS_Fx8fcj6MjFW4DvnMA:9 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130219035645.744633094@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 18 Feb 2013 22:56:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, John Kacur <jkacur@gmail.com>,
        Clark Williams <clark@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 2/7] acpi/rt: Convert acpi_gbl_hardware lock back to a raw_spinlock_t
References: <20130219035623.277664914@goodmis.org>
Content-Disposition: inline; filename=0002-acpi-rt-Convert-acpi_gbl_hardware-lock-back-to-a-raw.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

We hit the following bug with 3.6-rt:

[    5.898990] BUG: scheduling while atomic: swapper/3/0/0x00000002
[    5.898991] no locks held by swapper/3/0.
[    5.898993] Modules linked in:
[    5.898996] Pid: 0, comm: swapper/3 Not tainted 3.6.11-rt28.19.el6rt.x86_64.debug #1
[    5.898997] Call Trace:
[    5.899011]  [<ffffffff810804e7>] __schedule_bug+0x67/0x90
[    5.899028]  [<ffffffff81577923>] __schedule+0x793/0x7a0
[    5.899032]  [<ffffffff810b4e40>] ? debug_rt_mutex_print_deadlock+0x50/0x200
[    5.899034]  [<ffffffff81577b89>] schedule+0x29/0x70
[    5.899036] BUG: scheduling while atomic: swapper/7/0/0x00000002
[    5.899037] no locks held by swapper/7/0.
[    5.899039]  [<ffffffff81578525>] rt_spin_lock_slowlock+0xe5/0x2f0
[    5.899040] Modules linked in:
[    5.899041]
[    5.899045]  [<ffffffff81579a58>] ? _raw_spin_unlock_irqrestore+0x38/0x90
[    5.899046] Pid: 0, comm: swapper/7 Not tainted 3.6.11-rt28.19.el6rt.x86_64.debug #1
[    5.899047] Call Trace:
[    5.899049]  [<ffffffff81578bc6>] rt_spin_lock+0x16/0x40
[    5.899052]  [<ffffffff810804e7>] __schedule_bug+0x67/0x90
[    5.899054]  [<ffffffff8157d3f0>] ? notifier_call_chain+0x80/0x80
[    5.899056]  [<ffffffff81577923>] __schedule+0x793/0x7a0
[    5.899059]  [<ffffffff812f2034>] acpi_os_acquire_lock+0x1f/0x23
[    5.899062]  [<ffffffff810b4e40>] ? debug_rt_mutex_print_deadlock+0x50/0x200
[    5.899068]  [<ffffffff8130be64>] acpi_write_bit_register+0x33/0xb0
[    5.899071]  [<ffffffff81577b89>] schedule+0x29/0x70
[    5.899072]  [<ffffffff8130be13>] ? acpi_read_bit_register+0x33/0x51
[    5.899074]  [<ffffffff81578525>] rt_spin_lock_slowlock+0xe5/0x2f0
[    5.899077]  [<ffffffff8131d1fc>] acpi_idle_enter_bm+0x8a/0x28e
[    5.899079]  [<ffffffff81579a58>] ? _raw_spin_unlock_irqrestore+0x38/0x90
[    5.899081]  [<ffffffff8107e5da>] ? this_cpu_load+0x1a/0x30
[    5.899083]  [<ffffffff81578bc6>] rt_spin_lock+0x16/0x40
[    5.899087]  [<ffffffff8144c759>] cpuidle_enter+0x19/0x20
[    5.899088]  [<ffffffff8157d3f0>] ? notifier_call_chain+0x80/0x80
[    5.899090]  [<ffffffff8144c777>] cpuidle_enter_state+0x17/0x50
[    5.899092]  [<ffffffff812f2034>] acpi_os_acquire_lock+0x1f/0x23
[    5.899094]  [<ffffffff8144d1a1>] cpuidle899101]  [<ffffffff8130be13>] ?

As the acpi code disables interrupts in acpi_idle_enter_bm, and calls
code that grabs the acpi lock, it causes issues as the lock is currently
in RT a sleeping lock.

The lock was converted from a raw to a sleeping lock due to some
previous issues, and tests that showed it didn't seem to matter.
Unfortunately, it did matter for one of our boxes.

This patch converts the lock back to a raw lock. I've run this code on a
few of my own machines, one being my laptop that uses the acpi quite
extensively. I've been able to suspend and resume without issues.

[ tglx: Made the change exclusive for acpi_gbl_hardware_lock ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: John Kacur <jkacur@gmail.com>
Cc: Clark Williams <clark@redhat.com>
Link: http://lkml.kernel.org/r/1360765565.23152.5.camel@gandalf.local.home
Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/acpi/acpica/acglobal.h  |    2 +-
 drivers/acpi/acpica/hwregs.c    |    4 ++--
 drivers/acpi/acpica/hwxface.c   |    4 ++--
 drivers/acpi/acpica/utmutex.c   |    4 ++--
 include/acpi/platform/aclinux.h |   14 ++++++++++++++
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 76dc02f1..ca6bbe7 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -236,7 +236,7 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pending;
  * interrupt level
  */
 ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
-ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
+ACPI_EXTERN acpi_raw_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
 
 /*****************************************************************************
  *
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index cc70f3f..1df2ce6 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -263,14 +263,14 @@ acpi_status acpi_hw_clear_acpi_status(void)
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
 
 	/* Clear the fixed events in PM1 A/B */
 
 	status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
 					ACPI_BITMASK_ALL_FIXED_STATUS);
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 
 	if (ACPI_FAILURE(status))
 		goto exit;
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index c2793a8..5b28769 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -387,7 +387,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u32 value)
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
 
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -448,7 +448,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u32 value)
 
 unlock_and_exit:
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 7d797e2..b611bf3 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -88,7 +88,7 @@ acpi_status acpi_ut_mutex_initialize(void)
 		return_ACPI_STATUS (status);
 	}
 
-	status = acpi_os_create_lock (&acpi_gbl_hardware_lock);
+	status = acpi_os_create_raw_lock (&acpi_gbl_hardware_lock);
 	if (ACPI_FAILURE (status)) {
 		return_ACPI_STATUS (status);
 	}
@@ -135,7 +135,7 @@ void acpi_ut_mutex_terminate(void)
 	/* Delete the spinlocks */
 
 	acpi_os_delete_lock(acpi_gbl_gpe_lock);
-	acpi_os_delete_lock(acpi_gbl_hardware_lock);
+	acpi_os_delete_raw_lock(acpi_gbl_hardware_lock);
 
 	/* Delete the reader/writer lock */
 
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index f4b2eff..0e70789 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -73,6 +73,7 @@
 
 #define acpi_cache_t                        struct kmem_cache
 #define acpi_spinlock                       spinlock_t *
+#define acpi_raw_spinlock                   raw_spinlock_t *
 #define acpi_cpu_flags                      unsigned long
 
 #else /* !__KERNEL__ */
@@ -176,6 +177,19 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 	lock ? AE_OK : AE_NO_MEMORY;				\
 })
 
+#define acpi_os_create_raw_lock(__handle)			\
+({								\
+	raw_spinlock_t *lock = ACPI_ALLOCATE(sizeof(*lock));	\
+								\
+	if (lock) {						\
+		*(__handle) = lock;				\
+		raw_spin_lock_init(*(__handle));		\
+	}							\
+	lock ? AE_OK : AE_NO_MEMORY;				\
+})
+
+#define acpi_os_delete_raw_lock(__handle)	kfree(__handle)
+
 #endif /* __KERNEL__ */
 
 #endif /* __ACLINUX_H__ */
-- 
1.7.10.4


