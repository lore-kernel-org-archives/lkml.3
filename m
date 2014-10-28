Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbaJ1HRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:17:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488AbaJ1DoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Long <dave.long@linaro.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.16 035/127] arm64: debug: dont re-enable debug exceptions on return from el1_dbg
Date: Tue, 28 Oct 2014 11:34:30 +0800
Message-Id: <20141028033422.450370759@linuxfoundation.org>
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

From: Will Deacon <will.deacon@arm.com>

commit 1059c6bf8534acda249e7e65c81e7696fb074dc1 upstream.

When returning from a debug exception taken from EL1, we unmask debug
exceptions after handling the exception. This is crucial for debug
exceptions taken from EL0, so that any kernel work on the ret_to_user
path can be debugged by kgdb.

However, when returning back to EL1 the only thing left to do is to
restore the original register state before the exception return. If
single-step has been enabled by the debug exception handler, we will
get stuck in an infinite debug exception loop, since we will take the
step exception as soon as we unmask debug exceptions.

This patch avoids unmasking debug exceptions on the debug exception
return path when the exception was taken from EL1.

Fixes: 2a2830703a23 (arm64: debug: avoid accessing mdscr_el1 on fault paths where possible)
Reported-by: David Long <dave.long@linaro.org>
Reported-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/entry.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -298,7 +298,6 @@ el1_dbg:
 	mrs	x0, far_el1
 	mov	x2, sp				// struct pt_regs
 	bl	do_debug_exception
-	enable_dbg
 	kernel_exit 1
 el1_inv:
 	// TODO: add support for undefined instructions in kernel mode


