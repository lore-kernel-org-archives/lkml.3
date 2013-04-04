Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762999Ab3DDAEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:04:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22864 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab3DDADV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:03:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="35558407"
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: Richard Kuo <rkuo@codeaurora.org>
Subject: [PATCH 2/6] Hexagon: fix up int enable/disable at ret_from_fork
Date: Wed,  3 Apr 2013 19:02:52 -0500
Message-Id: <1365033776-21804-3-git-send-email-rkuo@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
References: <1365033776-21804-1-git-send-email-rkuo@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check return coming out of check_work_pending, and if copy_thread
passed us a function in r24, call it.  Based on feedback from Al
Viro.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
---
 arch/hexagon/kernel/vm_entry.S |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/hexagon/kernel/vm_entry.S b/arch/hexagon/kernel/vm_entry.S
index 053551e..0de8638 100644
--- a/arch/hexagon/kernel/vm_entry.S
+++ b/arch/hexagon/kernel/vm_entry.S
@@ -371,11 +371,20 @@ _K_enter_machcheck:
 	.globl ret_from_fork
 ret_from_fork:
 	{
-		call schedule_tail;
+		call schedule_tail
 		R16.H = #HI(do_work_pending);
 	}
 	{
+		P0 = cmp.eq(R24, #0);
 		R16.L = #LO(do_work_pending);
 		R0 = #VM_INT_DISABLE;
-		jump check_work_pending;
+	}
+	if P0 jump check_work_pending
+	{
+		R0 = R25;
+		callr R24
+	}
+	{
+		jump check_work_pending
+		R0 = #VM_INT_DISABLE;
 	}
-- 
1.7.9.5

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
