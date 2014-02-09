Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaBIWs5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 17:48:57 -0500
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:45512 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752250AbaBIWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 17:48:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:1:2:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1431:1437:1605:1730:1747:1777:1792:2194:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3873:4052:4250:4321:4419:4605:5007:6117:6119:6248:6261:7875:8603:8660:9040:9121:9201:9592:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:13148:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: voice93_13537e37b4315
X-Filterd-Recvd-Size: 10629
From: Joe Perches <joe@perches.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ncpfs: Add pr_fmt and convert printks to pr_<level>
Date: Sun,  9 Feb 2014 14:48:45 -0800
Message-Id: <56e474b69bc5fdd143856afbaffbbdb6b26318de.1391985629.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1391985629.git.joe@perches.com>
References: <cover.1391985629.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to a more current logging style.

Add pr_fmt to prefix with "ncpfs: ".
Remove the embedded function names and use "%s: ", __func__

Some previously unprefixed messages now have "ncpfs: "

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ncpfs/file.c          |  4 +++-
 fs/ncpfs/getopt.c        | 12 +++++++-----
 fs/ncpfs/inode.c         | 10 ++++++----
 fs/ncpfs/ncplib_kernel.c |  4 ++--
 fs/ncpfs/sock.c          | 31 ++++++++++++++++---------------
 5 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 8f5074e..93f3191 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -6,6 +6,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/uaccess.h>
 
 #include <linux/time.h>
@@ -34,7 +36,7 @@ int ncp_make_open(struct inode *inode, int right)
 
 	error = -EINVAL;
 	if (!inode) {
-		printk(KERN_ERR "ncp_make_open: got NULL inode\n");
+		pr_err("%s: got NULL inode\n", __func__);
 		goto out;
 	}
 
diff --git a/fs/ncpfs/getopt.c b/fs/ncpfs/getopt.c
index 0af3349..03ffde1 100644
--- a/fs/ncpfs/getopt.c
+++ b/fs/ncpfs/getopt.c
@@ -2,6 +2,8 @@
  * getopt.c
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/string.h>
 
@@ -46,8 +48,8 @@ int ncp_getopt(const char *caller, char **options, const struct ncp_option *opts
 				if (opts->has_arg & OPT_NOPARAM) {
 					return opts->val;
 				}
-				printk(KERN_INFO "%s: the %s option requires an argument\n",
-				       caller, token);
+				pr_info("%s: the %s option requires an argument\n",
+					caller, token);
 				return -EINVAL;
 			}
 			if (opts->has_arg & OPT_INT) {
@@ -57,18 +59,18 @@ int ncp_getopt(const char *caller, char **options, const struct ncp_option *opts
 				if (!*v) {
 					return opts->val;
 				}
-				printk(KERN_INFO "%s: invalid numeric value in %s=%s\n",
+				pr_info("%s: invalid numeric value in %s=%s\n",
 					caller, token, val);
 				return -EDOM;
 			}
 			if (opts->has_arg & OPT_STRING) {
 				return opts->val;
 			}
-			printk(KERN_INFO "%s: unexpected argument %s to the %s option\n",
+			pr_info("%s: unexpected argument %s to the %s option\n",
 				caller, val, token);
 			return -EINVAL;
 		}
 	}
-	printk(KERN_INFO "%s: Unrecognized mount option %s\n", caller, token);
+	pr_info("%s: Unrecognized mount option %s\n", caller, token);
 	return -EOPNOTSUPP;
 }
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 2cf2ebe..f1d0ce7 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -9,6 +9,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 
 #include <asm/uaccess.h>
@@ -257,7 +259,7 @@ ncp_iget(struct super_block *sb, struct ncp_entry_info *info)
 	struct inode *inode;
 
 	if (info == NULL) {
-		printk(KERN_ERR "ncp_iget: info is NULL\n");
+		pr_err("%s: info is NULL\n", __func__);
 		return NULL;
 	}
 
@@ -289,7 +291,7 @@ ncp_iget(struct super_block *sb, struct ncp_entry_info *info)
 		}
 		insert_inode_hash(inode);
 	} else
-		printk(KERN_ERR "ncp_iget: iget failed!\n");
+		pr_err("%s: iget failed!\n", __func__);
 	return inode;
 }
 
