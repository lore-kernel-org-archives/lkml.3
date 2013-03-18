Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934091Ab3CRV4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:56:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab3CRVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 45/75] s390: critical section cleanup vs. machine checks
Date: Mon, 18 Mar 2013 14:07:08 -0700
Message-Id: <20130318210513.493721358@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/entry.S   |    3 ++-
 arch/s390/kernel/entry64.S |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -636,7 +636,8 @@ ENTRY(mcck_int_handler)
 	UPDATE_VTIME %r14,%r15,__LC_MCCK_ENTER_TIMER
 mcck_skip:
 	SWITCH_ASYNC __LC_GPREGS_SAVE_AREA+32,__LC_PANIC_STACK,PAGE_SHIFT
-	mvc	__PT_R0(64,%r11),__LC_GPREGS_SAVE_AREA
+	stm	%r0,%r7,__PT_R0(%r11)
+	mvc	__PT_R8(32,%r11),__LC_GPREGS_SAVE_AREA+32
 	stm	%r8,%r9,__PT_PSW(%r11)
 	xc	__SF_BACKCHAIN(4,%r15),__SF_BACKCHAIN(%r15)
 	l	%r1,BASED(.Ldo_machine_check)
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -678,8 +678,9 @@ ENTRY(mcck_int_handler)
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


