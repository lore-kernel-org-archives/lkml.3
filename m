Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaFWIwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:52:02 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55570 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/111] net: Add variants of capable for use on on sockets
Date: Mon, 23 Jun 2014 10:32:04 +0200
Message-Id: <8c91777bd4951c1f1ad59842fe4d208f94a97dfe.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit a3b299da869d6e78cf42ae0b1b41797bcb8c5e4b ]

sk_net_capable - The common case, operations that are safe in a network namespace.
sk_capable - Operations that are not known to be safe in a network namespace
sk_ns_capable - The general case for special cases.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/net/sock.h |  5 +++++
 net/core/sock.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6e2c4901a477..4aa873a6267f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2275,6 +2275,11 @@ extern int sock_get_timestampns(struct sock *, struct timespec __user *);
 extern int sock_recv_errqueue(struct sock *sk, struct msghdr *msg, int len,
 			      int level, int type);
 
+bool sk_ns_capable(const struct sock *sk,
+		   struct user_namespace *user_ns, int cap);
+bool sk_capable(const struct sock *sk, int cap);
+bool sk_net_capable(const struct sock *sk, int cap);
+
 /*
  *	Enable debug/info messages
  */
diff --git a/net/core/sock.c b/net/core/sock.c
index ec228a30e7dc..f9ec2f5be1c0 100644
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
2.0.0

