Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaHHUw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:52:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932891AbaHHUw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:52:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 204/259] net: Add variants of capable for use on on sockets
Date: Fri,  8 Aug 2014 13:40:27 -0700
Message-Id: <1407530482-4483-205-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit a3b299da869d6e78cf42ae0b1b41797bcb8c5e4b ]

sk_net_capable - The common case, operations that are safe in a network namespace.
sk_capable - Operations that are not known to be safe in a network namespace
sk_ns_capable - The general case for special cases.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/sock.h |  5 +++++
 net/core/sock.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index a2b3d4e..ca1aeeb 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2267,6 +2267,11 @@ int sock_get_timestampns(struct sock *, struct timespec __user *);
 int sock_recv_errqueue(struct sock *sk, struct msghdr *msg, int len, int level,
 		       int type);
 
+bool sk_ns_capable(const struct sock *sk,
+		   struct user_namespace *user_ns, int cap);
+bool sk_capable(const struct sock *sk, int cap);
+bool sk_net_capable(const struct sock *sk, int cap);
+
 /*
  *	Enable debug/info messages
  */
diff --git a/net/core/sock.c b/net/core/sock.c
index 50db733..1ed4266 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -145,6 +145,55 @@
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

