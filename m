Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaBNUXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:23:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbaBNUXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:23:52 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
Subject: [PATCH] audit: add arch field to seccomp event log
Date: Fri, 14 Feb 2014 15:23:09 -0500
Message-Id: <4bc8c03bda84e004c331546e228b334811b03254.1392409147.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AUDIT_SECCOMP record looks something like this:

type=SECCOMP msg=audit(1373478171.953:32775): auid=4325 uid=4325 gid=4325 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0 pid=12381 comm="test" sig=31 syscall=231 compat=0 ip=0x39ea8bca89 code=0x0

In order to determine what syscall 231 maps to, we need to have the arch= field right before it.

To see the event, compile this test.c program:

=====
int main(void)
{
        return seccomp_load(seccomp_init(SCMP_ACT_KILL));
}
=====

gcc -g test.c -o test -lseccomp

After running the program, find the record by:  ausearch --start recent -m SECCOMP -i
---
 kernel/auditsc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 6874c1f..c464d44 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2412,6 +2412,7 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 		return;
 	audit_log_task(ab);
 	audit_log_format(ab, " sig=%ld", signr);
+	audit_log_format(ab, " arch=%x", current->audit_context->arch);
 	audit_log_format(ab, " syscall=%ld", syscall);
 	audit_log_format(ab, " compat=%d", is_compat_task());
 	audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));
-- 
1.7.1

