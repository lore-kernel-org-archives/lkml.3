Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbaIOVDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:03:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaIOT1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3.16 070/158] MIPS: syscall: Fix AUDIT value for O32 processes on MIPS64
Date: Mon, 15 Sep 2014 12:25:09 -0700
Message-Id: <20140915192545.003759318@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 40381529f84c4cda3bd2d20cab6a707508856b21 upstream.

On MIPS64, O32 processes set both TIF_32BIT_ADDR and
TIF_32BIT_REGS so the previous condition treated O32 applications
as N32 when evaluating seccomp filters. Fix the condition to check
both TIF_32BIT_{REGS, ADDR} for the N32 AUDIT flag.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Patchwork: http://patchwork.linux-mips.org/patch/7480/
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/syscall.h |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -131,10 +131,12 @@ static inline int syscall_get_arch(void)
 {
 	int arch = EM_MIPS;
 #ifdef CONFIG_64BIT
-	if (!test_thread_flag(TIF_32BIT_REGS))
+	if (!test_thread_flag(TIF_32BIT_REGS)) {
 		arch |= __AUDIT_ARCH_64BIT;
-	if (test_thread_flag(TIF_32BIT_ADDR))
-		arch |= __AUDIT_ARCH_CONVENTION_MIPS64_N32;
+		/* N32 sets only TIF_32BIT_ADDR */
+		if (test_thread_flag(TIF_32BIT_ADDR))
+			arch |= __AUDIT_ARCH_CONVENTION_MIPS64_N32;
+	}
 #endif
 #if defined(__LITTLE_ENDIAN)
 	arch |=  __AUDIT_ARCH_LE;


