Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab3JKUXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:23:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3JKTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 102/110] s390: fix system call restart after inferior call
Date: Fri, 11 Oct 2013 12:39:22 -0700
Message-Id: <20131011193818.902202549@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit dbbfe487e5f3fc00c9fe5207d63309859704d12f upstream.

Git commit 616498813b11ffef "s390: system call path micro optimization"
introduced a regression in regard to system call restarting and inferior
function calls via the ptrace interface. The pointer to the system call
table needs to be loaded in sysc_sigpending if do_signal returns with
TIF_SYSCALl set after it restored a system call context.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/entry.S   |    1 +
 arch/s390/kernel/entry64.S |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -265,6 +265,7 @@ sysc_sigpending:
 	tm	__TI_flags+3(%r12),_TIF_SYSCALL
 	jno	sysc_return
 	lm	%r2,%r7,__PT_R2(%r11)	# load svc arguments
+	l	%r10,__TI_sysc_table(%r12)	# 31 bit system call table
 	xr	%r8,%r8			# svc 0 returns -ENOSYS
 	clc	__PT_INT_CODE+2(2,%r11),BASED(.Lnr_syscalls+2)
 	jnl	sysc_nr_ok		# invalid svc number -> do svc 0
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -293,6 +293,7 @@ sysc_sigpending:
 	tm	__TI_flags+7(%r12),_TIF_SYSCALL
 	jno	sysc_return
 	lmg	%r2,%r7,__PT_R2(%r11)	# load svc arguments
+	lg	%r10,__TI_sysc_table(%r12)	# address of system call table
 	lghi	%r8,0			# svc 0 returns -ENOSYS
 	llgh	%r1,__PT_INT_CODE+2(%r11)	# load new svc number
 	cghi	%r1,NR_syscalls


