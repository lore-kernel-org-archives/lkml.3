Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab3HVO2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:28:48 -0400
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:60965 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613Ab3HVO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:28:46 -0400
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-nfc@ml01.01.org
Subject: [PATCH RFC] nfc: add a driver for pn532 connected on uart
Date: Thu, 22 Aug 2013 16:28:19 +0200
Message-Id: <1377181699-1668-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

This adds a driver for the nxp pn532 nfc chip.
It is not meant for merging. Instead it is meant to show that some
progress has been made and what the current state is and to help
testing.
Although I can do some basic things with this driver I expect it to
contain lots of bugs. Be aware!
This driver is heavily based on the pn533 driver and duplicates much
code. This has do be factored out some time.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 drivers/nfc/Kconfig      |    9 +
 drivers/nfc/Makefile     |    1 +
 drivers/nfc/pn532.c      | 2608 ++++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/tty.h |    1 +
 4 files changed, 2619 insertions(+)
 create mode 100644 drivers/nfc/pn532.c

diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index b0b64cc..e97303a 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -5,6 +5,15 @@
 menu "Near Field Communication (NFC) devices"
 	depends on NFC
 
+config NFC_PN532
+	tristate "NXP PN532 UART driver"
+	help
+	  NXP PN532 UART driver.
+	  This driver provides support for NFC NXP PN532 devices.
+
+	  Say Y here to compile support for PN532 devices into the
+	  kernel or say M to compile it as module (pn532).
+
 config NFC_PN533
 	tristate "NXP PN533 USB driver"
 	depends on USB
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index be7636a..a942734 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_NFC_PN544)		+= pn544/
 obj-$(CONFIG_NFC_MICROREAD)	+= microread/
+obj-$(CONFIG_NFC_PN532)		+= pn532.o
 obj-$(CONFIG_NFC_PN533)		+= pn533.o
 obj-$(CONFIG_NFC_WILINK)	+= nfcwilink.o
 obj-$(CONFIG_NFC_MEI_PHY)	+= mei_phy.o
