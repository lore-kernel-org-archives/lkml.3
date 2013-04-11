Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448Ab3DKN2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:28:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964772Ab3DKN2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 06/26] csr: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, Priit Laes <plaes@plaes.org>,
        Riku =?utf-8?b?TWV0dMOkbMOk?= <riku.mettala@bluegiga.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mikko =?utf-8?b?Vmlya2tpbMOk?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>,
        viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:28:29 +0100
Message-ID: <20130411132829.32763.34214.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>
cc: Priit Laes <plaes@plaes.org>
cc: devel@driverdev.osuosl.org
cc: Mikko Virkkilä <mikko.virkkila@bluegiga.com>
cc: Lauri Hintsala <Lauri.Hintsala@bluegiga.com>
cc: Riku Mettälä <riku.mettala@bluegiga.com>
cc: Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>
---

 drivers/staging/csr/csr_wifi_hip_udi.c       |  353 ++++++++++----------------
 drivers/staging/csr/csr_wifi_hip_unifi_udi.h |   17 -
 drivers/staging/csr/io.c                     |  151 ++++-------
 3 files changed, 189 insertions(+), 332 deletions(-)

diff --git a/drivers/staging/csr/csr_wifi_hip_udi.c b/drivers/staging/csr/csr_wifi_hip_udi.c
index a65b822..a6b006b 100644
--- a/drivers/staging/csr/csr_wifi_hip_udi.c
+++ b/drivers/staging/csr/csr_wifi_hip_udi.c
@@ -24,10 +24,50 @@
  *
  * ---------------------------------------------------------------------------
  */
