Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab3EQWHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:07:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707Ab3EQVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>, Eric Paris <eparis@redhat.com>
Subject: [ 11/50] audit: Syscall rules are not applied to existing processes on non-x86
Date: Fri, 17 May 2013 14:46:46 -0700
Message-Id: <20130517213843.860003205@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit cdee3904b4ce7c03d1013ed6dd704b43ae7fc2e9 upstream.

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
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/audit.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -480,7 +480,7 @@ static inline void audit_syscall_entry(i
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
 {
-	if (unlikely(!audit_dummy_context()))
+	if (unlikely(current->audit_context))
 		__audit_syscall_entry(arch, major, a0, a1, a2, a3);
 }
 static inline void audit_syscall_exit(void *pt_regs)


