Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbaFII6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58544 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932186AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 105/146] memory: mvebu-devbus: fix the conversion of the bus width
Date: Mon,  9 Jun 2014 10:50:40 +0200
Message-Id: <37f92fc6493c9f42b691dbc6c015ff28350ff6fa.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ce965c3d2e68c5325dd5624eb101d70423022fef upstream.

According to the Armada 370 and Armada XP datasheets, the part of the
Device Bus register that configure the bus width should contain 0 for
a 8 bits bus width, and 1 for a 16 bits bus width (other values are
unsupported/reserved).

However, the current conversion done in the driver to convert from a
bus width in bits to the value expected by the register leads to
setting the register to 1 for a 8 bits bus, and 2 for a 16 bits bus.

This mistake was compensated by a mistake in the existing Device Tree
files for Armada 370/XP platforms: they were declaring a 8 bits bus
width, while the hardware in fact uses a 16 bits bus width.

This commit fixes that by adjusting the conversion logic.

This patch fixes a bug that was introduced in
3edad321b1bd2e6c8b5f38146c115c8982438f06 ('drivers: memory: Introduce
Marvell EBU Device Bus driver'), which was merged in v3.11.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397489361-5833-2-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: 3edad321b1bd ('drivers: memory: Introduce Marvell EBU Device Bus driver')
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/memory/mvebu-devbus.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/mvebu-devbus.c b/drivers/memory/mvebu-devbus.c
index 110c03627051..b59a17fb7c3e 100644
--- a/drivers/memory/mvebu-devbus.c
+++ b/drivers/memory/mvebu-devbus.c
@@ -108,8 +108,19 @@ static int devbus_set_timing_params(struct devbus *devbus,
 			node->full_name);
 		return err;
 	}
-	/* Convert bit width to byte width */
-	r.bus_width /= 8;
+
+	/*
+	 * The bus width is encoded into the register as 0 for 8 bits,
+	 * and 1 for 16 bits, so we do the necessary conversion here.
+	 */
+	if (r.bus_width == 8)
+		r.bus_width = 0;
+	else if (r.bus_width == 16)
+		r.bus_width = 1;
+	else {
+		dev_err(devbus->dev, "invalid bus width %d\n", r.bus_width);
+		return -EINVAL;
+	}
 
 	err = get_timing_param_ps(devbus, node, "devbus,badr-skew-ps",
 				 &r.badr_skew);
-- 
1.9.3

