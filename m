Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab3HTCyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:54:51 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41383 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3HTCyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:54:50 -0400
X-Spam-Score: -101.1
Message-ID: <5212DA37.1090101@asianux.com>
Date: Tue, 20 Aug 2013 10:53:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        "dhowells@redhat.com" <dhowells@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: user_namespace: always set the return parameter 'new_cred'
 when call unshare_userns() successfully.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unshare_userns() succeed, recommend to always set the return
parameter which may be used by caller.

The caller has rights to call it with 'new_cred' uninitialized, if
succeed, the caller can assume the 'new_cred' has been initialized.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/user_namespace.h |    1 +
 kernel/user_namespace.c        |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index b6b215f..3159af5 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -75,6 +75,7 @@ static inline int unshare_userns(unsigned long unshare_flags,
 {
 	if (unshare_flags & CLONE_NEWUSER)
 		return -EINVAL;
+	*new_cred = NULL;
 	return 0;
 }
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 6e50a44..6b90818 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -107,8 +107,10 @@ int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
 	struct cred *cred;
 	int err = -ENOMEM;
 
-	if (!(unshare_flags & CLONE_NEWUSER))
+	if (!(unshare_flags & CLONE_NEWUSER)) {
+		*new_cred = NULL;
 		return 0;
+	}
 
 	cred = prepare_creds();
 	if (cred) {
-- 
1.7.7.6
