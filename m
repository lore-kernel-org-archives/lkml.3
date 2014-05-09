Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbaEIXnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 19:43:31 -0400
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:42012 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756802AbaEIXn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 19:43:28 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:4:41:69:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:2393:2538:2559:2562:2895:2898:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3874:4321:4605:5007:6117:6119:6261:7875:7903:9038:9592:10004:10026:10848:11026:11473:11638:11657:11658:11914:12043:12296:12517:12519:12555:12679:12683:13132:13161:13229:13231:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glue28_e71f8729a49
X-Filterd-Recvd-Size: 15852
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 4/4] UserModeLinux: Convert printks to pr_<level>
Date: Fri,  9 May 2014 16:43:13 -0700
Message-Id: <407b3ccdbb3a16a20c0e9a879cda9dca3d4eef07.1399678795.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1399678795.git.joe@perches.com>
References: <cover.1399678795.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.

Convert the remaining printks without a KERN_<PREFIX>
to pr_<level> where appropriate.

There a few additional printks without a level that
are emitted at KERN_DEFAULT for stack dumps and such.

Add printf format/argument verification to the static
inline just in case.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/um/drivers/daemon_kern.c        |  5 ++---
 arch/um/drivers/harddog_kern.c       |  4 +---
 arch/um/drivers/harddog_user.c       | 14 +++++++-------
 arch/um/drivers/pcap_kern.c          |  2 +-
 arch/um/drivers/random.c             |  3 +--
 arch/um/drivers/slip_kern.c          |  2 +-
 arch/um/drivers/slirp_kern.c         |  6 +++---
 arch/um/drivers/ubd_kern.c           | 35 +++++++++++++++++------------------
 arch/um/drivers/ubd_user.c           |  6 +++---
 arch/um/drivers/vde_kern.c           |  6 +++---
 arch/um/drivers/vde_user.c           |  3 +--
 arch/um/include/asm/pgtable-2level.h | 12 ++++++------
 arch/um/include/asm/pgtable-3level.h | 18 +++++++++---------
 arch/um/include/shared/user.h        |  1 +
 14 files changed, 56 insertions(+), 61 deletions(-)

diff --git a/arch/um/drivers/daemon_kern.c b/arch/um/drivers/daemon_kern.c
index 197b670..ce915b8 100644
--- a/arch/um/drivers/daemon_kern.c
+++ b/arch/um/drivers/daemon_kern.c
@@ -34,9 +34,8 @@ static void daemon_init(struct net_device *dev, void *data)
 	dpri->data_addr = NULL;
 	dpri->local_addr = NULL;
 
-	printk("daemon backend (uml_switch version %d) - %s:%s",
-	       SWITCH_VERSION, dpri->sock_type, dpri->ctl_sock);
-	printk("\n");
+	pr_info("daemon backend (uml_switch version %d) - %s:%s\n",
+		SWITCH_VERSION, dpri->sock_type, dpri->ctl_sock);
 }
 
 static int daemon_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
diff --git a/arch/um/drivers/harddog_kern.c b/arch/um/drivers/harddog_kern.c
index 2d0266d..86ad99d 100644
--- a/arch/um/drivers/harddog_kern.c
+++ b/arch/um/drivers/harddog_kern.c
@@ -176,8 +176,6 @@ static struct miscdevice harddog_miscdev = {
 	.fops		= &harddog_fops,
 };
 
-static char banner[] __initdata = KERN_INFO "UML Watchdog Timer\n";
-
 static int __init harddog_init(void)
 {
 	int ret;
@@ -187,7 +185,7 @@ static int __init harddog_init(void)
 	if (ret)
 		return ret;
 
-	printk(banner);
+	pr_info("UML Watchdog Timer\n");
 
 	return 0;
 }
