Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3AZCTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 21:19:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53384 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab3AZCT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 21:19:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Vasily Kulikov <segoon@openwall.com>
References: <87ehh8it9s.fsf@xmission.com>
Date: Fri, 25 Jan 2013 18:19:18 -0800
In-Reply-To: <87ehh8it9s.fsf@xmission.com> (Eric W. Biederman's message of
	"Fri, 25 Jan 2013 18:15:43 -0800")
Message-ID: <877gn0it3t.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Ad1OT1i6CnuXQ/0O2sHgdYbU5aYSTcUA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0796]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 1/6] userns: Avoid recursion in put_user_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When freeing a deeply nested user namespace free_user_ns calls
put_user_ns on it's parent which may in turn call free_user_ns again.
When -fno-optimize-sibling-calls is passed to gcc one stack frame per
user namespace is left on the stack, potentially overflowing the
kernel stack.  CONFIG_FRAME_POINTER forces -fno-optimize-sibling-calls
so we can't count on gcc to optimize this code.

Remove struct kref and use a plain atomic_t.  Making the code more
flexible and easier to comprehend.  Make the loop in free_user_ns
explict to guarantee that the stack does not overflow with
CONFIG_FRAME_POINTER enabled.

I have tested this fix with a simple program that uses unshare to
create a deeply nested user namespace structure and then calls exit.
With 1000 nesteuser namespaces before this change running my test
program causes the kernel to die a horrible death.  With 10,000,000
nested user namespaces after this change my test program runs to
completion and causes no harm.

Pointed-out-by: Vasily Kulikov <segoon@openwall.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/user_namespace.h |   10 +++++-----
 kernel/user.c                  |    4 +---
 kernel/user_namespace.c        |   17 +++++++++--------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index b9bd2e6..4ce0093 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -21,7 +21,7 @@ struct user_namespace {
 	struct uid_gid_map	uid_map;
 	struct uid_gid_map	gid_map;
 	struct uid_gid_map	projid_map;
-	struct kref		kref;
+	atomic_t		count;
 	struct user_namespace	*parent;
 	kuid_t			owner;
 	kgid_t			group;
@@ -35,18 +35,18 @@ extern struct user_namespace init_user_ns;
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 {
 	if (ns)
-		kref_get(&ns->kref);
+		atomic_inc(&ns->count);
 	return ns;
 }
 
 extern int create_user_ns(struct cred *new);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
-extern void free_user_ns(struct kref *kref);
+extern void free_user_ns(struct user_namespace *ns);
 
 static inline void put_user_ns(struct user_namespace *ns)
 {
-	if (ns)
-		kref_put(&ns->kref, free_user_ns);
+	if (ns && atomic_dec_and_test(&ns->count))
+		free_user_ns(ns);
 }
 
 struct seq_operations;
diff --git a/kernel/user.c b/kernel/user.c
index 33acb5e..57ebfd4 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -47,9 +47,7 @@ struct user_namespace init_user_ns = {
 			.count = 4294967295U,
 		},
 	},
-	.kref = {
-		.refcount	= ATOMIC_INIT(3),
-	},
+	.count = ATOMIC_INIT(3),
 	.owner = GLOBAL_ROOT_UID,
 	.group = GLOBAL_ROOT_GID,
 	.proc_inum = PROC_USER_INIT_INO,
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 2b042c4..24f8ec3 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -78,7 +78,7 @@ int create_user_ns(struct cred *new)
 		return ret;
 	}
 
-	kref_init(&ns->kref);
+	atomic_set(&ns->count, 1);
 	/* Leave the new->user_ns reference with the new user namespace. */
 	ns->parent = parent_ns;
 	ns->owner = owner;
@@ -104,15 +104,16 @@ int unshare_userns(unsigned long unshare_flags, struct cred **new_cred)
 	return create_user_ns(cred);
 }
 
-void free_user_ns(struct kref *kref)
+void free_user_ns(struct user_namespace *ns)
 {
-	struct user_namespace *parent, *ns =
-		container_of(kref, struct user_namespace, kref);
+	struct user_namespace *parent;
 
-	parent = ns->parent;
-	proc_free_inum(ns->proc_inum);
-	kmem_cache_free(user_ns_cachep, ns);
-	put_user_ns(parent);
+	do {
+		parent = ns->parent;
+		proc_free_inum(ns->proc_inum);
+		kmem_cache_free(user_ns_cachep, ns);
+		ns = parent;
+	} while (atomic_dec_and_test(&parent->count));
 }
 EXPORT_SYMBOL(free_user_ns);
 
-- 
1.7.5.4

