Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487Ab3LYCgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 21:36:44 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38937 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab3LYCgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 21:36:43 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, patches@linaro.org,
        dsaxena@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH] audit: correct a type mismatch in audit_syscall_exit()
Date: Wed, 25 Dec 2013 11:35:53 +0900
Message-Id: <1387938953-15667-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_syscall_exit() saves a result of regs_return_value() in intermediate
"int" variable and passes it to __audit_syscall_exit(), which expects its
second argument as a "long" value.
This will result in truncating the value returned by a system call and
making a wrong audit record.
I don't know why gcc compiler doesn't complain about this, but anyway it
causes a problem at runtime on arm64 (and probably most 64-bit archs).

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 include/linux/audit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index c49a312..3dcb3f0 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -144,7 +144,7 @@ static inline void audit_syscall_exit(void *pt_regs)
 {
 	if (unlikely(current->audit_context)) {
 		int success = is_syscall_success(pt_regs);
-		int return_code = regs_return_value(pt_regs);
+		long return_code = regs_return_value(pt_regs);
 
 		__audit_syscall_exit(success, return_code);
 	}
-- 
1.7.9.5

