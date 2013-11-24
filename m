Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3KXKdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 05:33:06 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54241 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab3KXKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 05:32:59 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, <stable@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/4] arm64: Fix the hw_breakpoint range check
Date: Sun, 24 Nov 2013 11:32:50 +0100
Message-Id: <1385289171-3411-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385289171-3411-1-git-send-email-fweisbec@gmail.com>
References: <1385289171-3411-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

arch_check_bp_in_kernelspace() tries to avoid the overflow and does 2
TASK_SIZE checks but it needs OR, not AND. Consider va = TASK_SIZE -1
and len = 2 case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Fixes: 478fcb2cdb2351dcfc3fb23f42d76f4436ee4149
Cc: <stable@vger.kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/arm64/kernel/hw_breakpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index ff516f6..4bbbfde 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -293,7 +293,7 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
 	va = info->address;
 	len = get_hbp_len(info->ctrl.len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 /*
-- 
1.8.3.1

