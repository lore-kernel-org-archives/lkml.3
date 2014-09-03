Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbaICQAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 12:00:18 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:55423 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaICQAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 12:00:14 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH] userns: Fix k[ug]id_has_mapping() for CONFIG_USER_NS=n
Date: Wed,  3 Sep 2014 10:59:34 -0500
Message-Id: <1409759974-46222-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling k[ug]id_has_mapping() with INVALID_[UG]ID returns false
if user namespaces are enabled and true if they are disabled.
INVALID_[UG]ID is never included in any mapping, so fix the
CONFIG_USER_NS=n to return false for invalid ids.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---

Hi Eric,

I noticed this inconsistency when working on support for user namespaces
in fuse. As far as I know this isn't breaking anything, but it seems
like invalid should be invalid even with CONFIG_USER_NS=n. A
compile/boot test with this patch didn't reveal any breakage.

Thanks,
Seth

 include/linux/uidgid.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index 2d1f9b627f91..6c302267f7cc 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -165,12 +165,12 @@ static inline gid_t from_kgid_munged(struct user_namespace *to, kgid_t kgid)
 
 static inline bool kuid_has_mapping(struct user_namespace *ns, kuid_t uid)
 {
-	return true;
+	return uid_valid(uid);
 }
 
 static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
 {
-	return true;
+	return gid_valid(gid);
 }
 
 #endif /* CONFIG_USER_NS */
-- 
1.9.1

