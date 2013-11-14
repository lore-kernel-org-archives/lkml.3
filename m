Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219Ab3KNWLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:11:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:63733 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258Ab3KNWK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:10:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435469162"
From: David Cohen <david.a.cohen@linux.intel.com>
To: matthew.garrett@nebula.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, eric.ernst@linux.intel.com
Subject: [PATCH v2 3/4] ipc: Handle error conditions in ipc command
Date: Thu, 14 Nov 2013 14:15:06 -0800
Message-Id: <1384467307-18556-4-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384467307-18556-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com>
 <1384467307-18556-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

Handle error conditions in intel_scu_ipc_command() and
pwr_reg_rdwr().

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/platform/x86/intel_scu_ipc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 86b6ce2a7a47..e26830f6c8dd 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -235,7 +235,7 @@ static int pwr_reg_rdwr(u16 *addr, u8 *data, u32 count, u32 op, u32 id)
 	}
 
 	err = busy_loop();
-	if (id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
+	if (!err && id == IPC_CMD_PCNTRL_R) { /* Read rbuf */
 		/* Workaround: values are read as 0 without memcpy_fromio */
 		memcpy_fromio(cbuf, ipcdev.ipc_base + 0x90, 16);
 		for (nc = 0; nc < count; nc++)
@@ -465,8 +465,10 @@ int intel_scu_ipc_command(int cmd, int sub, u32 *in, int inlen,
 	ipc_command((inlen << 16) | (sub << 12) | cmd);
 	err = busy_loop();
 
-	for (i = 0; i < outlen; i++)
-		*out++ = ipc_data_readl(4 * i);
+	if (!err) {
+		for (i = 0; i < outlen; i++)
+			*out++ = ipc_data_readl(4 * i);
+	}
 
 	mutex_unlock(&ipclock);
 	return err;
-- 
1.8.4.2

