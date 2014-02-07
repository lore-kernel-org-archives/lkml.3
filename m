Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaBGLur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:50:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbaBGLuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 126/233] audit: correct a type mismatch in audit_syscall_exit()
Date: Fri,  7 Feb 2014 11:45:45 +0000
Message-Id: <1391773652-25214-127-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: AKASHI Takahiro <takahiro.akashi@linaro.org>

commit 06bdadd7634551cfe8ce071fe44d0311b3033d9e upstream.

audit_syscall_exit() saves a result of regs_return_value() in intermediate
"int" variable and passes it to __audit_syscall_exit(), which expects its
second argument as a "long" value.  This will result in truncating the
value returned by a system call and making a wrong audit record.

I don't know why gcc compiler doesn't complain about this, but anyway it
causes a problem at runtime on arm64 (and probably most 64-bit archs).

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/audit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 729a4d1..4fb28b2 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -135,7 +135,7 @@ static inline void audit_syscall_exit(void *pt_regs)
 {
 	if (unlikely(current->audit_context)) {
 		int success = is_syscall_success(pt_regs);
-		int return_code = regs_return_value(pt_regs);
+		long return_code = regs_return_value(pt_regs);
 
 		__audit_syscall_exit(success, return_code);
 	}
-- 
1.8.3.2

