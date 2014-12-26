Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaLZGva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 01:51:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44522 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbaLZGuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 01:50:46 -0500
From: Alex Gartrell <agartrell@fb.com>
To: <davem@davemloft.net>, <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Alex Gartrell <agartrell@fb.com>
Subject: [PATCH net-next 1/2] socket: Allow external sockets to use socket syscalls
Date: Thu, 25 Dec 2014 22:50:23 -0800
Message-ID: <1419576624-8999-2-git-send-email-agartrell@fb.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1419576624-8999-1-git-send-email-agartrell@fb.com>
References: <1419576624-8999-1-git-send-email-agartrell@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_06:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=502.112
 compositescore=0.986137415400633 urlsuspect_oldscore=0.986137415400633
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.986137415400633 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412260074
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the "is-socket" test for a file compares the ops table pointer,
which is static and local to the socket.c.  Instead, this adds a flag for
private_data_is_socket.  This is an exceptionally long commit message for a
two-line patch.

Signed-off-by: Alex Gartrell <agartrell@fb.com>
---
 include/linux/fs.h | 2 +-
 net/socket.c       | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index bb29b02..d162476 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -809,7 +809,7 @@ struct file {
 #endif
 	/* needed for tty driver, and maybe others */
 	void			*private_data;
-
+	bool			private_data_is_socket : 1;
 #ifdef CONFIG_EPOLL
 	/* Used by fs/eventpoll.c to link all the hooks to this file */
 	struct list_head	f_ep_links;
diff --git a/net/socket.c b/net/socket.c
index 8809afc..cd853be 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -388,6 +388,7 @@ struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname)
 	sock->file = file;
 	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
 	file->private_data = sock;
+	file->private_data_is_socket = true;
 	return file;
 }
 EXPORT_SYMBOL(sock_alloc_file);
@@ -411,7 +412,7 @@ static int sock_map_fd(struct socket *sock, int flags)
 
 struct socket *sock_from_file(struct file *file, int *err)
 {
-	if (file->f_op == &socket_file_ops)
+	if (file->private_data_is_socket)
 		return file->private_data;	/* set in sock_map_fd */
 
 	*err = -ENOTSOCK;
-- 
Alex Gartrell <agartrell@fb.com>