diff --git a/arch/um/drivers/harddog_user.c b/arch/um/drivers/harddog_user.c
index f99b32a..43c3b75 100644
--- a/arch/um/drivers/harddog_user.c
+++ b/arch/um/drivers/harddog_user.c
@@ -39,13 +39,13 @@ int start_watchdog(int *in_fd_ret, int *out_fd_ret, char *sock)
 
 	err = os_pipe(in_fds, 1, 0);
 	if (err < 0) {
-		printk("harddog_open - os_pipe failed, err = %d\n", -err);
+		pr_err("harddog_open - os_pipe failed, err = %d\n", -err);
 		goto out;
 	}
 
 	err = os_pipe(out_fds, 1, 0);
 	if (err < 0) {
-		printk("harddog_open - os_pipe failed, err = %d\n", -err);
+		pr_err("harddog_open - os_pipe failed, err = %d\n", -err);
 		goto out_close_in;
 	}
 
@@ -71,20 +71,20 @@ int start_watchdog(int *in_fd_ret, int *out_fd_ret, char *sock)
 
 	if (pid < 0) {
 		err = -pid;
-		printk("harddog_open - run_helper failed, errno = %d\n", -err);
+		pr_err("harddog_open - run_helper failed, errno = %d\n", -err);
 		goto out_close_out;
 	}
 
 	n = read(in_fds[0], &c, sizeof(c));
 	if (n == 0) {
-		printk("harddog_open - EOF on watchdog pipe\n");
+		pr_err("harddog_open - EOF on watchdog pipe\n");
 		helper_wait(pid);
 		err = -EIO;
 		goto out_close_out;
 	}
 	else if (n < 0) {
-		printk("harddog_open - read of watchdog pipe failed, "
-		       "err = %d\n", errno);
+		pr_err("harddog_open - read of watchdog pipe failed, err = %d\n",
+		       errno);
 		helper_wait(pid);
 		err = n;
 		goto out_close_out;
@@ -116,7 +116,7 @@ int ping_watchdog(int fd)
 
 	n = write(fd, &c, sizeof(c));
 	if (n != sizeof(c)) {
-		printk("ping_watchdog - write failed, ret = %d, err = %d\n",
+		pr_err("ping_watchdog - write failed, ret = %d, err = %d\n",
 		       n, errno);
 		if (n < 0)
 			return n;
diff --git a/arch/um/drivers/pcap_kern.c b/arch/um/drivers/pcap_kern.c
index ccab947..bcea904 100644
--- a/arch/um/drivers/pcap_kern.c
+++ b/arch/um/drivers/pcap_kern.c
@@ -28,7 +28,7 @@ void pcap_init(struct net_device *dev, void *data)
 	ppri->optimize = init->optimize;
 	ppri->filter = init->filter;
 
-	printk("pcap backend, host interface %s\n", ppri->host_if);
+	pr_info("pcap backend, host interface %s\n", ppri->host_if);
 }
 
 static int pcap_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index 9e3a722..5453ccc 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -139,8 +139,7 @@ static int __init rng_init (void)
 
 	err = misc_register (&rng_miscdev);
 	if (err) {
-		printk (KERN_ERR RNG_MODULE_NAME ": misc device register "
-			"failed\n");
+		pr_err(RNG_MODULE_NAME ": misc device register failed\n");
 		goto err_out_cleanup_hw;
 	}
 out:
diff --git a/arch/um/drivers/slip_kern.c b/arch/um/drivers/slip_kern.c
index ed5249f..9519f32 100644
--- a/arch/um/drivers/slip_kern.c
+++ b/arch/um/drivers/slip_kern.c
@@ -36,7 +36,7 @@ static void slip_init(struct net_device *dev, void *data)
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
 	dev->flags = IFF_NOARP;
-	printk("SLIP backend - SLIP IP = %s\n", spri->gate_addr);
+	pr_info("SLIP backend - SLIP IP = %s\n", spri->gate_addr);
 }
 
 static unsigned short slip_protocol(struct sk_buff *skbuff)
diff --git a/arch/um/drivers/slirp_kern.c b/arch/um/drivers/slirp_kern.c
index 858caa7..ab1d9ac 100644
--- a/arch/um/drivers/slirp_kern.c
+++ b/arch/um/drivers/slirp_kern.c
@@ -38,10 +38,10 @@ void slirp_init(struct net_device *dev, void *data)
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 256;
 	dev->flags = IFF_NOARP;
-	printk("SLIRP backend - command line:");
+	pr_info("SLIRP backend - command line:");
 	for (i = 0; spri->argw.argv[i] != NULL; i++)
-		printk(" '%s'",spri->argw.argv[i]);
-	printk("\n");
+		pr_cont(" '%s'",spri->argw.argv[i]);
+	pr_cont("\n");
 }
 
 static unsigned short slirp_protocol(struct sk_buff *skbuff)
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 265cad0..b23b2aa 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -421,8 +421,8 @@ __uml_help(ubd_setup,
 
 static int udb_setup(char *str)
 {
-	printk("udb%s specified on command line is almost certainly a ubd -> udb TYPO\n",
-	       str);
+	pr_notice("udb%s specified on command line is almost certainly a ubd -> udb TYPO\n",
+		  str);
 	return 1;
 }
 
@@ -752,8 +752,7 @@ static int ubd_open_dev(struct ubd *ubd_dev)
 	}
 
 	if(fd < 0){
-		printk("Failed to open '%s', errno = %d\n", ubd_dev->file,
-		       -fd);
+		pr_err("Failed to open '%s', errno = %d\n", ubd_dev->file, -fd);
 		return fd;
 	}
 	ubd_dev->fd = fd;
