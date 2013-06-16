Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3FPWQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:16:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46315 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755604Ab3FPWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Vladimir Murzin" <murzin.v@gmail.com>,
        "Sergey Dyasly" <dserrg@gmail.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.351291086@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [35/83] xhci: fix list access before init
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-mem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1755,6 +1755,9 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	if (!xhci->rh_bw)
+		goto no_bw;
+
 	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
 	for (i = 0; i < num_ports; i++) {
 		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
@@ -1773,6 +1776,7 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 		}
 	}
 
+no_bw:
 	xhci->num_usb2_ports = 0;
 	xhci->num_usb3_ports = 0;
 	xhci->num_active_eps = 0;

