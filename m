Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbbASSwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:52:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbbASSwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:52:40 -0500
Date: Mon, 19 Jan 2015 19:51:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: [PATCH 1/3] x86, fpu: __kernel_fpu_begin() should clear
	fpu_owner_task even if use_eager_fpu()
Message-ID: <20150119185132.GB16427@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150119185109.GA16427@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119185109.GA16427@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__kernel_fpu_begin() does nothing if !__thread_has_fpu() && use_eager_fpu(),
perhaps it assumes that this case is simply impossible. This is certainly
not possible if in_interrupt() == T; interrupted_user_mode() should have
FPU, and interrupted_kernel_fpu_idle() should fail if !__thread_has_fpu().

However, even if use_eager_fpu() == T a task can do drop_fpu(), then switch
to another thread which becomes fpu_owner_task, then resume and call some
function which does kernel_fpu_begin(). Say, an exiting task does a lot of
things after exit_thread(), it is not safe to assume that it can't use FPU
in these paths.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/i387.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 81049ff..26f0e80 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -93,9 +93,10 @@ void __kernel_fpu_begin(void)
 
 	if (__thread_has_fpu(me)) {
 		__save_init_fpu(me);
-	} else if (!use_eager_fpu()) {
+	} else {
 		this_cpu_write(fpu_owner_task, NULL);
-		clts();
+		if (!use_eager_fpu())
+			clts();
 	}
 }
 EXPORT_SYMBOL(__kernel_fpu_begin);
-- 
1.5.5.1


