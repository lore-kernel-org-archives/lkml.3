Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201Ab3E1V3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:29:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59823 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933837Ab3E1V0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 50/78] usermodehelper: check subprocess_info->path != NULL
Date: Tue, 28 May 2013 14:19:59 -0700
Message-Id: <1369776027-17859-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 264b83c07a84223f0efd0d1db9ccc66d6f88288f upstream.

argv_split(empty_or_all_spaces) happily succeeds, it simply returns
argc == 0 and argv[0] == NULL. Change call_usermodehelper_exec() to
check sub_info->path != NULL to avoid the crash.

This is the minimal fix, todo:

 - perhaps we should change argv_split() to return NULL or change the
   callers.

 - kill or justify ->path[0] check

 - narrow the scope of helper_lock()

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-By: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/kmod.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 0023a87..41e1524 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -561,6 +561,11 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	int retval = 0;
 
 	helper_lock();
+	if (!sub_info->path) {
+		retval = -EINVAL;
+		goto out;
+	}
+
 	if (sub_info->path[0] == '\0')
 		goto out;
 
-- 
1.8.1.2

