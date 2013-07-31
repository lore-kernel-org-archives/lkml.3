Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135Ab3GaNjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:39:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47007 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759804Ab3GaNZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felipe Balbi" <balbi@ti.com>,
        "Huang Rui" <ray.huang@amd.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.974869864@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [40/84] usb: dwc3: fix wrong bit mask in dwc3_event_type
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -643,8 +643,8 @@ struct dwc3 {
 
 struct dwc3_event_type {
 	u32	is_devspec:1;
-	u32	type:6;
-	u32	reserved8_31:25;
+	u32	type:7;
+	u32	reserved8_31:24;
 } __packed;
 
 #define DWC3_DEPEVT_XFERCOMPLETE	0x01

