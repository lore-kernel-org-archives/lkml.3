Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaJ1DqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:46:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbaJ1DqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:46:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Meelis Roos <mroos@linux.ee>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.16 110/127] sparc64: Do not define thread fpregs save area as zero-length array.
Date: Tue, 28 Oct 2014 11:35:45 +0800
Message-Id: <20141028033425.667041969@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit e2653143d7d79a49f1a961aeae1d82612838b12c ]

This breaks the stack end corruption detection facility.

What that facility does it write a magic value to "end_of_stack()"
and checking to see if it gets overwritten.

"end_of_stack()" is "task_thread_info(p) + 1", which for sparc64 is
the beginning of the FPU register save area.

So once the user uses the FPU, the magic value is overwritten and the
debug checks trigger.

Fix this by making the size explicit.

Due to the size we use for the fpsaved[], gsr[], and xfsr[] arrays we
are limited to 7 levels of FPU state saves.  So each FPU register set
is 256 bytes, allocate 256 * 7 for the fpregs area.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/thread_info_64.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -63,7 +63,8 @@ struct thread_info {
 	struct pt_regs		*kern_una_regs;
 	unsigned int		kern_una_insn;
 
-	unsigned long		fpregs[0] __attribute__ ((aligned(64)));
+	unsigned long		fpregs[(7 * 256) / sizeof(unsigned long)]
+		__attribute__ ((aligned(64)));
 };
 
 #endif /* !(__ASSEMBLY__) */


