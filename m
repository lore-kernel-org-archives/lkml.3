Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab3BMRWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:22:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:60331 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759964Ab3BMRWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:22:02 -0500
Date: Wed, 13 Feb 2013 18:21:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>, John Kacur <jkacur@gmail.com>,
        Clark Williams <clark@redhat.com>
Subject: Re: [RFC][PATCH RT] acpi/rt: Convert acpi lock back to a
 raw_spinlock_t
In-Reply-To: <alpine.LFD.2.03.1302131744590.13701@tycho>
Message-ID: <alpine.LFD.2.02.1302131755230.11905@ionos>
References: <1360765565.23152.5.camel@gandalf.local.home> <alpine.LFD.2.03.1302131744590.13701@tycho>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013, John Kacur wrote:
> 
> Thanks Steven. That looks way better than the previous revert.

I can't tell as I haven't seen the previous revert. And looks good is
not really a good review criteria.

The patch is converting _all_ the spin_locks in acpi to raw spinlocks,
which will give you a nice bunch of "BUG: sleeping function called
from invalid context" splats depending on the ACPI functionality of
your machine.

The lock which is related to this splat is: acpi_gbl_hardware_lock and
that's the only lock which can be safely converted to a raw spinlock.

Untested patch below.

Thanks,

	tglx


Index: linux-stable/drivers/acpi/acpica/acglobal.h
===================================================================
--- linux-stable.orig/drivers/acpi/acpica/acglobal.h
+++ linux-stable/drivers/acpi/acpica/acglobal.h
@@ -251,7 +251,7 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pend
  * interrupt level
  */
 ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
-ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
+ACPI_EXTERN acpi_raw_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
 
 /*****************************************************************************
  *
Index: linux-stable/drivers/acpi/acpica/hwregs.c
===================================================================
--- linux-stable.orig/drivers/acpi/acpica/hwregs.c
+++ linux-stable/drivers/acpi/acpica/hwregs.c
@@ -271,14 +271,14 @@ acpi_status acpi_hw_clear_acpi_status(vo
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
Index: linux-stable/drivers/acpi/acpica/hwxface.c
===================================================================
--- linux-stable.orig/drivers/acpi/acpica/hwxface.c
+++ linux-stable/drivers/acpi/acpica/hwxface.c
@@ -366,7 +366,7 @@ acpi_status acpi_write_bit_register(u32 
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(acpi_gbl_hardware_lock, lock_flags);
 
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -427,7 +427,7 @@ acpi_status acpi_write_bit_register(u32 
 
 unlock_and_exit:
 
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 
Index: linux-stable/drivers/acpi/acpica/utmutex.c
===================================================================
--- linux-stable.orig/drivers/acpi/acpica/utmutex.c
+++ linux-stable/drivers/acpi/acpica/utmutex.c
@@ -88,7 +88,7 @@ acpi_status acpi_ut_mutex_initialize(voi
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
 
Index: linux-stable/include/acpi/platform/aclinux.h
===================================================================
--- linux-stable.orig/include/acpi/platform/aclinux.h
+++ linux-stable/include/acpi/platform/aclinux.h
@@ -72,6 +72,7 @@
 
 #define acpi_cache_t                        struct kmem_cache
 #define acpi_spinlock                       spinlock_t *
+#define acpi_raw_spinlock                   raw_spinlock_t *
 #define acpi_cpu_flags                      unsigned long
 
 #else /* !__KERNEL__ */
@@ -175,6 +176,19 @@ static inline void *acpi_os_acquire_obje
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
