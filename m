Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbbAIKke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:34 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44576 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757476AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 58/78] userns: Document what the invariant required for safe unprivileged mappings.
Date: Fri,  9 Jan 2015 11:32:07 +0100
Message-Id: <eddcd0249342e9e723a7bd5571f2f2fca2fde065.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 0542f17bf2c1f2430d368f44c8fcf2f82ec9e53e upstream.

The rule is simple.  Don't allow anything that wouldn't be allowed
without unprivileged mappings.

It was previously overlooked that establishing gid mappings would
allow dropping groups and potentially gaining permission to files and
directories that had lesser permissions for a specific group than for
all other users.

This is the rule needed to fix CVE-2014-8989 and prevent any other
security issues with new_idmap_permitted.

The reason for this rule is that the unix permission model is old and
there are programs out there somewhere that take advantage of every
little corner of it.  So allowing a uid or gid mapping to be
established without privielge that would allow anything that would not
be allowed without that mapping will result in expectations from some
code somewhere being violated.  Violated expectations about the
behavior of the OS is a long way to say a security issue.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/user_namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 6991139e3303..c9aa0e2c07ba 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -798,7 +798,9 @@ static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
 				struct uid_gid_map *new_map)
 {
-	/* Allow mapping to your own filesystem ids */
+	/* Don't allow mappings that would allow anything that wouldn't
+	 * be allowed without the establishment of unprivileged mappings.
+	 */
 	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1)) {
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
-- 
2.2.1

