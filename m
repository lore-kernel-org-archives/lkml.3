Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925Ab3FCWXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:23:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30555 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742Ab3FCWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:57 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fnKe4KI2X1kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hWjMM9_jUWAA:10 a=hGzw-44bAAAA:8 a=voM4FWlXAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=dowx1zmaLagA:10 a=LI9Vle30uBYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221154.320195525@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>, <stable@kernel.org>,
        Eric Paris <eparis@redhat.com>
Subject: [13/65] audit: Syscall rules are not applied to existing processes on
 non-x86
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0013-audit-Syscall-rules-are-not-applied-to-existing-proc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

[ Upstream commit cdee3904b4ce7c03d1013ed6dd704b43ae7fc2e9 ]

Commit b05d8447e782 (audit: inline audit_syscall_entry to reduce
burden on archs) changed audit_syscall_entry to check for a dummy
context before calling __audit_syscall_entry. Unfortunately the dummy
context state is maintained in __audit_syscall_entry so once set it
never gets cleared, even if the audit rules change.

As a result, if there are no auditing rules when a process starts
then it will never be subject to any rules added later. x86 doesn't
see this because it has an assembly fast path that calls directly into
__audit_syscall_entry.

I noticed this issue when working on audit performance optimisations.
I wrote a set of simple test cases available at:

http://ozlabs.org/~anton/junkcode/audit_tests.tar.gz

02_new_rule.py fails without the patch and passes with it. The
test case clears all rules, starts a process, adds a rule then
verifies the process produces a syscall audit record.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org> # 3.3+
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/audit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 36abf2a..a36d567 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -481,7 +481,7 @@ static inline void audit_syscall_entry(int arch, int major, unsigned long a0,
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
 {
-	if (unlikely(!audit_dummy_context()))
+	if (unlikely(current->audit_context))
 		__audit_syscall_entry(arch, major, a0, a1, a2, a3);
 }
 static inline void audit_syscall_exit(void *pt_regs)
-- 
1.7.10.4


