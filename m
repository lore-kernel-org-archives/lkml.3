Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbbAIKuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:50:12 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44561 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757449AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 65/78] userns: Allow setting gid_maps without privilege when setgroups is disabled
Date: Fri,  9 Jan 2015 11:32:14 +0100
Message-Id: <90aca415b2917dbb16512b5299f0d5118cf0748c.1420799385.git.jslaby@suse.cz>
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

commit 66d2f338ee4c449396b6f99f5e75cd18eb6df272 upstream.

Now that setgroups can be disabled and not reenabled, setting gid_map
without privielge can now be enabled when setgroups is disabled.

This restores most of the functionality that was lost when unprivileged
setting of gid_map was removed.  Applications that use this functionality
will need to check to see if they use setgroups or init_groups, and if they
don't they can be fixed by simply disabling setgroups before writing to
gid_map.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/user_namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 7737b3da335c..c09fe8b87cb0 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -812,6 +812,11 @@ static bool new_idmap_permitted(const struct file *file,
 			kuid_t uid = make_kuid(ns->parent, id);
 			if (uid_eq(uid, cred->euid))
 				return true;
+		} else if (cap_setid == CAP_SETGID) {
+			kgid_t gid = make_kgid(ns->parent, id);
+			if (!(ns->flags & USERNS_SETGROUPS_ALLOWED) &&
+			    gid_eq(gid, cred->egid))
+				return true;
 		}
 	}
 
-- 
2.2.1

