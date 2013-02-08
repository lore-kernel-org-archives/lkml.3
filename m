Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946035Ab3BHBCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:02:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945917Ab3BHA6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Moody <pmoody@google.com>, Jan Beulich <jbeulich@suse.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 04/16] x86-64: Replace left over sti/cli in ia32 audit exit code
Date: Thu,  7 Feb 2013 16:58:03 -0800
Message-Id: <20130208004627.831001175@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.112511141@linuxfoundation.org>
References: <20130208004627.112511141@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/ia32/ia32entry.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -208,7 +208,7 @@ sysexit_from_sys_call:
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%esi		/* second arg, syscall return value */
 	cmpl $0,%eax		/* is it < 0? */
 	setl %al		/* 1 if so, 0 if not */
@@ -218,7 +218,7 @@ sysexit_from_sys_call:
 	GET_THREAD_INFO(%r10)
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %edi,TI_flags(%r10)
 	jz \exit


