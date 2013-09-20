Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3ITUOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab3ITUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 31/93] proc: Restrict mounting the proc filesystem
Date: Fri, 20 Sep 2013 13:08:26 -0700
Message-Id: <1379707768-1804-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit aee1c13dd0f6c2fc56e0e492b349ee8ac655880f upstream.

Don't allow mounting the proc filesystem unless the caller has
CAP_SYS_ADMIN rights over the pid namespace.  The principle here is if
you create or have capabilities over it you can mount it, otherwise
you get to live with what other people have mounted.

Andy pointed out that this is needed to prevent users in a user
namespace from remounting proc and specifying different hidepid and gid
options on already existing proc mounts.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/proc/root.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 9c7fab1..411068e 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -110,7 +110,8 @@ static struct dentry *proc_mount(struct file_system_type *fs_type,
 		ns = task_active_pid_ns(current);
 		options = data;
 
-		if (!current_user_ns()->may_mount_proc)
+		if (!current_user_ns()->may_mount_proc ||
+		    !ns_capable(ns->user_ns, CAP_SYS_ADMIN))
 			return ERR_PTR(-EPERM);
 	}
 
-- 
1.8.1.2

