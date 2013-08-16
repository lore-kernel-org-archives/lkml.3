Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3HQAGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:06:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3HPWj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 101/133] userns: unshare_userns(&cred) should not populate cred on failure
Date: Fri, 16 Aug 2013 15:34:03 -0700
Message-Id: <1376692475-28413-102-git-send-email-kamal@canonical.com>
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

commit 6160968cee8b90a5dd95318d716e31d7775c4ef3 upstream.

unshare_userns(new_cred) does *new_cred = prepare_creds() before
create_user_ns() which can fail. However, the caller expects that
it doesn't need to take care of new_cred if unshare_userns() fails.

We could change the single caller, sys_unshare(), but I think it
would be more clean to avoid the side effects on failure, so with
this patch unshare_userns() does put_cred() itself and initializes
*new_cred only if create_user_ns() succeeeds.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/user_namespace.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index f359dc7..38ae0f5 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -105,16 +105,21 @@ int create_user_ns(struct cred *new)
 int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
 {
 	struct cred *cred;
+	int err = -ENOMEM;
 
 	if (!(unshare_flags & CLONE_NEWUSER))
 		return 0;
 
 	cred = prepare_creds();
-	if (!cred)
-		return -ENOMEM;
+	if (cred) {
+		err = create_user_ns(cred);
+		if (err)
+			put_cred(cred);
+		else
+			*new_cred = cred;
+	}
 
-	*new_cred = cred;
-	return create_user_ns(cred);
+	return err;
 }
 
 void free_user_ns(struct kref *kref)
-- 
1.8.1.2

