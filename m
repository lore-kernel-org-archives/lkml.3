Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766Ab3CZPWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:22:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868Ab3CZPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 028/150] s390: critical section cleanup vs. machine checks
Date: Tue, 26 Mar 2013 15:18:47 +0000
Message-Id: <1364311249-14454-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 6551fbdfd8b85d1ab5822ac98abb4fb449bcfae0 upstream.

The current machine check code uses the registers stored by the machine
in the lowcore at __LC_GPREGS_SAVE_AREA as the registers of the interrupted
context. The registers 0-7 of a user process can get clobbered if a machine
checks interrupts the execution of a critical section in entry[64].S.

The reason is that the critical section cleanup code may need to modify
the PSW and the registers for the previous context to get to the end of a
critical section. If registers 0-7 have to be replaced the relevant copy
will be in the registers, which invalidates the copy in the lowcore. The
machine check handler needs to explicitly store registers 0-7 to the stack.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kernel/entry.S   | 3 ++-
 arch/s390/kernel/entry64.S | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 1ae93b5..b48e939 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -670,7 +670,8 @@ ENTRY(mcck_int_handler)
 	UPDATE_VTIME %r14,%r15,__LC_MCCK_ENTER_TIMER
 mcck_skip:
 	SWITCH_ASYNC __LC_GPREGS_SAVE_AREA+32,__LC_PANIC_STACK,PAGE_SHIFT
-	mvc	__PT_R0(64,%r11),__LC_GPREGS_SAVE_AREA
+	stm	%r0,%r7,__PT_R0(%r11)
+	mvc	__PT_R8(32,%r11),__LC_GPREGS_SAVE_AREA+32
 	stm	%r8,%r9,__PT_PSW(%r11)
 	xc	__SF_BACKCHAIN(4,%r15),__SF_BACKCHAIN(%r15)
 	l	%r1,BASED(.Ldo_machine_check)
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 229fe1d..db8d885 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -697,8 +697,9 @@ ENTRY(mcck_int_handler)
 	UPDATE_VTIME %r14,__LC_MCCK_ENTER_TIMER
 	LAST_BREAK %r14
 mcck_skip:
-	lghi	%r14,__LC_GPREGS_SAVE_AREA
-	mvc	__PT_R0(128,%r11),0(%r14)
+	lghi	%r14,__LC_GPREGS_SAVE_AREA+64
+	stmg	%r0,%r7,__PT_R0(%r11)
+	mvc	__PT_R8(64,%r11),0(%r14)
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs
-- 
1.8.1.2

