Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3E1TVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:21:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab3E1TVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:21:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/4] MN10300: Enable IRQs more in system call exit work path
 [ver #2]
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Ken Cox <jkc@redhat.com>
Date: Tue, 28 May 2013 20:21:10 +0100
Message-ID: <20130528192110.20162.24770.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130528192102.20162.96295.stgit@warthog.procyon.org.uk>
References: <20130528192102.20162.96295.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable IRQs when calling schedule() for TIF_NEED_RESCHED and
do_notify_resume().  If interrupts are enabled during do_notify_resume(), a
warning can be seen (see lower down).

Whilst we're at it, resume_userspace can be made local to entry.S as it is not
called outside of there and it can be merged with the part of work_resched that
occurs after schedule() is called.


------------[ cut here ]------------
WARNING: at kernel/softirq.c:160 local_bh_enable+0x42/0xa0()
Modules linked in:
Stack:
  00000000 93d63d88 90009916 901f618c 901f65a8 000000a0 900109b2 93d63db0
  93d62000 93d24d40 00000000 90009940 93d63eb3 93d63dbc 900109b2 00000009
  00000000 93d63dc0 900109b2 93d62000 93d63de0 93d63de0 9016cd1a 901124c8

Call Trace:
 [<90002b8f>] ? show_trace+0x13/0xb4
 [<90002cd0>] show_stack+0x7c/0x84
 [<901124c8>] ? skb_free_head+0x4c/0x54
 [<90002fc9>] dump_stack+0x11/0x18
 [<90009916>] warn_slowpath_common+0x4a/0x5c
 [<900109b2>] ? local_bh_enable+0x42/0xa0
 [<90009940>] warn_slowpath_null+0x18/0x20
 [<900109b2>] ? local_bh_enable+0x42/0xa0
 [<900109b2>] local_bh_enable+0x42/0xa0
 [<9016cd1a>] unix_release_sock+0x86/0x23c
 [<901124c8>] ? skb_free_head+0x4c/0x54
 [<9010e8b5>] ? sk_free+0x31/0x38
 [<9016cef0>] unix_release+0x20/0x28
 [<9010c647>] sock_release+0x17/0x88
 [<9010c874>] sock_close+0x20/0x28
 [<900678e9>] __fput+0xc9/0x1fc
 [<90067a27>] ____fput+0xb/0x10
 [<9001f5a8>] task_work_run+0x64/0x78
 [<9010bda7>] ? sys_connect+0x5b/0x80
 [<90002399>] do_notify_resume+0x53d/0x544
 [<90067dc6>] ? fput+0xce/0xd4
 [<90065117>] ? filp_close+0x5f/0x68
 [<9007bba0>] ? __close_fd+0x7c/0xb0
 [<900026c6>] work_notifysig+0xa/0xc

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Ken Cox <jkc@redhat.com>
---

 arch/mn10300/kernel/entry.S |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)


diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 9420057..222152a 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -108,10 +108,10 @@ syscall_exit_work:
 	and	EPSW_nSL,d0
 	beq	resume_kernel		# returning to supervisor mode
 
-	btst	_TIF_SYSCALL_TRACE,d2
-	beq	work_pending
 	LOCAL_IRQ_ENABLE		# could let syscall_trace_exit() call
 					# schedule() instead
+	btst	_TIF_SYSCALL_TRACE,d2
+	beq	work_pending
 	mov	fp,d0
 	call	syscall_trace_exit[],0	# do_syscall_trace(regs)
 	jmp	resume_userspace
@@ -124,6 +124,7 @@ work_pending:
 work_resched:
 	call	schedule[],0
 
+resume_userspace:
 	# make sure we don't miss an interrupt setting need_resched or
 	# sigpending between sampling and the rti
 	LOCAL_IRQ_DISABLE
@@ -132,6 +133,8 @@ work_resched:
 	mov	(TI_flags,a2),d2
 	btst	_TIF_WORK_MASK,d2
 	beq	restore_all
+
+	LOCAL_IRQ_ENABLE
 	btst	_TIF_NEED_RESCHED,d2
 	bne	work_resched
 
@@ -170,17 +173,6 @@ ret_from_intr:
 	and	EPSW_nSL,d0
 	beq	resume_kernel		# returning to supervisor mode
 
-ENTRY(resume_userspace)
-	# make sure we don't miss an interrupt setting need_resched or
-	# sigpending between sampling and the rti
-	LOCAL_IRQ_DISABLE
-
-	# is there any work to be done on int/exception return?
-	mov	(TI_flags,a2),d2
-	btst	_TIF_WORK_MASK,d2
-	bne	work_pending
-	jmp	restore_all
-
 #ifdef CONFIG_PREEMPT
 ENTRY(resume_kernel)
 	LOCAL_IRQ_DISABLE