@@ -1251,7 +1250,7 @@ static bool submit_request(struct io_thread_req *io_req, struct ubd *dev)
 			     sizeof(io_req));
 	if (n != sizeof(io_req)) {
 		if (n != -EAGAIN)
-			printk("write to io thread failed, errno = %d\n", -n);
+			pr_err("write to io thread failed, errno = %d\n", -n);
 		else if (list_empty(&dev->restart))
 			list_add(&dev->restart, &restart);
 
@@ -1370,15 +1369,15 @@ static int update_bitmap(struct io_thread_req *req)
 
 	n = os_seek_file(req->fds[1], req->cow_offset);
 	if(n < 0){
-		printk("do_io - bitmap lseek failed : err = %d\n", -n);
+		pr_err("do_io - bitmap lseek failed : err = %d\n", -n);
 		return 1;
 	}
 
 	n = os_write_file(req->fds[1], &req->bitmap_words,
 			  sizeof(req->bitmap_words));
 	if(n != sizeof(req->bitmap_words)){
-		printk("do_io - bitmap update failed, err = %d fd = %d\n", -n,
-		       req->fds[1]);
+		pr_err("do_io - bitmap update failed, err = %d fd = %d\n",
+		       -n, req->fds[1]);
 		return 1;
 	}
 
@@ -1397,7 +1396,7 @@ static void do_io(struct io_thread_req *req)
 		/* fds[0] is always either the rw image or our cow file */
 		n = os_sync_file(req->fds[0]);
 		if (n != 0) {
-			printk("do_io - sync failed err = %d fd = %d\n",
+			pr_err("do_io - sync failed err = %d fd = %d\n",
 			       -n, req->fds[0]);
 			req->error = 1;
 		}
@@ -1421,7 +1420,7 @@ static void do_io(struct io_thread_req *req)
 
 		err = os_seek_file(req->fds[bit], off);
 		if(err < 0){
-			printk("do_io - lseek failed : err = %d\n", -err);
+			pr_err("do_io - lseek failed : err = %d\n", -err);
 			req->error = 1;
 			return;
 		}
@@ -1432,7 +1431,7 @@ static void do_io(struct io_thread_req *req)
 				len -= n;
 				n = os_read_file(req->fds[bit], buf, len);
 				if (n < 0) {
-					printk("do_io - read failed, err = %d fd = %d\n",
+					pr_err("do_io - read failed, err = %d fd = %d\n",
 					       -n, req->fds[bit]);
 					req->error = 1;
 					return;
@@ -1442,7 +1441,7 @@ static void do_io(struct io_thread_req *req)
 		} else {
 			n = os_write_file(req->fds[bit], buf, len);
 			if(n != len){
-				printk("do_io - write failed err = %d fd = %d\n",
+				pr_err("do_io - write failed err = %d fd = %d\n",
 				       -n, req->fds[bit]);
 				req->error = 1;
 				return;
@@ -1474,12 +1473,12 @@ int io_thread(void *arg)
 		n = os_read_file(kernel_fd, &req,
 				 sizeof(struct io_thread_req *));
 		if(n != sizeof(struct io_thread_req *)){
-			if(n < 0)
-				printk("io_thread - read failed, fd = %d, err = %d\n",
+			if(n < 0) {
+				pr_err("io_thread - read failed, fd = %d, err = %d\n",
 				       kernel_fd, -n);
-			else {
-				printk("io_thread - short read, fd = %d, length = %d\n",
-				       kernel_fd, n);
+			} else {
+				pr_notice("io_thread - short read, fd = %d, length = %d\n",
+					  kernel_fd, n);
 			}
 			continue;
 		}
@@ -1488,7 +1487,7 @@ int io_thread(void *arg)
 		n = os_write_file(kernel_fd, &req,
 				  sizeof(struct io_thread_req *));
 		if(n != sizeof(struct io_thread_req *))
-			printk("io_thread - write failed, fd = %d, err = %d\n",
+			pr_err("io_thread - write failed, fd = %d, err = %d\n",
 			       kernel_fd, -n);
 	}
 
diff --git a/arch/um/drivers/ubd_user.c b/arch/um/drivers/ubd_user.c
index e376f9b..37ca5c3 100644
--- a/arch/um/drivers/ubd_user.c
+++ b/arch/um/drivers/ubd_user.c
@@ -27,7 +27,7 @@ int start_io_thread(unsigned long sp, int *fd_out)
 
 	err = os_pipe(fds, 1, 1);
 	if(err < 0){
-		printk("start_io_thread - os_pipe failed, err = %d\n", -err);
+		pr_err("start_io_thread - os_pipe failed, err = %d\n", -err);
 		goto out;
 	}
 
@@ -36,14 +36,14 @@ int start_io_thread(unsigned long sp, int *fd_out)
 
 	err = os_set_fd_block(*fd_out, 0);
 	if (err) {
-		printk("start_io_thread - failed to set nonblocking I/O.\n");
+		pr_err("start_io_thread - failed to set nonblocking I/O\n");
 		goto out_close;
 	}
 
 	pid = clone(io_thread, (void *) sp, CLONE_FILES | CLONE_VM, NULL);
 	if(pid < 0){
 		err = -errno;
-		printk("start_io_thread - clone failed : errno = %d\n", errno);
+		pr_err("start_io_thread - clone failed : errno = %d\n", errno);
 		goto out_close;
 	}
 
diff --git a/arch/um/drivers/vde_kern.c b/arch/um/drivers/vde_kern.c
index 3d2bc4e..a39201e 100644
--- a/arch/um/drivers/vde_kern.c
+++ b/arch/um/drivers/vde_kern.c
@@ -28,12 +28,12 @@ static void vde_init(struct net_device *dev, void *data)
 	vpri->conn = NULL;
 	vpri->dev = dev;
 
-	printk("vde backend - %s, ", vpri->vde_switch ?
-	       vpri->vde_switch : "(default socket)");
+	pr_info("vde backend - %s, ",
+		vpri->vde_switch ? vpri->vde_switch : "(default socket)");
 
 	vde_init_libstuff(vpri, init);
 
-	printk("\n");
+	pr_cont("\n");
 }
 
 static int vde_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index 849baf8..bcd7ba0 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -87,8 +87,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 	args->group = init->group;
 	args->mode = init->mode ? init->mode : 0700;
 
-	args->port ?  printk("port %d", args->port) :
-		printk("undefined port");
+	args->port ? pr_cont("port %d", args->port) : pr_cont("undefined port");
 }
 
 int vde_user_read(void *conn, void *buf, int len)
diff --git a/arch/um/include/asm/pgtable-2level.h b/arch/um/include/asm/pgtable-2level.h
index f534b73..84593d0 100644
--- a/arch/um/include/asm/pgtable-2level.h
+++ b/arch/um/include/asm/pgtable-2level.h
@@ -25,12 +25,12 @@
 #define PTRS_PER_PGD	1024
 #define FIRST_USER_ADDRESS	0
 
-#define pte_ERROR(e) \
-        printk("%s:%d: bad pte %p(%08lx).\n", __FILE__, __LINE__, &(e), \
-	       pte_val(e))
-#define pgd_ERROR(e) \
-        printk("%s:%d: bad pgd %p(%08lx).\n", __FILE__, __LINE__, &(e), \
-	       pgd_val(e))
+#define pte_ERROR(e)					\
+        printk("%s:%d: bad pte %p(%08lx)\n",		\
+	       __FILE__, __LINE__, &(e), pte_val(e))
+#define pgd_ERROR(e)					\
+        printk("%s:%d: bad pgd %p(%08lx)\n",		\
+	       __FILE__, __LINE__, &(e), pgd_val(e))
 
 static inline int pgd_newpage(pgd_t pgd)	{ return 0; }
 static inline void pgd_mkuptodate(pgd_t pgd)	{ }
diff --git a/arch/um/include/asm/pgtable-3level.h b/arch/um/include/asm/pgtable-3level.h
index 0032f92..84304b3 100644
--- a/arch/um/include/asm/pgtable-3level.h
+++ b/arch/um/include/asm/pgtable-3level.h
@@ -43,15 +43,15 @@
 #define USER_PTRS_PER_PGD ((TASK_SIZE + (PGDIR_SIZE - 1)) / PGDIR_SIZE)
 #define FIRST_USER_ADDRESS	0
 
-#define pte_ERROR(e) \
-        printk("%s:%d: bad pte %p(%016lx).\n", __FILE__, __LINE__, &(e), \
-	       pte_val(e))
-#define pmd_ERROR(e) \
-        printk("%s:%d: bad pmd %p(%016lx).\n", __FILE__, __LINE__, &(e), \
-	       pmd_val(e))
-#define pgd_ERROR(e) \
-        printk("%s:%d: bad pgd %p(%016lx).\n", __FILE__, __LINE__, &(e), \
-	       pgd_val(e))
+#define pte_ERROR(e)					\
+        printk("%s:%d: bad pte %p(%016lx)\n",		\
+	       __FILE__, __LINE__, &(e), pte_val(e))
+#define pmd_ERROR(e)					\
+        printk("%s:%d: bad pmd %p(%016lx)\n",		\
+	       __FILE__, __LINE__, &(e), pmd_val(e))
+#define pgd_ERROR(e)					\
+        printk("%s:%d: bad pgd %p(%016lx)\n",		\
+	       __FILE__, __LINE__, &(e), pgd_val(e))
 
 #define pud_none(x)	(!(pud_val(x) & ~_PAGE_NEWPAGE))
 #define	pud_bad(x)	((pud_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
diff --git a/arch/um/include/shared/user.h b/arch/um/include/shared/user.h
index 4fa82c0..7f00fbc 100644
--- a/arch/um/include/shared/user.h
+++ b/arch/um/include/shared/user.h
@@ -31,6 +31,7 @@ extern int printk(const char *fmt, ...)
 	__attribute__ ((format (printf, 1, 2)));
 #else
 static inline int printk(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)))
 {
 	return 0;
 }
-- 
1.8.1.2.459.gbcd45b4.dirty

