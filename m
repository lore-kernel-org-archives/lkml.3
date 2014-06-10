Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673AbaFJAWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:22:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934514AbaFJAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 56/88] nfsd: pass net to nfsd_create_serv()
Date: Mon,  9 Jun 2014 17:25:06 -0700
Message-Id: <20140610002426.369738208@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 6777436b0f072fb20a025a73e9b67a35ad8a5451 upstream.

Precursor patch. Hard-coded "init_net" will be replaced by proper one in
future.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[wengmeiling: backport to 3.4: adjust context]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    4 ++--
 fs/nfsd/nfsd.h   |    2 +-
 fs/nfsd/nfssvc.c |    5 ++---
 3 files changed, 5 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -657,7 +657,7 @@ static ssize_t __write_ports_addfd(char
 	if (err != 0 || fd < 0)
 		return -EINVAL;
 
-	err = nfsd_create_serv();
+	err = nfsd_create_serv(net);
 	if (err != 0)
 		return err;
 
@@ -708,7 +708,7 @@ static ssize_t __write_ports_addxprt(cha
 	if (port < 1 || port > USHRT_MAX)
 		return -EINVAL;
 
-	err = nfsd_create_serv();
+	err = nfsd_create_serv(net);
 	if (err != 0)
 		return err;
 
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -101,7 +101,7 @@ enum vers_op {NFSD_SET, NFSD_CLEAR, NFSD
 int nfsd_vers(int vers, enum vers_op change);
 int nfsd_minorversion(u32 minorversion, enum vers_op change);
 void nfsd_reset_versions(void);
-int nfsd_create_serv(void);
+int nfsd_create_serv(struct net *net);
 
 extern int nfsd_max_blksize;
 
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -326,10 +326,9 @@ static int nfsd_get_default_max_blksize(
 	return ret;
 }
 
-int nfsd_create_serv(void)
+int nfsd_create_serv(struct net *net)
 {
 	int error;
-	struct net *net = &init_net;
 
 	WARN_ON(!mutex_is_locked(&nfsd_mutex));
 	if (nfsd_serv) {
@@ -451,7 +450,7 @@ nfsd_svc(unsigned short port, int nrserv
 	if (nrservs == 0 && nfsd_serv == NULL)
 		goto out;
 
-	error = nfsd_create_serv();
+	error = nfsd_create_serv(net);
 	if (error)
 		goto out;
 


