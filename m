Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab3FQSB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:01:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50394 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3FQRbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vladimir Murzin <murzin.v@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 09/84] xhci: fix list access before init
Date: Mon, 17 Jun 2013 10:30:13 -0700
Message-Id: <1371490288-23167-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <murzin.v@gmail.com>

commit 88696ae432ce7321540ac53d9caab3de9118b094 upstream.

If for whatever reason we fall into fail path in xhci_mem_init()
before bw table gets initialized we may access the uninitialized lists
in xhci_mem_cleanup().

Check for bw table before traversing lists in cleanup routine.

This patch should be backported to kernels as old as 3.2, that contain
the commit 839c817ce67178ca3c7c7ad534c571bba1e69ebe "xhci: Store
information about roothubs and TTs."

Reported-by: Sergey Dyasly <dserrg@gmail.com>
Tested-by: Sergey Dyasly <dserrg@gmail.com>
Signed-off-by: Vladimir Murzin <murzin.v@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/xhci-mem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 59c08b2..0618f25 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1847,6 +1847,9 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	if (!xhci->rh_bw)
+		goto no_bw;
+
 	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
 	for (i = 0; i < num_ports; i++) {
 		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
@@ -1865,6 +1868,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 		}
 	}
 
+no_bw:
 	xhci->num_usb2_ports = 0;
 	xhci->num_usb3_ports = 0;
 	xhci->num_active_eps = 0;
-- 
1.8.1.2

