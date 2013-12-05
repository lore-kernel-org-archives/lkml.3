Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab3LERju (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:39:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933448Ab3LERiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 85/90] staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.
Date: Thu,  5 Dec 2013 17:36:07 +0000
Message-Id: <1386264972-5399-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 9df682927c2e3a92f43803d6b52095992e3b2ab8 upstream.

This fixes resets on heavy TX data traffic.

Vendor driver
VT6656_Linux_src_v1.21.03_x86_11.04.zip
http://www.viaembedded.com/servlet/downloadSvl?id=1890&download_file_id=14704
This is GPL-licensed code.

original code
BBbVT3184Init
...
//2007-0725, RobertChang add, Enable Squelch detect reset option(SQ_RST_Opt), USB (register4, bit1)
CONTROLnsRequestIn(pDevice,
                                 MESSAGE_TYPE_READ,
                                 (WORD)0x600+4,     // USB's Reg4's bit1
                                 MESSAGE_REQUEST_MEM,
                                 1,
                                 (PBYTE) &byData);
byData = byData|2 ;
CONTROLnsRequestOut(pDevice,
                              MESSAGE_TYPE_WRITE,
                              (WORD)0x600+4,     // USB's Reg4's bit1
                              MESSAGE_REQUEST_MEM,
                              1,
                              (PBYTE) &byData);

return TRUE;//ntStatus;
....

A back port patch is needed for kernels less than 3.10.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/vt6656/baseband.c | 11 +++++++++++
 drivers/staging/vt6656/rndis.h    |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 06f27f6..858e2a8 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -976,6 +976,7 @@ BOOL BBbVT3184Init(PSDevice pDevice)
     PBYTE                   pbyAgc;
     WORD                    wLengthAgc;
     BYTE                    abyArray[256];
+	u8 data;
 
     ntStatus = CONTROLnsRequestIn(pDevice,
                                   MESSAGE_TYPE_READ,
@@ -1144,6 +1145,16 @@ else {
     ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x0D,0x01);
 
     RFbRFTableDownload(pDevice);
+
+	/* Fix for TX USB resets from vendors driver */
+	CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ, USB_REG4,
+		MESSAGE_REQUEST_MEM, sizeof(data), &data);
+
+	data |= 0x2;
+
+	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, USB_REG4,
+		MESSAGE_REQUEST_MEM, sizeof(data), &data);
+
     return TRUE;//ntStatus;
 }
 
diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndis.h
index fccf7e9..dcf7bf5 100644
--- a/drivers/staging/vt6656/rndis.h
+++ b/drivers/staging/vt6656/rndis.h
@@ -69,6 +69,7 @@
 
 #define VIAUSB20_PACKET_HEADER          0x04
 
+#define USB_REG4	0x604
 
 /*---------------------  Export Classes  ----------------------------*/
 
-- 
1.8.3.2