@@ -305,7 +307,7 @@ ncp_evict_inode(struct inode *inode)
 
 	if (ncp_make_closed(inode) != 0) {
 		/* We can't do anything but complain. */
-		printk(KERN_ERR "ncp_evict_inode: could not close\n");
+		pr_err("%s: could not close\n", __func__);
 	}
 }
 
@@ -620,7 +622,7 @@ static int ncp_fill_super(struct super_block *sb, void *raw_data, int silent)
 	   now because of PATH_MAX changes.. */
 	if (server->m.time_out < 1) {
 		server->m.time_out = 10;
-		printk(KERN_INFO "You need to recompile your ncpfs utils..\n");
+		pr_info("You need to recompile your ncpfs utils..\n");
 	}
 	server->m.time_out = server->m.time_out * HZ / 100;
 	server->m.file_mode = (server->m.file_mode & S_IRWXUGO) | S_IFREG;
diff --git a/fs/ncpfs/ncplib_kernel.c b/fs/ncpfs/ncplib_kernel.c
index 981a956..827c118 100644
--- a/fs/ncpfs/ncplib_kernel.c
+++ b/fs/ncpfs/ncplib_kernel.c
@@ -9,7 +9,7 @@
  *
  */
 
-
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include "ncp_fs.h"
 
@@ -425,7 +425,7 @@ int ncp_obtain_info(struct ncp_server *server, struct inode *dir, const char *pa
 	int result;
 
 	if (target == NULL) {
-		printk(KERN_ERR "ncp_obtain_info: invalid call\n");
+		pr_err("%s: invalid call\n", __func__);
 		return -EINVAL;
 	}
 	ncp_init_request(server);
diff --git a/fs/ncpfs/sock.c b/fs/ncpfs/sock.c
index 3a15872..6390d7b 100644
--- a/fs/ncpfs/sock.c
+++ b/fs/ncpfs/sock.c
@@ -8,6 +8,7 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/time.h>
 #include <linux/errno.h>
@@ -231,7 +232,7 @@ static void __ncptcp_try_send(struct ncp_server *server)
 		return;
 
 	if (result < 0) {
-		printk(KERN_ERR "ncpfs: tcp: Send failed: %d\n", result);
+		pr_err("tcp: Send failed: %d\n", result);
 		__ncp_abort_request(server, rq, result);
 		return;
 	}
@@ -332,7 +333,7 @@ static int ncp_add_request(struct ncp_server *server, struct ncp_request_reply *
 	mutex_lock(&server->rcv.creq_mutex);
 	if (!ncp_conn_valid(server)) {
 		mutex_unlock(&server->rcv.creq_mutex);
-		printk(KERN_ERR "ncpfs: tcp: Server died\n");
+		pr_err("tcp: Server died\n");
 		return -EIO;
 	}
 	ncp_req_get(req);
@@ -448,7 +449,7 @@ void ncpdgram_rcv_proc(struct work_struct *work)
 							result -= 8;
 							hdrl = sock->sk->sk_family == AF_INET ? 8 : 6;
 							if (sign_verify_reply(server, server->rxbuf + hdrl, result - hdrl, cpu_to_le32(result), server->rxbuf + result)) {
-								printk(KERN_INFO "ncpfs: Signature violation\n");
+								pr_info("Signature violation\n");
 								result = -EIO;
 							}
 						}
@@ -524,7 +525,7 @@ static int do_tcp_rcv(struct ncp_server *server, void *buffer, size_t len)
 		return result;
 	}
 	if (result > len) {
-		printk(KERN_ERR "ncpfs: tcp: bug in recvmsg (%u > %Zu)\n", result, len);
+		pr_err("tcp: bug in recvmsg (%u > %Zu)\n", result, len);
 		return -EIO;			
 	}
 	return result;
@@ -552,7 +553,7 @@ static int __ncptcp_rcv_proc(struct ncp_server *server)
 					__ncptcp_abort(server);
 				}
 				if (result < 0) {
-					printk(KERN_ERR "ncpfs: tcp: error in recvmsg: %d\n", result);
+					pr_err("tcp: error in recvmsg: %d\n", result);
 				} else {
 					DPRINTK(KERN_ERR "ncpfs: tcp: EOF\n");
 				}
