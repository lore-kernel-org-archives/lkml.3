Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbbANCyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 21:54:38 -0500
Received: from 60-248-182-7.HINET-IP.hinet.net ([60.248.182.7]:38670 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751531AbbANCy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 21:54:28 -0500
X-Greylist: delayed 801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 21:54:22 EST
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0E2eUA9024332, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <oakad@yahoo.com>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 2/3] memstick: rtsx: finish request if no card exist
Date: Wed, 14 Jan 2015 10:40:16 +0800
Message-ID: <48dbfdff5bf6148483698249fa5ca21ab33816d5.1421202479.git.micky_ching@realsil.com.cn>
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

Check card exist before start request, this method can make card remove
faster. If we found the card is not exist, just return error-code,
not sending request can save much time.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/memstick/host/rtsx_pci_ms.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index baf94db..c9981af 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -85,6 +85,11 @@ static void ms_print_debug_regs(struct realtek_pci_ms *host)
 
 #endif
 
+static inline int ms_get_cd_int(struct realtek_pci_ms *host)
+{
+	return rtsx_pci_readl(host->pcr, RTSX_BIPR) & MS_EXIST;
+}
+
 static int ms_power_on(struct realtek_pci_ms *host)
 {
 	struct rtsx_pcr *pcr = host->pcr;
@@ -409,6 +414,9 @@ static void rtsx_pci_ms_handle_req(struct work_struct *work)
 	struct memstick_host *msh = host->msh;
 	int rc;
 
+	if (host->req)
+		return;
+
 	mutex_lock(&pcr->pcr_mutex);
 
 	rtsx_pci_start_run(pcr);
@@ -419,15 +427,16 @@ static void rtsx_pci_ms_handle_req(struct work_struct *work)
 	rtsx_pci_write_register(pcr, CARD_SHARE_MODE,
 			CARD_SHARE_MASK, CARD_SHARE_48_MS);
 
-	if (!host->req) {
-		do {
-			rc = memstick_next_req(msh, &host->req);
-			dev_dbg(ms_dev(host), "next req %d\n", rc);
-
-			if (!rc)
-				host->req->error = rtsx_pci_ms_issue_cmd(host);
-		} while (!rc);
-	}
+	while (true) {
+		rc = memstick_next_req(msh, &host->req);
+		dev_dbg(ms_dev(host), "next req %d\n", rc);
+		if (rc)
+			break;
+		if (!ms_get_cd_int(host))
+			host->req->error = -ENOMEDIUM;
+		else
+			host->req->error = rtsx_pci_ms_issue_cmd(host);
+	};
 
 	mutex_unlock(&pcr->pcr_mutex);
 }
-- 
1.9.1

