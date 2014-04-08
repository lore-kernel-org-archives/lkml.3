Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaDHXpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 19:45:16 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:52766 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbaDHXoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 19:44:44 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Neil Greatorex <neil@fatboyfat.co.uk>, Willy Tarreau <w@1wt.eu>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window size
Date: Tue,  8 Apr 2014 17:44:14 -0600
Message-Id: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mbus hardware requires a power of two size, and size aligned base.
Currently, if a non-power of two is passed in to the low level routines
they configure the register in a way that results in undefined behaviour.

Call WARN and return EINVAL instead.

Also, update the debugfs routines to show a message if there is an
invalid register setting.

All together this makes the recent problems with silent failure
of PCI very obvious, noisy and debuggable.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/bus/mvebu-mbus.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

It would be good to see that these warn's trigger, my system here has
everything aligned..

diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
index 2ac754e..9578ae3 100644
--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -56,6 +56,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/debugfs.h>
+#include <linux/log2.h>
 
 /*
  * DDR target is the same on all platforms.
@@ -266,6 +267,17 @@ static int mvebu_mbus_setup_window(struct mvebu_mbus_state *mbus,
 		mbus->soc->win_cfg_offset(win);
 	u32 ctrl, remap_addr;
 
+	if (!is_power_of_2(size)) {
+		WARN(true, "Invalid MBus window size: 0x%zx\n", size);
+		return -EINVAL;
+	}
+
+	if ((base & (phys_addr_t)(size - 1)) != 0) {
+		WARN(true, "Invalid MBus base/size: %pa len 0x%zx\n", &base,
+		     size);
+		return -EINVAL;
+	}
+
 	ctrl = ((size - 1) & WIN_CTRL_SIZE_MASK) |
 		(attr << WIN_CTRL_ATTR_SHIFT)    |
 		(target << WIN_CTRL_TGT_SHIFT)   |
@@ -413,6 +425,10 @@ static int mvebu_devs_debug_show(struct seq_file *seq, void *v)
 			   win, (unsigned long long)wbase,
 			   (unsigned long long)(wbase + wsize), wtarget, wattr);
 
+		if (!is_power_of_2(wsize) ||
+		    ((wbase & (u64)(wsize - 1)) != 0))
+			seq_puts(seq, " (Invalid base/size!!)");
+
 		if (win < mbus->soc->num_remappable_wins) {
 			seq_printf(seq, " (remap %016llx)\n",
 				   (unsigned long long)wremap);
-- 
1.8.1.2

