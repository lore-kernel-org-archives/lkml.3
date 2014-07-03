Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030700AbaGCJqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:46:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276AbaGCJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 134/198] net: Add variants of capable for use on on sockets
Date: Thu,  3 Jul 2014 10:19:37 +0100
Message-Id: <1404379241-8590-135-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit a3b299da869d6e78cf42ae0b1b41797bcb8c5e4b upstream.

sk_net_capable - The common case, operations that are safe in a network namespace.
sk_capable - Operations that are not known to be safe in a network namespace
sk_ns_capable - The general case for special cases.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/sock.h |  5 +++++
 net/core/sock.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 643f92e911d9..0588d4f195e3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2257,6 +2257,11 @@ extern void sock_enable_timestamp(struct sock *sk, int flag);
 extern int sock_get_timestamp(struct sock *, struct timeval __user *);
 extern int sock_get_timestampns(struct sock *, struct timespec __user *);
 
+bool sk_ns_capable(const struct sock *sk,
+		   struct user_namespace *user_ns, int cap);
+bool sk_capable(const struct sock *sk, int cap);
+bool sk_net_capable(const struct sock *sk, int cap);
+
 /*
  *	Enable debug/info messages
  */
diff --git a/net/core/sock.c b/net/core/sock.c
index 0e2b67e5c903..b384ce6cda2a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -144,6 +144,55 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
+/**
+ * sk_ns_capable - General socket capability test
+ * @sk: Socket to use a capability on or through
+ * @user_ns: The user namespace of the capability to use
+ * @cap: The capability to use
+ *
+ * Test to see if the opener of the socket had when the socket was
+ * created and the current process has the capability @cap in the user
+ * namespace @user_ns.
+ */
+bool sk_ns_capable(const struct sock *sk,
+		   struct user_namespace *user_ns, int cap)
+{
+	return file_ns_capable(sk->sk_socket->file, user_ns, cap) &&
+		ns_capable(user_ns, cap);
+}
+EXPORT_SYMBOL(sk_ns_capable);
+
+/**
+ * sk_capable - Socket global capability test
+ * @sk: Socket to use a capability on or through
+ * @cap: The global capbility to use
+ *
+ * Test to see if the opener of the socket had when the socket was
+ * created and the current process has the capability @cap in all user
+ * namespaces.
+ */
+bool sk_capable(const struct sock *sk, int cap)
+{
+	return sk_ns_capable(sk, &init_user_ns, cap);
+}
+EXPORT_SYMBOL(sk_capable);
+
+/**
+ * sk_net_capable - Network namespace socket capability test
+ * @sk: Socket to use a capability on or through
+ * @cap: The capability to use
+ *
+ * Test to see if the opener of the socket had when the socke was created
+ * and the current process has the capability @cap over the network namespace
+ * the socket is a member of.
+ */
+bool sk_net_capable(const struct sock *sk, int cap)
+{
+	return sk_ns_capable(sk, sock_net(sk)->user_ns, cap);
+}
+EXPORT_SYMBOL(sk_net_capable);
+
+
 #ifdef CONFIG_MEMCG_KMEM
 int mem_cgroup_sockets_init(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
-- 
1.9.1

