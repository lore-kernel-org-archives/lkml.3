Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab3JJPts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52997 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab3JJPto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 104/104] net: Update the sysctl permissions handler to test effective uid/gid
Date: Thu, 10 Oct 2013 08:42:32 -0700
Message-Id: <1381419752-29733-105-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 2433c8f094a008895e66f25bd1773cdb01c91d01 upstream.

Modify the code to use current_euid(), and in_egroup_p, as in done
in fs/proc/proc_sysctl.c:test_perm()

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sysctl_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index 9bc6db0..e7000be 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -47,12 +47,12 @@ static int net_ctl_permissions(struct ctl_table_header *head,
 
 	/* Allow network administrator to have same access as root. */
 	if (ns_capable(net->user_ns, CAP_NET_ADMIN) ||
-	    uid_eq(root_uid, current_uid())) {
+	    uid_eq(root_uid, current_euid())) {
 		int mode = (table->mode >> 6) & 7;
 		return (mode << 6) | (mode << 3) | mode;
 	}
 	/* Allow netns root group to have the same access as the root group */
-	if (gid_eq(root_gid, current_gid())) {
+	if (in_egroup_p(root_gid)) {
 		int mode = (table->mode >> 3) & 7;
 		return (mode << 3) | mode;
 	}
-- 
1.8.1.2

