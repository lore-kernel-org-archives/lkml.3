Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761845Ab3JPUQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:16:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761822Ab3JPUQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:16:44 -0400
Date: Wed, 16 Oct 2013 22:09:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf: Kill the dead !vma->vm_mm code in
	perf_event_mmap_event()
Message-ID: <20131016200945.GB23214@redhat.com>
References: <20131012192203.GA21738@redhat.com> <20131014102426.GX3081@twins.programming.kicks-ass.net> <20131016200924.GA23214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016200924.GA23214@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. perf_event_mmap(vma) is never called with a gate_vma-like arg,
   remove the "if (!vma->vm_mm)" code.

2. arch_vma_name() can use the chached value of mmap_event->vma.

3. Change the code to not call arch_vma_name() twice.

4. Purely cosmetic, but since we use "goto got_name" all the time
   remove "else" from "[stack]" branch just for symmetry.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/core.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cb4238e..e27d8f8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5130,21 +5130,19 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		min = MINOR(dev);
 
 	} else {
-		if (arch_vma_name(mmap_event->vma)) {
-			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
-				       sizeof(tmp) - 1);
+		name = arch_vma_name(vma);
+		if (name) {
+			name = strncpy(tmp, name, sizeof(tmp) - 1);
 			tmp[sizeof(tmp) - 1] = '\0';
 			goto got_name;
 		}
 
-		if (!vma->vm_mm) {
-			name = strncpy(tmp, "[vdso]", sizeof(tmp));
-			goto got_name;
-		} else if (vma->vm_start <= vma->vm_mm->start_brk &&
+		if (vma->vm_start <= vma->vm_mm->start_brk &&
 				vma->vm_end >= vma->vm_mm->brk) {
 			name = strncpy(tmp, "[heap]", sizeof(tmp));
 			goto got_name;
-		} else if (vma->vm_start <= vma->vm_mm->start_stack &&
+		}
+		if (vma->vm_start <= vma->vm_mm->start_stack &&
 				vma->vm_end >= vma->vm_mm->start_stack) {
 			name = strncpy(tmp, "[stack]", sizeof(tmp));
 			goto got_name;
-- 
1.5.5.1


