Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbbALS35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:29:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbbALS3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 128/216] userns: Allow setting gid_maps without privilege when setgroups is disabled
Date: Mon, 12 Jan 2015 18:28:26 +0000
Message-Id: <1421087394-2712-16-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/user_namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index c960426a46fc..a4017e14a5b0 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -826,6 +826,11 @@ static bool new_idmap_permitted(const struct file *file,
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
2.1.4

