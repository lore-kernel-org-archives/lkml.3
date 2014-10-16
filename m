Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaJPUys (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:54:48 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:58828 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752578AbaJPUym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:54:42 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 04/10] tty,serial: Unify UPF_* and ASYNC_* flag definitions
Date: Thu, 16 Oct 2014 16:54:21 -0400
Message-Id: <1413492867-20679-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The userspace-defined ASYNC_* flags in include/uapi/linux/tty_flags.h
are the authoritative bit definitions for the serial_struct flags,
and thus for any derivative values or fields.

Although the serial core provides the TIOCSSERIAL and TIOCGSERIAL
ioctls to set and retrieve these flags from userspace, it defines these
bits independently, as UPF_* macros.

Define the UPF_* macros which are userspace-modifiable directly from
the ASYNC_* symbolic constants. Add compile-time test to ensure the
bits changeable by TIOCSSERIAL match the defined range in the uapi
header.

Add ASYNCB_MAGIC_MULTIPLIER to the uapi header since this bit is
programmable by userspace.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/serial_core.h    | 47 ++++++++++++++++++++++++++++--------------
 include/uapi/linux/tty_flags.h |  6 +++++-
 2 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index bb828a5..ab7180e 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -156,21 +156,33 @@ struct uart_port {
 	/* flags must be updated while holding port mutex */
 	upf_t			flags;
 
-#define UPF_FOURPORT		((__force upf_t) (1 << 1))
-#define UPF_SAK			((__force upf_t) (1 << 2))
-#define UPF_SPD_MASK		((__force upf_t) (0x1030))
-#define UPF_SPD_HI		((__force upf_t) (0x0010))
-#define UPF_SPD_VHI		((__force upf_t) (0x0020))
-#define UPF_SPD_CUST		((__force upf_t) (0x0030))
-#define UPF_SPD_SHI		((__force upf_t) (0x1000))
-#define UPF_SPD_WARP		((__force upf_t) (0x1010))
-#define UPF_SKIP_TEST		((__force upf_t) (1 << 6))
-#define UPF_AUTO_IRQ		((__force upf_t) (1 << 7))
-#define UPF_HARDPPS_CD		((__force upf_t) (1 << 11))
-#define UPF_LOW_LATENCY		((__force upf_t) (1 << 13))
-#define UPF_BUGGY_UART		((__force upf_t) (1 << 14))
+	/*
+	 * These flags must be equivalent to the flags defined in
+	 * include/uapi/linux/tty_flags.h which are the userspace definitions
+	 * assigned from the serial_struct flags in uart_set_info()
+	 * [for bit definitions in the UPF_CHANGE_MASK]
+	 *
+	 * Bits [0..UPF_LAST_USER] are userspace defined/visible/changeable
+	 * except bit 15 (UPF_NO_TXEN_TEST) which is masked off.
+	 * The remaining bits are serial-core specific and not modifiable by
+	 * userspace.
+	 */
+#define UPF_FOURPORT		((__force upf_t) ASYNC_FOURPORT       /* 1  */ )
+#define UPF_SAK			((__force upf_t) ASYNC_SAK            /* 2  */ )
+#define UPF_SPD_HI		((__force upf_t) ASYNC_SPD_HI         /* 4  */ )
+#define UPF_SPD_VHI		((__force upf_t) ASYNC_SPD_VHI        /* 5  */ )
+#define UPF_SPD_CUST		((__force upf_t) ASYNC_SPD_CUST   /* 0x0030 */ )
+#define UPF_SPD_WARP		((__force upf_t) ASYNC_SPD_WARP   /* 0x1010 */ )
+#define UPF_SPD_MASK		((__force upf_t) ASYNC_SPD_MASK   /* 0x1030 */ )
+#define UPF_SKIP_TEST		((__force upf_t) ASYNC_SKIP_TEST      /* 6  */ )
+#define UPF_AUTO_IRQ		((__force upf_t) ASYNC_AUTO_IRQ       /* 7  */ )
+#define UPF_HARDPPS_CD		((__force upf_t) ASYNC_HARDPPS_CD     /* 11 */ )
+#define UPF_SPD_SHI		((__force upf_t) ASYNC_SPD_SHI        /* 12 */ )
+#define UPF_LOW_LATENCY		((__force upf_t) ASYNC_LOW_LATENCY    /* 13 */ )
+#define UPF_BUGGY_UART		((__force upf_t) ASYNC_BUGGY_UART     /* 14 */ )
 #define UPF_NO_TXEN_TEST	((__force upf_t) (1 << 15))
-#define UPF_MAGIC_MULTIPLIER	((__force upf_t) (1 << 16))
+#define UPF_MAGIC_MULTIPLIER	((__force upf_t) ASYNC_MAGIC_MULTIPLIER /* 16 */ )
+
 /* Port has hardware-assisted h/w flow control (iow, auto-RTS *not* auto-CTS) */
 #define UPF_HARD_FLOW		((__force upf_t) (1 << 21))
 /* Port has hardware-assisted s/w flow control */
@@ -186,9 +198,14 @@ struct uart_port {
 #define UPF_DEAD		((__force upf_t) (1 << 30))
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
 
-#define UPF_CHANGE_MASK		((__force upf_t) (0x17fff))
+#define __UPF_CHANGE_MASK	0x17fff
+#define UPF_CHANGE_MASK		((__force upf_t) __UPF_CHANGE_MASK)
 #define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY))
 
+#if __UPF_CHANGE_MASK > ASYNC_FLAGS
+#error Change mask not equivalent to userspace-visible bit defines
+#endif
+
 	/* status must be updated while holding port lock */
 	upstat_t		status;
 
diff --git a/include/uapi/linux/tty_flags.h b/include/uapi/linux/tty_flags.h
index eefcb48..7b516f7 100644
--- a/include/uapi/linux/tty_flags.h
+++ b/include/uapi/linux/tty_flags.h
@@ -6,6 +6,8 @@
  * shared by the tty_port flags structures.
  *
  * Define ASYNCB_* for convenient use with {test,set,clear}_bit.
+ *
+ * Bits [0..ASYNCB_LAST_USER] are userspace defined/visible/changeable
  */
 #define ASYNCB_HUP_NOTIFY	 0 /* Notify getty on hangups and closes
 				    * on the callout port */
@@ -26,7 +28,8 @@
 #define ASYNCB_BUGGY_UART	14 /* This is a buggy UART, skip some safety
 				    * checks.  Note: can be dangerous! */
 #define ASYNCB_AUTOPROBE	15 /* Port was autoprobed by PCI or PNP code */
-#define ASYNCB_LAST_USER	15
+#define ASYNCB_MAGIC_MULTIPLIER	16 /* Use special CLK or divisor */
+#define ASYNCB_LAST_USER	16
 
 /* Internal flags used only by kernel */
 #define ASYNCB_INITIALIZED	31 /* Serial port was initialized */
@@ -57,6 +60,7 @@
 #define ASYNC_LOW_LATENCY	(1U << ASYNCB_LOW_LATENCY)
 #define ASYNC_BUGGY_UART	(1U << ASYNCB_BUGGY_UART)
 #define ASYNC_AUTOPROBE		(1U << ASYNCB_AUTOPROBE)
+#define ASYNC_MAGIC_MULTIPLIER	(1U << ASYNCB_MAGIC_MULTIPLIER)
 
 #define ASYNC_FLAGS		((1U << (ASYNCB_LAST_USER + 1)) - 1)
 #define ASYNC_USR_MASK		(ASYNC_SPD_MASK|ASYNC_CALLOUT_NOHUP| \
-- 
2.1.1