+#include <linux/seq_file.h>
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_card.h"
 
 
+static void unifi_print_unsafe_sdio_status(card_t *card, struct seq_file *m)
+{
+#ifdef CSR_UNSAFE_SDIO_ACCESS
+	s32 iostate;
+	CsrResult r;
+	static const char *const states[] = {
+		"AWAKE", "DROWSY", "TORPID"
+	};
+#define SHARED_READ_RETRY_LIMIT 10
+	u8 b;
+
+	seq_printf(m, "Host State: %s\n", states[card->host_state]);
+
+	r = unifi_check_io_status(card, &iostate);
+	if (iostate == 1) {
+		seq_puts(m, remaining, "I/O Check: F1 disabled\n");
+        } else {
+		if (iostate == 1) {
+			seq_puts(m, "I/O Check: pending interrupt\n");
+
+		seq_printf(m, "BH reason interrupt = %d\n", card->bh_reason_unifi);
+		seq_printf(m, "BH reason host      = %d\n", card->bh_reason_host);
+
+		for (i = 0; i < SHARED_READ_RETRY_LIMIT; i++) {
+			r = unifi_read_8_or_16(card, card->sdio_ctrl_addr + 2, &b);
+			if (r == CSR_RESULT_SUCCESS && !(b & 0x80)) {
+				seq_printf(m, "fhsr: %u (driver thinks is %u)\n",
+					   b, card->from_host_signals_r);
+				break;
+			}
+		}
+
+		iostate = unifi_read_shared_count(card, card->sdio_ctrl_addr + 4);
+		seq_printf(m, "thsw: %u (driver thinks is %u)\n",
+			   iostate, card->to_host_signals_w);
+        }
+#endif
+}
+
 /*
  * ---------------------------------------------------------------------------
  *  unifi_print_status
@@ -41,228 +81,93 @@
  *      None.
  * ---------------------------------------------------------------------------
  */
-s32 unifi_print_status(card_t *card, char *str, s32 *remain)
+s32 unifi_print_status(card_t *card, struct seq_file *m)
 {
-    char *p = str;
-    sdio_config_data_t *cfg;
-    u16 i, n;
-    s32 remaining = *remain;
-    s32 written;
-#ifdef CSR_UNSAFE_SDIO_ACCESS
-    s32 iostate;
-    CsrResult r;
-    static const char *const states[] = {
-        "AWAKE", "DROWSY", "TORPID"
-    };
-    #define SHARED_READ_RETRY_LIMIT 10
-    u8 b;
-#endif
-
-    if (remaining <= 0)
-    {
-        return 0;
-    }
-
-    i = n = 0;
-    written = scnprintf(p, remaining, "Chip ID %u\n",
-                          (u16)card->chip_id);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "Chip Version %04X\n",
-                          card->chip_version);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "HIP v%u.%u\n",
-                          (card->config_data.version >> 8) & 0xFF,
-                          card->config_data.version & 0xFF);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "Build %u: %s\n",
-                          card->build_id, card->build_id_string);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    cfg = &card->config_data;
-
-    written = scnprintf(p, remaining, "sdio ctrl offset          %u\n",
-                          cfg->sdio_ctrl_offset);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "fromhost sigbuf handle    %u\n",
-                          cfg->fromhost_sigbuf_handle);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "tohost_sigbuf_handle      %u\n",
-                          cfg->tohost_sigbuf_handle);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "num_fromhost_sig_frags    %u\n",
-                          cfg->num_fromhost_sig_frags);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "num_tohost_sig_frags      %u\n",
-                          cfg->num_tohost_sig_frags);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "num_fromhost_data_slots   %u\n",
-                          cfg->num_fromhost_data_slots);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "num_tohost_data_slots     %u\n",
-                          cfg->num_tohost_data_slots);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "data_slot_size            %u\n",
-                          cfg->data_slot_size);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    /* Added by protocol version 0x0001 */
-    written = scnprintf(p, remaining, "overlay_size              %u\n",
-                          (u16)cfg->overlay_size);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    /* Added by protocol version 0x0300 */
-    written = scnprintf(p, remaining, "data_slot_round           %u\n",
-                          cfg->data_slot_round);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "sig_frag_size             %u\n",
-                          cfg->sig_frag_size);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    /* Added by protocol version 0x0300 */
-    written = scnprintf(p, remaining, "tohost_sig_pad            %u\n",
-                          cfg->tohost_signal_padding);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    written = scnprintf(p, remaining, "\nInternal state:\n");
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    written = scnprintf(p, remaining, "Last PHY PANIC: %04x:%04x\n",
-                          card->last_phy_panic_code, card->last_phy_panic_arg);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "Last MAC PANIC: %04x:%04x\n",
-                          card->last_mac_panic_code, card->last_mac_panic_arg);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    written = scnprintf(p, remaining, "fhsr: %u\n",
-                          (u16)card->from_host_signals_r);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "fhsw: %u\n",
-                          (u16)card->from_host_signals_w);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "thsr: %u\n",
-                          (u16)card->to_host_signals_r);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "thsw: %u\n",
-                          (u16)card->to_host_signals_w);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining,
-                          "fh buffer contains: %d signals, %td bytes\n",
-                          card->fh_buffer.count,
-                          card->fh_buffer.ptr - card->fh_buffer.buf);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    written = scnprintf(p, remaining, "paused: ");
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    for (i = 0; i < sizeof(card->tx_q_paused_flag) / sizeof(card->tx_q_paused_flag[0]); i++)
-    {
-        written = scnprintf(p, remaining, card->tx_q_paused_flag[i]?"1" : "0");
-        UNIFI_SNPRINTF_RET(p, remaining, written);
-    }
-    written = scnprintf(p, remaining, "\n");
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    written = scnprintf(p, remaining,
-                          "fh command q: %u waiting, %u free of %u:\n",
-                          CSR_WIFI_HIP_Q_SLOTS_USED(&card->fh_command_queue),
-                          CSR_WIFI_HIP_Q_SLOTS_FREE(&card->fh_command_queue),
-                          UNIFI_SOFT_COMMAND_Q_LENGTH);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    for (i = 0; i < UNIFI_NO_OF_TX_QS; i++)
-    {
-        written = scnprintf(p, remaining,
-                              "fh traffic q[%u]: %u waiting, %u free of %u:\n",
-                              i,
-                              CSR_WIFI_HIP_Q_SLOTS_USED(&card->fh_traffic_queue[i]),
-                              CSR_WIFI_HIP_Q_SLOTS_FREE(&card->fh_traffic_queue[i]),
-                              UNIFI_SOFT_TRAFFIC_Q_LENGTH);
-        UNIFI_SNPRINTF_RET(p, remaining, written);
-    }
-
-    written = scnprintf(p, remaining, "fh data slots free: %u\n",
-                          card->from_host_data?CardGetFreeFromHostDataSlots(card) : 0);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-
-    written = scnprintf(p, remaining, "From host data slots:");
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    n = card->config_data.num_fromhost_data_slots;
-    for (i = 0; i < n && card->from_host_data; i++)
-    {
-        written = scnprintf(p, remaining, " %u",
-                              (u16)card->from_host_data[i].bd.data_length);
-        UNIFI_SNPRINTF_RET(p, remaining, written);
-    }
-    written = scnprintf(p, remaining, "\n");
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    written = scnprintf(p, remaining, "To host data slots:");
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    n = card->config_data.num_tohost_data_slots;
-    for (i = 0; i < n && card->to_host_data; i++)
-    {
-        written = scnprintf(p, remaining, " %u",
-                              (u16)card->to_host_data[i].data_length);
-        UNIFI_SNPRINTF_RET(p, remaining, written);
-    }
-
-    written = scnprintf(p, remaining, "\n");
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-#ifdef CSR_UNSAFE_SDIO_ACCESS
-    written = scnprintf(p, remaining, "Host State: %s\n", states[card->host_state]);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    r = unifi_check_io_status(card, &iostate);
-    if (iostate == 1)
-    {
-        written = scnprintf(p, remaining, "I/O Check: F1 disabled\n");
-        UNIFI_SNPRINTF_RET(p, remaining, written);
-    }
-    else
-    {
-        if (iostate == 1)
-        {
-            written = scnprintf(p, remaining, "I/O Check: pending interrupt\n");
-            UNIFI_SNPRINTF_RET(p, remaining, written);
-        }
-
-        written = scnprintf(p, remaining, "BH reason interrupt = %d\n",
-                              card->bh_reason_unifi);
-        UNIFI_SNPRINTF_RET(p, remaining, written);
-        written = scnprintf(p, remaining, "BH reason host      = %d\n",
-                              card->bh_reason_host);
-        UNIFI_SNPRINTF_RET(p, remaining, written);
-
-        for (i = 0; i < SHARED_READ_RETRY_LIMIT; i++)
-        {
-            r = unifi_read_8_or_16(card, card->sdio_ctrl_addr + 2, &b);
-            if ((r == CSR_RESULT_SUCCESS) && (!(b & 0x80)))
-            {
-                written = scnprintf(p, remaining, "fhsr: %u (driver thinks is %u)\n",
-                                      b, card->from_host_signals_r);
-                UNIFI_SNPRINTF_RET(p, remaining, written);
-                break;
-            }
-        }
-        iostate = unifi_read_shared_count(card, card->sdio_ctrl_addr + 4);
-        written = scnprintf(p, remaining, "thsw: %u (driver thinks is %u)\n",
-                              iostate, card->to_host_signals_w);
-        UNIFI_SNPRINTF_RET(p, remaining, written);
-    }
-#endif
-
-    written = scnprintf(p, remaining, "\nStats:\n");
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "Total SDIO bytes: R=%u W=%u\n",
-                          card->sdio_bytes_read, card->sdio_bytes_written);
-
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-    written = scnprintf(p, remaining, "Interrupts generated on card: %u\n",
-                          card->unifi_interrupt_seq);
-    UNIFI_SNPRINTF_RET(p, remaining, written);
-
-    *remain = remaining;
-    return (p - str);
-} /* unifi_print_status() */
-
-
+	sdio_config_data_t *cfg;
+	u16 i, n;
+
+	i = n = 0;
+	seq_printf(m, "Chip ID %u\n", card->chip_id);
+	seq_printf(m, "Chip Version %04X\n", card->chip_version);
+	seq_printf(m, "HIP v%u.%u\n",
+		   (card->config_data.version >> 8) & 0xFF,
+		   card->config_data.version & 0xFF);
+	seq_printf(m, "Build %u: %s\n", card->build_id, card->build_id_string);
+
+	cfg = &card->config_data;
+
+	seq_printf(m, "sdio ctrl offset          %u\n", cfg->sdio_ctrl_offset);
+	seq_printf(m, "fromhost sigbuf handle    %u\n", cfg->fromhost_sigbuf_handle);
+	seq_printf(m, "tohost_sigbuf_handle      %u\n", cfg->tohost_sigbuf_handle);
+	seq_printf(m, "num_fromhost_sig_frags    %u\n", cfg->num_fromhost_sig_frags);
+	seq_printf(m, "num_tohost_sig_frags      %u\n", cfg->num_tohost_sig_frags);
+	seq_printf(m, "num_fromhost_data_slots   %u\n", cfg->num_fromhost_data_slots);
+	seq_printf(m, "num_tohost_data_slots     %u\n", cfg->num_tohost_data_slots);
+	seq_printf(m, "data_slot_size            %u\n", cfg->data_slot_size);
+
+	/* Added by protocol version 0x0001 */
+	seq_printf(m, "overlay_size              %u\n", cfg->overlay_size);
+
+	/* Added by protocol version 0x0300 */
+	seq_printf(m, "data_slot_round           %u\n", cfg->data_slot_round);
+	seq_printf(m, "sig_frag_size             %u\n", cfg->sig_frag_size);
+
+	/* Added by protocol version 0x0300 */
+	seq_printf(m, "tohost_sig_pad            %u\n", cfg->tohost_signal_padding);
+
+	seq_puts(m, "\nInternal state:\n");
+
+	seq_printf(m, "Last PHY PANIC: %04x:%04x\n",
+		   card->last_phy_panic_code, card->last_phy_panic_arg);
+	seq_printf(m, "Last MAC PANIC: %04x:%04x\n",
+		   card->last_mac_panic_code, card->last_mac_panic_arg);
+
+	seq_printf(m, "fhsr: %hu\n", (u16)card->from_host_signals_r);
+	seq_printf(m, "fhsw: %hu\n", (u16)card->from_host_signals_w);
+	seq_printf(m, "thsr: %hu\n", (u16)card->to_host_signals_r);
+	seq_printf(m, "thsw: %hu\n", (u16)card->to_host_signals_w);
+	seq_printf(m, "fh buffer contains: %d signals, %td bytes\n",
+		   card->fh_buffer.count,
+		   card->fh_buffer.ptr - card->fh_buffer.buf);
+
+	seq_puts(m, "paused: ");
+	for (i = 0; i < ARRAY_SIZE(card->tx_q_paused_flag); i++)
+		seq_printf(m, card->tx_q_paused_flag[i] ? "1" : "0");
+	seq_putc(m, '\n');
+
+	seq_printf(m, "fh command q: %u waiting, %u free of %u:\n",
+		   CSR_WIFI_HIP_Q_SLOTS_USED(&card->fh_command_queue),
+		   CSR_WIFI_HIP_Q_SLOTS_FREE(&card->fh_command_queue),
+		   UNIFI_SOFT_COMMAND_Q_LENGTH);
+
+	for (i = 0; i < UNIFI_NO_OF_TX_QS; i++)
+		seq_printf(m, "fh traffic q[%u]: %u waiting, %u free of %u:\n",
+			   i,
+			   CSR_WIFI_HIP_Q_SLOTS_USED(&card->fh_traffic_queue[i]),
+			   CSR_WIFI_HIP_Q_SLOTS_FREE(&card->fh_traffic_queue[i]),
+			   UNIFI_SOFT_TRAFFIC_Q_LENGTH);
+
+	seq_printf(m, "fh data slots free: %u\n",
+		   card->from_host_data ? CardGetFreeFromHostDataSlots(card) : 0);
+
+	seq_puts(m, "From host data slots:");
+	n = card->config_data.num_fromhost_data_slots;
+	for (i = 0; i < n && card->from_host_data; i++)
+		seq_printf(m, " %hu", (u16)card->from_host_data[i].bd.data_length);
+	seq_putc(m, '\n');
+
+	seq_puts(m, "To host data slots:");
+	n = card->config_data.num_tohost_data_slots;
+	for (i = 0; i < n && card->to_host_data; i++)
+		seq_printf(m, " %hu", (u16)card->to_host_data[i].data_length);
+	seq_putc(m, '\n');
+
+	unifi_print_unsafe_sdio_status(card, m);
+
+	seq_puts(m, "\nStats:\n");
+	seq_printf(m, "Total SDIO bytes: R=%u W=%u\n",
+		   card->sdio_bytes_read, card->sdio_bytes_written);
+
+	seq_printf(m, "Interrupts generated on card: %u\n", card->unifi_interrupt_seq);
+	return 0;
+}
diff --git a/drivers/staging/csr/csr_wifi_hip_unifi_udi.h b/drivers/staging/csr/csr_wifi_hip_unifi_udi.h
index 9d85cfd..4126e85 100644
--- a/drivers/staging/csr/csr_wifi_hip_unifi_udi.h
+++ b/drivers/staging/csr/csr_wifi_hip_unifi_udi.h
@@ -47,21 +47,6 @@ CsrResult unifi_remove_udi_hook(card_t *card, udi_func_t udi_fn);
  * This is used in the linux /proc interface and might be useful
  * in other systems.
  */
