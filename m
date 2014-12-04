Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaLDK2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:28:15 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:65057 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaLDKWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:22:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, Angus Clark <angus.clark@st.com>
Subject: [PATCH v2 RESEND 01/11] mtd: st_spi_fsm: Extend fsm_clear_fifo to handle unwanted bytes
Date: Thu,  4 Dec 2014 10:21:42 +0000
Message-Id: <1417688512-7644-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
References: <1417688512-7644-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under certain conditions, the SPI-FSM Controller can be left in a state where
the data FIFO is not entirely empty.  This can lead to problems where subsequent
data transfers appear to have been shifted by a number of unidentified bytes.

One simple example would be an errant FSM sequence which loaded more data to the
FIFO than was read by the host.  Another more interesting case results from an
obscure artefact in the FSM Controller.  When switching from data transfers in
x4 or x2 mode to data transfers in x1 mode, extraneous bytes will appear in the
FIFO, unless the previous data transfer was a multiple of 32 cycles (i.e. 8
bytes for x2, and 16 bytes for x4).  This applies equally whether FSM is being
operated directly by a S/W driver, or by the SPI boot-controller in FSM-Boot
mode.  Furthermore, data in the FIFO not only survive a transition between
FSM-Boot and FSM, but also a S/W reset of IP block [1].

By taking certain precautions, it is possible to prevent the driver from causing
this type of problem (e.g. ensuring that the host and programmed sequence
agree on the transfer size, and restricting transfer sizes to multiples of
32-cycles [2]).  However, at the point the driver is loaded, no assumptions can be
made regarding the state of the FIFO.  Even if previous S/W drivers have behaved
correctly, it is impossible to control the number of transactions serviced by
the controller operating in FSM-Boot.

To address this problem, we ensure the FIFO is cleared during initialisation,
before performing any FSM operations.  Previously, the fsm_clear_fifo() code was
capable of detecting and clearing any unwanted 32-bit words from the FIFO.  This
patch extends the capability to handle an arbitrary number of bytes present in
the FIFO [3].  Now that the issue is better understood, we also remove the calls
to fsm_clear_fifo() following the fsm_read() and fsm_write() operations.

The process of actually clearing the FIFO deserves a mention.  While the FIFO
may contain any number of bytes, the SPI_FAST_SEQ_STA register only reports the
number of complete 32-bit words present.  Furthermore, data can only be drained
from the FIFO by reading complete 32-bit words.  With this in mind, a two stage
process is used to the clear the FIFO:

    1. Read any complete 32-bit words from the FIFO, as reported by the
           SPI_FAST_SEQ_STA register.

    2. Mop up any remaining bytes.  At this point, it is not known if there
           are 0, 1, 2, or 3 bytes in the FIFO.  To handle all cases, a dummy
           FSM sequence is used to load one byte at a time, until a complete
           32-bit word is formed; at most, 4 bytes will need to be loaded.

[1] Although this issue has existed since early versions of the SPI-FSM
    controller, its full extent only emerged recently as a consequence of the
    targetpacks starting to use FSM-Boot(x4) as the default configuration.

[2] The requirement to restrict transfers to multiples of 32 cycles was found
    empirically back when DUAL and QUAD mode support was added.  The current
    analysis now gives a satisfactory explanation for this requirement.

[3] Theoretically, it is possible for the FIFO to contain an arbitrary number of
    bits.  However, since there are no known use-cases that leave incomplete
    bytes in the FIFO, only words and bytes are considered here.

Signed-off-by: Angus Clark <angus.clark@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 95 +++++++++++++++++++++++++++++++++-------
 1 file changed, 79 insertions(+), 16 deletions(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index d252514..6e4d3bfe 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -663,6 +663,23 @@ static struct stfsm_seq stfsm_seq_write_status = {
 		    SEQ_CFG_STARTSEQ),
 };
 
