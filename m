Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaFWNbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:31:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60775 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754891AbaFWN3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:29:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 18/21] kgr: fix race of stub and patching
Date: Mon, 23 Jun 2014 15:29:32 +0200
Message-Id: <1403530175-29217-18-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
References: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we are patching, we set up a stub which refers to
kgr_in_progress of a process. The stub can be called immediately when
set up, but we set the flag even after done with patching in
kgr_handle_processes. This is obviously too late, so set the flag
before we start patching, but after we check that no other patching is
in progress -- we would interfere otherwise.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Aravinda Prasad <aravinda@linux.vnet.ibm.com>
---
 kernel/kgraft.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index 6816da29a6a3..89414957cf74 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -124,14 +124,22 @@ static void kgr_work_fn(struct work_struct *work)
 	mutex_unlock(&kgr_in_progress_lock);
 }
 
-static void kgr_handle_processes(void)
+static void kgr_mark_processes(void)
 {
 	struct task_struct *p;
 
 	read_lock(&tasklist_lock);
-	for_each_process(p) {
+	for_each_process(p)
 		kgr_mark_task_in_progress(p);
+	read_unlock(&tasklist_lock);
+}
 
+static void kgr_handle_processes(void)
+{
+	struct task_struct *p;
+
+	read_lock(&tasklist_lock);
+	for_each_process(p) {
 		/* wake up kthreads, they will clean the progress flag */
 		if (!p->mm) {
 			/*
@@ -333,6 +341,8 @@ int kgr_start_patching(struct kgr_patch *patch)
 		goto unlock_free;
 	}
 
+	kgr_mark_processes();
+
 	for (patch_fun = patch->patches; *patch_fun; patch_fun++) {
 		ret = kgr_patch_code(patch, *patch_fun, false);
 		/*
-- 
2.0.0

