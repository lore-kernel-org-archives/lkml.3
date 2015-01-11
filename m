Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbbAKWHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:07:00 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38185 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbbAKWF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:26 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 03/11] x86,fpu: move __thread_fpu_begin to when the task has the fpu
Date: Sun, 11 Jan 2015 16:46:25 -0500
Message-Id: <1421012793-30106-4-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Move the call to __thread_fpu_begin, which in turn calls
__thread_set_has_fpu, to a spot where the task actually has
the FPU.

This is in preparation for the next patch.

This changeset introduces an extraneous clts() call when
switching from one FPU-using task to another FPU-using
task in non-eager FPU switching mode. The next patch gets
rid of that.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/fpu-internal.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fpu-internal.h b/arch/x86/include/asm/fpu-internal.h
index 5f8f971..27556f4 100644
--- a/arch/x86/include/asm/fpu-internal.h
+++ b/arch/x86/include/asm/fpu-internal.h
@@ -420,7 +420,6 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
 		if (preload) {
 			new->thread.fpu_counter++;
 			set_thread_flag(TIF_LOAD_FPU);
-			__thread_set_has_fpu(new);
 			prefetch(new->thread.fpu.state);
 		} else if (!use_eager_fpu())
 			stts();
@@ -436,7 +435,6 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
 				prefetch(new->thread.fpu.state);
 				set_thread_flag(TIF_LOAD_FPU);
 			}
-			__thread_fpu_begin(new);
 		}
 		/* else: CR0.TS is still set from a previous FPU switch */
 	}
@@ -451,6 +449,7 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
 static inline void switch_fpu_finish(struct task_struct *new)
 {
 	if (test_and_clear_thread_flag(TIF_LOAD_FPU)) {
+		__thread_fpu_begin(new);
 		if (unlikely(restore_fpu_checking(new)))
 			drop_init_fpu(new);
 	}
-- 
1.9.3

