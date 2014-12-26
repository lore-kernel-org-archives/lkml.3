Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaLZGuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 01:50:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25117 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbaLZGus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 01:50:48 -0500
From: Alex Gartrell <agartrell@fb.com>
To: <davem@davemloft.net>, <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>, Alex Gartrell <agartrell@fb.com>
Subject: [PATCH net-next 2/2] tun: enable socket system calls
Date: Thu, 25 Dec 2014 22:50:24 -0800
Message-ID: <1419576624-8999-3-git-send-email-agartrell@fb.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1419576624-8999-1-git-send-email-agartrell@fb.com>
References: <1419576624-8999-1-git-send-email-agartrell@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-25_06:2014-12-24,2014-12-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=514.84
 compositescore=0.98609165920913 urlsuspect_oldscore=0.98609165920913
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412260073
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By setting private_data to a socket and private_data_is_socket to true, we
can use the socket syscalls.  We also can't just blindly use private_data
anymore, so there's a __tun_file_get function that returns the container_of
private_data appropriately.

Signed-off-by: Alex Gartrell <agartrell@fb.com>
---
 drivers/net/tun.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a5cbf67..b16ddc5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -547,9 +547,18 @@ static void tun_detach_all(struct net_device *dev)
 		module_put(THIS_MODULE);
 }
 
+static struct tun_file *tun_file_from_file(struct file *file)
+{
+	struct socket *s = (struct socket *)file->private_data;
+
+	if (!s)
+		return NULL;
+	return container_of(s, struct tun_file, socket);
+}
+
 static int tun_attach(struct tun_struct *tun, struct file *file, bool skip_filter)
 {
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	int err;
 
 	err = security_tun_dev_attach(tfile->socket.sk, tun->security);
@@ -612,7 +621,7 @@ static struct tun_struct *__tun_get(struct tun_file *tfile)
 
 static struct tun_struct *tun_get(struct file *file)
 {
-	return __tun_get(file->private_data);
+	return __tun_get(tun_file_from_file(file));
 }
 
 static void tun_put(struct tun_struct *tun)
@@ -973,7 +982,7 @@ static void tun_net_init(struct net_device *dev)
 /* Poll */
 static unsigned int tun_chr_poll(struct file *file, poll_table *wait)
 {
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	struct tun_struct *tun = __tun_get(tfile);
 	struct sock *sk;
 	unsigned int mask = 0;
@@ -1235,7 +1244,7 @@ static ssize_t tun_chr_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct tun_struct *tun = tun_get(file);
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	ssize_t result;
 
 	if (!tun)
@@ -1392,7 +1401,7 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 static ssize_t tun_chr_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	struct tun_struct *tun = __tun_get(tfile);
 	ssize_t len = iov_iter_count(to), ret;
 
@@ -1567,7 +1576,7 @@ static DEVICE_ATTR(group, 0444, tun_show_group, NULL);
 static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 {
 	struct tun_struct *tun;
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	struct net_device *dev;
 	int err;
 
@@ -1801,7 +1810,7 @@ static void tun_set_sndbuf(struct tun_struct *tun)
 
 static int tun_set_queue(struct file *file, struct ifreq *ifr)
 {
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	struct tun_struct *tun;
 	int ret = 0;
 
@@ -1834,7 +1843,7 @@ unlock:
 static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg, int ifreq_len)
 {
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	struct tun_struct *tun;
 	void __user* argp = (void __user*)arg;
 	struct ifreq ifr;
@@ -2122,7 +2131,7 @@ static long tun_chr_compat_ioctl(struct file *file,
 
 static int tun_chr_fasync(int fd, struct file *file, int on)
 {
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	int ret;
 
 	if ((ret = fasync_helper(fd, file, on, &tfile->fasync)) < 0)
@@ -2165,7 +2174,8 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;
 
-	file->private_data = tfile;
+	file->private_data = &tfile->socket;
+	file->private_data_is_socket = true;
 	set_bit(SOCK_EXTERNALLY_ALLOCATED, &tfile->socket.flags);
 	INIT_LIST_HEAD(&tfile->next);
 
@@ -2176,7 +2186,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 
 static int tun_chr_close(struct inode *inode, struct file *file)
 {
-	struct tun_file *tfile = file->private_data;
+	struct tun_file *tfile = tun_file_from_file(file);
 	struct net *net = tfile->net;
 
 	tun_detach(tfile, true);
@@ -2335,7 +2345,7 @@ struct socket *tun_get_socket(struct file *file)
 	struct tun_file *tfile;
 	if (file->f_op != &tun_fops)
 		return ERR_PTR(-EINVAL);
-	tfile = file->private_data;
+	tfile = tun_file_from_file(file);
 	if (!tfile)
 		return ERR_PTR(-EBADFD);
 	return &tfile->socket;
-- 
Alex Gartrell <agartrell@fb.com>

