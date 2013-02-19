Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067Ab3BSSv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933985Ab3BSSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Beulich <jbeulich@suse.com>, David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 21/81] x86-64: Replace left over sti/cli in ia32 audit exit code
Date: Tue, 19 Feb 2013 15:48:44 -0300
Message-Id: <1361299784-8830-22-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 40a1ef95da85843696fc3ebe5fce39b0db32669f upstream.

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
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Tested-by: Peter Moody <pmoody@google.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/ia32/ia32entry.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 20e5f7b..f6d477a 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -204,7 +204,7 @@ sysexit_from_sys_call:
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%esi		/* second arg, syscall return value */
 	cmpl $-MAX_ERRNO,%eax	/* is it an error ? */
 	jbe 1f
@@ -214,7 +214,7 @@ sysexit_from_sys_call:
 	call __audit_syscall_exit
 	movq RAX-ARGOFFSET(%rsp),%rax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %edi,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jz \exit
-- 
1.7.9.5

