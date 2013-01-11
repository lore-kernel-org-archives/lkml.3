Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3AKTM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:12:28 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:44088 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3AKTM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:12:26 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, JBottomley@parallels.com,
        linux-kernel@vger.kernel.org, kxie@chelsio.com,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Divy La Rey <divy@chelsio.com>
Subject: [PATCH] cxgb4i: Remove the scsi host device when removing device
Date: Fri, 11 Jan 2013 17:12:09 -0200
Message-Id: <1357931529-10248-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011119-9254-0000-0000-00000B55E8C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing a hotplug remove of a cxgb4 device, there are still dandling
symlinks at /sys/class/scsi_host/hostX to the removed PCI device. The
upper layer device may also try to send data, which may crash the
system.

The DETACH message from the lower level driver is sent to the ULD when
the device is removed, when the scsi host should be removed from the
system, avoiding any problems.

After this patch, there are no more dangling symlinks and many attempts
to crash the system while there is SCSI activity and removing the device
have failed. Adding the device back again works as expected, with the
scsi hosts showing up again.

Based on a patch by Karen Xie.

Cc: Karen Xie <kxie@chelsio.com>
Cc: Divy La Rey <divy@chelsio.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index f924b3c..3fecf35 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1564,6 +1564,7 @@ static int t4_uld_state_change(void *handle, enum cxgb4_state state)
 		break;
 	case CXGB4_STATE_DETACH:
 		pr_info("cdev 0x%p, DETACH.\n", cdev);
+		cxgbi_device_unregister(cdev);
 		break;
 	default:
 		pr_info("cdev 0x%p, unknown state %d.\n", cdev, state);
-- 
1.7.1

