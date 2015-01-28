Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbbA2JAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:14 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754553AbbA2JAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 153/176] bus: mvebu-mbus: fix support of MBus window 13
Date: Wed, 28 Jan 2015 15:29:43 +0100
Message-Id: <5ade5ab30a84496e8a860c3ea192d3e247418a5a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 38bdf45f4aa5cb6186d50a29e6cbbd9d486a1519 upstream.

On Armada XP, 375 and 38x the MBus window 13 has the remap capability,
like windows 0 to 7. However, the mvebu-mbus driver isn't currently
taking into account this special case, which means that when window 13
is actually used, the remap registers are left to 0, making the device
using this MBus window unavailable.

As a minimal fix for stable, don't use window 13. A full fix will
follow later.

Fixes: fddddb52a6c ("bus: introduce an Marvell EBU MBus driver")
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bus/mvebu-mbus.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
index b4bd72b6fdc8..b50c5e32ca35 100644
--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -181,12 +181,25 @@ static void mvebu_mbus_disable_window(struct mvebu_mbus_state *mbus,
 }
 
 /* Checks whether the given window number is available */
+
+/* On Armada XP, 375 and 38x the MBus window 13 has the remap
+ * capability, like windows 0 to 7. However, the mvebu-mbus driver
+ * isn't currently taking into account this special case, which means
+ * that when window 13 is actually used, the remap registers are left
+ * to 0, making the device using this MBus window unavailable. The
+ * quick fix for stable is to not use window 13. A follow up patch
+ * will correctly handle this window.
+*/
 static int mvebu_mbus_window_is_free(struct mvebu_mbus_state *mbus,
 				     const int win)
 {
 	void __iomem *addr = mbus->mbuswins_base +
 		mbus->soc->win_cfg_offset(win);
 	u32 ctrl = readl(addr + WIN_CTRL_OFF);
+
+	if (win == 13)
+		return false;
+
 	return !(ctrl & WIN_CTRL_ENABLE);
 }
 
-- 
2.2.2

