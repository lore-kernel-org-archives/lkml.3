Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3HQWJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 18:09:53 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3HQWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 18:09:52 -0400
From: Richard Weinberger <richard@nod.at>
To: richard@nod.at
Cc: viro@zeniv.linux.org.uk, user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, rjones@redhat.com
Subject: [PATCH] um: ubd: Add REQ_FLUSH suppport
Date: Sun, 18 Aug 2013 00:09:34 +0200
Message-Id: <1376777374-17521-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML's block device driver does not support write barriers,
to support this this patch adds REQ_FLUSH suppport.
Every time the block layer sends a REQ_FLUSH we fsync() now
our backing file to guarantee data consistency.

Cc: rjones@redhat.com
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/ubd_kern.c  | 41 ++++++++++++++++++++++++++++++++++++++++-
 arch/um/include/shared/os.h |  1 +
 arch/um/os-Linux/file.c     |  9 +++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 879990c..d27c703 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -41,7 +41,7 @@
 #include <os.h>
 #include "cow.h"
 
-enum ubd_req { UBD_READ, UBD_WRITE };
+enum ubd_req { UBD_READ, UBD_WRITE, UBD_FLUSH };
 
 struct io_thread_req {
 	struct request *req;
@@ -866,6 +866,7 @@ static int ubd_add(int n, char **error_out)
 		goto out;
 	}
 	ubd_dev->queue->queuedata = ubd_dev;
+	blk_queue_flush(ubd_dev->queue, REQ_FLUSH);
 
 	blk_queue_max_segments(ubd_dev->queue, MAX_SG);
 	err = ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, &ubd_gendisk[n]);
@@ -1239,6 +1240,19 @@ static void prepare_request(struct request *req, struct io_thread_req *io_req,
 }
 
 /* Called with dev->lock held */
+static void prepare_flush_request(struct request *req,
+				  struct io_thread_req *io_req)
+{
+	struct gendisk *disk = req->rq_disk;
+	struct ubd *ubd_dev = disk->private_data;
+
+	io_req->req = req;
+	io_req->fds[0] = (ubd_dev->cow.file != NULL) ? ubd_dev->cow.fd :
+		ubd_dev->fd;
+	io_req->op = UBD_FLUSH;
+}
+
+/* Called with dev->lock held */
 static void do_ubd_request(struct request_queue *q)
 {
 	struct io_thread_req *io_req;
@@ -1259,6 +1273,20 @@ static void do_ubd_request(struct request_queue *q)
 		}
 
 		req = dev->request;
+
+		if (req->cmd_flags & REQ_FLUSH) {
+			io_req = kmalloc(sizeof(struct io_thread_req),
+					 GFP_ATOMIC);
+			if (io_req == NULL) {
+				if (list_empty(&dev->restart))
+					list_add(&dev->restart, &restart);
+				return;
+			}
+			prepare_flush_request(req, io_req);
+			os_write_file(thread_fd, &io_req,
+					  sizeof(struct io_thread_req *));
+		}
+
 		while(dev->start_sg < dev->end_sg){
 			struct scatterlist *sg = &dev->sg[dev->start_sg];
 
@@ -1367,6 +1395,17 @@ static void do_io(struct io_thread_req *req)
 	int err;
 	__u64 off;
 
+	if (req->op == UBD_FLUSH) {
+		/* fds[0] is always either the rw image or our cow file */
+		n = os_sync_file(req->fds[0]);
+		if (n != 0) {
+			printk("do_io - sync failed err = %d "
+			       "fd = %d\n", -n, req->fds[0]);
+			req->error = 1;
+		}
+		return;
+	}
+
 	nsectors = req->length / req->sectorsize;
 	start = 0;
 	do {
diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index 95feaa4..04859b7 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -141,6 +141,7 @@ extern int os_seek_file(int fd, unsigned long long offset);
 extern int os_open_file(const char *file, struct openflags flags, int mode);
 extern int os_read_file(int fd, void *buf, int len);
 extern int os_write_file(int fd, const void *buf, int count);
+extern int os_sync_file(int fd);
 extern int os_file_size(const char *file, unsigned long long *size_out);
 extern int os_file_modtime(const char *file, unsigned long *modtime);
 extern int os_pipe(int *fd, int stream, int close_on_exec);
diff --git a/arch/um/os-Linux/file.c b/arch/um/os-Linux/file.c
index c17bd6f..07a7501 100644
--- a/arch/um/os-Linux/file.c
+++ b/arch/um/os-Linux/file.c
@@ -266,6 +266,15 @@ int os_write_file(int fd, const void *buf, int len)
 	return n;
 }
 
+int os_sync_file(int fd)
+{
+	int n = fsync(fd);
+
+	if (n < 0)
+		return -errno;
+	return n;
+}
+
 int os_file_size(const char *file, unsigned long long *size_out)
 {
 	struct uml_stat buf;
-- 
1.8.3.1

