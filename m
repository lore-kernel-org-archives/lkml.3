Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3H0Vqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:46:36 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46259 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3H0Vqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:46:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <878uzmhkqg.fsf@xmission.com>
Date: Tue, 27 Aug 2013 14:46:27 -0700
In-Reply-To: <878uzmhkqg.fsf@xmission.com> (Eric W. Biederman's message of
	"Tue, 27 Aug 2013 14:44:39 -0700")
Message-ID: <874naahkng.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18H2IcVUjC2C+NomxXNJY8DK7fEauveoNg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1188]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH 2/2] sysfs: Restrict mounting sysfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
over the net namespace.  The principle here is if you create or have
capabilities over it you can mount it, otherwise you get to live with
what other people have mounted.

Instead of testing this with a straight forward ns_capable call,
perform this check the long and torturous way with kobject helpers,
this keeps direct knowledge of namespaces out of sysfs, and preserves
the existing sysfs abstractions.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/sysfs/mount.c           |   12 +++++++++---
 include/linux/kobject_ns.h |    2 ++
 lib/kobject.c              |   12 ++++++++++++
 net/core/net-sysfs.c       |    8 ++++++++
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 4a2da3a..8c69ef4 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -112,9 +112,15 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
 	struct super_block *sb;
 	int error;
 
-	if (!(flags & MS_KERNMOUNT) && !capable(CAP_SYS_ADMIN) &&
-	    !fs_fully_visible(fs_type))
-		return ERR_PTR(-EPERM);
+	if (!(flags & MS_KERNMOUNT)) {
+		if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
+			return ERR_PTR(-EPERM);
+
+		for (type = KOBJ_NS_TYPE_NONE; type < KOBJ_NS_TYPES; type++) {
+			if (!kobj_ns_current_may_mount(type))
+				return ERR_PTR(-EPERM);
+		}
+	}
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
diff --git a/include/linux/kobject_ns.h b/include/linux/kobject_ns.h
index f66b065..df32d25 100644
--- a/include/linux/kobject_ns.h
+++ b/include/linux/kobject_ns.h
@@ -39,6 +39,7 @@ enum kobj_ns_type {
  */
 struct kobj_ns_type_operations {
 	enum kobj_ns_type type;
+	bool (*current_may_mount)(void);
 	void *(*grab_current_ns)(void);
 	const void *(*netlink_ns)(struct sock *sk);
 	const void *(*initial_ns)(void);
@@ -50,6 +51,7 @@ int kobj_ns_type_registered(enum kobj_ns_type type);
 const struct kobj_ns_type_operations *kobj_child_ns_ops(struct kobject *parent);
 const struct kobj_ns_type_operations *kobj_ns_ops(struct kobject *kobj);
 
+bool kobj_ns_current_may_mount(enum kobj_ns_type type);
 void *kobj_ns_grab_current(enum kobj_ns_type type);
 const void *kobj_ns_netlink(enum kobj_ns_type type, struct sock *sk);
 const void *kobj_ns_initial(enum kobj_ns_type type);
diff --git a/lib/kobject.c b/lib/kobject.c
index 4a1f33d..1853bd9 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -915,6 +915,18 @@ const struct kobj_ns_type_operations *kobj_ns_ops(struct kobject *kobj)
 	return kobj_child_ns_ops(kobj->parent);
 }
 
+bool kobj_ns_current_may_mount(enum kobj_ns_type type)
+{
+	bool may_mount = false;
+
+	spin_lock(&kobj_ns_type_lock);
+	if ((type > KOBJ_NS_TYPE_NONE) && (type < KOBJ_NS_TYPES) &&
+	    kobj_ns_ops_tbl[type])
+		may_mount = kobj_ns_ops_tbl[type]->current_may_mount();
+	spin_unlock(&kobj_ns_type_lock);
+
+	return may_mount;
+}
 
 void *kobj_ns_grab_current(enum kobj_ns_type type)
 {
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 981fed3..0b0ff95 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1157,6 +1157,13 @@ static void remove_queue_kobjects(struct net_device *net)
 #endif
 }
 
+static bool net_current_may_mount(void)
+{
+	struct net *net = current->nsproxy->net_ns;
+
+	return !ns_capable(net->user_ns, CAP_SYS_ADMIN);
+}
+
 static void *net_grab_current_ns(void)
 {
 	struct net *ns = current->nsproxy->net_ns;
@@ -1179,6 +1186,7 @@ static const void *net_netlink_ns(struct sock *sk)
 
 struct kobj_ns_type_operations net_ns_type_operations = {
 	.type = KOBJ_NS_TYPE_NET,
+	.current_may_mount = net_current_may_mount,
 	.grab_current_ns = net_grab_current_ns,
 	.netlink_ns = net_netlink_ns,
 	.initial_ns = net_initial_ns,
-- 
1.7.5.4

