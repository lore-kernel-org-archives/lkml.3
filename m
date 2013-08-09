Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030347Ab3HICEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:04:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030199Ab3HIB7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 084/102] userns: unshare_userns(&cred) should not populate cred on failure
Date: Thu,  8 Aug 2013 18:58:00 -0700
Message-Id: <20130809015030.058683606@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

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
 
 void free_user_ns(struct user_namespace *ns)


