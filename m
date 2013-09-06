Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab3IFBt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:49:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab3IFBtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:49:17 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ZtygFLEOK88A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=SJBCHd5iOokA:10 a=QyXUC8HyAAAA:8 a=a_U1oVfrAAAA:8 a=zGuplzhgmjNTnmIVghEA:9 a=k4qQewaewV0A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130906014915.433485667@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 05 Sep 2013 21:48:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [for-next][PATCH 3/4] x86-32, ftrace: Fix static ftrace when early microcode is enabled
References: <20130906014816.037690469@goodmis.org>
Content-Disposition: inline; filename=0003-x86-32-ftrace-Fix-static-ftrace-when-early-microcode.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Early microcode loading runs C code before paging is enabled on 32
bits.  Since ftrace puts a hook into every function, that hook needs
to be safe to execute in the pre-paging environment.  This is
currently true for dynamic ftrace but not for static ftrace.

Static ftrace is obsolescent and assumed to not be
performance-critical, so we can simply test that the stack pointer
falls within the valid range of kernel addresses.

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Tested-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 2cfbc3a..f0dcb0c 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1176,6 +1176,9 @@ ftrace_restore_flags:
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
 ENTRY(mcount)
+	cmpl $__PAGE_OFFSET, %esp
+	jb ftrace_stub		/* Paging not enabled yet? */
+
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
-- 
1.7.10.4


