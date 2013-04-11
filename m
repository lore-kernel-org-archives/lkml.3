Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936246Ab3DKBAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:00:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48986 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762769Ab3DKBAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:00:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,451,1363158000"; 
   d="scan'208";a="37561281"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: msm: Fix uncompess.h tx underrun check
Date: Wed, 10 Apr 2013 18:00:11 -0700
Message-Id: <1365642011-4664-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bit 3 of the SR register is set if there is a tx underrun. If
this bit isn't set, we should loop on the tx ready bit until we
can transmit again. Otherwise we should skip the loop and
transmit immediately. The code is doing the opposite though,
checking for an underrun and then looping on the tx ready bit
causing us to never loop on the tx read bit when the tx buffer
may not be ready.

This doesn't seem to affect my 8960 device too often, but in some
cases I see a lost character or two from the decompressor prints.
This also matches what we do in the assembly in debug-macro.S.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Nobody has noticed this so far so I'm ok waiting for 3.10 on this one. Also
it doesn't improve stability (debug feature) so I don't see a reason to send
it to stable.

 arch/arm/mach-msm/include/mach/uncompress.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/include/mach/uncompress.h b/arch/arm/mach-msm/include/mach/uncompress.h
index fa97a10..9432487 100644
--- a/arch/arm/mach-msm/include/mach/uncompress.h
+++ b/arch/arm/mach-msm/include/mach/uncompress.h
@@ -37,7 +37,7 @@ static void putc(int c)
 	 * Wait for TX_READY to be set; but skip it if we have a
 	 * TX underrun.
 	 */
-	if (UART_DM_SR & 0x08)
+	if (!(UART_DM_SR & 0x08))
 		while (!(UART_DM_ISR & 0x80))
 			cpu_relax();
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

