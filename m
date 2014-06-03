Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaFCP0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:26:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49383 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaFCP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:26:08 -0400
Date: Tue, 3 Jun 2014 16:26:04 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: richard@nod.at, akpm@linux-foundation.org, bfields@fieldses.org
Subject: [PATCH v2 10/11] [net/sunrpc] replace strict_strto calls
Message-ID: <20140603152604.GL28580@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 10/11] [net/sunrpc] replace strict_strto calls

Replace obsolete strict_strto calls with appropriate kstrto calls

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 net/sunrpc/addr.c     | 16 ++++++----------
 net/sunrpc/auth.c     |  2 +-
 net/sunrpc/xprtsock.c |  4 ++--
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/sunrpc/addr.c b/net/sunrpc/addr.c
index a622ad6..2e0a6f9 100644
--- a/net/sunrpc/addr.c
+++ b/net/sunrpc/addr.c
@@ -176,7 +176,7 @@ static int rpc_parse_scope_id(struct net *net, const char *buf,
 	len = (buf + buflen) - delim - 1;
 	p = kstrndup(delim + 1, len, GFP_KERNEL);
 	if (p) {
-		unsigned long scope_id = 0;
+		u32 scope_id = 0;
 		struct net_device *dev;
 
 		dev = dev_get_by_name(net, p);
@@ -184,7 +184,7 @@ static int rpc_parse_scope_id(struct net *net, const char *buf,
 			scope_id = dev->ifindex;
 			dev_put(dev);
 		} else {
-			if (strict_strtoul(p, 10, &scope_id) == 0) {
+			if (kstrtou32(p, 10, &scope_id) == 0) {
 				kfree(p);
 				return 0;
 			}
@@ -304,7 +304,7 @@ char *rpc_sockaddr2uaddr(const struct sockaddr *sap, gfp_t gfp_flags)
  * @sap: buffer into which to plant socket address
  * @salen: size of buffer
  *
- * @uaddr does not have to be '\0'-terminated, but strict_strtoul() and
+ * @uaddr does not have to be '\0'-terminated, but kstrtou8() and
  * rpc_pton() require proper string termination to be successful.
  *
  * Returns the size of the socket address if successful; otherwise
@@ -315,7 +315,7 @@ size_t rpc_uaddr2sockaddr(struct net *net, const char *uaddr,
 			  const size_t salen)
 {
 	char *c, buf[RPCBIND_MAXUADDRLEN + sizeof('\0')];
-	unsigned long portlo, porthi;
+	u8 portlo, porthi;
 	unsigned short port;
 
 	if (uaddr_len > RPCBIND_MAXUADDRLEN)
@@ -327,18 +327,14 @@ size_t rpc_uaddr2sockaddr(struct net *net, const char *uaddr,
 	c = strrchr(buf, '.');
 	if (unlikely(c == NULL))
 		return 0;
-	if (unlikely(strict_strtoul(c + 1, 10, &portlo) != 0))
-		return 0;
-	if (unlikely(portlo > 255))
+	if (unlikely(kstrtou8(c + 1, 10, &portlo) != 0))
 		return 0;
 
 	*c = '\0';
 	c = strrchr(buf, '.');
 	if (unlikely(c == NULL))
 		return 0;
-	if (unlikely(strict_strtoul(c + 1, 10, &porthi) != 0))
-		return 0;
-	if (unlikely(porthi > 255))
+	if (unlikely(kstrtou8(c + 1, 10, &porthi) != 0))
 		return 0;
 
 	port = (unsigned short)((porthi << 8) | portlo);
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 5285ead..0a64ffe 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -48,7 +48,7 @@ static int param_set_hashtbl_sz(const char *val, const struct kernel_param *kp)
 
 	if (!val)
 		goto out_inval;
-	ret = strict_strtoul(val, 0, &num);
+	ret = kstrtoul(val, 0, &num);
 	if (ret == -EINVAL)
 		goto out_inval;
 	nbits = fls(num);
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 25a3dcf..45db0c6 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -3057,12 +3057,12 @@ static int param_set_uint_minmax(const char *val,
 		const struct kernel_param *kp,
 		unsigned int min, unsigned int max)
 {
-	unsigned long num;
+	unsigned int num;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
-	ret = strict_strtoul(val, 0, &num);
+	ret = kstrtouint(val, 0, &num);
 	if (ret == -EINVAL || num < min || num > max)
 		return -EINVAL;
 	*((unsigned int *)kp->arg) = num;
-- 
1.9.3

