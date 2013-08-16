Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab3HQAak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:30:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51373 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3HPWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 003/133] usb: dwc3: fix wrong bit mask in dwc3_event_type
Date: Fri, 16 Aug 2013 15:32:25 -0700
Message-Id: <1376692475-28413-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Rui <ray.huang@amd.com>

commit 1974d494dea05ea227cb42f5e918828801e237aa upstream.

Per dwc3 2.50a spec, the is_devspec bit is used to distinguish the
Device Endpoint-Specific Event or Device-Specific Event (DEVT). If the
bit is 1, the event is represented Device-Specific Event, then use
[7:1] bits as Device Specific Event to marked the type. It has 7 bits,
and we can see the reserved8_31 variable name which means from 8 to 31
bits marked reserved, actually there are 24 bits not 25 bits between
that. And 1 + 7 + 24 = 32, the event size is 4 byes.

So in dwc3_event_type, the bit mask should be:
is_devspec	[0]		1  bit
type		[7:1]		7  bits
reserved8_31	[31:8]		24 bits

This patch should be backported to kernels as old as 3.2, that contain
the commit 72246da40f3719af3bfd104a2365b32537c27d83 "usb: Introduce
DesignWare USB3 DRD Driver".

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 1dae91d..17dcd98 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -730,8 +730,8 @@ struct dwc3 {
 
 struct dwc3_event_type {
 	u32	is_devspec:1;
-	u32	type:6;
-	u32	reserved8_31:25;
+	u32	type:7;
+	u32	reserved8_31:24;
 } __packed;
 
 #define DWC3_DEPEVT_XFERCOMPLETE	0x01
-- 
1.8.1.2

