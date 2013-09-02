Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab3IBJTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:19:47 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:41534 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab3IBJTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:19:45 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.34 with qID r829FwYC020379, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realtek.com>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] mmc: rtsx: change phase searching method
Date: Mon, 2 Sep 2013 17:16:52 +0800
Message-ID: <1378113412-24200-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

The new phase searching method is more concise, and makes the code
easier to understand.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |  107 +++++++++++--------------------------
 1 file changed, 30 insertions(+), 77 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index f981f7d..299a27c 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -32,15 +32,6 @@
 #include <linux/mfd/rtsx_pci.h>
 #include <asm/unaligned.h>
 
-/* SD Tuning Data Structure
- * Record continuous timing phase path
- */
-struct timing_phase_path {
-	int start;
-	int end;
-	int mid;
-	int len;
-};
 
 struct realtek_pci_sdmmc {
 	struct platform_device	*pdev;
@@ -497,85 +488,47 @@ static int sd_change_phase(struct realtek_pci_sdmmc *host, u8 sample_point)
 	return 0;
 }
 
-static u8 sd_search_final_phase(struct realtek_pci_sdmmc *host, u32 phase_map)
+static inline u32 get_phase_point(u32 phase_map, unsigned int idx)
 {
-	struct timing_phase_path path[MAX_PHASE + 1];
-	int i, j, cont_path_cnt;
-	int new_block, max_len, final_path_idx;
-	u8 final_phase = 0xFF;
+	idx &= MAX_PHASE;
+	return phase_map & (1 << idx);
+}
+
+static int get_phase_len(u32 phase_map, unsigned int idx)
+{
+	int i;
 
-	/* Parse phase_map, take it as a bit-ring */
-	cont_path_cnt = 0;
-	new_block = 1;
-	j = 0;
 	for (i = 0; i < MAX_PHASE + 1; i++) {
-		if (phase_map & (1 << i)) {
-			if (new_block) {
-				new_block = 0;
-				j = cont_path_cnt++;
-				path[j].start = i;
-				path[j].end = i;
-			} else {
-				path[j].end = i;
-			}
-		} else {
-			new_block = 1;
-			if (cont_path_cnt) {
-				/* Calculate path length and middle point */
-				int idx = cont_path_cnt - 1;
-				path[idx].len =
-					path[idx].end - path[idx].start + 1;
-				path[idx].mid =
-					path[idx].start + path[idx].len / 2;
-			}
-		}
+		if (get_phase_point(phase_map, idx + i) == 0)
+			return i;
 	}
+	return MAX_PHASE + 1;
+}
 
-	if (cont_path_cnt == 0) {
-		dev_dbg(sdmmc_dev(host), "No continuous phase path\n");
-		goto finish;
-	} else {
-		/* Calculate last continuous path length and middle point */
-		int idx = cont_path_cnt - 1;
-		path[idx].len = path[idx].end - path[idx].start + 1;
-		path[idx].mid = path[idx].start + path[idx].len / 2;
-	}
+static u8 sd_search_final_phase(struct realtek_pci_sdmmc *host, u32 phase_map)
+{
+	int start = 0, len = 0;
+	int start_final = 0, len_final = 0;
+	u8 final_phase = 0xFF;
 
-	/* Connect the first and last continuous paths if they are adjacent */
-	if (!path[0].start && (path[cont_path_cnt - 1].end == MAX_PHASE)) {
-		/* Using negative index */
-		path[0].start = path[cont_path_cnt - 1].start - MAX_PHASE - 1;
-		path[0].len += path[cont_path_cnt - 1].len;
-		path[0].mid = path[0].start + path[0].len / 2;
-		/* Convert negative middle point index to positive one */
-		if (path[0].mid < 0)
-			path[0].mid += MAX_PHASE + 1;
-		cont_path_cnt--;
+	if (phase_map == 0) {
+		dev_dbg(sdmmc_dev(host), "Phase: [map:%x]\n", phase_map);
+		return final_phase;
 	}
 
-	/* Choose the longest continuous phase path */
-	max_len = 0;
-	final_phase = 0;
-	final_path_idx = 0;
-	for (i = 0; i < cont_path_cnt; i++) {
-		if (path[i].len > max_len) {
-			max_len = path[i].len;
-			final_phase = (u8)path[i].mid;
-			final_path_idx = i;
+	while (start < MAX_PHASE + 1) {
+		len = get_phase_len(phase_map, start);
+		if (len_final < len) {
+			start_final = start;
+			len_final = len;
 		}
-
-		dev_dbg(sdmmc_dev(host), "path[%d].start = %d\n",
-				i, path[i].start);
-		dev_dbg(sdmmc_dev(host), "path[%d].end = %d\n",
-				i, path[i].end);
-		dev_dbg(sdmmc_dev(host), "path[%d].len = %d\n",
-				i, path[i].len);
-		dev_dbg(sdmmc_dev(host), "path[%d].mid = %d\n",
-				i, path[i].mid);
+		start += len ? len : 1;
 	}
 
-finish:
-	dev_dbg(sdmmc_dev(host), "Final chosen phase: %d\n", final_phase);
+	final_phase = (start_final + len_final / 2) & MAX_PHASE;
+	dev_dbg(sdmmc_dev(host), "Phase: [map:%x] [maxlen:%d] [final:%d]\n",
+		phase_map, len_final, final_phase);
+
 	return final_phase;
 }
 
-- 
1.7.9.5

