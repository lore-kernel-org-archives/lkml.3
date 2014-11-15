Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaKOVCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 16:02:40 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52044 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbaKOVCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 16:02:38 -0500
X-Originating-IP: 50.43.41.112
Date: Sat, 15 Nov 2014 13:02:29 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, mtk.manpages@gmail.com,
        linux-api@vger.kernel.org, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 1/2] groups: Factor out a function to set a pre-sorted
 group list
Message-ID: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416085112.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way, functions that already need to sort the group list need not do
so twice.

The new set_groups_sorted is intentionally not exported.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/groups.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f..f0667e7 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -154,16 +154,26 @@ int groups_search(const struct group_info *group_info, kgid_t grp)
 }
 
 /**
+ * set_groups_sorted - Change a group subscription in a set of credentials
+ * @new: The newly prepared set of credentials to alter
+ * @group_info: The group list to install; must be sorted
+ */
+static void set_groups_sorted(struct cred *new, struct group_info *group_info)
+{
+	put_group_info(new->group_info);
+	get_group_info(group_info);
+	new->group_info = group_info;
+}
+
+/**
  * set_groups - Change a group subscription in a set of credentials
  * @new: The newly prepared set of credentials to alter
  * @group_info: The group list to install
  */
 void set_groups(struct cred *new, struct group_info *group_info)
 {
-	put_group_info(new->group_info);
 	groups_sort(group_info);
-	get_group_info(group_info);
-	new->group_info = group_info;
+	set_groups_sorted(new, group_info);
 }
 
 EXPORT_SYMBOL(set_groups);
-- 
2.1.3