@@ -566,20 +567,20 @@ static int __ncptcp_rcv_proc(struct ncp_server *server)
 		switch (server->rcv.state) {
 			case 0:
 				if (server->rcv.buf.magic != htonl(NCP_TCP_RCVD_MAGIC)) {
-					printk(KERN_ERR "ncpfs: tcp: Unexpected reply type %08X\n", ntohl(server->rcv.buf.magic));
+					pr_err("tcp: Unexpected reply type %08X\n", ntohl(server->rcv.buf.magic));
 					__ncptcp_abort(server);
 					return -EIO;
 				}
 				datalen = ntohl(server->rcv.buf.len) & 0x0FFFFFFF;
 				if (datalen < 10) {
-					printk(KERN_ERR "ncpfs: tcp: Unexpected reply len %d\n", datalen);
+					pr_err("tcp: Unexpected reply len %d\n", datalen);
 					__ncptcp_abort(server);
 					return -EIO;
 				}
 #ifdef CONFIG_NCPFS_PACKET_SIGNING				
 				if (server->sign_active) {
 					if (datalen < 18) {
-						printk(KERN_ERR "ncpfs: tcp: Unexpected reply len %d\n", datalen);
+						pr_err("tcp: Unexpected reply len %d\n", datalen);
 						__ncptcp_abort(server);
 						return -EIO;
 					}
@@ -618,7 +619,7 @@ skipdata:;
 					goto skipdata2;
 				}
 				if (datalen > req->datalen + 8) {
-					printk(KERN_ERR "ncpfs: tcp: Unexpected reply len %d (expected at most %Zd)\n", datalen, req->datalen + 8);
+					pr_err("tcp: Unexpected reply len %d (expected at most %Zd)\n", datalen, req->datalen + 8);
 					server->rcv.state = 3;
 					goto skipdata;
 				}
@@ -638,12 +639,12 @@ skipdata:;
 				req = server->rcv.creq;
 				if (req->tx_type != NCP_ALLOC_SLOT_REQUEST) {
 					if (((struct ncp_reply_header*)server->rxbuf)->sequence != server->sequence) {
-						printk(KERN_ERR "ncpfs: tcp: Bad sequence number\n");
+						pr_err("tcp: Bad sequence number\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
 					}
 					if ((((struct ncp_reply_header*)server->rxbuf)->conn_low | (((struct ncp_reply_header*)server->rxbuf)->conn_high << 8)) != server->connection) {
-						printk(KERN_ERR "ncpfs: tcp: Connection number mismatch\n");
+						pr_err("tcp: Connection number mismatch\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
 					}
@@ -651,7 +652,7 @@ skipdata:;
 #ifdef CONFIG_NCPFS_PACKET_SIGNING				
 				if (server->sign_active && req->tx_type != NCP_DEALLOC_SLOT_REQUEST) {
 					if (sign_verify_reply(server, server->rxbuf + 6, req->datalen - 6, cpu_to_be32(req->datalen + 16), &server->rcv.buf.type)) {
-						printk(KERN_ERR "ncpfs: tcp: Signature violation\n");
+						pr_err("tcp: Signature violation\n");
 						__ncp_abort_request(server, req, -EIO);
 						return -EIO;
 					}
@@ -742,7 +743,7 @@ static int ncp_do_request(struct ncp_server *server, int size,
 	int result;
 
 	if (server->lock == 0) {
-		printk(KERN_ERR "ncpfs: Server not locked!\n");
+		pr_err("Server not locked!\n");
 		return -EIO;
 	}
 	if (!ncp_conn_valid(server)) {
@@ -865,14 +866,14 @@ void ncp_lock_server(struct ncp_server *server)
 {
 	mutex_lock(&server->mutex);
 	if (server->lock)
-		printk(KERN_WARNING "ncp_lock_server: was locked!\n");
+		pr_warn("%s: was locked!\n", __func__);
 	server->lock = 1;
 }
 
 void ncp_unlock_server(struct ncp_server *server)
 {
 	if (!server->lock) {
-		printk(KERN_WARNING "ncp_unlock_server: was not locked!\n");
+		pr_warn("%s: was not locked!\n", __func__);
 		return;
 	}
 	server->lock = 0;
-- 
1.8.1.2.459.gbcd45b4.dirty

