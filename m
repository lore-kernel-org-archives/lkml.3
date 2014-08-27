Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971AbaH0Syj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:54:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964948AbaH0Syd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:54:33 -0400
Date: Wed, 27 Aug 2014 20:52:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] x86, fpu: copy_process: sanitize fpu->last_cpu
	initialization
Message-ID: <20140827185202.GA12515@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827185138.GA12487@redhat.com>
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
---
 arch/x86/kernel/process.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 60076b4..36dfb1d 100644
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

