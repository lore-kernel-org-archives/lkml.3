Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaHEBIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:08:22 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38561 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaHEBIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:08:19 -0400
Message-ID: <53E02E7F.90804@gmail.com>
Date: Mon, 04 Aug 2014 18:08:15 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
CC: Stephen Boyd <sboyd@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [test patch 4/4] debug hackery to trace msm_serial receive interrupts
References: <53E02C7C.4090206@gmail.com>
In-Reply-To: <53E02C7C.4090206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>

Not intended to be applied to mainline.

This is debug code that captures a trace of msm_serial reads by handle_rx_dm().

The trace is printed to the console when the sys_sync() system call is
invoked (that is, when the sync user space command is executed).

Not-signed-off-by-yet: Frank Rowand <frank.rowand@sonymobile.com>

---
 arch/arm/boot/dts/qcom-msm8974.dtsi |    1 
 drivers/tty/serial/msm_serial.c     |  110 ++++++++++++++++++++++++++++++++++++
 fs/sync.c                           |    5 +
 3 files changed, 116 insertions(+)

Index: b/drivers/tty/serial/msm_serial.c
===================================================================
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -100,6 +100,80 @@ static void msm_enable_ms(struct uart_po
 	msm_write(port, msm_port->imr, UART_IMR);
 }
 
