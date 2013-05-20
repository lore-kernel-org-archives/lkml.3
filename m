Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3ETK4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:56:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56448 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab3ETKyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:54:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 108/115] usermodehelper: check subprocess_info->path != NULL
Date: Mon, 20 May 2013 11:51:48 +0100
Message-Id: <1369047116-9378-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/kmod.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index ff2c7cb..cc76ad6 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -541,6 +541,11 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
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

