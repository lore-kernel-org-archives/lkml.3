Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbaJDAq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:46:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbaJCVcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.16 055/357] arm64: ptrace: fix compat hardware watchpoint reporting
Date: Fri,  3 Oct 2014 14:27:21 -0700
Message-Id: <20141003212935.108632703@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 27d7ff273c2aad37b28f6ff0cab2cfa35b51e648 upstream.

I'm not sure what I was on when I wrote this, but when iterating over
the hardware watchpoint array (hbp_watch_array), our index is off by
ARM_MAX_BRP, so we walk off the end of our thread_struct...

... except, a dodgy condition in the loop means that it never executes
at all (bp cannot be NULL).

This patch fixes the code so that we remove the bp check and use the
correct index for accessing the watchpoint structures.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/hw_breakpoint.h |    1 -
 arch/arm64/kernel/ptrace.c             |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -79,7 +79,6 @@ static inline void decode_ctrl_reg(u32 r
  */
 #define ARM_MAX_BRP		16
 #define ARM_MAX_WRP		16
-#define ARM_MAX_HBP_SLOTS	(ARM_MAX_BRP + ARM_MAX_WRP)
 
 /* Virtual debug register bases. */
 #define AARCH64_DBG_REG_BVR	0
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -85,7 +85,8 @@ static void ptrace_hbptriggered(struct p
 			break;
 		}
 	}
-	for (i = ARM_MAX_BRP; i < ARM_MAX_HBP_SLOTS && !bp; ++i) {
+
+	for (i = 0; i < ARM_MAX_WRP; ++i) {
 		if (current->thread.debug.hbp_watch[i] == bp) {
 			info.si_errno = -((i << 1) + 1);
 			break;