+#define dbg_rx_c_MAX 95
+struct dbg_rx {
+	unsigned int	rx_break;
+	unsigned int	stale;
+	unsigned int	count_exhausted;
+	unsigned int	rx_total_snap;
+	unsigned int	count;
+	unsigned int	old_snap_state_1;
+	unsigned int	old_snap_state_2;
+	unsigned int	c_idx;
+	unsigned int	c[dbg_rx_c_MAX + 1];
+};
+
+#define dbg_rx_MAX 4000
+static struct dbg_rx dbg_rx[dbg_rx_MAX + 1];
+static int dbg_rx_idx = -1;
+
+#define BUF_MAX 4095
+#define BUF_SIZE (BUF_MAX + 1)
+static unsigned char buf[BUF_SIZE];
+void print_dbg_rx(void)
+{
+	unsigned char c;
+	int k;
+	int j;
+	int i;
+	struct dbg_rx *d = &dbg_rx[0];
+	unsigned char *bufp;
+
+	pr_err(
+	       "     B S E\n"
+	       "     r t x old_\n"
+	       "     e a h snap_state\n"
+	       "     a l s ---------- tot\n"
+	       "     k t t   1    2   snap count c_idx --- data\n"
+	       "---- - - -  ---- ---- ---- ----- ----- --- --------\n");
+
+	for (k = 0; k <= dbg_rx_idx; k++, d++) {
+		bufp = &buf[0];
+		bufp += scnprintf(bufp, BUF_SIZE, "%4d %c %c %c  %4d %4d %4d %5d %5d --- ",
+			k,
+			d->rx_break ? 'B' : ' ',
+			d->stale ? 'S' : 'H',
+			d->count_exhausted ? 'E' : ' ',
+			d->old_snap_state_1,
+			d->old_snap_state_2,
+			d->rx_total_snap,
+			d->count,
+			d->c_idx
+			);
+		for (j = 0; j < d->c_idx; j++) {
+			bufp += scnprintf(bufp,
+				BUF_SIZE - (bufp - &buf[0]),
+				"%08x ", d->c[j]);
+		}
+		for (j = 0; j < d->c_idx; j++) {
+			for (i = 3; i >= 0; i--) {
+				c = (d->c[j] >> (8 * i)) & 0xff;
+				bufp += scnprintf(bufp,
+					BUF_SIZE - (bufp - &buf[0]),
+					"%c",
+				       ((c >= 0x20) && (c <= 0x7e)) ? c : '.');
+			}
+			bufp += scnprintf(bufp,
+				BUF_SIZE - (bufp - &buf[0]),
+				" ");
+		}
+		bufp += scnprintf(bufp,
+			BUF_SIZE - (bufp - &buf[0]),
+			"\n");
+		pr_err("%s", buf);
+	}
+}
+
 static void handle_rx_dm(struct uart_port *port, unsigned int misr)
 {
 	struct tty_port *tport = &port->state->port;
@@ -110,6 +184,13 @@ static void handle_rx_dm(struct uart_por
 	int res;
 	char *cp;
 
+	dbg_rx_idx++;
+	if (dbg_rx_idx > dbg_rx_MAX)
+		dbg_rx_idx = 0;
+	memset(&dbg_rx[dbg_rx_idx], 0, sizeof(dbg_rx[0]));
+	dbg_rx[dbg_rx_idx].old_snap_state_1 = msm_port->old_snap_state;
+	dbg_rx[dbg_rx_idx].stale = imr_rx_stale;
+
 	if ((msm_read(port, UART_SR) & UART_SR_OVERRUN)) {
 		port->icount.overrun++;
 		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
@@ -117,8 +198,14 @@ static void handle_rx_dm(struct uart_por
 	}
 
 	if (imr_rx_stale) {
+#if 1
+		int rx_total_snap = msm_read(port, UARTDM_RX_TOTAL_SNAP);
+		dbg_rx[dbg_rx_idx].rx_total_snap = rx_total_snap;
+		count = rx_total_snap - msm_port->old_snap_state;
+#else
 		count = msm_read(port, UARTDM_RX_TOTAL_SNAP) -
 			msm_port->old_snap_state;
+#endif
 		msm_port->old_snap_state = 0;
 	} else {
 		count = msm_read(port, UART_RFWR);
@@ -126,6 +213,7 @@ static void handle_rx_dm(struct uart_por
 			count = 4 * count;
 		msm_port->old_snap_state += count;
 	}
+	dbg_rx[dbg_rx_idx].count = count;
 
 	/* TODO: Precise error reporting */
 
@@ -138,12 +226,15 @@ static void handle_rx_dm(struct uart_por
 		if ((sr & UART_SR_RX_READY) == 0) {
 			if (!imr_rx_stale)
 				msm_port->old_snap_state -= count;
+			dbg_rx[dbg_rx_idx].count_exhausted = 1;
 			break;
 		}
 
 		c = msm_read(port, UARTDM_RF);
+		dbg_rx[dbg_rx_idx].c[dbg_rx[dbg_rx_idx].c_idx++] = c;
 
 		if (sr & UART_SR_RX_BREAK) {
+			dbg_rx[dbg_rx_idx].rx_break = 1;
 			port->icount.brk++;
 			uart_handle_break(port);
 			if (msm_port->rx_sc_enabled)
@@ -193,6 +284,7 @@ static void handle_rx_dm(struct uart_por
 		msm_write(port, UART_CR_CMD_RESET_STALE_INT, UART_CR);
 	msm_write(port, 0xFFFFFF, UARTDM_DMRX);
 	msm_write(port, UART_CR_CMD_STALE_EVENT_ENABLE, UART_CR);
+	dbg_rx[dbg_rx_idx].old_snap_state_2 = msm_port->old_snap_state;
 }
 
 static void handle_rx(struct uart_port *port)
@@ -771,6 +863,9 @@ static int msm_poll_init(struct uart_por
 	struct msm_port *msm_port = UART_TO_MSM(port);
 	unsigned int watermark;
 
+	pr_err("enter msm_poll_init()\n");
+	pr_err("msm_port->is_uartdm %d\n", msm_port->is_uartdm);
+
 	/* Enable single character mode on RX FIFO */
 	if (msm_port->is_uartdm >= UARTDM_1P4) {
 		msm_write(port, UARTDM_DMEN_RX_SC_ENABLE, UARTDM_DMEN);
@@ -1273,6 +1368,21 @@ static int __init msm_console_setup(stru
 
 	printk(KERN_INFO "msm_serial: console setup on port #%d\n", port->line);
 
+#if 1
+{
+	/* zzz debug info */
+
+	unsigned int version;
+
+	version = msm_read(port, 0xd8);
+	pr_err("msm_serial: HW_VERSION %d.%d.%d\n",
+	       (version >> 28) & 0xf,
+	       (version >> 16) & 0xfff,
+	       (version      ) & 0xffff);
+
+}
+#endif
+
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
 
Index: b/fs/sync.c
===================================================================
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -99,10 +99,15 @@ static void fdatawait_one_bdev(struct bl
  * just write metadata (such as inodes or bitmaps) to block device page cache
  * and do not sync it on their own in ->sync_fs().
  */
+void print_dbg_rx(void);
+int zzz_print_dbg_rx = 1;
 SYSCALL_DEFINE0(sync)
 {
 	int nowait = 0, wait = 1;
 
+	if (zzz_print_dbg_rx)
+		print_dbg_rx();
+
 	wakeup_flusher_threads(0, WB_REASON_SYNC);
 	iterate_supers(sync_inodes_one_sb, NULL);
 	iterate_supers(sync_fs_one_sb, &nowait);
Index: b/arch/arm/boot/dts/qcom-msm8974.dtsi
===================================================================
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -227,6 +227,7 @@
 
 		serial@f991e000 {
 			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
+			/* compatible = "qcom,msm-uartdm-v1.3", "qcom,msm-uartdm"; */
 			reg = <0xf991e000 0x1000>;
 			interrupts = <0 108 0x0>;
 			clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
