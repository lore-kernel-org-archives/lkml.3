Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3HLVBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:01:38 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:41227 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3HLVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:01:37 -0400
From: Linn Crosetto <linn@hp.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, jacob.shin@amd.com
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [PATCH] x86: selective remapping in parse_setup_data()
Date: Mon, 12 Aug 2013 15:00:06 -0600
Message-Id: <1376341206-72835-1-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices may advertise a ROM size larger than early_memremap() is
able to handle. If this occurs it leads to a NULL dereference in
parse_setup_data(). Avoid this by remapping the data only when
necessary.

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 arch/x86/kernel/setup.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..2063a49 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -423,6 +423,17 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+static void __init remap_setup_data(u64 pa_data, u32 data_len,
+				    struct setup_data **data, u32 *map_len)
+{
+	if (data_len <= *map_len)
+		return;
+
+	early_iounmap(*data, *map_len);
+	*data = early_memremap(pa_data, data_len);
+	*map_len = data_len;
+}
+
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
@@ -432,18 +443,16 @@ static void __init parse_setup_data(void)
 	while (pa_data) {
 		u32 data_len, map_len;
 
+		/* The data length may be too large for early remapping,
+		   remap the data only when needed. */
 		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
 			      (u64)sizeof(struct setup_data));
 		data = early_memremap(pa_data, map_len);
 		data_len = data->len + sizeof(struct setup_data);
-		if (data_len > map_len) {
-			early_iounmap(data, map_len);
-			data = early_memremap(pa_data, data_len);
-			map_len = data_len;
-		}
 
 		switch (data->type) {
 		case SETUP_E820_EXT:
+			remap_setup_data(pa_data, data_len, &data, &map_len);
 			parse_e820_ext(data);
 			break;
 		case SETUP_DTB:
-- 
1.7.11.3

