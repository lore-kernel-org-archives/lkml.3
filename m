Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3HBKSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:18:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3HBKSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:18:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Huang Rui <ray.huang@amd.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 11/39] usb: dwc3: fix wrong bit mask in dwc3_event_type
Date: Fri,  2 Aug 2013 18:18:21 +0800
Message-Id: <20130802101458.420613943@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/core.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -641,8 +641,8 @@ struct dwc3 {
 
 struct dwc3_event_type {
 	u32	is_devspec:1;
-	u32	type:6;
-	u32	reserved8_31:25;
+	u32	type:7;
+	u32	reserved8_31:24;
 } __packed;
 
 #define DWC3_DEPEVT_XFERCOMPLETE	0x01


