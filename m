Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbaLEFy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:54:59 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47390 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLEFy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:54:57 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB55sZUe016651, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v4 2/6] mmc: rtsx: add dump_reg_range to simplify dump register
Date: Fri, 5 Dec 2014 13:54:27 +0800
Message-ID: <dcd9add1d29623726bdde4819c7e5267966d2f4f.1417758564.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1417758564.git.micky_ching@realsil.com.cn>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add a new function to dump register within a range.
We print 1 register a line before this patch,
this may make debug info too long when we add more register to dump.

The new dump_reg_range() dump to 8 register a line,
and it is easy to use.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index c70b602..b1390f0 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -71,25 +71,29 @@ static inline void sd_clear_error(struct realtek_pci_sdmmc *host)
 }
 
 #ifdef DEBUG
-static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
+static void dump_reg_range(struct realtek_pci_sdmmc *host, u16 start, u16 end)
 {
-	struct rtsx_pcr *pcr = host->pcr;
-	u16 i;
-	u8 *ptr;
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
+		dev_dbg(sdmmc_dev(host), "0x%04X(%d): %8ph\n",
+			start + i, n, data);
+	}
+}
 
-	/* Print SD host internal registers */
-	rtsx_pci_init_cmd(pcr);
-	for (i = 0xFDA0; i <= 0xFDAE; i++)
-		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
-	for (i = 0xFD52; i <= 0xFD69; i++)
-		rtsx_pci_add_cmd(pcr, READ_REG_CMD, i, 0, 0);
-	rtsx_pci_send_cmd(pcr, 100);
-
-	ptr = rtsx_pci_get_cmd_data(pcr);
-	for (i = 0xFDA0; i <= 0xFDAE; i++)
-		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
-	for (i = 0xFD52; i <= 0xFD69; i++)
-		dev_dbg(sdmmc_dev(host), "0x%04X: 0x%02x\n", i, *(ptr++));
+static void sd_print_debug_regs(struct realtek_pci_sdmmc *host)
+{
+	dump_reg_range(host, 0xFDA0, 0xFDB3);
+	dump_reg_range(host, 0xFD52, 0xFD69);
 }
 #else
 #define sd_print_debug_regs(host)
-- 
1.9.1

