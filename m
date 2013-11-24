Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab3KXKdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 05:33:08 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:59577 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3KXKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 05:32:58 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, <stable@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/4] x86: Fix the hw_breakpoint range check
Date: Sun, 24 Nov 2013 11:32:49 +0100
Message-Id: <1385289171-3411-3-git-send-email-fweisbec@gmail.com>
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

Note: TASK_SIZE doesn't look right at least on x86, I think it should
be replaced by TASK_SIZE_MAX.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Fixes: 0067f1297241ea567f2b22a455519752d70fcca9
Cc: <stable@vger.kernel.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/hw_breakpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index f66ff16..1131c1f 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -200,7 +200,7 @@ int arch_check_bp_in_kernelspace(struct perf_event *bp)
 	va = info->address;
 	len = get_hbp_len(info->len);
 
-	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+	return (va >= TASK_SIZE) || ((va + len - 1) >= TASK_SIZE);
 }
 
 int arch_bp_generic_fields(int x86_len, int x86_type,
-- 
1.8.3.1

