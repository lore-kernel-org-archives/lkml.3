Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaHZPmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:42:36 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41053 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHZPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:42:35 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH] thunderbolt: Clear hops before overwriting
Date: Tue, 26 Aug 2014 17:42:21 +0200
Message-Id: <1409067741-3378-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero hops in tb_path_activate before writing a new path.

This fixes the following scenario:
 - Boot with a coldplugged device
 - Unplug device
 - Plug device back in
 - PCI hotplug fails

The hotplug operation fails because our new path matches the (now
defunct) path which was setup by the firmware for the coldplugged
device. By writing zeros before writing our path configuration we can
force thunderbolt to retrain the path.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/path.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/path.c b/drivers/thunderbolt/path.c
index 8fcf8a7..9562cd0 100644
--- a/drivers/thunderbolt/path.c
+++ b/drivers/thunderbolt/path.c
@@ -150,7 +150,26 @@ int tb_path_activate(struct tb_path *path)
 
 	/* Activate hops. */
 	for (i = path->path_length - 1; i >= 0; i--) {
-		struct tb_regs_hop hop;
+		struct tb_regs_hop hop = { 0 };
+
+		/*
+		 * We do (currently) not tear down paths setup by the firmeware.
+		 * If a firmware device is unplugged and plugged in again then
+		 * it can happen that we reuse some of the hops from the (now
+		 * defunct) firmeware path. This causes the hotplug operation to
+		 * fail (the pci device does not show up). Clearing the hop
+		 * before overwriting it fixes the problem.
+		 *
+		 * Should be removed once we discover and tear down firmeware
+		 * paths.
+		 */
+		res = tb_port_write(path->hops[i].in_port, &hop, TB_CFG_HOPS,
+				    2 * path->hops[i].in_hop_index, 2);
+		if (res) {
+			__tb_path_deactivate_hops(path, i);
+			__tb_path_deallocate_nfc(path, 0);
+			goto err;
+		}
 
 		/* dword 0 */
 		hop.next_hop = path->hops[i].next_hop_index;
-- 
2.1.0

