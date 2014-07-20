Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaGTVwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 17:52:15 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:43925 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaGTVwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 17:52:01 -0400
Date: Sun, 20 Jul 2014 23:51:52 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: X86 ML <x86@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86_32, entry: use syscall_badsys from syscall_trace_entry
Message-ID: <alpine.LNX.2.11.1407202350500.31021@titan.int.lan.stealer.net>
User-Agent: Alpine 2.11 (LNX 23 2013-08-11)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 1.8
X-Spam-Bar: +
X-Spam-Report: Scanned by SpamAssassin 3.3.2 2011-06-06 on smtp1.stealer.net at Sun, 20 Jul 2014 21:52:00 +0000
 Bayes: 0.1723 Tokens: new, 167; hammy, 2; neutral, 4; spammy, 0.
 AutoLearn: no
 * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
 *      [score: 0.1723]
 *  1.0 URIBL_RHSMAILPOLICE Contains a URL listed in the
 *      block.rhs.mailpolice.com blocklist
 *      [URIs: stealer.net]
 *  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
X-Spam-Signature: 36c640b7447df0dd5426861c78fdfd98b58e2321
X-DomainKey-Status: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring syscall_trace_entry in line with the other syscall_* error
handling code and use syscall_badsys for setting -ENOSYS.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 arch/x86/kernel/entry_32.S | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 0d0c9d4..793f6c9 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -644,13 +644,12 @@ END(work_pending)
 	# perform syscall exit tracing
 	ALIGN
 syscall_trace_entry:
-	movl $-ENOSYS,PT_EAX(%esp)
 	movl %esp, %eax
 	call syscall_trace_enter
 	/* What it returned is what we'll actually use.  */
 	cmpl $(NR_syscalls), %eax
-	jnae syscall_call
-	jmp syscall_exit
+	jae syscall_badsys
+	jmp syscall_call
 END(syscall_trace_entry)
 
 	# perform syscall exit tracing
