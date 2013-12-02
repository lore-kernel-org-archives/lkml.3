Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009Ab3LBV3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:29:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab3LBTHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:07:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3.4 27/60] staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.
Date: Mon,  2 Dec 2013 11:06:08 -0800
Message-Id: <20131202190336.128479431@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/vt6656/baseband.c |   11 +++++++++++
 drivers/staging/vt6656/rndis.h    |    1 +
 2 files changed, 12 insertions(+)

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
 
--- a/drivers/staging/vt6656/rndis.h
+++ b/drivers/staging/vt6656/rndis.h
@@ -69,6 +69,7 @@
 
 #define VIAUSB20_PACKET_HEADER          0x04
 
+#define USB_REG4	0x604
 
 /*---------------------  Export Classes  ----------------------------*/
 


