Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3AaLHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:07:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3AaLHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:07:46 -0500
Date: Thu, 31 Jan 2013 03:07:20 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-40a1ef95da85843696fc3ebe5fce39b0db32669f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jbeulich@suse.com, pmoody@google.com,
        JBeulich@suse.com, tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jbeulich@suse.com, pmoody@google.com,
        JBeulich@suse.com, tglx@linutronix.de, david.vrabel@citrix.com
In-Reply-To: <5108E01902000078000BA9C5@nat28.tlf.novell.com>
References: <5108E01902000078000BA9C5@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64: Replace left over sti/
 cli in ia32 audit exit code
Git-Commit-ID: 40a1ef95da85843696fc3ebe5fce39b0db32669f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 03:07:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40a1ef95da85843696fc3ebe5fce39b0db32669f
Gitweb:     http://git.kernel.org/tip/40a1ef95da85843696fc3ebe5fce39b0db32669f
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Wed, 30 Jan 2013 07:55:53 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 31 Jan 2013 10:36:01 +0100

x86-64: Replace left over sti/cli in ia32 audit exit code

For some reason they didn't get replaced so far by their
paravirt equivalents, resulting in code to be run with
interrupts disabled that doesn't expect so (causing, in the
observed case, a BUG_ON() to trigger) when syscall auditing is
enabled.

David (Cc-ed) came up with an identical fix, so likely this can
be taken to count as an ack from him.

Reported-by: Peter Moody <pmoody@google.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/5108E01902000078000BA9C5@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Tested-by: Peter Moody <pmoody@google.com>
---
 arch/x86/ia32/ia32entry.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 102ff7c..142c4ce 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -207,7 +207,7 @@ sysexit_from_sys_call:
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%esi		/* second arg, syscall return value */
 	cmpl $-MAX_ERRNO,%eax	/* is it an error ? */
 	jbe 1f
@@ -217,7 +217,7 @@ sysexit_from_sys_call:
 	call __audit_syscall_exit
 	movq RAX-ARGOFFSET(%rsp),%rax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz \exit
