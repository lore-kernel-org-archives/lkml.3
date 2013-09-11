Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3IKF0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:26:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7710 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3IKF0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 01:26:44 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=m7dsqYhdkEsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=m19cnjxhN6gA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=nUuTZ29dAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=wu_e27o_rKQA:10 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042907.087847475@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>
Subject: [089/251] usb: dwc3: fix wrong bit mask in dwc3_event_type
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0089-usb-dwc3-fix-wrong-bit-mask-in-dwc3_event_type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Huang Rui <ray.huang@amd.com>

[ Upstream commit 1974d494dea05ea227cb42f5e918828801e237aa ]

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

Cc: <stable@vger.kernel.org>
Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/dwc3/core.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 151eca8..06dffc8 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -728,8 +728,8 @@ struct dwc3 {
 
 struct dwc3_event_type {
 	u32	is_devspec:1;
-	u32	type:6;
-	u32	reserved8_31:25;
+	u32	type:7;
+	u32	reserved8_31:24;
 } __packed;
 
 #define DWC3_DEPEVT_XFERCOMPLETE	0x01
-- 
1.7.10.4