diff --git a/drivers/nfc/pn532.c b/drivers/nfc/pn532.c
new file mode 100644
index 0000000..7e0db46
--- /dev/null
+++ b/drivers/nfc/pn532.c
@@ -0,0 +1,2608 @@
+/*
+ * Copyright (C) 2013 Lemonage Software GmbH
+ *
+ * Author:
+ *    Lars Poeschel <poeschel@lemonage.de>
+ *
+ * Heavily based on the pn533 driver by:
+ *    Lauro Ramos Venancio <lauro.venancio@openbossa.org>
+ *    Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#define DEBUG
+
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/tty.h>
+#include <linux/nfc.h>
+#include <linux/netdevice.h>
+#include <net/nfc/nfc.h>
+
+#define DESCRIPTION "PN532 uart driver"
+#define PN532_MAX_DEVS		2
+
+#define PN532_ALL_PROTOCOLS (NFC_PROTO_JEWEL_MASK | NFC_PROTO_MIFARE_MASK |\
+			     NFC_PROTO_FELICA_MASK | NFC_PROTO_ISO14443_MASK |\
+			     NFC_PROTO_NFC_DEP_MASK |\
+			     NFC_PROTO_ISO14443_B_MASK)
+
+#define PN532_NO_TYPE_B_PROTOCOLS (NFC_PROTO_JEWEL_MASK | \
+				   NFC_PROTO_MIFARE_MASK | \
+				   NFC_PROTO_FELICA_MASK | \
+				   NFC_PROTO_ISO14443_MASK | \
+				   NFC_PROTO_NFC_DEP_MASK)
+
+/* How much time we spend listening for initiators */
+#define PN532_LISTEN_TIME 2
+
+/* frame definitions */
+#define PN532_FRAME_HEADER_LEN (sizeof(struct pn532_frame) \
+					+ 2) /* data[0] TFI, data[1] CC */
+#define PN532_FRAME_TAIL_LEN 2 /* data[len] DCS, data[len + 1] postamble*/
+
+/*
+ * Max extended frame payload len, excluding TFI and CC
+ * which are already in PN532_FRAME_HEADER_LEN.
+ */
+#define PN532_FRAME_MAX_PAYLOAD_LEN 263
+
+#define PN532_FRAME_ACK_SIZE 6 /* Preamble (1), SoPC (2), ACK Code (2),
+				  Postamble (1) */
+#define PN532_FRAME_CHECKSUM(f) (f->data[f->datalen])
+#define PN532_FRAME_POSTAMBLE(f) (f->data[f->datalen + 1])
+
+/* start of frame */
+#define PN532_SOF 0x00FF
+
+/* frame identifier: in/out/error */
+#define PN532_FRAME_IDENTIFIER(f) (f->data[0])
+#define PN532_DIR_OUT 0xD4
+#define PN532_DIR_IN 0xD5
+
+/* PN532 Commands */
+#define PN532_FRAME_CMD(f) (f->data[1])
+
+#define PN532_CMD_GET_FIRMWARE_VERSION 0x02
+#define PN532_CMD_SAM_CONFIGURATION 0x14
+#define PN532_CMD_RF_CONFIGURATION 0x32
+#define PN532_CMD_IN_DATA_EXCHANGE 0x40
+#define PN532_CMD_IN_COMM_THRU     0x42
+#define PN532_CMD_IN_LIST_PASSIVE_TARGET 0x4A
+#define PN532_CMD_IN_ATR 0x50
+#define PN532_CMD_IN_RELEASE 0x52
+#define PN532_CMD_IN_JUMP_FOR_DEP 0x56
+#define PN532_CMD_IN_AUTOPOLL 0x60
+
+#define PN532_CMD_TG_INIT_AS_TARGET 0x8c
+#define PN532_CMD_TG_GET_DATA 0x86
+#define PN532_CMD_TG_SET_DATA 0x8e
+#define PN532_CMD_UNDEF 0xff
+
+#define PN532_CMD_RESPONSE(cmd) (cmd + 1)
+
+/* PN532 Return codes */
+#define PN532_CMD_RET_MASK 0x3F
+#define PN532_CMD_MI_MASK 0x40
+#define PN532_CMD_RET_SUCCESS 0x00
+
+struct pn532;
+
+typedef int (*pn532_cmd_complete_t) (struct pn532 *dev, void *arg, int status);
+
+typedef int (*pn532_send_async_complete_t) (struct pn532 *dev, void *arg,
+					struct sk_buff *resp);
+
+/* structs for pn532 commands */
+
+/* PN532_CMD_GET_FIRMWARE_VERSION */
+struct pn532_fw_version {
+	u8 ic;
+	u8 ver;
+	u8 rev;
+	u8 support;
+};
+
+/* PN532_CMD_RF_CONFIGURATION */
+#define PN532_CFGITEM_TIMING 0x02
+#define PN532_CFGITEM_MAX_RETRIES 0x05
+#define PN532_CFGITEM_PASORI 0x82
+
+#define PN532_CONFIG_TIMING_102 0xb
+#define PN532_CONFIG_TIMING_204 0xc
+#define PN532_CONFIG_TIMING_409 0xd
+#define PN532_CONFIG_TIMING_819 0xe
+
+#define PN532_CONFIG_MAX_RETRIES_NO_RETRY 0x00
+#define PN532_CONFIG_MAX_RETRIES_ENDLESS 0xFF
+
+struct pn532_config_max_retries {
+	u8 mx_rty_atr;
+	u8 mx_rty_psl;
+	u8 mx_rty_passive_act;
+} __packed;
+
+struct pn532_config_timing {
+	u8 rfu;
+	u8 atr_res_timeout;
+	u8 dep_timeout;
+} __packed;
+
+/* PN532_CMD_IN_LIST_PASSIVE_TARGET */
+
+/* felica commands opcode */
+#define PN532_FELICA_OPC_SENSF_REQ 0
+#define PN532_FELICA_OPC_SENSF_RES 1
+/* felica SENSF_REQ parameters */
+#define PN532_FELICA_SENSF_SC_ALL 0xFFFF
+#define PN532_FELICA_SENSF_RC_NO_SYSTEM_CODE 0
+#define PN532_FELICA_SENSF_RC_SYSTEM_CODE 1
+#define PN532_FELICA_SENSF_RC_ADVANCED_PROTOCOL 2
+
+/* type B initiator_data values */
+#define PN532_TYPE_B_AFI_ALL_FAMILIES 0
+#define PN532_TYPE_B_POLL_METHOD_TIMESLOT 0
+#define PN532_TYPE_B_POLL_METHOD_PROBABILISTIC 1
+
+union pn532_cmd_poll_initdata {
+	struct {
+		u8 afi;
+		u8 polling_method;
+	} __packed type_b;
+	struct {
+		u8 opcode;
+		__be16 sc;
+		u8 rc;
+		u8 tsn;
+	} __packed felica;
+};
+
+/* Poll modulations */
+enum {
+	PN532_POLL_MOD_106KBPS_A,
+	PN532_POLL_MOD_212KBPS_FELICA,
+	PN532_POLL_MOD_424KBPS_FELICA,
+	PN532_POLL_MOD_106KBPS_JEWEL,
+	PN532_POLL_MOD_106KBPS_B,
+	PN532_LISTEN_MOD,
+
+	__PN532_POLL_MOD_AFTER_LAST,
+};
+#define PN532_POLL_MOD_MAX (__PN532_POLL_MOD_AFTER_LAST - 1)
+
+struct pn532_poll_modulations {
+	struct {
+		u8 maxtg;
+		u8 brty;
+		union pn532_cmd_poll_initdata initiator_data;
+	} __packed data;
+	u8 len;
+};
+
+static const struct pn532_poll_modulations poll_mod[] = {
+	[PN532_POLL_MOD_106KBPS_A] = {
+		.data = {
+			.maxtg = 1,
+			.brty = 0,
+		},
+		.len = 2,
+	},
+	[PN532_POLL_MOD_212KBPS_FELICA] = {
+		.data = {
+			.maxtg = 1,
+			.brty = 1,
+			.initiator_data.felica = {
+				.opcode = PN532_FELICA_OPC_SENSF_REQ,
+				.sc = PN532_FELICA_SENSF_SC_ALL,
+				.rc = PN532_FELICA_SENSF_RC_NO_SYSTEM_CODE,
+				.tsn = 0,
+			},
+		},
+		.len = 7,
+	},
+	[PN532_POLL_MOD_424KBPS_FELICA] = {
+		.data = {
+			.maxtg = 1,
+			.brty = 2,
+			.initiator_data.felica = {
+				.opcode = PN532_FELICA_OPC_SENSF_REQ,
+				.sc = PN532_FELICA_SENSF_SC_ALL,
+				.rc = PN532_FELICA_SENSF_RC_NO_SYSTEM_CODE,
+				.tsn = 0,
+			},
+		 },
+		.len = 7,
+	},
+	[PN532_POLL_MOD_106KBPS_JEWEL] = {
+		.data = {
+			.maxtg = 1,
+			.brty = 4,
+		},
+		.len = 2,
+	},
+	[PN532_POLL_MOD_106KBPS_B] = {
+		.data = {
+			.maxtg = 1,
+			.brty = 3,
+			.initiator_data.type_b = {
+				.afi = PN532_TYPE_B_AFI_ALL_FAMILIES,
+				.polling_method =
+					PN532_TYPE_B_POLL_METHOD_TIMESLOT,
+			},
+		},
+		.len = 3,
+	},
+	[PN532_LISTEN_MOD] = {
+		.len = 0,
+	},
+};
+
+/* PN532_CMD_IN_ATR */
+
+struct pn532_cmd_activate_response {
+	u8 status;
+	u8 nfcid3t[10];
+	u8 didt;
+	u8 bst;
+	u8 brt;
+	u8 to;
+	u8 ppt;
+	/* optional */
+	u8 gt[];
+} __packed;
+
+struct pn532_cmd_jump_dep_response {
+	u8 status;
+	u8 tg;
+	u8 nfcid3t[10];
+	u8 didt;
+	u8 bst;
+	u8 brt;
+	u8 to;
+	u8 ppt;
+	/* optional */
+	u8 gt[];
+} __packed;
+
+/* PN532_CMD_IN_AUTOPOLL */
+#define PN532_AUTOPOLL_POLLNR_INFINITE	0xff
+#define PN532_AUTOPOLL_PERIOD		0x03 /* in units of 150 ms */
+
+#define PN532_AUTOPOLL_TYPE_GENERIC_106		0x00
+#define PN532_AUTOPOLL_TYPE_GENERIC_212		0x01
+#define PN532_AUTOPOLL_TYPE_GENERIC_424		0x02
+#define PN532_AUTOPOLL_TYPE_JEWEL		0x04
+#define PN532_AUTOPOLL_TYPE_MIFARE		0x10
+#define PN532_AUTOPOLL_TYPE_FELICA212		0x11
+#define PN532_AUTOPOLL_TYPE_FELICA424		0x12
+#define PN532_AUTOPOLL_TYPE_ISOA		0x20
+#define PN532_AUTOPOLL_TYPE_ISOB		0x23
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_106	0x40
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_212	0x41
+#define PN532_AUTOPOLL_TYPE_DEP_ACTIVE_424	0x42
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_106	0x80
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_212	0x81
+#define PN532_AUTOPOLL_TYPE_DEP_PASSIVE_424	0x82
+
+/* PN532_TG_INIT_AS_TARGET */
+#define PN532_INIT_TARGET_PASSIVE 0x1
+#define PN532_INIT_TARGET_DEP 0x2
+
+#define PN532_INIT_TARGET_RESP_FRAME_MASK 0x3
+#define PN532_INIT_TARGET_RESP_ACTIVE     0x1
+#define PN532_INIT_TARGET_RESP_DEP        0x4
+
+#define PN532_MAGIC		0x162f
+
+struct pn532_frame {
+	u8 preamble;
+	__be16 start_frame;
+	u8 datalen;
+	u8 datalen_checksum;
+	u8 data[];
+} __packed;
+
+typedef int (*pn532_recv_complete_t) (struct pn532 *dev,
+					struct pn532_frame *frame);
+
+struct pn532 {
+	int magic;
+	struct tty_struct *tty;
+	struct nfc_dev *nfc_dev;
+
+	/* These are pointers to the malloc()ed frame buffers. */
+	/*
+	unsigned char		rbuff[PN532_FRAME_HEADER_LEN +
+				      PN532_FRAME_MAX_PAYLOAD_LEN +
+				      PN532_FRAME_TAIL_LEN
+				     ];	*//* receiver buffer	     */
+	unsigned char *rbuf;
+	int rlen; /* length of receive buffer */
+	int rcount; /* received chars counter    */
+	pn532_recv_complete_t recv_complete;
+
+	/*
+	unsigned char		xbuff[PN532_FRAME_HEADER_LEN +
+				      PN532_FRAME_MAX_PAYLOAD_LEN +
+				      PN532_FRAME_TAIL_LEN
+				     ];	*//* transmitter buffer	     */
+	unsigned char *xbuf;
+	unsigned char		*xhead;         /* pointer to next XMIT byte */
+	int			xleft;          /* bytes left in XMIT queue  */
+	unsigned	wakeup;
+
+	struct sk_buff_head resp_q;
+
+	struct workqueue_struct	*wq;
+	struct workqueue_struct	*wq_deactivate_tgt;
+	struct workqueue_struct	*wq_conn_nfc;
+	struct work_struct cmd_work;
+	struct work_struct cmd_complete_work;
+	struct work_struct poll_work;
+	struct work_struct mi_work;
+	struct work_struct tg_work;
+	struct work_struct conn_nfc_work;
+	struct work_struct deactivate_tgt_work;
+	struct timer_list listen_timer;
+	int wq_in_error;
+	int cancel_listen;
+
+	pn532_cmd_complete_t cmd_complete;
+	void *cmd_complete_arg;
+	void *cmd_complete_mi_arg;
+	struct mutex cmd_lock; /* Lock for modifying the cmd_pending, cmd,
+				  cmd_complete, cmd_complete_arg and setting
+				  the buffer of this struct */
+	u8 cmd;
+
+	struct pn532_poll_modulations *poll_mod_active[PN532_POLL_MOD_MAX + 1];
+	u8 poll_mod_count;
+	u8 poll_mod_curr;
+	u32 poll_protocols;
+	u32 listen_protocols;
+
+	u8 *gb;
+	size_t gb_len;
+
+	u8 tgt_available_prots;
+	u8 tgt_active_prot;
+	u8 tgt_mode;
+
+	u32 device_type;
+
+	struct list_head cmd_queue;
+	u8 cmd_pending;
+
+	struct pn532_frame_ops *ops;
+};
+
+struct pn532_cmd {
+	struct list_head queue;
+	u8 cmd_code;
+	struct sk_buff *req;
+	struct sk_buff *resp;
+	int resp_len;
+	void *arg;
+};
+
+struct pn532_frame_ops {
+	void (*tx_frame_init)(void *frame, u8 cmd_code);
+	void (*tx_frame_finish)(void *frame);
+	void (*tx_update_payload_len)(void *frame, int len);
+	int tx_header_len;
+	int tx_tail_len;
+
+	bool (*rx_is_frame_valid)(void *frame);
+	int (*rx_frame_size)(void *frame);
+	int rx_header_len;
+	int rx_tail_len;
+
+	int max_payload_len;
+	u8 (*get_cmd_code)(void *frame);
+};
+
+/* The rule: value + checksum = 0 */
+static inline u8 pn532_checksum(u8 value)
+{
+	return ~value + 1;
+}
+
+/* The rule: sum(data elements) + checksum = 0 */
+static u8 pn532_data_checksum(u8 *data, int datalen)
+{
+	u8 sum = 0;
+	int i;
+
+	for (i = 0; i < datalen; i++)
+		sum += data[i];
+
+	return pn532_checksum(sum);
+}
+
+static void pn532_tx_frame_init(void *_frame, u8 cmd_code)
+{
+	struct pn532_frame *frame = _frame;
+
+	frame->preamble = 0;
+	frame->start_frame = cpu_to_be16(PN532_SOF);
+	PN532_FRAME_IDENTIFIER(frame) = PN532_DIR_OUT;
+	PN532_FRAME_CMD(frame) = cmd_code;
+	frame->datalen = 2;
+}
+
+static void pn532_tx_frame_finish(void *_frame)
+{
+	struct pn532_frame *frame = _frame;
+
+	frame->datalen_checksum = pn532_checksum(frame->datalen);
+
+	PN532_FRAME_CHECKSUM(frame) =
+		pn532_data_checksum(frame->data, frame->datalen);
+
+	PN532_FRAME_POSTAMBLE(frame) = 0;
+}
+
+static void pn532_tx_update_payload_len(void *_frame, int len)
+{
+	struct pn532_frame *frame = _frame;
+
+	frame->datalen += len;
+}
+
+static bool pn532_rx_frame_is_valid(void *_frame)
+{
+	u8 checksum;
+	struct pn532_frame *frame = _frame;
+
+	if (frame->start_frame != cpu_to_be16(PN532_SOF))
+		return false;
+
+	checksum = pn532_checksum(frame->datalen);
+	if (checksum != frame->datalen_checksum)
+		return false;
+
+	checksum = pn532_data_checksum(frame->data, frame->datalen);
+	if (checksum != PN532_FRAME_CHECKSUM(frame))
+		return false;
+
+	return true;
+}
+
+static bool pn532_rx_frame_is_ack(struct pn532_frame *frame)
+{
+	if (frame->start_frame != cpu_to_be16(PN532_SOF))
+		return false;
+
+	if (frame->datalen != 0 || frame->datalen_checksum != 0xFF)
+		return false;
+
+	return true;
+}
+
+static inline int pn532_rx_frame_size(void *frame)
+{
+	struct pn532_frame *f = frame;
+
+	return sizeof(struct pn532_frame) + f->datalen + PN532_FRAME_TAIL_LEN;
+}
+
+static u8 pn532_get_cmd_code(void *frame)
+{
+	struct pn532_frame *f = frame;
+
+	return PN532_FRAME_CMD(f);
+}
+
+static struct pn532_frame_ops pn532_std_frame_ops = {
+	.tx_frame_init = pn532_tx_frame_init,
+	.tx_frame_finish = pn532_tx_frame_finish,
+	.tx_update_payload_len = pn532_tx_update_payload_len,
+	.tx_header_len = PN532_FRAME_HEADER_LEN,
+	.tx_tail_len = PN532_FRAME_TAIL_LEN,
+
+	.rx_is_frame_valid = pn532_rx_frame_is_valid,
+	.rx_frame_size = pn532_rx_frame_size,
+	.rx_header_len = PN532_FRAME_HEADER_LEN,
+	.rx_tail_len = PN532_FRAME_TAIL_LEN,
+
+	.max_payload_len =  PN532_FRAME_MAX_PAYLOAD_LEN,
+	.get_cmd_code = pn532_get_cmd_code,
+};
+
+static bool pn532_rx_frame_is_cmd_response(struct pn532 *dev, void *frame)
+{
+	return (dev->ops->get_cmd_code(frame) == PN532_CMD_RESPONSE(dev->cmd));
+}
+
+
+static void pn532_wq_cmd_complete(struct work_struct *work)
+{
+	struct pn532 *dev = container_of(work, struct pn532, cmd_complete_work);
+	int rc;
+
+	rc = dev->cmd_complete(dev, dev->cmd_complete_arg, dev->wq_in_error);
+
+	nfc_dev_dbg(dev->tty->dev, "%s rc:%i", __func__, rc);
+	if (rc != -EINPROGRESS)
+		queue_work(dev->wq, &dev->cmd_work);
+}
+
+static int pn532_recv_response(struct pn532 *dev, struct pn532_frame *frame)
+{
+	nfc_dev_dbg(dev->tty->dev, "%s Received a frame.", __func__);
+	print_hex_dump(KERN_DEBUG, "PN532 RX: ", DUMP_PREFIX_NONE, 16, 1,
+		       frame, dev->ops->rx_frame_size(frame), false);
+
+	if (!dev->ops->rx_is_frame_valid(frame)) {
+		nfc_dev_err(dev->tty->dev, "Received an invalid frame");
+		dev->wq_in_error = -EIO;
+		goto sched_wq;
+	}
+
+	if (!pn532_rx_frame_is_cmd_response(dev, frame)) {
+		nfc_dev_err(dev->tty->dev,
+			    "It it not the response to the last command");
+		dev->wq_in_error = -EIO;
+		goto sched_wq;
+	}
+
+	dev->wq_in_error = 0;
+	queue_work(dev->wq, &dev->cmd_complete_work);
+	return 0;
+
+sched_wq:
+	queue_work(dev->wq, &dev->cmd_complete_work);
+	return -1;
+}
+
+
+static int pn532_recv_ack(struct pn532 *dev, struct pn532_frame *frame)
+{
+	if (!pn532_rx_frame_is_ack(frame)) {
+		nfc_dev_err(dev->tty->dev, "Received an invalid ack");
+		dev->wq_in_error = -EIO;
+		goto sched_wq;
+	}
+
+	dev->recv_complete = pn532_recv_response;
+
+	return 0;
+
+sched_wq:
+	queue_work(dev->wq, &dev->cmd_complete_work);
+	return -1;
+}
+
+static int pn532_send_ack(struct pn532 *dev, gfp_t flags)
+{
+	u8 ack[PN532_FRAME_ACK_SIZE] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
+	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
+	int rc;
+
+	dev->xbuf = ack;
+
+	set_bit(TTY_DO_WRITE_WAKEUP, &dev->tty->flags);
+	rc = dev->tty->ops->write(dev->tty, dev->xbuf, sizeof(ack));
+	dev->xleft = sizeof(ack) - rc;
+	dev->xhead = dev->xbuf + rc;
+
+	return 0;
+}
+
+static int __pn532_send_frame_async(struct pn532 *dev,
+					struct sk_buff *out,
+					struct sk_buff *in,
+					int in_len,
+					pn532_cmd_complete_t cmd_complete,
+					void *arg)
+{
+	int count;
+	unsigned char wakeup[] = {0x55, 0x55, 0x00, 0x00, 0x00, 0x00};
+
+	nfc_dev_dbg(dev->tty->dev, "%s wakeup:%i", __func__, dev->wakeup);
+
+	dev->cmd = dev->ops->get_cmd_code(out->data);
+	dev->cmd_complete = cmd_complete;
+	dev->cmd_complete_arg = arg;
+
+	dev->xbuf = out->data;
+	dev->rbuf = in->data;
+	dev->rlen = in_len;
+
+	print_hex_dump(KERN_DEBUG, "PN532 TX: ", DUMP_PREFIX_NONE, 16, 1,
+		       out->data, out->len, false);
+
+	if (dev->wakeup) {
+		dev->tty->ops->write(dev->tty, wakeup, sizeof(wakeup));
+		dev->wakeup = 0;
+	}
+	set_bit(TTY_DO_WRITE_WAKEUP, &dev->tty->flags);
+	count = dev->tty->ops->write(dev->tty, dev->xbuf, out->len);
+	dev->xleft = out->len - count;
+	dev->xhead = dev->xbuf + count;
+
+	nfc_dev_dbg(dev->tty->dev, "count:%i xleft:%i", count, dev->xleft);
+
+	dev->recv_complete = pn532_recv_ack;
+
+	return 0;
+}
+
+static void pn532_build_cmd_frame(struct pn532 *dev, u8 cmd_code,
+				  struct sk_buff *skb)
+{
+	/* payload is already there, just update datalen */
+	int payload_len = skb->len;
+	struct pn532_frame_ops *ops = dev->ops;
+
+
+	skb_push(skb, ops->tx_header_len);
+	skb_put(skb, ops->tx_tail_len);
+
+	ops->tx_frame_init(skb->data, cmd_code);
+	ops->tx_update_payload_len(skb->data, payload_len);
+	ops->tx_frame_finish(skb->data);
+}
+
+struct pn532_send_async_complete_arg {
+	pn532_send_async_complete_t  complete_cb;
+	void *complete_cb_context;
+	struct sk_buff *resp;
+	struct sk_buff *req;
+};
+
+static int pn532_send_async_complete(struct pn532 *dev, void *_arg, int status)
+{
+	struct pn532_send_async_complete_arg *arg = _arg;
+
+	struct sk_buff *req = arg->req;
+	struct sk_buff *resp = arg->resp;
+
+	int rc;
+
+	dev_kfree_skb(req);
+
+	if (status < 0) {
+		nfc_dev_dbg(dev->tty->dev, "%s error way status < 0", __func__);
+		arg->complete_cb(dev, arg->complete_cb_context,
+				 ERR_PTR(status));
+		dev_kfree_skb(resp);
+		kfree(arg);
+		return status;
+	}
+
+	skb_put(resp, dev->ops->rx_frame_size(resp->data));
+	skb_pull(resp, dev->ops->rx_header_len);
+	skb_trim(resp, resp->len - dev->ops->rx_tail_len);
+
+	rc = arg->complete_cb(dev, arg->complete_cb_context, resp);
+
+	kfree(arg);
+	return rc;
+}
+
+static int __pn532_send_async(struct pn532 *dev, u8 cmd_code,
+			      struct sk_buff *req, struct sk_buff *resp,
+			      int resp_len,
+			      pn532_send_async_complete_t complete_cb,
+			      void *complete_cb_context)
+{
+	struct pn532_cmd *cmd;
+	struct pn532_send_async_complete_arg *arg;
+	int rc = 0;
+
+	nfc_dev_dbg(dev->tty->dev, "%s Sending command 0x%x",
+			__func__, cmd_code);
+
+	arg = kzalloc(sizeof(*arg), GFP_KERNEL);
+	if (!arg)
+		return -ENOMEM;
+
+	arg->complete_cb = complete_cb;
+	arg->complete_cb_context = complete_cb_context;
+	arg->resp = resp;
+	arg->req = req;
+
+	pn532_build_cmd_frame(dev, cmd_code, req);
+
+	mutex_lock(&dev->cmd_lock);
+
+	if (!dev->cmd_pending) {
+		rc = __pn532_send_frame_async(dev, req, resp, resp_len,
+					      pn532_send_async_complete, arg);
+		if (rc)
+			goto error;
+
+		dev->cmd_pending = 1;
+		goto unlock;
+	}
+
+	nfc_dev_dbg(dev->tty->dev, "%s Queuing command 0x%x", __func__,
+		    cmd_code);
+
+	cmd = kzalloc(sizeof(struct pn532_cmd), GFP_KERNEL);
+	if (!cmd) {
+		rc = -ENOMEM;
+		goto error;
+	}
+
+	INIT_LIST_HEAD(&cmd->queue);
+	cmd->cmd_code = cmd_code;
+	cmd->req = req;
+	cmd->resp = resp;
+	cmd->resp_len = resp_len;
+	cmd->arg = arg;
+
+	list_add_tail(&cmd->queue, &dev->cmd_queue);
+
+	goto unlock;
+
+error:
+	kfree(arg);
+unlock:
+	mutex_unlock(&dev->cmd_lock);
+	return rc;
+}
+
+static int pn532_send_data_async(struct pn532 *dev, u8 cmd_code,
+				 struct sk_buff *req,
+				 pn532_send_async_complete_t complete_cb,
+				 void *complete_cb_context)
+{
+	struct sk_buff *resp;
+	int rc;
+	int  resp_len = dev->ops->rx_header_len +
+			dev->ops->max_payload_len +
+			dev->ops->rx_tail_len;
+
+	resp = nfc_alloc_recv_skb(resp_len, GFP_KERNEL);
+	if (!resp)
+		return -ENOMEM;
+
+	rc = __pn532_send_async(dev, cmd_code, req, resp, resp_len, complete_cb,
+				complete_cb_context);
+	if (rc)
+		dev_kfree_skb(resp);
+
+	return rc;
+}
+
+static int pn532_send_cmd_async(struct pn532 *dev, u8 cmd_code,
+				struct sk_buff *req,
+				pn532_send_async_complete_t complete_cb,
+				void *complete_cb_context)
+{
+	struct sk_buff *resp;
+	int rc;
+	int  resp_len = dev->ops->rx_header_len +
+			dev->ops->max_payload_len +
+			dev->ops->rx_tail_len;
+
+	resp = alloc_skb(resp_len, GFP_KERNEL);
+	if (!resp)
+		return -ENOMEM;
+
+	rc = __pn532_send_async(dev, cmd_code, req, resp, resp_len, complete_cb,
+				complete_cb_context);
+	if (rc)
+		dev_kfree_skb(resp);
+
+	return rc;
+}
+
+/*
+ * pn532_send_cmd_direct_async
+ *
+ * The function sends a piority cmd directly to the chip omiting the cmd
+ * queue. It's intended to be used by chaining mechanism of received responses
+ * where the host has to request every single chunk of data before scheduling
+ * next cmd from the queue.
+ */
+static int pn532_send_cmd_direct_async(struct pn532 *dev, u8 cmd_code,
+				       struct sk_buff *req,
+				       pn532_send_async_complete_t complete_cb,
+				       void *complete_cb_context)
+{
+	struct pn532_send_async_complete_arg *arg;
+	struct sk_buff *resp;
+	int rc;
+	int resp_len = dev->ops->rx_header_len +
+		       dev->ops->max_payload_len +
+		       dev->ops->rx_tail_len;
+
+	resp = alloc_skb(resp_len, GFP_KERNEL);
+	if (!resp)
+		return -ENOMEM;
+
+	arg = kzalloc(sizeof(*arg), GFP_KERNEL);
+	if (!arg) {
+		dev_kfree_skb(resp);
+		return -ENOMEM;
+	}
+
+	arg->complete_cb = complete_cb;
+	arg->complete_cb_context = complete_cb_context;
+	arg->resp = resp;
+	arg->req = req;
+
+	pn532_build_cmd_frame(dev, cmd_code, req);
+
+	rc = __pn532_send_frame_async(dev, req, resp, resp_len,
+				      pn532_send_async_complete, arg);
+	if (rc < 0) {
+		dev_kfree_skb(resp);
+		kfree(arg);
+	}
+
+	return rc;
+}
+
+static void pn532_wq_cmd(struct work_struct *work)
+{
+	struct pn532 *dev = container_of(work, struct pn532, cmd_work);
+	struct pn532_cmd *cmd;
+
+	mutex_lock(&dev->cmd_lock);
+
+	if (list_empty(&dev->cmd_queue)) {
+		dev->cmd_pending = 0;
+		mutex_unlock(&dev->cmd_lock);
+		return;
+	}
+
+	cmd = list_first_entry(&dev->cmd_queue, struct pn532_cmd, queue);
+
+	list_del(&cmd->queue);
+
+	mutex_unlock(&dev->cmd_lock);
+
+	__pn532_send_frame_async(dev, cmd->req, cmd->resp, cmd->resp_len,
+				 pn532_send_async_complete, cmd->arg);
+
+	kfree(cmd);
+}
+
+struct pn532_sync_cmd_response {
+	struct sk_buff *resp;
+	struct completion done;
+};
+
+static int pn532_send_sync_complete(struct pn532 *dev, void *_arg,
+				    struct sk_buff *resp)
+{
+	struct pn532_sync_cmd_response *arg = _arg;
+
+	nfc_dev_dbg(dev->tty->dev, "%s arg:%p resp:%p", __func__, arg, resp);
+
+	arg->resp = resp;
+	nfc_dev_dbg(dev->tty->dev, "%s done:%p", __func__, &arg->done);
+	complete(&arg->done);
+
+	return 0;
+}
+
+/*  pn532_send_cmd_sync
+ *
+ *  Please note the req parameter is freed inside the function to
+ *  limit a number of return value interpretations by the caller.
+ *
+ *  1. negative in case of error during TX path -> req should be freed
+ *
+ *  2. negative in case of error during RX path -> req should not be freed
+ *     as it's been already freed at the beginning of RX path by
+ *     async_complete_cb.
+ *
+ *  3. valid pointer in case of successful RX path
+ *
+ *  A caller has to check a return value with IS_ERR macro. If the test pass,
+ *  the returned pointer is valid.
+ *
+ * */
+static struct sk_buff *pn532_send_cmd_sync(struct pn532 *dev, u8 cmd_code,
+					       struct sk_buff *req)
+{
+	int rc;
+	struct pn532_sync_cmd_response arg;
+
+	init_completion(&arg.done);
+
+	rc = pn532_send_cmd_async(dev, cmd_code, req,
+				  pn532_send_sync_complete, &arg);
+	if (rc) {
+		dev_kfree_skb(req);
+		return ERR_PTR(rc);
+	}
+
+	/* TODO den Timeout richtig einstellen */
+	rc = wait_for_completion_timeout(&arg.done, HZ);
+	if (rc <= 0)
+		return ERR_PTR(-ETIMEDOUT);
+
+	return arg.resp;
+}
+
+/*
+ * Allocates a skb and reserves space for the tx_header
+ */
+static struct sk_buff *pn532_alloc_skb(struct pn532 *dev, unsigned int size)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(dev->ops->tx_header_len +
+			size +
+			dev->ops->tx_tail_len, GFP_KERNEL);
+
+	if (skb)
+		skb_reserve(skb, dev->ops->tx_header_len);
+
+	return skb;
+}
+
+struct pn532_target_type_a {
+	__be16 sens_res;
+	u8 sel_res;
+	u8 nfcid_len;
+	u8 nfcid_data[];
+} __packed;
+
+
+#define PN532_TYPE_A_SENS_RES_NFCID1(x) ((u8)((be16_to_cpu(x) & 0x00C0) >> 6))
+#define PN532_TYPE_A_SENS_RES_SSD(x) ((u8)((be16_to_cpu(x) & 0x001F) >> 0))
+#define PN532_TYPE_A_SENS_RES_PLATCONF(x) ((u8)((be16_to_cpu(x) & 0x0F00) >> 8))
+
+#define PN532_TYPE_A_SENS_RES_SSD_JEWEL 0x00
+#define PN532_TYPE_A_SENS_RES_PLATCONF_JEWEL 0x0C
+
+#define PN532_TYPE_A_SEL_PROT(x) (((x) & 0x60) >> 5)
+#define PN532_TYPE_A_SEL_CASCADE(x) (((x) & 0x04) >> 2)
+
+#define PN532_TYPE_A_SEL_PROT_MIFARE 0
+#define PN532_TYPE_A_SEL_PROT_ISO14443 1
+#define PN532_TYPE_A_SEL_PROT_DEP 2
+#define PN532_TYPE_A_SEL_PROT_ISO14443_DEP 3
+
+static bool pn532_target_type_a_is_valid(struct pn532_target_type_a *type_a,
+							int target_data_len)
+{
+	u8 ssd;
+	u8 platconf;
+
+	if (target_data_len < sizeof(struct pn532_target_type_a))
+		return false;
+
+	/* The lenght check of nfcid[] and ats[] are not being performed because
+	   the values are not being used */
+
+	/* Requirement 4.6.3.3 from NFC Forum Digital Spec */
+	ssd = PN532_TYPE_A_SENS_RES_SSD(type_a->sens_res);
+	platconf = PN532_TYPE_A_SENS_RES_PLATCONF(type_a->sens_res);
+
+	if ((ssd == PN532_TYPE_A_SENS_RES_SSD_JEWEL &&
+	     platconf != PN532_TYPE_A_SENS_RES_PLATCONF_JEWEL) ||
+	    (ssd != PN532_TYPE_A_SENS_RES_SSD_JEWEL &&
+	     platconf == PN532_TYPE_A_SENS_RES_PLATCONF_JEWEL))
+		return false;
+
+	/* Requirements 4.8.2.1, 4.8.2.3, 4.8.2.5 and 4.8.2.7 from NFC Forum */
+	if (PN532_TYPE_A_SEL_CASCADE(type_a->sel_res) != 0)
+		return false;
+
+	return true;
+}
+
+static int pn532_target_found_type_a(struct nfc_target *nfc_tgt, u8 *tgt_data,
+							int tgt_data_len)
+{
+	struct pn532_target_type_a *tgt_type_a;
+
+	tgt_type_a = (struct pn532_target_type_a *)tgt_data;
+
+	if (!pn532_target_type_a_is_valid(tgt_type_a, tgt_data_len))
+		return -EPROTO;
+
+	switch (PN532_TYPE_A_SEL_PROT(tgt_type_a->sel_res)) {
+	case PN532_TYPE_A_SEL_PROT_MIFARE:
+		pr_debug("mifare");
+		nfc_tgt->supported_protocols = NFC_PROTO_MIFARE_MASK;
+		break;
+	case PN532_TYPE_A_SEL_PROT_ISO14443:
+		pr_debug("iso14443");
+		nfc_tgt->supported_protocols = NFC_PROTO_ISO14443_MASK;
+		break;
+	case PN532_TYPE_A_SEL_PROT_DEP:
+		pr_debug("dep");
+		nfc_tgt->supported_protocols = NFC_PROTO_NFC_DEP_MASK;
+		break;
+	case PN532_TYPE_A_SEL_PROT_ISO14443_DEP:
+		pr_debug("iso dep");
+		nfc_tgt->supported_protocols = NFC_PROTO_ISO14443_MASK |
+							NFC_PROTO_NFC_DEP_MASK;
+		break;
+	}
+
+	nfc_tgt->sens_res = be16_to_cpu(tgt_type_a->sens_res);
+	nfc_tgt->sel_res = tgt_type_a->sel_res;
+	nfc_tgt->nfcid1_len = tgt_type_a->nfcid_len;
+	memcpy(nfc_tgt->nfcid1, tgt_type_a->nfcid_data, nfc_tgt->nfcid1_len);
+
+	return 0;
+}
+
+struct pn532_target_felica {
+	u8 pol_res;
+	u8 opcode;
+	u8 nfcid2[8];
+	u8 pad[8];
+	/* optional */
+	u8 syst_code[];
+} __packed;
+
+#define PN532_FELICA_SENSF_NFCID2_DEP_B1 0x01
+#define PN532_FELICA_SENSF_NFCID2_DEP_B2 0xFE
+
+static bool pn532_target_felica_is_valid(struct pn532_target_felica *felica,
+							int target_data_len)
+{
+	if (target_data_len < sizeof(struct pn532_target_felica))
+		return false;
+
+	if (felica->opcode != PN532_FELICA_OPC_SENSF_RES)
+		return false;
+
+	return true;
+}
+
+static int pn532_target_found_felica(struct nfc_target *nfc_tgt, u8 *tgt_data,
+							int tgt_data_len)
+{
+	struct pn532_target_felica *tgt_felica;
+
+	tgt_felica = (struct pn532_target_felica *)tgt_data;
+
+	if (!pn532_target_felica_is_valid(tgt_felica, tgt_data_len))
+		return -EPROTO;
+
+	if ((tgt_felica->nfcid2[0] == PN532_FELICA_SENSF_NFCID2_DEP_B1) &&
+	    (tgt_felica->nfcid2[1] == PN532_FELICA_SENSF_NFCID2_DEP_B2))
+		nfc_tgt->supported_protocols = NFC_PROTO_NFC_DEP_MASK;
+	else
+		nfc_tgt->supported_protocols = NFC_PROTO_FELICA_MASK;
+
+	memcpy(nfc_tgt->sensf_res, &tgt_felica->opcode, 9);
+	nfc_tgt->sensf_res_len = 9;
+
+	return 0;
+}
+
+struct pn532_target_jewel {
+	__be16 sens_res;
+	u8 jewelid[4];
+} __packed;
+
+static bool pn532_target_jewel_is_valid(struct pn532_target_jewel *jewel,
+							int target_data_len)
+{
+	u8 ssd;
+	u8 platconf;
+
+	if (target_data_len < sizeof(struct pn532_target_jewel))
+		return false;
+
+	/* Requirement 4.6.3.3 from NFC Forum Digital Spec */
+	ssd = PN532_TYPE_A_SENS_RES_SSD(jewel->sens_res);
+	platconf = PN532_TYPE_A_SENS_RES_PLATCONF(jewel->sens_res);
+
+	if ((ssd == PN532_TYPE_A_SENS_RES_SSD_JEWEL &&
+	     platconf != PN532_TYPE_A_SENS_RES_PLATCONF_JEWEL) ||
+	    (ssd != PN532_TYPE_A_SENS_RES_SSD_JEWEL &&
+	     platconf == PN532_TYPE_A_SENS_RES_PLATCONF_JEWEL))
+		return false;
+
+	return true;
+}
+
+static int pn532_target_found_jewel(struct nfc_target *nfc_tgt, u8 *tgt_data,
+							int tgt_data_len)
+{
+	struct pn532_target_jewel *tgt_jewel;
+
+	tgt_jewel = (struct pn532_target_jewel *)tgt_data;
+
+	if (!pn532_target_jewel_is_valid(tgt_jewel, tgt_data_len))
+		return -EPROTO;
+
+	nfc_tgt->supported_protocols = NFC_PROTO_JEWEL_MASK;
+	nfc_tgt->sens_res = be16_to_cpu(tgt_jewel->sens_res);
+	nfc_tgt->nfcid1_len = 4;
+	memcpy(nfc_tgt->nfcid1, tgt_jewel->jewelid, nfc_tgt->nfcid1_len);
+
+	return 0;
+}
+
+struct pn532_type_b_prot_info {
+	u8 bitrate;
+	u8 fsci_type;
+	u8 fwi_adc_fo;
+} __packed;
+
+#define PN532_TYPE_B_PROT_FCSI(x) (((x) & 0xF0) >> 4)
+#define PN532_TYPE_B_PROT_TYPE(x) (((x) & 0x0F) >> 0)
+#define PN532_TYPE_B_PROT_TYPE_RFU_MASK 0x8
+
+struct pn532_type_b_sens_res {
+	u8 opcode;
+	u8 nfcid[4];
+	u8 appdata[4];
+	struct pn532_type_b_prot_info prot_info;
+} __packed;
+
+#define PN532_TYPE_B_OPC_SENSB_RES 0x50
+
+struct pn532_target_type_b {
+	struct pn532_type_b_sens_res sensb_res;
+	u8 attrib_res_len;
+	u8 attrib_res[];
+} __packed;
+
+static bool pn532_target_type_b_is_valid(struct pn532_target_type_b *type_b,
+							int target_data_len)
+{
+	if (target_data_len < sizeof(struct pn532_target_type_b))
+		return false;
+
+	if (type_b->sensb_res.opcode != PN532_TYPE_B_OPC_SENSB_RES)
+		return false;
+
+	if (PN532_TYPE_B_PROT_TYPE(type_b->sensb_res.prot_info.fsci_type) &
+						PN532_TYPE_B_PROT_TYPE_RFU_MASK)
+		return false;
+
+	return true;
+}
+
+static int pn532_target_found_type_b(struct nfc_target *nfc_tgt, u8 *tgt_data,
+							int tgt_data_len)
+{
+	struct pn532_target_type_b *tgt_type_b;
+
+	tgt_type_b = (struct pn532_target_type_b *)tgt_data;
+
+	if (!pn532_target_type_b_is_valid(tgt_type_b, tgt_data_len))
+		return -EPROTO;
+
+	nfc_tgt->supported_protocols = NFC_PROTO_ISO14443_B_MASK;
+
+	return 0;
+}
+
+static inline void pn532_poll_next_mod(struct pn532 *dev)
+{
+	dev->poll_mod_curr = (dev->poll_mod_curr + 1) % dev->poll_mod_count;
+}
+
+static void pn532_poll_reset_mod_list(struct pn532 *dev)
+{
+	dev->poll_mod_count = 0;
+}
+
+struct pn532_autopoll_resp {
+	u8 type;
+	u8 ln;
+	u8 tg;
+	u8 tgdata[];
+};
+
+static int pn532_start_poll_complete(struct pn532 *dev, struct sk_buff *resp)
+{
+	u8 nbtg;
+	int rc;
+	struct pn532_autopoll_resp *pres;
+	struct nfc_target *nfc_tgt;
+
+	nbtg = resp->data[0];
+	if ((nbtg > 2) || (nbtg <= 0))
+		return -EAGAIN;
+
+	nfc_tgt = kzalloc(nbtg * sizeof(struct nfc_target), GFP_KERNEL);
+	if (!nfc_tgt)
+		return -ENOMEM;
+
+	pres = (struct pn532_autopoll_resp *)&resp->data[1];
+
+	while (nbtg--) {
+		nfc_dev_dbg(dev->tty->dev, "%s -type=0x%x tg=%d nbtg=%d ln=%d",
+			__func__, pres->type, pres->tg, nbtg, pres->ln);
+
+		if (pres->tg != 1)
+			return -EPROTO;
+
+		switch (pres->type) {
+		case PN532_AUTOPOLL_TYPE_ISOA:
+			nfc_dev_dbg(dev->tty->dev, "ISOA");
+			rc = pn532_target_found_type_a(nfc_tgt, pres->tgdata,
+						       pres->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_FELICA212:
+		case PN532_AUTOPOLL_TYPE_FELICA424:
+			nfc_dev_dbg(dev->tty->dev, "FELICA");
+			rc = pn532_target_found_felica(nfc_tgt, pres->tgdata,
+						       pres->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_JEWEL:
+			nfc_dev_dbg(dev->tty->dev, "JEWEL");
+			rc = pn532_target_found_jewel(nfc_tgt, pres->tgdata,
+						      pres->ln - 1);
+			break;
+		case PN532_AUTOPOLL_TYPE_ISOB:
+			nfc_dev_dbg(dev->tty->dev, "ISOB");
+			rc = pn532_target_found_type_b(nfc_tgt, pres->tgdata,
+						       pres->ln - 1);
+			break;
+		default:
+			nfc_dev_dbg(dev->tty->dev, "default");
+			nfc_dev_err(dev->tty->dev,
+				    "Unknown current poll modulation");
+			return -EPROTO;
+		}
+
+		nfc_dev_dbg(dev->tty->dev, "%s rc:%d", __func__, rc);
+
+		if (rc)
+			return rc;
+
+		if (!(nfc_tgt->supported_protocols & dev->poll_protocols)) {
+			nfc_dev_dbg(dev->tty->dev,
+				    "The Tg found doesn't have the desired protocol");
+			return -EAGAIN;
+		}
+
+		nfc_dev_dbg(dev->tty->dev,
+			    "Target found - supported protocols: 0x%x",
+			    nfc_tgt->supported_protocols);
+
+		dev->tgt_available_prots = nfc_tgt->supported_protocols;
+		pres = (struct pn532_autopoll_resp *)
+					(pres->tgdata + (pres->ln));
+	}
+	nfc_targets_found(dev->nfc_dev, nfc_tgt, resp->data[0]);
+
+	kfree(nfc_tgt);
+	return 0;
+}
+
+static struct sk_buff *pn532_alloc_poll_tg_frame(struct pn532 *dev)
+{
+	struct sk_buff *skb;
+	u8 *felica, *nfcid3, *gb;
+
+	u8 *gbytes = dev->gb;
+	size_t gbytes_len = dev->gb_len;
+
+	u8 felica_params[18] = {0x1, 0xfe, /* DEP */
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, /* random */
+				0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
+				0xff, 0xff}; /* System code */
+
+	u8 mifare_params[6] = {0x1, 0x1, /* SENS_RES */
+			       0x0, 0x0, 0x0,
+			       0x40}; /* SEL_RES for DEP */
+
+	unsigned int skb_len = 36 + /* mode (1), mifare (6),
+				       felica (18), nfcid3 (10), gb_len (1) */
+			       gbytes_len +
+			       1;  /* len Tk*/
+
+	skb = pn532_alloc_skb(dev, skb_len);
+	if (!skb)
+		return NULL;
+
+	/* DEP support only */
+	*skb_put(skb, 1) = PN532_INIT_TARGET_DEP;
+
+	/* MIFARE params */
+	memcpy(skb_put(skb, 6), mifare_params, 6);
+
+	/* Felica params */
+	felica = skb_put(skb, 18);
+	memcpy(felica, felica_params, 18);
+	get_random_bytes(felica + 2, 6);
+
+	/* NFCID3 */
+	nfcid3 = skb_put(skb, 10);
+	memset(nfcid3, 0, 10);
+	memcpy(nfcid3, felica, 8);
+
+	/* General bytes */
+	*skb_put(skb, 1) = gbytes_len;
+
+	gb = skb_put(skb, gbytes_len);
+	memcpy(gb, gbytes, gbytes_len);
+
+	/* Len Tk */
+	*skb_put(skb, 1) = 0;
+
+	return skb;
+}
+
+#define PN532_CMD_DATAEXCH_HEAD_LEN 1
+#define PN532_CMD_DATAEXCH_DATA_MAXLEN 262
+static int pn532_tm_get_data_complete(struct pn532 *dev, void *arg,
+				      struct sk_buff *resp)
+{
+	u8 status;
+
+	if (IS_ERR(resp))
+		return PTR_ERR(resp);
+
+	status = resp->data[0];
+	skb_pull(resp, sizeof(status));
+
+	if (status != 0) {
+		nfc_tm_deactivated(dev->nfc_dev);
+		dev->tgt_mode = 0;
+		dev_kfree_skb(resp);
+		return 0;
+	}
+
+	return nfc_tm_data_received(dev->nfc_dev, resp);
+}
+
+static void pn532_wq_tg_get_data(struct work_struct *work)
+{
+	struct pn532 *dev = container_of(work, struct pn532, tg_work);
+
+	struct sk_buff *skb;
+	int rc;
+
+	skb = pn532_alloc_skb(dev, 0);
+	if (!skb)
+		return;
+
+	rc = pn532_send_data_async(dev, PN532_CMD_TG_GET_DATA, skb,
+				   pn532_tm_get_data_complete, NULL);
+
+	if (rc < 0)
+		dev_kfree_skb(skb);
+
+	return;
+}
+
+static void pn532_listen_mode_timer(unsigned long data)
+{
+	struct pn532 *dev = (struct pn532 *)data;
+
+	nfc_dev_dbg(dev->tty->dev, "Listen mode timeout");
+
+	/* An ack will cancel the last issued command (poll) */
+	pn532_send_ack(dev, GFP_ATOMIC);
+
+	dev->cancel_listen = 1;
+
+	pn532_poll_next_mod(dev);
+
+	queue_work(dev->wq, &dev->poll_work);
+}
+
+static int pn532_poll_complete(struct pn532 *dev, void *arg,
+			       struct sk_buff *resp)
+{
+	int rc;
+
+	nfc_dev_dbg(dev->tty->dev, "%s", __func__);
+
+	if (IS_ERR(resp)) {
+		rc = PTR_ERR(resp);
+
+		nfc_dev_err(dev->tty->dev, "%s  Poll complete error %d",
+			    __func__, rc);
+
+		if (rc == -ENOENT) {
+			if (dev->poll_mod_count != 0)
+				return rc;
+			else
+				goto stop_poll;
+		} else if (rc < 0) {
+			nfc_dev_err(dev->tty->dev,
+				    "Error %d when running poll", rc);
+			goto stop_poll;
+		}
+	}
+
+	rc = pn532_start_poll_complete(dev, resp);
+	if (!rc)
+		goto done;
+
+done:
+	dev_kfree_skb(resp);
+	return rc;
+
+stop_poll:
+	nfc_dev_err(dev->tty->dev, "Polling operation has been stopped");
+
+	pn532_poll_reset_mod_list(dev);
+	dev->poll_protocols = 0;
+	return rc;
+}
+
+static struct sk_buff *pn532_alloc_poll_in_frame(struct pn532 *dev,
+					struct pn532_poll_modulations *mod)
+{
+	struct sk_buff *skb;
+
+	skb = pn532_alloc_skb(dev, mod->len);
+	if (!skb)
+		return NULL;
+
+	memcpy(skb_put(skb, mod->len), &mod->data, mod->len);
+
+	return skb;
+}
+
+static int pn532_send_poll_frame(struct pn532 *dev)
+{
+	struct pn532_poll_modulations *mod;
+	struct sk_buff *skb;
+	int rc;
+	u8 cmd_code;
+
+	mod = dev->poll_mod_active[dev->poll_mod_curr];
+
+	nfc_dev_dbg(dev->tty->dev, "%s mod len %d\n",
+		    __func__, mod->len);
+
+	if (mod->len == 0) {  /* Listen mode */
+		cmd_code = PN532_CMD_TG_INIT_AS_TARGET;
+		skb = pn532_alloc_poll_tg_frame(dev);
+	} else {  /* Polling mode */
+		cmd_code =  PN532_CMD_IN_AUTOPOLL;
+		skb = pn532_alloc_poll_in_frame(dev, mod);
+	}
+
+	if (!skb) {
+		nfc_dev_err(dev->tty->dev, "Failed to allocate skb.");
+		return -ENOMEM;
+	}
+
+	rc = pn532_send_cmd_async(dev, cmd_code, skb, pn532_poll_complete,
+				  NULL);
+	if (rc < 0) {
+		dev_kfree_skb(skb);
+		nfc_dev_err(dev->tty->dev, "Polling loop error %d", rc);
+	}
+
+	return rc;
+}
+
+static void pn532_wq_poll(struct work_struct *work)
+{
+	struct pn532 *dev = container_of(work, struct pn532, poll_work);
+	struct pn532_poll_modulations *cur_mod;
+	int rc;
+
+	cur_mod = dev->poll_mod_active[dev->poll_mod_curr];
+
+	nfc_dev_dbg(dev->tty->dev,
+		    "%s cancel_listen %d modulation len %d",
+		    __func__, dev->cancel_listen, cur_mod->len);
+
+	if (dev->cancel_listen == 1) {
+		dev->cancel_listen = 0;
+		/*
+		usb_kill_urb(dev->in_urb);
+		*/
+	}
+
+	rc = pn532_send_poll_frame(dev);
+	if (rc)
+		return;
+
+	if (cur_mod->len == 0 && dev->poll_mod_count > 1)
+		mod_timer(&dev->listen_timer, jiffies + PN532_LISTEN_TIME * HZ);
+
+	return;
+}
+
+static int pn532_start_auto_poll(struct nfc_dev *nfc_dev,
+			    u32 im_protocols, u32 tm_protocols)
+{
+	struct pn532 *dev = nfc_get_drvdata(nfc_dev);
+	u8	rc;
+	struct sk_buff *skb;
+
+	nfc_dev_dbg(dev->tty->dev,
+		    "%s: im protocols 0x%x tm protocols 0x%x",
+		    __func__, im_protocols, tm_protocols);
+
+	if (dev->tgt_active_prot) {
+		nfc_dev_err(dev->tty->dev,
+			    "Cannot poll with a target already activated");
+		return -EBUSY;
+	}
+
+	if (dev->tgt_mode) {
+		nfc_dev_err(dev->tty->dev,
+			    "Cannot poll while already being activated");
+		return -EBUSY;
+	}
+
+	if (tm_protocols) {
+		dev->gb = nfc_get_local_general_bytes(nfc_dev, &dev->gb_len);
+		if (dev->gb == NULL)
+			tm_protocols = 0;
+	}
+
+	skb = pn532_alloc_skb(dev, 4 + 6);
+	if (!skb) {
+		nfc_dev_err(dev->tty->dev, "Failed to allocate skb.");
+		return -ENOMEM;
+	}
+
+	*skb_put(skb, 1) = PN532_AUTOPOLL_POLLNR_INFINITE;
+	*skb_put(skb, 1) = PN532_AUTOPOLL_PERIOD;
+
+	if ((im_protocols & NFC_PROTO_MIFARE_MASK) ||
+	    (im_protocols & NFC_PROTO_ISO14443_MASK) ||
+	    (im_protocols & NFC_PROTO_NFC_DEP_MASK))
+		*skb_put(skb, 1) = PN532_AUTOPOLL_TYPE_ISOA;
+
+	if (im_protocols & NFC_PROTO_FELICA_MASK ||
+	    im_protocols & NFC_PROTO_NFC_DEP_MASK) {
+		*skb_put(skb, 1) = PN532_AUTOPOLL_TYPE_FELICA212;
+		*skb_put(skb, 1) = PN532_AUTOPOLL_TYPE_FELICA424;
+	}
+
+	if (im_protocols & NFC_PROTO_JEWEL_MASK)
+		*skb_put(skb, 1) = PN532_AUTOPOLL_TYPE_JEWEL;
+
+	if (im_protocols & NFC_PROTO_ISO14443_B_MASK)
+		*skb_put(skb, 1) = PN532_AUTOPOLL_TYPE_ISOB;
+
+	if (tm_protocols)
+		*skb_put(skb, 1) = PN532_AUTOPOLL_TYPE_DEP_PASSIVE_106;
+
+	rc = pn532_send_cmd_async(dev, PN532_CMD_IN_AUTOPOLL, skb,
+				  pn532_poll_complete, NULL);
+	if (rc < 0) {
+		dev_kfree_skb(skb);
+		nfc_dev_err(dev->tty->dev, "Error setting up autopoll %d", rc);
+	}
+	dev->poll_protocols = im_protocols;
+	dev->listen_protocols = tm_protocols;
+	return rc;
+}
+
+static void pn532_stop_poll(struct nfc_dev *nfc_dev)
+{
+	struct pn532 *dev = nfc_get_drvdata(nfc_dev);
+
+	del_timer(&dev->listen_timer);
+
+	if (!dev->poll_mod_count) {
+		nfc_dev_dbg(dev->tty->dev,
+			    "Polling operation was not running");
+		return;
+	}
+
+	/* An ack will cancel the last issued command (poll) */
+	pn532_send_ack(dev, GFP_KERNEL);
+
+	/* prevent pn532_start_poll_complete to issue a new poll meanwhile */
+	/*
+	dev->rbuf = NULL;
+	*/
+
+	pn532_poll_reset_mod_list(dev);
+}
+
+static int pn532_activate_target_nfcdep(struct pn532 *dev)
+{
+	struct pn532_cmd_activate_response *rsp;
+	u16 gt_len;
+	int rc;
+
+	struct sk_buff *skb;
+	struct sk_buff *resp;
+
+	skb = pn532_alloc_skb(dev, sizeof(u8) * 2); /*TG + Next*/
+	if (!skb)
+		return -ENOMEM;
+
+	*skb_put(skb, sizeof(u8)) = 1; /* TG */
+	*skb_put(skb, sizeof(u8)) = 0; /* Next */
+
+	resp = pn532_send_cmd_sync(dev, PN532_CMD_IN_ATR, skb);
+	if (IS_ERR(resp))
+		return PTR_ERR(resp);
+
+	rsp = (struct pn532_cmd_activate_response *)resp->data;
+	rc = rsp->status & PN532_CMD_RET_MASK;
+	if (rc != PN532_CMD_RET_SUCCESS) {
+		dev_kfree_skb(resp);
+		return -EIO;
+	}
+
+	/* ATR_RES general bytes are located at offset 16 */
+	gt_len = resp->len - 16;
+	rc = nfc_set_remote_general_bytes(dev->nfc_dev, rsp->gt, gt_len);
+
+	dev_kfree_skb(resp);
+	return rc;
+}
+
+static int pn532_activate_target(struct nfc_dev *nfc_dev,
+				 struct nfc_target *target, u32 protocol)
+{
+	struct pn532 *dev = nfc_get_drvdata(nfc_dev);
+	int rc;
+
+	nfc_dev_dbg(dev->tty->dev, "%s - protocol=%u", __func__,
+		    protocol);
+
+	if (dev->poll_mod_count) {
+		nfc_dev_err(dev->tty->dev,
+			    "Cannot activate while polling");
+		return -EBUSY;
+	}
+
+	if (dev->tgt_active_prot) {
+		nfc_dev_err(dev->tty->dev,
+			    "There is already an active target");
+		return -EBUSY;
+	}
+
+	if (!dev->tgt_available_prots) {
+		nfc_dev_err(dev->tty->dev,
+			    "There is no available target to activate");
+		return -EINVAL;
+	}
+
+	if (!(dev->tgt_available_prots & (1 << protocol))) {
+		nfc_dev_err(dev->tty->dev,
+			    "Target doesn't support requested proto %u",
+			    protocol);
+		return -EINVAL;
+	}
+
+	if (protocol == NFC_PROTO_NFC_DEP) {
+		rc = pn532_activate_target_nfcdep(dev);
+		if (rc) {
+			nfc_dev_err(dev->tty->dev,
+				    "Activating target with DEP failed %d", rc);
+			return rc;
+		}
+	}
+
+	dev->tgt_active_prot = protocol;
+	dev->tgt_available_prots = 0;
+
+	return 0;
+}
+
+static void pn532_wq_deactivate_tgt(struct work_struct *work)
+{
+	struct pn532 *dev =
+		container_of(work, struct pn532, deactivate_tgt_work);
+	struct sk_buff *skb;
+	struct sk_buff *resp;
+
+	int rc;
+
+	if (!dev->tgt_active_prot) {
+		nfc_dev_err(dev->tty->dev, "There is no active target");
+		return;
+	}
+
+	dev->tgt_active_prot = 0;
+	skb_queue_purge(&dev->resp_q);
+
+	skb = pn532_alloc_skb(dev, sizeof(u8));
+	if (!skb)
+		return;
+
+	*skb_put(skb, 1) = 1; /* TG*/
+
+	resp = pn532_send_cmd_sync(dev, PN532_CMD_IN_RELEASE, skb);
+	if (IS_ERR(resp))
+		return;
+
+	rc = resp->data[0] & PN532_CMD_RET_MASK;
+	if (rc != PN532_CMD_RET_SUCCESS)
+		nfc_dev_err(dev->tty->dev,
+			    "Error 0x%x when releasing the target", rc);
+
+	dev_kfree_skb(resp);
+	return;
+}
+
+static void pn532_deactivate_target(struct nfc_dev *nfc_dev,
+				    struct nfc_target *target)
+{
+	struct pn532 *dev = nfc_get_drvdata(nfc_dev);
+
+	queue_work(dev->wq_deactivate_tgt, &dev->deactivate_tgt_work);
+}
+
+
+static int pn532_in_dep_link_up_complete(struct pn532 *dev, void *arg,
+					 struct sk_buff *resp)
+{
+	struct pn532_cmd_jump_dep_response *rsp;
+	u8 target_gt_len;
+	int rc;
+	u8 active = *(u8 *)arg;
+
+	kfree(arg);
+
+	if (IS_ERR(resp))
+		return PTR_ERR(resp);
+
+	if (dev->tgt_available_prots &&
+	    !(dev->tgt_available_prots & (1 << NFC_PROTO_NFC_DEP))) {
+		nfc_dev_err(dev->tty->dev,
+			    "The target does not support DEP");
+		rc =  -EINVAL;
+		goto error;
+	}
+
+	rsp = (struct pn532_cmd_jump_dep_response *)resp->data;
+
+	rc = rsp->status & PN532_CMD_RET_MASK;
+	if (rc != PN532_CMD_RET_SUCCESS) {
+		nfc_dev_err(dev->tty->dev,
+			    "Bringing DEP link up failed %d", rc);
+		goto error;
+	}
+
+	if (!dev->tgt_available_prots) {
+		struct nfc_target nfc_target;
+
+		nfc_dev_dbg(dev->tty->dev, "Creating new target");
+
+		nfc_target.supported_protocols = NFC_PROTO_NFC_DEP_MASK;
+		nfc_target.nfcid1_len = 10;
+		memcpy(nfc_target.nfcid1, rsp->nfcid3t, nfc_target.nfcid1_len);
+		rc = nfc_targets_found(dev->nfc_dev, &nfc_target, 1);
+		if (rc)
+			goto error;
+
+		dev->tgt_available_prots = 0;
+	}
+
+	dev->tgt_active_prot = NFC_PROTO_NFC_DEP;
+
+	/* ATR_RES general bytes are located at offset 17 */
+	target_gt_len = resp->len - 17;
+	rc = nfc_set_remote_general_bytes(dev->nfc_dev,
+					  rsp->gt, target_gt_len);
+	if (rc == 0)
+		rc = nfc_dep_link_is_up(dev->nfc_dev,
+					dev->nfc_dev->targets[0].idx,
+					!active, NFC_RF_INITIATOR);
+
+error:
+	dev_kfree_skb(resp);
+	return rc;
+}
+
+static int pn532_mod_to_baud(struct pn532 *dev)
+{
+	switch (dev->poll_mod_curr) {
+	case PN532_POLL_MOD_106KBPS_A:
+		return 0;
+	case PN532_POLL_MOD_212KBPS_FELICA:
+		return 1;
+	case PN532_POLL_MOD_424KBPS_FELICA:
+		return 2;
+	default:
+		return -EINVAL;
+	}
+}
+
+#define PASSIVE_DATA_LEN 5
+static int pn532_dep_link_up(struct nfc_dev *nfc_dev, struct nfc_target *target,
+			     u8 comm_mode, u8 *gb, size_t gb_len)
+{
+	struct pn532 *dev = nfc_get_drvdata(nfc_dev);
+	struct sk_buff *skb;
+	int rc, baud, skb_len;
+	u8 *next, *arg;
+
+	u8 passive_data[PASSIVE_DATA_LEN] = {0x00, 0xff, 0xff, 0x00, 0x3};
+
+	if (dev->poll_mod_count) {
+		nfc_dev_err(dev->tty->dev,
+			    "Cannot bring the DEP link up while polling");
+		return -EBUSY;
+	}
+
+	if (dev->tgt_active_prot) {
+		nfc_dev_err(dev->tty->dev,
+			    "There is already an active target");
+		return -EBUSY;
+	}
+
+	baud = pn532_mod_to_baud(dev);
+	if (baud < 0) {
+		nfc_dev_err(dev->tty->dev,
+			    "Invalid curr modulation %d", dev->poll_mod_curr);
+		return baud;
+	}
+
+	skb_len = 3 + gb_len; /* ActPass + BR + Next */
+	if (comm_mode == NFC_COMM_PASSIVE)
+		skb_len += PASSIVE_DATA_LEN;
+
+	skb = pn532_alloc_skb(dev, skb_len);
+	if (!skb)
+		return -ENOMEM;
+
+	*skb_put(skb, 1) = !comm_mode;  /* ActPass */
+	*skb_put(skb, 1) = baud;  /* Baud rate */
+
+	next = skb_put(skb, 1);  /* Next */
+	*next = 0;
+
+	if (comm_mode == NFC_COMM_PASSIVE && baud > 0) {
+		memcpy(skb_put(skb, PASSIVE_DATA_LEN), passive_data,
+		       PASSIVE_DATA_LEN);
+		*next |= 1;
+	}
+
+	if (gb != NULL && gb_len > 0) {
+		memcpy(skb_put(skb, gb_len), gb, gb_len);
+		*next |= 4; /* We have some Gi */
+	} else {
+		*next = 0;
+	}
+
+	arg = kmalloc(sizeof(*arg), GFP_KERNEL);
+	if (!arg) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	*arg = !comm_mode;
+
+	rc = pn532_send_cmd_async(dev, PN532_CMD_IN_JUMP_FOR_DEP, skb,
+				  pn532_in_dep_link_up_complete, arg);
+
+	if (rc < 0) {
+		dev_kfree_skb(skb);
+		kfree(arg);
+	}
+
+	return rc;
+}
+
+static int pn532_dep_link_down(struct nfc_dev *nfc_dev)
+{
+	struct pn532 *dev = nfc_get_drvdata(nfc_dev);
+
+	pn532_poll_reset_mod_list(dev);
+
+	if (dev->tgt_mode || dev->tgt_active_prot) {
+		pn532_send_ack(dev, GFP_KERNEL);
+		dev->rbuf = NULL;
+	}
+
+	dev->tgt_active_prot = 0;
+	dev->tgt_mode = 0;
+
+	skb_queue_purge(&dev->resp_q);
+
+	return 0;
+}
+
+struct pn532_data_exchange_arg {
+	data_exchange_cb_t cb;
+	void *cb_context;
+};
+
+static struct sk_buff *pn532_build_response(struct pn532 *dev)
+{
+	struct sk_buff *skb, *tmp, *t;
+	unsigned int skb_len = 0, tmp_len = 0;
+
+	if (skb_queue_empty(&dev->resp_q))
+		return NULL;
+
+	if (skb_queue_len(&dev->resp_q) == 1) {
+		skb = skb_dequeue(&dev->resp_q);
+		goto out;
+	}
+
+	skb_queue_walk_safe(&dev->resp_q, tmp, t)
+		skb_len += tmp->len;
+
+	skb = alloc_skb(skb_len, GFP_KERNEL);
+	if (skb == NULL)
+		goto out;
+
+	skb_put(skb, skb_len);
+
+	skb_queue_walk_safe(&dev->resp_q, tmp, t) {
+		memcpy(skb->data + tmp_len, tmp->data, tmp->len);
+		tmp_len += tmp->len;
+	}
+
+out:
+	skb_queue_purge(&dev->resp_q);
+
+	return skb;
+}
+
+static int pn532_data_exchange_complete(struct pn532 *dev, void *_arg,
+					struct sk_buff *resp)
+{
+	struct pn532_data_exchange_arg *arg = _arg;
+	struct sk_buff *skb;
+	int rc = 0;
+	u8 status, ret, mi;
+
+	if (IS_ERR(resp)) {
+		rc = PTR_ERR(resp);
+		goto _error;
+	}
+
+	status = resp->data[0];
+	ret = status & PN532_CMD_RET_MASK;
+	mi = status & PN532_CMD_MI_MASK;
+
+	skb_pull(resp, sizeof(status));
+
+	if (ret != PN532_CMD_RET_SUCCESS) {
+		nfc_dev_err(dev->tty->dev,
+			    "PN532 reported error %d when exchanging data",
+			    ret);
+		rc = -EIO;
+		goto error;
+	}
+
+	skb_queue_tail(&dev->resp_q, resp);
+
+	if (mi) {
+		dev->cmd_complete_mi_arg = arg;
+		queue_work(dev->wq, &dev->mi_work);
+		return -EINPROGRESS;
+	}
+
+	skb = pn532_build_response(dev);
+	if (!skb)
+		goto error;
+
+	arg->cb(arg->cb_context, skb, 0);
+	kfree(arg);
+	return 0;
+
+error:
+	dev_kfree_skb(resp);
+_error:
+	skb_queue_purge(&dev->resp_q);
+	arg->cb(arg->cb_context, NULL, rc);
+	kfree(arg);
+	return rc;
+}
+
+static int pn532_transceive(struct nfc_dev *nfc_dev,
+			    struct nfc_target *target, struct sk_buff *skb,
+			    data_exchange_cb_t cb, void *cb_context)
+{
+	struct pn532 *dev = nfc_get_drvdata(nfc_dev);
+	struct pn532_data_exchange_arg *arg = NULL;
+	int rc;
+
+	nfc_dev_dbg(dev->tty->dev, "%s", __func__);
+
+	if (skb->len > PN532_CMD_DATAEXCH_DATA_MAXLEN) {
+		/* TODO: Implement support to multi-part data exchange */
+		nfc_dev_err(dev->tty->dev,
+			    "Data length greater than the max allowed: %d",
+			    PN532_CMD_DATAEXCH_DATA_MAXLEN);
+		rc = -ENOSYS;
+		goto error;
+	}
+
+	if (!dev->tgt_active_prot) {
+		nfc_dev_err(dev->tty->dev,
+			    "Can't exchange data if there is no active target");
+		rc = -EINVAL;
+		goto error;
+	}
+
+	arg = kmalloc(sizeof(*arg), GFP_KERNEL);
+	if (!arg) {
+		rc = -ENOMEM;
+		goto error;
+	}
+
+	arg->cb = cb;
+	arg->cb_context = cb_context;
+
+	*skb_push(skb, sizeof(u8)) =  1; /*TG*/
+
+	rc = pn532_send_data_async(dev, PN532_CMD_IN_DATA_EXCHANGE,
+				   skb, pn532_data_exchange_complete,
+				   arg);
+
+	if (rc < 0) /* rc from send_async */
+		goto error;
+
+	return 0;
+
+error:
+	kfree(arg);
+	dev_kfree_skb(skb);
+	return rc;
+}
+
+static int pn532_tm_send_complete(struct pn532 *dev, void *arg,
+				  struct sk_buff *resp)
+{
+	u8 status;
+
+	if (IS_ERR(resp))
+		return PTR_ERR(resp);
+
+	status = resp->data[0];
+
+	dev_kfree_skb(resp);
+
+	if (status != 0) {
+		nfc_tm_deactivated(dev->nfc_dev);
+
+		dev->tgt_mode = 0;
+
+		return 0;
+	}
+
+	queue_work(dev->wq, &dev->tg_work);
+
+	return 0;
+}
+
+static int pn532_tm_send(struct nfc_dev *nfc_dev, struct sk_buff *skb)
+{
+	struct pn532 *dev = nfc_get_drvdata(nfc_dev);
+	int rc;
+
+	if (skb->len > PN532_CMD_DATAEXCH_DATA_MAXLEN) {
+		nfc_dev_err(dev->tty->dev,
+			    "Data length greater than the max allowed: %d",
+			    PN532_CMD_DATAEXCH_DATA_MAXLEN);
+		return -ENOSYS;
+	}
+
+	rc = pn532_send_data_async(dev, PN532_CMD_TG_SET_DATA, skb,
+				   pn532_tm_send_complete, NULL);
+	if (rc < 0)
+		dev_kfree_skb(skb);
+
+	return rc;
+}
+
+static void pn532_wq_mi_recv(struct work_struct *work)
+{
+	struct pn532 *dev = container_of(work, struct pn532, mi_work);
+
+	struct sk_buff *skb;
+	int rc;
+
+	skb = pn532_alloc_skb(dev, PN532_CMD_DATAEXCH_HEAD_LEN);
+	if (!skb)
+		goto error;
+
+	*skb_put(skb, sizeof(u8)) =  1; /*TG*/
+
+	rc = pn532_send_cmd_direct_async(dev,
+					 PN532_CMD_IN_DATA_EXCHANGE,
+					 skb,
+					 pn532_data_exchange_complete,
+					 dev->cmd_complete_mi_arg);
+
+	if (rc == 0) /* success */
+		return;
+
+	nfc_dev_err(dev->tty->dev,
+		    "Error %d when trying to perform data_exchange", rc);
+
+	dev_kfree_skb(skb);
+	kfree(dev->cmd_complete_arg);
+
+error:
+	pn532_send_ack(dev, GFP_KERNEL);
+	queue_work(dev->wq, &dev->cmd_work);
+}
+
+static int pn532_set_configuration(struct pn532 *dev, u8 cfgitem, u8 *cfgdata,
+								u8 cfgdata_len)
+{
+	struct sk_buff *skb;
+	struct sk_buff *resp;
+
+	int skb_len;
+
+	skb_len = sizeof(cfgitem) + cfgdata_len; /* cfgitem + cfgdata */
+
+	skb = pn532_alloc_skb(dev, skb_len);
+	if (!skb)
+		return -ENOMEM;
+
+	*skb_put(skb, sizeof(cfgitem)) = cfgitem;
+	memcpy(skb_put(skb, cfgdata_len), cfgdata, cfgdata_len);
+
+	resp = pn532_send_cmd_sync(dev, PN532_CMD_RF_CONFIGURATION, skb);
+	if (IS_ERR(resp))
+		return PTR_ERR(resp);
+
+	dev_kfree_skb(resp);
+	return 0;
+}
+
+static int pn532_get_firmware_version(struct pn532 *dev,
+				      struct pn532_fw_version *fv)
+{
+	struct sk_buff *skb;
+	struct sk_buff *resp;
+
+	skb = pn532_alloc_skb(dev, 0);
+	if (!skb)
+		return -ENOMEM;
+
+	resp = pn532_send_cmd_sync(dev, PN532_CMD_GET_FIRMWARE_VERSION, skb);
+	if (IS_ERR(resp))
+		return PTR_ERR(resp);
+
+	fv->ic = resp->data[0];
+	fv->ver = resp->data[1];
+	fv->rev = resp->data[2];
+	fv->support = resp->data[3];
+
+	dev_kfree_skb(resp);
+	return 0;
+}
+
+static int pn532_sam_configuration(struct pn532 *dev)
+{
+	struct sk_buff *skb;
+	struct sk_buff *resp;
+
+	skb = pn532_alloc_skb(dev, sizeof(u8));
+	if (!skb)
+		return -ENOMEM;
+
+	*skb_put(skb, sizeof(u8)) = 0x01; /* Mode(timeout and IRQ left out) */
+
+	resp = pn532_send_cmd_sync(dev, PN532_CMD_SAM_CONFIGURATION, skb);
+	if (IS_ERR(resp))
+		return PTR_ERR(resp);
+
+	dev_kfree_skb(resp);
+
+	return 0;
+}
+
+static struct nfc_ops pn532_nfc_ops = {
+	/* TODO implement dev_up und dev_down */
+	.dev_up = NULL,
+	.dev_down = NULL,
+	.dep_link_up = pn532_dep_link_up,
+	.dep_link_down = pn532_dep_link_down,
+	.start_poll = pn532_start_auto_poll,
+	.stop_poll = pn532_stop_poll,
+	.activate_target = pn532_activate_target,
+	.deactivate_target = pn532_deactivate_target,
+	.im_transceive = pn532_transceive,
+	.tm_send = pn532_tm_send,
+};
+
+static int pn532_setup(struct pn532 *dev)
+{
+	struct pn532_config_max_retries max_retries;
+	struct pn532_config_timing timing;
+	int rc;
+
+	max_retries.mx_rty_atr = PN532_CONFIG_MAX_RETRIES_ENDLESS;
+	max_retries.mx_rty_psl = 2;
+	max_retries.mx_rty_passive_act = PN532_CONFIG_MAX_RETRIES_NO_RETRY;
+
+	timing.rfu = PN532_CONFIG_TIMING_102;
+	timing.atr_res_timeout = PN532_CONFIG_TIMING_204;
+	timing.dep_timeout = PN532_CONFIG_TIMING_409;
+
+	rc = pn532_set_configuration(dev, PN532_CFGITEM_MAX_RETRIES,
+				     (u8 *)&max_retries, sizeof(max_retries));
+	if (rc) {
+		nfc_dev_err(dev->tty->dev,
+			    "Error on setting MAX_RETRIES config");
+		return rc;
+	}
+
+
+	rc = pn532_set_configuration(dev, PN532_CFGITEM_TIMING,
+				     (u8 *)&timing, sizeof(timing));
+	if (rc) {
+		nfc_dev_err(dev->tty->dev,
+			    "Error on setting RF timings");
+		return rc;
+	}
+
+	return 0;
+}
+
+static void pn532_connect_nfc(struct work_struct *work)
+{
+	struct pn532 *dev = container_of(work, struct pn532, conn_nfc_work);
+	struct pn532_fw_version fw_ver;
+	int rc = -ENOMEM;
+
+	if (dev == NULL || dev->tty == NULL || dev->tty->dev == NULL)
+		return;
+
+	mutex_init(&dev->cmd_lock);
+
+	INIT_WORK(&dev->cmd_work, pn532_wq_cmd);
+	INIT_WORK(&dev->cmd_complete_work, pn532_wq_cmd_complete);
+	INIT_WORK(&dev->mi_work, pn532_wq_mi_recv);
+	INIT_WORK(&dev->tg_work, pn532_wq_tg_get_data);
+	INIT_WORK(&dev->poll_work, pn532_wq_poll);
+	INIT_WORK(&dev->deactivate_tgt_work, pn532_wq_deactivate_tgt);
+	dev->wq = alloc_ordered_workqueue("pn532", 0);
+	if (dev->wq == NULL)
+		return;
+
+	dev->wq_deactivate_tgt = alloc_workqueue("pn532_add", 0, 0);
+	if (dev->wq_deactivate_tgt == NULL) {
+		destroy_workqueue(dev->wq);
+		return;
+	}
+
+	init_timer(&dev->listen_timer);
+	dev->listen_timer.data = (unsigned long) dev;
+	dev->listen_timer.function = pn532_listen_mode_timer;
+
+	skb_queue_head_init(&dev->resp_q);
+
+	INIT_LIST_HEAD(&dev->cmd_queue);
+
+	dev->ops = &pn532_std_frame_ops;
+
+	dev->wakeup = 1;
+	rc = pn532_sam_configuration(dev);
+
+	if (rc < 0) {
+		destroy_workqueue(dev->wq_deactivate_tgt);
+		destroy_workqueue(dev->wq);
+		return;
+	}
+
+	memset(&fw_ver, 0, sizeof(fw_ver));
+	rc = pn532_get_firmware_version(dev, &fw_ver);
+	if (rc < 0) {
+		destroy_workqueue(dev->wq_deactivate_tgt);
+		destroy_workqueue(dev->wq);
+		return;
+	}
+
+	nfc_dev_info(dev->tty->dev,
+		     "NXP PN532 firmware ver %d.%d now attached",
+		     fw_ver.ver, fw_ver.rev);
+
+
+	dev->nfc_dev = nfc_allocate_device(&pn532_nfc_ops, PN532_ALL_PROTOCOLS,
+					   dev->ops->tx_header_len +
+					   PN532_CMD_DATAEXCH_HEAD_LEN,
+					   dev->ops->tx_tail_len);
+	if (!dev->nfc_dev) {
+		destroy_workqueue(dev->wq_deactivate_tgt);
+		destroy_workqueue(dev->wq);
+		return;
+	}
+
+	nfc_set_parent_dev(dev->nfc_dev, dev->tty->dev);
+	nfc_set_drvdata(dev->nfc_dev, dev);
+
+	rc = nfc_register_device(dev->nfc_dev);
+	if (rc)
+		goto free_nfc_dev;
+
+	rc = pn532_setup(dev);
+	if (rc)
+		goto unregister_nfc_dev;
+
+	destroy_workqueue(dev->wq_conn_nfc);
+	return;
+
+unregister_nfc_dev:
+	nfc_unregister_device(dev->nfc_dev);
+
+free_nfc_dev:
+	nfc_free_device(dev->nfc_dev);
+}
+
+/*
+ * line discipline
+ */
+
+/*
+ * scans the buffer if it contains a pn532 frame. It is not checked if it is
+ * valid. This could be done with pn532_rx_frame_is_valid. It therefore does
+ * not require, that the frame starts at the beginning of the buffer.
+ * This is useful for malformed or errornous transmitted frames. Returns the
+ * bufferposition where the frame starts.
+ */
+static struct pn532_frame *pn532_rx_is_frame(unsigned char *buf, u8 buf_len)
+{
+	int i;
+	u16 frame_len;
+	u16 *flp;
+
+	/* minimal frame length = 5 */
+	for (i = 0; i + 4 < buf_len; i++) {
+		/* search start code */
+		if (buf[i] == 0x00 &&
+			buf[i + 1] == 0x00 &&
+			buf[i + 2] == 0xff) {
+			/* type */
+			switch (buf[i + 3]) {
+			case 0x00: /* ACK frame ? */
+				if (buf[i + 4] == 0xff)
+					return (struct pn532_frame *) &buf[i];
+				break;
+			case 0x01: /* error frame */
+				if ((buf[i + 4] == 0xff) &&
+					(buf_len >= 6))
+					return (struct pn532_frame *) &buf[i];
+				break;
+			case 0xff: /* extended frame ?*/
+				flp = (u16 *)&buf[i + 5];
+				frame_len = be16_to_cpu(*flp);
+				if (buf_len >= frame_len + 9)
+					return (struct pn532_frame *) &buf[i];
+				break;
+			default: /* normal information frame */
+				frame_len = buf[i + 3];
+				if (buf_len >= frame_len + 6)
+					return (struct pn532_frame *) &buf[i];
+				break;
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static void pn532_receive_buf(struct tty_struct *tty,
+			      const unsigned char *cp, char *fp, int count)
+{
+	struct pn532_frame *frame;
+	struct pn532 *dev = (struct pn532 *)tty->disc_data;
+	unsigned char c;
+
+	nfc_dev_dbg(dev->tty->dev, "count:%i rbuf:%p rlen:%i rcount:%i",
+		count, dev->rbuf, dev->rlen, dev->rcount);
+
+	print_hex_dump(KERN_DEBUG, "frischRX: ", DUMP_PREFIX_NONE, 16, 1,
+		       cp, count, false);
+
+	if (!dev || dev->magic != PN532_MAGIC || dev->rbuf == NULL)
+		return;
+
+	while (count-- && (dev->rlen - dev->rcount > 0)) {
+		if (fp && *fp++) {
+			/*
+			if (!test_and_set_bit(PN532_ERROR, &dev->flags))
+			{
+				// TODO handle error
+			}
+			*/
+			cp++;
+			continue;
+		}
+		c = *cp++;
+		/*
+		if (c != 0)
+			continue;
+		*/
+
+		dev->rbuf[dev->rcount] = c;
+		frame = pn532_rx_is_frame(dev->rbuf, dev->rcount++);
+
+		if (frame != NULL)
+			if (!dev->recv_complete(dev, frame))
+				dev->rcount = 0;
+	}
+}
+
+static void pn532_write_wakeup(struct tty_struct *tty)
+{
+	int actual;
+	struct pn532 *pn532 = (struct pn532 *)tty->disc_data;
+
+	if (!pn532 || pn532->magic != PN532_MAGIC)
+		return;
+
+	if (pn532->xleft <= 0) {
+		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+		return;
+	}
+
+	actual = tty->ops->write(tty, pn532->xhead, pn532->xleft);
+	pn532->xleft -= actual;
+	pn532->xhead += actual;
+}
+
+static int pn532_open(struct tty_struct *tty)
+{
+	struct pn532 *pn532;
+	int err;
+
+	if (tty->ops->write == NULL)
+		return -EOPNOTSUPP;
+
+	/*
+	mutex_lock();
+	*/
+
+	pn532 = tty->disc_data;
+
+	err = -EEXIST;
+	/* First make sure we're not already connected. */
+	if (pn532 && pn532->magic == PN532_MAGIC)
+		goto err_exit;
+
+	err = -ENFILE;
+	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
+	if (pn532 == NULL)
+		goto err_exit;
+
+	pn532->tty = tty;
+
+	INIT_WORK(&pn532->conn_nfc_work, pn532_connect_nfc);
+	pn532->wq_conn_nfc = alloc_workqueue("pn532_connect_nfc", 0, 0);
+	if (pn532->wq_conn_nfc == NULL)
+		goto err_free;
+
+	tty->disc_data = pn532;
+
+	/* Done.  We have linked the TTY line to a channel. */
+	/*
+	mutex_unlock();
+	*/
+	tty->receive_room = 65536;	/* We don't flow control */
+
+	queue_work(pn532->wq_conn_nfc, &pn532->conn_nfc_work);
+	pn532->magic = PN532_MAGIC;
+	/* TTY layer expects 0 on success */
+	return 0;
+
+err_free:
+	kfree(pn532);
+err_exit:
+	/*
+	mutex_unlock();
+	*/
+
+	/* Count references from TTY module */
+	return err;
+}
+
+static void pn532_close(struct tty_struct *tty)
+{
+	struct pn532 *pn532 = (struct pn532 *) tty->disc_data;
+	struct pn532_cmd *cmd, *n;
+
+	/* First make sure we're connected. */
+	if (!pn532 || pn532->magic != PN532_MAGIC || pn532->tty != tty)
+		return;
+
+	if (pn532->nfc_dev) {
+		destroy_workqueue(pn532->wq_deactivate_tgt);
+		destroy_workqueue(pn532->wq);
+
+		nfc_unregister_device(pn532->nfc_dev);
+		nfc_free_device(pn532->nfc_dev);
+
+		skb_queue_purge(&pn532->resp_q);
+
+		del_timer(&pn532->listen_timer);
+
+		list_for_each_entry_safe(cmd, n, &pn532->cmd_queue, queue) {
+			list_del(&cmd->queue);
+			kfree(cmd);
+		}
+		nfc_dev_info(pn532->tty->dev, "NXP PN532 NFC device disconnected");
+	}
+	tty->disc_data = NULL;
+
+	kfree(pn532);
+}
+
+static int pn532_hangup(struct tty_struct *tty)
+{
+	pn532_close(tty);
+	return 0;
+}
+
+/* Perform I/O control on an active SLCAN channel. */
+static int pn532_ioctl(struct tty_struct *tty, struct file *file,
+		       unsigned int cmd, unsigned long arg)
+{
+	struct pn532 *pn532 = (struct pn532 *) tty->disc_data;
+	unsigned int tmp;
+
+	/* First make sure we're connected. */
+	if (!pn532 || pn532->magic != PN532_MAGIC)
+		return -EINVAL;
+
+	switch (cmd) {
+	case SIOCGIFNAME:
+		if (!pn532->nfc_dev)
+			return -EINVAL;
+		tmp = strlen(nfc_device_name(pn532->nfc_dev)) + 1;
+		if (copy_to_user((void __user *)arg,
+					nfc_device_name(pn532->nfc_dev), tmp))
+			return -EFAULT;
+		return 0;
+
+	case SIOCSIFHWADDR:
+		return -EINVAL;
+
+	default:
+		return tty_mode_ioctl(tty, file, cmd, arg);
+	}
+}
+
+static struct tty_ldisc_ops pn532_ldisc = {
+	.owner		= THIS_MODULE,
+	.magic		= TTY_LDISC_MAGIC,
+	.name		= "pn532",
+	.open		= pn532_open,
+	.close		= pn532_close,
+	.hangup		= pn532_hangup,
+	.ioctl		= pn532_ioctl,
+	.receive_buf	= pn532_receive_buf,
+	.write_wakeup	= pn532_write_wakeup,
+};
+
+static int __init pn532_init(void)
+{
+	int ret;
+
+	ret = tty_register_ldisc(N_PN532, &pn532_ldisc);
+	if (ret)
+		pr_err("pn532: can not register line discipline\n");
+
+	return ret;
+}
+
+static void __exit pn532_exit(void)
+{
+	int ret;
+
+	ret = tty_unregister_ldisc(N_PN532);
+	if (ret)
+		pr_err("pn532: can not unregister ldisc (err %d)\n", ret);
+}
+
+module_init(pn532_init);
+module_exit(pn532_exit);
+
+MODULE_ALIAS_LDISC(N_PN532);
+MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
+MODULE_DESCRIPTION(DESCRIPTION);
+MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/tty.h b/include/uapi/linux/tty.h
index dac199a..e6b6d77 100644
--- a/include/uapi/linux/tty.h
+++ b/include/uapi/linux/tty.h
@@ -34,5 +34,6 @@
 #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
 #define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
 #define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
+#define N_PN532		25	/* NXP PN532 NFC chip */
 
 #endif /* _UAPI_LINUX_TTY_H */
-- 
1.7.10.4

