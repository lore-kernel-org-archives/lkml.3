Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab3AOWbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:31:09 -0500
Received: from mail.kernel.org ([198.145.19.201]:42160 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757556Ab3AOWbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:31:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 100/221] staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of timer.
Date: Tue, 15 Jan 2013 10:50:27 -0800
Message-Id: <20130115185005.250787923@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 70e227790d4ee4590023d8041a3485f8053593fc upstream.

The timer appears to run too fast/race on 64 bit systems.

Using msecs_to_jiffies seems to cause a deadlock on 64 bit.

A calculation of (MSecond * HZ) / 1000 appears to run satisfactory.

Change BSSIDInfoCount to u32.

After this patch the driver can be successfully connect on little endian 64/32 bit systems.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/wcmd.c |   20 +++++++++++---------
 drivers/staging/vt6656/wpa2.h |    4 ++--
 2 files changed, 13 insertions(+), 11 deletions(-)

--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -316,17 +316,19 @@ s_MgrMakeProbeRequest(
     return pTxPacket;
 }
 
-void vCommandTimerWait(void *hDeviceContext, unsigned int MSecond)
+void vCommandTimerWait(void *hDeviceContext, unsigned long MSecond)
 {
-    PSDevice        pDevice = (PSDevice)hDeviceContext;
+	PSDevice pDevice = (PSDevice)hDeviceContext;
 
-    init_timer(&pDevice->sTimerCommand);
-    pDevice->sTimerCommand.data = (unsigned long)pDevice;
-    pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
-    // RUN_AT :1 msec ~= (HZ/1024)
-    pDevice->sTimerCommand.expires = (unsigned int)RUN_AT((MSecond * HZ) >> 10);
-    add_timer(&pDevice->sTimerCommand);
-    return;
+	init_timer(&pDevice->sTimerCommand);
+
+	pDevice->sTimerCommand.data = (unsigned long)pDevice;
+	pDevice->sTimerCommand.function = (TimerFunction)vRunCommand;
+	pDevice->sTimerCommand.expires = RUN_AT((MSecond * HZ) / 1000);
+
+	add_timer(&pDevice->sTimerCommand);
+
+	return;
 }
 
 void vRunCommand(void *hDeviceContext)
--- a/drivers/staging/vt6656/wpa2.h
+++ b/drivers/staging/vt6656/wpa2.h
@@ -45,8 +45,8 @@ typedef struct tagsPMKIDInfo {
 } PMKIDInfo, *PPMKIDInfo;
 
 typedef struct tagSPMKIDCache {
-    unsigned long       BSSIDInfoCount;
-    PMKIDInfo   BSSIDInfo[MAX_PMKID_CACHE];
+	u32 BSSIDInfoCount;
+	PMKIDInfo BSSIDInfo[MAX_PMKID_CACHE];
 } SPMKIDCache, *PSPMKIDCache;
 
 


