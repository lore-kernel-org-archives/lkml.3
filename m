Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927Ab3GCSlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:41:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6045 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964780Ab3GCSlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:14 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=P19OJLiwtJ8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=DdxKdol1BvYA:10 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=nHUrWhAopbcH2RfJhBIA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=YUkUdY_67zmQZWC4:21 a=ikeVVFr-BU4G3erS:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184056.246771268@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sergey Dyasly <dserrg@gmail.com>, Vladimir Murzin <murzin.v@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [070/141] xhci: fix list access before init
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0070-xhci-fix-list-access-before-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vladimir Murzin <murzin.v@gmail.com>

[ Upstream commit 88696ae432ce7321540ac53d9caab3de9118b094 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci-mem.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 0550d53..419d34a 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1840,6 +1840,9 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	if (!xhci->rh_bw)
+		goto no_bw;
+
 	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
 	for (i = 0; i < num_ports; i++) {
 		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
@@ -1858,6 +1861,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 		}
 	}
 
+no_bw:
 	xhci->num_usb2_ports = 0;
 	xhci->num_usb3_ports = 0;
 	xhci->num_active_eps = 0;
-- 
1.7.10.4


