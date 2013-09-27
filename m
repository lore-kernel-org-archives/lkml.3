Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3I0K6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 06:58:24 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:36278 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3I0K6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 06:58:20 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: <arc-linux-dev@synopsys.com>, <u.kleine-koenig@pengutronix.de>,
        Noam Camus <noamc@ezchip.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 2/4] ARC: Fix 32-bit wrap around in access_ok()
Date: Fri, 27 Sep 2013 16:27:35 +0530
Message-ID: <1380279457-14299-3-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380279457-14299-1-git-send-email-vgupta@synopsys.com>
References: <1380279457-14299-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.111]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton reported

 | LTP tests syscalls/process_vm_readv01 and process_vm_writev01 fail
 | similarly in one testcase test_iov_invalid -> lvec->iov_base.
 | Testcase expects errno EFAULT and return code -1,
 | but it gets return code 1 and ERRNO is 0 what means success.

Essentially test case was passing a pointer of -1 which access_ok()
was not catching. It was doing [@addr + @sz <= TASK_SIZE] which would
pass for @addr == -1

Fixed that by rewriting as [@addr <= TASK_SIZE - @sz]

Reported-by: Anton Kolesov <Anton.Kolesov@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/uaccess.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arc/include/asm/uaccess.h b/arch/arc/include/asm/uaccess.h
index 3242082..30c9baf 100644
--- a/arch/arc/include/asm/uaccess.h
+++ b/arch/arc/include/asm/uaccess.h
@@ -43,7 +43,7 @@
  * Because it essentially checks if buffer end is within limit and @len is
  * non-ngeative, which implies that buffer start will be within limit too.
  *
- * The reason for rewriting being, for majorit yof cases, @len is generally
+ * The reason for rewriting being, for majority of cases, @len is generally
  * compile time constant, causing first sub-expression to be compile time
  * subsumed.
  *
@@ -53,7 +53,7 @@
  *
  */
 #define __user_ok(addr, sz)	(((sz) <= TASK_SIZE) && \
-				 (((addr)+(sz)) <= get_fs()))
+				 ((addr) <= (get_fs() - (sz))))
 #define __access_ok(addr, sz)	(unlikely(__kernel_ok) || \
 				 likely(__user_ok((addr), (sz))))
 
-- 
1.8.1.2

