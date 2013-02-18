Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab3BRTd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:33:59 -0500
Received: from www.linutronix.de ([62.245.132.108]:56912 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3BRTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:33:58 -0500
Date: Mon, 18 Feb 2013 20:33:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.11-rt30
Message-ID: <alpine.LFD.2.02.1302182029500.22263@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.11-rt30 release.

Changes since 3.6.11-rt29:

   1) Fix a deadlock on imx serial

   2) Fix a ACPI scheduling while atomic issue (Steven)
      
   3) Fix a longstanding mainline issue in printk (Yitian Bu)

I know I said that a few days ago already, but this is
probably^Whopefully the last release for 3.6 from my side. Steven
might keep it maintained until the 3.8-rt stabilizes, but that's not
yet decided.

The delta patch against 3.6.11-rt29 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.11-rt29-rt30.pa
tch.xz

The RT patch against 3.6.11 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.11-rt30.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.11-rt30.tar.xz

Enjoy,

        tglx

Index: linux-stable/kernel/printk.c
===================================================================
--- linux-stable.orig/kernel/printk.c
+++ linux-stable/kernel/printk.c
@@ -1412,9 +1412,9 @@ static int console_trylock_for_printk(un
 		}
 	}
 	logbuf_cpu = UINT_MAX;
+	raw_spin_unlock(&logbuf_lock);
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
 	return retval;
 }
 
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt29
+-rt30
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
Index: linux-stable/drivers/tty/serial/imx.c
===================================================================
--- linux-stable.orig/drivers/tty/serial/imx.c
+++ linux-stable/drivers/tty/serial/imx.c
@@ -1213,8 +1213,14 @@ imx_console_write(struct console *co, co
 	struct imx_port_ucrs old_ucr;
 	unsigned int ucr1;
 	unsigned long flags;
+	int locked = 1;
 
-	spin_lock_irqsave(&sport->port.lock, flags);
+	if (sport->port.sysrq)
+		locked = 0;
+	else if (oops_in_progress)
+		locked = spin_trylock_irqsave(&sport->port.lock, flags);
+	else
+		spin_lock_irqsave(&sport->port.lock, flags);
 
 	/*
 	 *	First, save UCR1/2/3 and then disable interrupts
@@ -1241,7 +1247,8 @@ imx_console_write(struct console *co, co
 
 	imx_port_ucrs_restore(&sport->port, &old_ucr);
 
-	spin_unlock_irqrestore(&sport->port.lock, flags);
+	if (locked)
+		spin_unlock_irqrestore(&sport->port.lock, flags);
 }
 
 /*
