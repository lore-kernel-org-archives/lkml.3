Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbaIBWTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:19:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbaIBWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:19:52 -0400
Date: Tue, 2 Sep 2014 15:19:30 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-5e23fee23ea10730c752edce1777e6b7e727290f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sbsiddha@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sbsiddha@gmail.com, tglx@linutronix.de, oleg@redhat.com,
        hpa@linux.intel.com
In-Reply-To: <20140902175727.GA21666@redhat.com>
References: <20140902175727.GA21666@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: copy_process: Sanitize fpu->
 last_cpu initialization
Git-Commit-ID: 5e23fee23ea10730c752edce1777e6b7e727290f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e23fee23ea10730c752edce1777e6b7e727290f
Gitweb:     http://git.kernel.org/tip/5e23fee23ea10730c752edce1777e6b7e727290f
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 2 Sep 2014 19:57:27 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Sep 2014 14:51:16 -0700

x86, fpu: copy_process: Sanitize fpu->last_cpu initialization

Cosmetic, but imho memset(&dst->thread.fpu, 0) is not good simply
because it hides the (important) usage of ->has_fpu/etc from grep.
Change this code to initialize the members explicitly.

And note that ->last_cpu = 0 looks simply wrong, this can confuse
fpu_lazy_restore() if per_cpu(fpu_owner_task, 0) has already exited
and copy_process() re-allocated the same task_struct. Fortunately
this is not actually possible because child->fpu_counter == 0 and
thus fpu_lazy_restore() will not be called, but still this is not
clean/robust.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20140902175727.GA21666@redhat.com
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/process.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b9ba9d5..a44268c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -66,7 +66,9 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
 
-	memset(&dst->thread.fpu, 0, sizeof(dst->thread.fpu));
+	dst->thread.fpu.has_fpu = 0;
+	dst->thread.fpu.last_cpu = ~0;
+	dst->thread.fpu.state = NULL;
 	if (tsk_used_math(src)) {
 		int err = fpu_alloc(&dst->thread.fpu);
 		if (err)
