Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab3APQIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab3APQH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:07:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 163/222] staging: vt6656: 64bit fixes: vCommandTimerWait change calculation of timer.
Date: Wed, 16 Jan 2013 13:56:03 -0200
Message-Id: <1358351822-7675-164-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/staging/vt6656/wcmd.c |   20 +++++++++++---------
 drivers/staging/vt6656/wpa2.h |    4 ++--
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 78ea121..31fb96a 100644
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
diff --git a/drivers/staging/vt6656/wpa2.h b/drivers/staging/vt6656/wpa2.h
index 46c2959..c359252 100644
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
 
 
-- 
1.7.9.5

