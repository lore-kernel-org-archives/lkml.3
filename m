Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaANR2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:28:09 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaANR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:28:07 -0500
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, pat-lkml@erley.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH v2] Call arch_pick_mmap_layout() only once
Date: Tue, 14 Jan 2014 18:27:52 +0100
Message-Id: <1389720472-28362-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently both setup_new_exec() and flush_old_exec() issue
a call to arch_pick_mmap_layout().
As setup_new_exec() and flush_old_exec() are always called
pairwise arch_pick_mmap_layout() is called twice.

This patch removes one call from setup_new_exec() to have
it only called once.

Tested-by: Pat Erley <pat-lkml@erley.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
Changes between v1 and v2:

Pat reported that v1 broke IA32 emulation on x86_64.
It turned out that we have to keep the second call to
arch_pick_mmap_layout() and are free to remove the first
one. v1 did it the other way around.
This is needed because only the latter call will see all
current->personality flags.

diff --git a/fs/exec.c b/fs/exec.c
index 7ea097f..a733599 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -843,7 +843,6 @@ static int exec_mmap(struct mm_struct *mm)
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
 	task_unlock(tsk);
-	arch_pick_mmap_layout(mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
 		BUG_ON(active_mm != old_mm);
-- 
1.8.4.2

