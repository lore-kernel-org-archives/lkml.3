Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbbAGC2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:28:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbbAGCQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.17 54/73] userns: Allow setting gid_maps without privilege when setgroups is disabled
Date: Tue,  6 Jan 2015 18:16:15 -0800
Message-Id: <20150107021559.181620724@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -826,6 +826,11 @@ static bool new_idmap_permitted(const st
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
 


