Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655Ab3JPRqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761292Ab3JPRpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [ 18/69] ARC: Fix 32-bit wrap around in access_ok()
Date: Wed, 16 Oct 2013 10:44:27 -0700
Message-Id: <20131016174315.114565125@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit 0752adfda15f0eca9859a76da3db1800e129ad43 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/asm/uaccess.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 


