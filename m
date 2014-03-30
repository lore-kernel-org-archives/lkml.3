Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaC3XdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:33:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36515 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753132AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Borkmann" <dborkman@redhat.com>,
        "Neil Horman" <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vlad Yasevich" <vyasevich@gmail.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.299429317@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 191/200] net: sctp: fix sctp_connectx abi for ia32 
 emulation/compat mode
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/socket.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c53d01e..c28eb7b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -70,6 +70,7 @@
 #include <linux/init.h>
 #include <linux/crypto.h>
 #include <linux/slab.h>
+#include <linux/compat.h>
 
 #include <net/ip.h>
 #include <net/icmp.h>
@@ -1376,11 +1377,19 @@ SCTP_STATIC int sctp_setsockopt_connectx(struct sock* sk,
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
@@ -1389,16 +1398,30 @@ SCTP_STATIC int sctp_getsockopt_connectx3(struct sock* sk, int len,
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

