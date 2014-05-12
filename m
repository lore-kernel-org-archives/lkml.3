Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaELBmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:42:43 -0400
Received: from 1wt.eu ([62.212.114.60]:34599 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbaELBmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:40 -0400
Message-Id: <20140512003204.877170755@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 102/143] net: sctp: fix sctp_connectx abi for ia32 emulation/compat mode
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit ffd5939381c609056b33b7585fb05a77b4c695f3 ]

SCTP's sctp_connectx() abi breaks for 64bit kernels compiled with 32bit
emulation (e.g. ia32 emulation or x86_x32). Due to internal usage of
'struct sctp_getaddrs_old' which includes a struct sockaddr pointer,
sizeof(param) check will always fail in kernel as the structure in
64bit kernel space is 4bytes larger than for user binaries compiled
in 32bit mode. Thus, applications making use of sctp_connectx() won't
be able to run under such circumstances.

Introduce a compat interface in the kernel to deal with such
situations by using a 'struct compat_sctp_getaddrs_old' structure
where user data is copied into it, and then sucessively transformed
into a 'struct sctp_getaddrs_old' structure with the help of
compat_ptr(). That fixes sctp_connectx() abi without any changes
needed in user space, and lets the SCTP test suite pass when compiled
in 32bit and run on 64bit kernels.

Fixes: f9c67811ebc0 ("sctp: Fix regression introduced by new sctp_connectx api")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sctp/socket.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 44d8eab..c26d905 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -67,6 +67,7 @@
 #include <linux/poll.h>
 #include <linux/init.h>
 #include <linux/crypto.h>
+#include <linux/compat.h>
 
 #include <net/ip.h>
 #include <net/icmp.h>
@@ -1284,11 +1285,19 @@ SCTP_STATIC int sctp_setsockopt_connectx(struct sock* sk,
 /*
  * New (hopefully final) interface for the API.
  * We use the sctp_getaddrs_old structure so that use-space library
- * can avoid any unnecessary allocations.   The only defferent part
+ * can avoid any unnecessary allocations. The only different part
  * is that we store the actual length of the address buffer into the
- * addrs_num structure member.  That way we can re-use the existing
+ * addrs_num structure member. That way we can re-use the existing
  * code.
  */
+#ifdef CONFIG_COMPAT
+struct compat_sctp_getaddrs_old {
+	sctp_assoc_t	assoc_id;
+	s32		addr_num;
+	compat_uptr_t	addrs;		/* struct sockaddr * */
+};
+#endif
+
 SCTP_STATIC int sctp_getsockopt_connectx3(struct sock* sk, int len,
 					char __user *optval,
 					int __user *optlen)
@@ -1297,16 +1306,30 @@ SCTP_STATIC int sctp_getsockopt_connectx3(struct sock* sk, int len,
 	sctp_assoc_t assoc_id = 0;
 	int err = 0;
 
-	if (len < sizeof(param))
-		return -EINVAL;
+#ifdef CONFIG_COMPAT
+	if (is_compat_task()) {
+		struct compat_sctp_getaddrs_old param32;
 
-	if (copy_from_user(&param, optval, sizeof(param)))
-		return -EFAULT;
+		if (len < sizeof(param32))
+			return -EINVAL;
+		if (copy_from_user(&param32, optval, sizeof(param32)))
+			return -EFAULT;
 
-	err = __sctp_setsockopt_connectx(sk,
-			(struct sockaddr __user *)param.addrs,
-			param.addr_num, &assoc_id);
+		param.assoc_id = param32.assoc_id;
+		param.addr_num = param32.addr_num;
+		param.addrs = compat_ptr(param32.addrs);
+	} else
+#endif
+	{
+		if (len < sizeof(param))
+			return -EINVAL;
+		if (copy_from_user(&param, optval, sizeof(param)))
+			return -EFAULT;
+	}
 
+	err = __sctp_setsockopt_connectx(sk, (struct sockaddr __user *)
+					 param.addrs, param.addr_num,
+					 &assoc_id);
 	if (err == 0 || err == -EINPROGRESS) {
 		if (copy_to_user(optval, &assoc_id, sizeof(assoc_id)))
 			return -EFAULT;
-- 
1.7.12.2.21.g234cd45.dirty



