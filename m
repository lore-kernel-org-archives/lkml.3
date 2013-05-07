Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab3EGEMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:12:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27087 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3EGD6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:46 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BmrcGei1N7oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=cqPL34UvuKEA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8 a=oGMlB6cnAAAA:8 a=QyXUC8HyAAAA:8 a=UOpjjlpZozkG-P3uORQA:9 a=jEp0ucaQiEUA:10 a=zv9_9hqRWm8A:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=g47H-S6DKWrq1WH8:21 a=ilVFhMu8VF5Bw45O:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035844.600903953@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Paul Moore <pmoore@redhat.com>, Will Drewry <wad@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [022/126] x86: remove the x32 syscall bitmask from syscall_get_nr()
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0022-x86-remove-the-x32-syscall-bitmask-from-syscall_get_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

[ Upstream commit 8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1 ]

Commit fca460f95e928bae373daa8295877b6905bc62b8 simplified the x32
implementation by creating a syscall bitmask, equal to 0x40000000, that
could be applied to x32 syscalls such that the masked syscall number
would be the same as a x86_64 syscall.  While that patch was a nice
way to simplify the code, it went a bit too far by adding the mask to
syscall_get_nr(); returning the masked syscall numbers can cause
confusion with callers that expect syscall numbers matching the x32
ABI, e.g. unmasked syscall numbers.

This patch fixes this by simply removing the mask from syscall_get_nr()
while preserving the other changes from the original commit.  While
there are several syscall_get_nr() callers in the kernel, most simply
check that the syscall number is greater than zero, in this case this
patch will have no effect.  Of those remaining callers, they appear
to be few, seccomp and ftrace, and from my testing of seccomp without
this patch the original commit definitely breaks things; the seccomp
filter does not correctly filter the syscalls due to the difference in
syscall numbers in the BPF filter and the value from syscall_get_nr().
Applying this patch restores the seccomp BPF filter functionality on
x32.

I've tested this patch with the seccomp BPF filters as well as ftrace
and everything looks reasonable to me; needless to say general usage
seemed fine as well.

Signed-off-by: Paul Moore <pmoore@redhat.com>
Link: http://lkml.kernel.org/r/20130215172143.12549.10292.stgit@localhost
Cc: <stable@vger.kernel.org>
Cc: Will Drewry <wad@chromium.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/syscall.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 1ace47b..2e188d6 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -29,13 +29,13 @@ extern const unsigned long sys_call_table[];
  */
 static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	return regs->orig_ax & __SYSCALL_MASK;
+	return regs->orig_ax;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
-	regs->ax = regs->orig_ax & __SYSCALL_MASK;
+	regs->ax = regs->orig_ax;
 }
 
 static inline long syscall_get_error(struct task_struct *task,
-- 
1.7.10.4


