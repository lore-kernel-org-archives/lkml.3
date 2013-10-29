Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab3J2OIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:08:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab3J2OIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:08:41 -0400
Date: Tue, 29 Oct 2013 07:08:07 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-32c5fb7e7d18b4fd37c5e29dea731151e9d66866@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131016200945.GB23214@redhat.com>
References: <20131016200945.GB23214@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Kill the dead !vma->
 vm_mm code in perf_event_mmap_event()
Git-Commit-ID: 32c5fb7e7d18b4fd37c5e29dea731151e9d66866
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:08:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32c5fb7e7d18b4fd37c5e29dea731151e9d66866
Gitweb:     http://git.kernel.org/tip/32c5fb7e7d18b4fd37c5e29dea731151e9d66866
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 16 Oct 2013 22:09:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:51 +0100

perf: Kill the dead !vma->vm_mm code in perf_event_mmap_event()

1. perf_event_mmap(vma) is never called with a gate_vma-like arg,
   remove the "if (!vma->vm_mm)" code.

2. arch_vma_name() can use the chached value of mmap_event->vma.

3. Change the code to not call arch_vma_name() twice.

4. Purely cosmetic, but since we use "goto got_name" all the time
   remove "else" from "[stack]" branch just for symmetry.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131016200945.GB23214@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 028dad9..3ea5605 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5136,21 +5136,19 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
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
