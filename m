Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3K0DMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:12:20 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51780 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3K0DMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:12:19 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
        luto@amacapital.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] kernel/fork.c : remove local 'oldmm' and retval
Date: Wed, 27 Nov 2013 12:12:13 +0900
Message-ID: <2547094.3YTvOEEdct@daeseok-laptop>
User-Agent: KMail/4.8.5 (Linux/3.2.0-55-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cec2f201f0dc99a33a58d9d1e0452140bb0993a1 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@lge.com>
Date: Wed, 27 Nov 2013 09:54:41 +0900
Subject: [PATCH] kernel/fork.c : remove local 'oldmm' and retval

 Local oldmm is used only for increaing mm_users field
 in current->mm. When clone_flags have a CLONE_VM flag,
 current->mm is assigning to local 'mm'.
 Local retval is used only for returning -ENOMEM value.
 When dup_mm() is failed, just return -ENOMEM.

 Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 kernel/fork.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 728d5be..022a0af 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -857,8 +857,7 @@ fail_nocontext:
 
 static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 {
-	struct mm_struct *mm, *oldmm;
-	int retval;
+	struct mm_struct *mm;
 
 	tsk->min_flt = tsk->maj_flt = 0;
 	tsk->nvcsw = tsk->nivcsw = 0;
@@ -874,28 +873,23 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 	 *
 	 * We need to steal a active VM for that..
 	 */
-	oldmm = current->mm;
-	if (!oldmm)
+	if (!current->mm)
 		return 0;
 
 	if (clone_flags & CLONE_VM) {
-		atomic_inc(&oldmm->mm_users);
-		mm = oldmm;
+		mm = current->mm;
+		atomic_inc(&mm->mm_users);
 		goto good_mm;
 	}
 
-	retval = -ENOMEM;
 	mm = dup_mm(tsk);
 	if (!mm)
-		goto fail_nomem;
+		return -ENOMEM;
 
 good_mm:
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	return 0;
-
-fail_nomem:
-	return retval;
 }
 
 static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
-- 
1.7.9.5

---