-s32 unifi_print_status(card_t *card, char *str, s32 *remain);
-
-#define UNIFI_SNPRINTF_RET(buf_p, remain, written)                  \
-    do {                                                            \
-        if (written >= remain) {                                    \
-            if (remain >= 2) {                                      \
-                buf_p[remain - 2] = '\n';                           \
-                buf_p[remain - 1] = 0;                              \
-            }                                                       \
-            buf_p += remain;                                        \
-            remain = 0;                                             \
-        } else if (written > 0) {                                   \
-            buf_p += written;                                       \
-            remain -= written;                                      \
-        }                                                           \
-    } while (0)
+s32 unifi_print_status(card_t *card, struct seq_file *m);
 
 #endif /* __CSR_WIFI_HIP_UNIFI_UDI_H__ */
diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index af9c28f..c55f1b2 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -31,6 +31,7 @@
  * ---------------------------------------------------------------------------
  */
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include "csr_wifi_hip_unifi.h"
 #include "csr_wifi_hip_unifiversion.h"
@@ -76,9 +77,28 @@ DEFINE_SEMAPHORE(Unifi_instance_mutex);
  */
 DECLARE_WAIT_QUEUE_HEAD(Unifi_cleanup_wq);
 
+#ifdef CONFIG_PROC_FS
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int uf_proc_show(struct seq_file *m, void *v);
+
+#define UNIFI_DEBUG_TXT_BUFFER (8 * 1024)
+
+static int uf_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open_size(file, uf_proc_show, PDE(inode)->data,
+				UNIFI_DEBUG_TXT_BUFFER);
+}
+
+static const struct file_operations uf_proc_fops = {
+	.open		= uf_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 
-static int uf_read_proc(char *page, char **start, off_t offset, int count,
-                        int *eof, void *data);
+#endif /* CONFIG_PROC_FS */
 
 #ifdef CSR_WIFI_RX_PATH_SPLIT
 
@@ -327,8 +347,8 @@ register_unifi_sdio(CsrSdioFunction *sdio_dev, int bus_id, struct device *dev)
      * The following complex casting is in place in order to eliminate 64-bit compilation warning
      * "cast to/from pointer from/to integer of different size"
      */
-    if (!create_proc_read_entry(priv->proc_entry_name, 0, 0,
-                uf_read_proc, (void *)(long)priv->instance))
+    if (!proc_create_data(priv->proc_entry_name, 0, NULL,
+			  &uf_proc_fops, (void *)(long)priv->instance))
     {
         unifi_error(priv, "unifi: can't create /proc/driver/unifi\n");
     }
@@ -827,7 +847,7 @@ uf_put_instance(int inst)
 
 /*
  * ---------------------------------------------------------------------------
- *  uf_read_proc
+ *  uf_proc_show
  *
  *      Read method for driver node in /proc/driver/unifi0
  *
@@ -844,107 +864,54 @@ uf_put_instance(int inst)
  * ---------------------------------------------------------------------------
  */
 #ifdef CONFIG_PROC_FS
-static int
-uf_read_proc(char *page, char **start, off_t offset, int count,
-        int *eof, void *data)
+static int uf_proc_show(struct seq_file *m, void *v)
 {
-#define UNIFI_DEBUG_TXT_BUFFER 8*1024
-    unifi_priv_t *priv;
-    int actual_amount_to_copy;
-    char *p, *orig_p;
-    s32 remain = UNIFI_DEBUG_TXT_BUFFER;
-    s32 written;
-    int i;
-
-    /*
-    * The following complex casting is in place in order to eliminate 64-bit compilation warning
-    * "cast to/from pointer from/to integer of different size"
-    */
-    priv = uf_find_instance((int)(long)data);
-    if (!priv) {
-        return 0;
-    }
-
-    p = kmalloc( UNIFI_DEBUG_TXT_BUFFER, GFP_KERNEL );
-
-    orig_p = p;
-
-    written = scnprintf(p, remain, "UniFi SDIO Driver: %s %s %s\n",
-            CSR_WIFI_VERSION, __DATE__, __TIME__);
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	unifi_priv_t *priv;
+	int i;
+
+	/*
+	 * The following complex casting is in place in order to eliminate
+	 * 64-bit compilation warning "cast to/from pointer from/to integer of
+	 * different size"
+	 */
+	priv = uf_find_instance((long)m->private);
+	if (!priv)
+		return 0;
+
+	seq_printf(m, "UniFi SDIO Driver: %s %s %s\n",
+		   CSR_WIFI_VERSION, __DATE__, __TIME__);
 #ifdef CSR_SME_USERSPACE
-    written = scnprintf(p, remain, "SME: CSR userspace ");
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	seq_puts(m, "SME: CSR userspace ");
 #ifdef CSR_SUPPORT_WEXT
-    written = scnprintf(p, remain, "with WEXT support\n");
+	seq_puts(m, "with WEXT support\n");
 #else
-    written = scnprintf(p, remain, "\n");
+	seq_putc(m, '\n');
 #endif /* CSR_SUPPORT_WEXT */
-    UNIFI_SNPRINTF_RET(p, remain, written);
 #endif /* CSR_SME_USERSPACE */
 #ifdef CSR_NATIVE_LINUX
-    written = scnprintf(p, remain, "SME: native\n");
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	seq_puts(m, "SME: native\n");
 #endif
 
 #ifdef CSR_SUPPORT_SME
-    written = scnprintf(p, remain,
-            "Firmware (ROM) build:%u, Patch:%u\n",
-            priv->card_info.fw_build,
-            priv->sme_versions.firmwarePatch);
-    UNIFI_SNPRINTF_RET(p, remain, written);
+	seq_printf(m, "Firmware (ROM) build:%u, Patch:%u\n",
+		   priv->card_info.fw_build,
+		   priv->sme_versions.firmwarePatch);
 #endif
-    p += unifi_print_status(priv->card, p, &remain);
-
-    written = scnprintf(p, remain, "Last dbg str: %s\n",
-            priv->last_debug_string);
-    UNIFI_SNPRINTF_RET(p, remain, written);
-
-    written = scnprintf(p, remain, "Last dbg16:");
-    UNIFI_SNPRINTF_RET(p, remain, written);
-    for (i = 0; i < 8; i++) {
-        written = scnprintf(p, remain, " %04X",
-                priv->last_debug_word16[i]);
-        UNIFI_SNPRINTF_RET(p, remain, written);
-    }
-    written = scnprintf(p, remain, "\n");
-    UNIFI_SNPRINTF_RET(p, remain, written);
-    written = scnprintf(p, remain, "           ");
-    UNIFI_SNPRINTF_RET(p, remain, written);
-    for (; i < 16; i++) {
-        written = scnprintf(p, remain, " %04X",
-                priv->last_debug_word16[i]);
-        UNIFI_SNPRINTF_RET(p, remain, written);
-    }
-    written = scnprintf(p, remain, "\n");
-    UNIFI_SNPRINTF_RET(p, remain, written);
-    *start = page;
-
-    written = UNIFI_DEBUG_TXT_BUFFER - remain;
-
-    if( offset >= written )
-    {
-        *eof = 1;
-        kfree( orig_p );
-        return(0);
-    }
-
-    if( offset + count > written )
-    {
-        actual_amount_to_copy = written - offset;
-        *eof = 1;
-    }
-    else
-    {
-        actual_amount_to_copy = count;
-    }
 
-    memcpy( page, &(orig_p[offset]), actual_amount_to_copy );
+	unifi_print_status(priv->card, m);
 
-    kfree( orig_p );
+	seq_printf(m, "Last dbg str: %s\n", priv->last_debug_string);
 
-    return( actual_amount_to_copy );
-} /* uf_read_proc() */
+	seq_puts(m, "Last dbg16:");
+	for (i = 0; i < 8; i++)
+		seq_printf(m, " %04X", priv->last_debug_word16[i]);
+	seq_putc(m, '\n');
+	seq_puts(m, "           ");
+	for (; i < 16; i++)
+		seq_printf(m, " %04X", priv->last_debug_word16[i]);
+	seq_putc(m, '\n');
+	return 0;
+}
 #endif
 
 

