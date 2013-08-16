Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3HPWj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51708 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab3HPWjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 102/133] userns: limit the maximum depth of user_namespace->parent chain
Date: Fri, 16 Aug 2013 15:34:04 -0700
Message-Id: <1376692475-28413-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 8742f229b635bf1c1c84a3dfe5e47c814c20b5c8 upstream.

Ensure that user_namespace->parent chain can't grow too much.
Currently we use the hardroded 32 as limit.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/user_namespace.h | 1 +
 kernel/user_namespace.c        | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 5209cfe..e4539aa 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -23,6 +23,7 @@ struct user_namespace {
 	struct uid_gid_map	projid_map;
 	struct kref		kref;
 	struct user_namespace	*parent;
+	int			level;
 	kuid_t			owner;
 	kgid_t			group;
 	unsigned int		proc_inum;
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 38ae0f5..b9b0b51 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -62,6 +62,9 @@ int create_user_ns(struct cred *new)
 	kgid_t group = new->egid;
 	int ret;
 
+	if (parent_ns->level > 32)
+		return -EUSERS;
+
 	/*
 	 * Verify that we can not violate the policy of which files
 	 * may be accessed that is specified by the root directory,
@@ -92,6 +95,7 @@ int create_user_ns(struct cred *new)
 	kref_init(&ns->kref);
 	/* Leave the new->user_ns reference with the new user namespace. */
 	ns->parent = parent_ns;
+	ns->level = parent_ns->level + 1;
 	ns->owner = owner;
 	ns->group = group;
 
-- 
1.8.1.2

