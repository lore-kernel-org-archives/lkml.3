Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbbAGCKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:10:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118AbbAGCHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:07:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.14 37/52] userns: Dont allow unprivileged creation of gid mappings
Date: Tue,  6 Jan 2015 18:07:05 -0800
Message-Id: <20150107020601.146112950@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107020555.043793795@linuxfoundation.org>
References: <20150107020555.043793795@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit be7c6dba2332cef0677fbabb606e279ae76652c3 upstream.

As any gid mapping will allow and must allow for backwards
compatibility dropping groups don't allow any gid mappings to be
established without CAP_SETGID in the parent user namespace.

For a small class of applications this change breaks userspace
and removes useful functionality.  This small class of applications
includes tools/testing/selftests/mount/unprivilged-remount-test.c

Most of the removed functionality will be added back with the addition
of a one way knob to disable setgroups.  Once setgroups is disabled
setting the gid_map becomes as safe as setting the uid_map.

For more common applications that set the uid_map and the gid_map
with privilege this change will have no affect.

This is part of a fix for CVE-2014-8989.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -814,11 +814,6 @@ static bool new_idmap_permitted(const st
 			if (uid_eq(uid, file->f_cred->fsuid))
 				return true;
 		}
-		else if (cap_setid == CAP_SETGID) {
-			kgid_t gid = make_kgid(ns->parent, id);
-			if (gid_eq(gid, file->f_cred->fsgid))
-				return true;
-		}
 	}
 
 	/* Allow anyone to set a mapping that doesn't require privilege */


