Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3ETLIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:08:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56209 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab3ETKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, Eric Paris <eparis@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 061/115] audit: Syscall rules are not applied to existing processes on non-x86
Date: Mon, 20 May 2013 11:51:01 +0100
Message-Id: <1369047116-9378-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/audit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index eaa7c9f..41b4e49 100644
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
1.8.1.2