+/* Dummy sequence to read one byte of data from flash into the FIFO */
+static const struct stfsm_seq stfsm_seq_load_fifo_byte = {
+	.data_size = TRANSFER_SIZE(1),
+	.seq_opc[0] = (SEQ_OPC_PADS_1 |
+		       SEQ_OPC_CYCLES(8) |
+		       SEQ_OPC_OPCODE(SPINOR_OP_RDID)),
+	.seq = {
+		STFSM_INST_CMD1,
+		STFSM_INST_DATA_READ,
+		STFSM_INST_STOP,
+	},
+	.seq_cfg = (SEQ_CFG_PADS_1 |
+		    SEQ_CFG_READNOTWRITE |
+		    SEQ_CFG_CSDEASSERT |
+		    SEQ_CFG_STARTSEQ),
+};
+
 static int stfsm_n25q_en_32bit_addr_seq(struct stfsm_seq *seq)
 {
 	seq->seq_opc[0] = (SEQ_OPC_PADS_1 | SEQ_OPC_CYCLES(8) |
@@ -695,22 +712,6 @@ static inline uint32_t stfsm_fifo_available(struct stfsm *fsm)
 	return (readl(fsm->base + SPI_FAST_SEQ_STA) >> 5) & 0x7f;
 }
 
-static void stfsm_clear_fifo(struct stfsm *fsm)
-{
-	uint32_t avail;
-
-	for (;;) {
-		avail = stfsm_fifo_available(fsm);
-		if (!avail)
-			break;
-
-		while (avail) {
-			readl(fsm->base + SPI_FAST_SEQ_DATA_REG);
-			avail--;
-		}
-	}
-}
-
 static inline void stfsm_load_seq(struct stfsm *fsm,
 				  const struct stfsm_seq *seq)
 {
@@ -772,6 +773,68 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf, uint32_t size)
 	}
 }
 
+/*
+ * Clear the data FIFO
+ *
+ * Typically, this is only required during driver initialisation, where no
+ * assumptions can be made regarding the state of the FIFO.
+ *
+ * The process of clearing the FIFO is complicated by fact that while it is
+ * possible for the FIFO to contain an arbitrary number of bytes [1], the
+ * SPI_FAST_SEQ_STA register only reports the number of complete 32-bit words
+ * present.  Furthermore, data can only be drained from the FIFO by reading
+ * complete 32-bit words.
+ *
+ * With this in mind, a two stage process is used to the clear the FIFO:
+ *
+ *     1. Read any complete 32-bit words from the FIFO, as reported by the
+ *        SPI_FAST_SEQ_STA register.
+ *
+ *     2. Mop up any remaining bytes.  At this point, it is not known if there
+ *        are 0, 1, 2, or 3 bytes in the FIFO.  To handle all cases, a dummy FSM
+ *        sequence is used to load one byte at a time, until a complete 32-bit
+ *        word is formed; at most, 4 bytes will need to be loaded.
+ *
+ * [1] It is theoretically possible for the FIFO to contain an arbitrary number
+ *     of bits.  However, since there are no known use-cases that leave
+ *     incomplete bytes in the FIFO, only words and bytes are considered here.
+ */
+static void stfsm_clear_fifo(struct stfsm *fsm)
+{
+	const struct stfsm_seq *seq = &stfsm_seq_load_fifo_byte;
+	uint32_t words, i;
+
+	/* 1. Clear any 32-bit words */
+	words = stfsm_fifo_available(fsm);
+	if (words) {
+		for (i = 0; i < words; i++)
+			readl(fsm->base + SPI_FAST_SEQ_DATA_REG);
+		dev_dbg(fsm->dev, "cleared %d words from FIFO\n", words);
+	}
+
+	/*
+	 * 2. Clear any remaining bytes
+	 *    - Load the FIFO, one byte at a time, until a complete 32-bit word
+	 *      is available.
+	 */
+	for (i = 0, words = 0; i < 4 && !words; i++) {
+		stfsm_load_seq(fsm, seq);
+		stfsm_wait_seq(fsm);
+		words = stfsm_fifo_available(fsm);
+	}
+
+	/*    - A single word must be available now */
+	if (words != 1) {
+		dev_err(fsm->dev, "failed to clear bytes from the data FIFO\n");
+		return;
+	}
+
+	/*    - Read the 32-bit word */
+	readl(fsm->base + SPI_FAST_SEQ_DATA_REG);
+
+	dev_dbg(fsm->dev, "cleared %d byte(s) from the data FIFO\n", 4 - i);
+}
+
 static int stfsm_write_fifo(struct stfsm *fsm, const uint32_t *buf,
 			    uint32_t size)
 {
-- 
1.9.1

