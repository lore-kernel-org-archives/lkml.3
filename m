Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720AbaFJAbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:31:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577AbaFJAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 57/88] nfsd: pass net to nfsd_svc()
Date: Mon,  9 Jun 2014 17:25:07 -0700
Message-Id: <20140610002426.400424678@linuxfoundation.org>
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

commit d41a9417cd89a69f58a26935034b4264a2d882d6 upstream.

Precursor patch. Hard-coded "init_net" will be replaced by proper one in
future.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[wengmeiling: backport to 3.4:
 - adjust context
 - one more parameter(int port) for nfsd_svc()]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    4 +++-
 fs/nfsd/nfsd.h   |    2 +-
 fs/nfsd/nfssvc.c |    3 +--
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -389,6 +389,8 @@ static ssize_t write_threads(struct file
 {
 	char *mesg = buf;
 	int rv;
+	struct net *net = &init_net;
+
 	if (size > 0) {
 		int newthreads;
 		rv = get_int(&mesg, &newthreads);
@@ -396,7 +398,7 @@ static ssize_t write_threads(struct file
 			return rv;
 		if (newthreads < 0)
 			return -EINVAL;
-		rv = nfsd_svc(NFS_PORT, newthreads);
+		rv = nfsd_svc(NFS_PORT, newthreads, net);
 		if (rv < 0)
 			return rv;
 	} else
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -65,7 +65,7 @@ extern const struct seq_operations nfs_e
 /*
  * Function prototypes.
  */
-int		nfsd_svc(unsigned short port, int nrservs);
+int		nfsd_svc(unsigned short port, int nrservs, struct net *net);
 int		nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp);
 
 int		nfsd_nrthreads(void);
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -434,11 +434,10 @@ int nfsd_set_nrthreads(int n, int *nthre
  * this is the first time nrservs is nonzero.
  */
 int
-nfsd_svc(unsigned short port, int nrservs)
+nfsd_svc(unsigned short port, int nrservs, struct net *net)
 {
 	int	error;
 	bool	nfsd_up_before;
-	struct net *net = &init_net;
 
 	mutex_lock(&nfsd_mutex);
 	dprintk("nfsd: creating service\n");


