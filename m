Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaFWBco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:32:44 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39723 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbaFWBck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:32:40 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>,
        Fredrick John Berchmans <fredrickprashanth@gmail.com>
Subject: [PATCH 01/18] staging/lustre/libcfs: revert changes to libcfs_sock_ioctl
Date: Sun, 22 Jun 2014 21:32:05 -0400
Message-Id: <1403487142-4880-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes introduced by 80db2734acbc78db12798cfb611d6acc7fe389e6
unfortunately totally break lustre, we use this function
to access not only socket proto obs, but also device ioctl
like SIOCGIFCONF that now fail.
Reverting part of the previous patch to regain the needed
functionality.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
CC: Fredrick John Berchmans <fredrickprashanth@gmail.com>
---
 .../lustre/lustre/libcfs/linux/linux-tcpip.c        | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index a21b426..e52e33a 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -46,16 +46,31 @@
 int
 libcfs_sock_ioctl(int cmd, unsigned long arg)
 {
+	mm_segment_t	oldmm = get_fs();
 	struct socket  *sock;
-	int	     rc;
+	int		rc;
+	struct file    *sock_filp;
 
 	rc = sock_create (PF_INET, SOCK_STREAM, 0, &sock);
 	if (rc != 0) {
 		CERROR ("Can't create socket: %d\n", rc);
 		return rc;
 	}
-	rc = kernel_sock_ioctl(sock, cmd, arg);
-	sock_release(sock);
+
+	sock_filp = sock_alloc_file(sock, 0, NULL);
+	if (IS_ERR(sock_filp)) {
+		sock_release(sock);
+		rc = PTR_ERR(sock_filp);
+		goto out;
+	}
+
+	set_fs(KERNEL_DS);
+	if (sock_filp->f_op->unlocked_ioctl)
+		rc = sock_filp->f_op->unlocked_ioctl(sock_filp, cmd, arg);
+	set_fs(oldmm);
+
+	fput(sock_filp);
+out:
 	return rc;
 }
 
-- 
1.9.0

