Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbbANCyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:54:35 -0500
Received: from 60-248-182-7.HINET-IP.hinet.net ([60.248.182.7]:38670 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751028AbbANCyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:54:25 -0500
X-Greylist: delayed 801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 21:54:22 EST
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0E2eS3G024320, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <oakad@yahoo.com>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 1/3] memstick: rtsx: dump register using compact format
Date: Wed, 14 Jan 2015 10:40:15 +0800
Message-ID: <d081508c3433ac832e7da888190312bdf122d8f4.1421202479.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421202479.git.micky_ching@realsil.com.cn>
References: <cover.1421202479.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Using more compact format for dump register when error occurs,
this is useful to read debug log and reduce log length.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/memstick/host/rtsx_pci_ms.c | 37 ++++++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index 818fa94..baf94db 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -54,26 +54,29 @@ static inline void ms_clear_error(struct realtek_pci_ms *host)
 }
 
 #ifdef DEBUG
+static void dump_reg_range(struct realtek_pci_ms *host, u16 start, u16 end)
+{
+	u16 len = end - start + 1;
+	int i;
+	u8 data[8];
+
+	for (i = 0; i < len; i += 8) {
+		int j;
+		int n = min(8, len - i);
+
+		memset(&data, 0, sizeof(data));
+		for (j = 0; j < n; j++)
+			rtsx_pci_read_register(host->pcr, start + i + j,
+				data + j);
+		dev_dbg(ms_dev(host), "0x%04X(%d): %8ph\n",
+			start + i, n, data);
+	}
+}
 
 static void ms_print_debug_regs(struct realtek_pci_ms *host)
 {
-	struct rtsx_pcr *pcr = host->pcr;
-	u16 i;
-	u8 *ptr;
-
-	/* Print MS host internal registers */
-	rtsx_pci_init_cmd(pcr);
-	for (i = 0xFD40; i <= 0xFD44; i++)
-		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
-	for (i = 0xFD52; i <= 0xFD69; i++)
-		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
-	rtsx_pci_send_cmd(pcr, 100);
-
-	ptr = rtsx_pci_get_cmd_data(pcr);
-	for (i = 0xFD40; i <= 0xFD44; i++)
-		dev_dbg(ms_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
-	for (i = 0xFD52; i <= 0xFD69; i++)
-		dev_dbg(ms_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
+	dump_reg_range(host, 0xFD40, 0xFD44);
+	dump_reg_range(host, 0xFD52, 0xFD69);
 }
 
 #else
-- 
1.9.1

