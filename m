Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaHMXGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:06:09 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:41889 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbaHMXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:06:07 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Andreas Noever <andreas.noever@gmail.com>, Greg KH <greg@kroah.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Thunderbolt driver hotplug not working correctly
Date: Thu, 14 Aug 2014 01:05:43 +0200
Message-Id: <1407971143-2928-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <CAMxnaaXjtk1LB9LA_H9UOKX2-XUBM=RP1p=9ctxsnDpMsr6f3w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Steven,

I think that there are two problems:
 - The Kernel does not notice that the device is gone.
 - The first hotplug operation, after removing a coldplugged device fails.

For the first one could you check whether thie pciehp (sub)-driver is loaded?
(dmesg | grep pciehp should show something, the config option is
CONFIG_HOTPLUG_PCI_PCIE).

I was able reproduce the second problem on my machine. Could you test whether
this patch fixes the problem?

Thanks,
Andreas

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
2.0.4

