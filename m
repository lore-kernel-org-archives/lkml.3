Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaIBR76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbaIBR7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:59:55 -0400
Date: Tue, 2 Sep 2014 19:57:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha <sbsiddha@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Bean Anderson <bean@azulsystems.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] x86, fpu: copy_process: sanitize fpu->last_cpu
	initialization
Message-ID: <20140902175727.GA21666@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902175654.GA21626@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Reviewed-by: Suresh Siddha <sbsiddha@gmail.com>
---
 arch/x86/kernel/process.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1dfdd69..9b9f088 100644
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
-- 
1.5.5.1

