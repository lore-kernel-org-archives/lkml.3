Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbbAOLM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:12:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30320 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbbAOLM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:12:26 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-4d-54b7a0980fe3
From: Robert Baldyga <r.baldyga@samsung.com>
To: paulz@synopsys.com
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@opensource.altera.com,
        yousaf.kaukab@intel.com, m.szyprowski@samsung.com,
        stern@rowland.harvard.edu, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3] usb: dwc2: call dwc2_is_controller_alive() under spinlock
Date: Thu, 15 Jan 2015 12:11:36 +0100
Message-id: <1421320296-11525-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd2ZC7aHGPy/yW5x8H69xapPa5gt
	mhevZ7O4vGsOm8WiZa3MFmuP3GW32D5lOpPFg8M72S0m/L7AZrFp009mBy6PxXteMnnsn7uG
	3aP/2iR2j9l3fzB69G1ZxeixZf9nRo/jN7YzeXzeJBfAEcVlk5Kak1mWWqRvl8CV8WP9WpaC
	Pp6KyRvvMzUwtnB1MXJySAiYSLw4Mp8dwhaTuHBvPVsXIxeHkMB0RokD096xQzjtTBLTnn5n
	AaliE9CR2PJ9AmMXIweHCFDH9w+cIDXMAo1MEnfbf7GB1AgL+Er8fr+MEcRmEVCVaN0FsoGD
	g1fAVWLiBWWIZXISJ49NZp3AyL2AkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnB4PZPe
	wbiqweIQowAHoxIPL4Pf9hAh1sSy4srcQ4wSHMxKIrydOUAh3pTEyqrUovz4otKc1OJDjNIc
	LErivEr2bSFCAumJJanZqakFqUUwWSYOTqkGxtK5DOyS7itdD3e13vQRagsP6vc6tvRN+Z1D
	8hrv1r5Nyug5H3PpkcgzrereFc3v7m1TOu7tdPr8bnaZa+qWD76tm2dRrGNe+Uz3/pJEB3aO
	Iou0dZeFYyew7kxfOXmjmmdd2fL1jz4uPcQ8aY6iRjXDbM7by+Y22Hxy88hbumpbd9mtwquz
	PimxFGckGmoxFxUnAgCCy1cHKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following problem: data transmission in direction
IN break unless the GSNPSID register access is done with spinlock held.
This issue occurs at least in Exynos4412 SoC, probably in many SoC's
from Exynos familly.

The problem is described here:
https://lkml.org/lkml/2014/12/22/185
And there is linux mailing list discussion:
https://lkml.org/lkml/2015/1/14/17

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---

Changelog:

v3:
- updated the commit message

v2: https://lkml.org/lkml/2015/1/14/17
- fixed comment from Paul Zimmerman

v1: https://lkml.org/lkml/2015/1/13/186

 drivers/usb/dwc2/core_intr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index ad43c5b..02e3e2d 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -476,13 +476,13 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
 	u32 gintsts;
 	irqreturn_t retval = IRQ_NONE;
 
+	spin_lock(&hsotg->lock);
+
 	if (!dwc2_is_controller_alive(hsotg)) {
 		dev_warn(hsotg->dev, "Controller is dead\n");
 		goto out;
 	}
 
-	spin_lock(&hsotg->lock);
-
 	gintsts = dwc2_read_common_intr(hsotg);
 	if (gintsts & ~GINTSTS_PRTINT)
 		retval = IRQ_HANDLED;
@@ -515,8 +515,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
 		}
 	}
 
-	spin_unlock(&hsotg->lock);
 out:
+	spin_unlock(&hsotg->lock);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(dwc2_handle_common_intr);
-- 
1.9.1

