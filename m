Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab3APQE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:04:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab3APQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:04:45 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 114/222] proc: pid/status: show all supplementary groups
Date: Wed, 16 Jan 2013 13:55:14 -0200
Message-Id: <1358351822-7675-115-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 8d238027b87e654be552eabdf492042a34c5c300 upstream.

We display a list of supplementary group for each process in
/proc/<pid>/status.  However, we show only the first 32 groups, not all of
them.

Although this is rare, but sometimes processes do have more than 32
supplementary groups, and this kernel limitation breaks user-space apps
that rely on the group list in /proc/<pid>/status.

Number 32 comes from the internal NGROUPS_SMALL macro which defines the
length for the internal kernel "small" groups buffer.  There is no
apparent reason to limit to this value.

This patch removes the 32 groups printing limit.

The Linux kernel limits the amount of supplementary groups by NGROUPS_MAX,
which is currently set to 65536.  And this is the maximum count of groups
we may possibly print.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c1c207c..bd31e02 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -212,7 +212,7 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	group_info = cred->group_info;
 	task_unlock(p);
 
-	for (g = 0; g < min(group_info->ngroups, NGROUPS_SMALL); g++)
+	for (g = 0; g < group_info->ngroups; g++)
 		seq_printf(m, "%d ",
 			   from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
-- 
1.7.9.5

