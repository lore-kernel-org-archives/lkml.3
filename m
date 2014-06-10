Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705AbaFJAWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:22:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934578AbaFJAWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 58/88] nfsd: pass net to nfsd_set_nrthreads()
Date: Mon,  9 Jun 2014 17:25:08 -0700
Message-Id: <20140610002426.433855395@linuxfoundation.org>
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

commit 3938a0d5eb5effcc89c6909741403f4e6a37252d upstream.

Precursor patch. Hard-coded "init_net" will be replaced by proper one in
future.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[wengmeiling: backport to 3.4: adjust context]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    3 ++-
 fs/nfsd/nfsd.h   |    2 +-
 fs/nfsd/nfssvc.c |    3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -440,6 +440,7 @@ static ssize_t write_pool_threads(struct
 	int len;
 	int npools;
 	int *nthreads;
+	struct net *net = &init_net;
 
 	mutex_lock(&nfsd_mutex);
 	npools = nfsd_nrpools();
@@ -470,7 +471,7 @@ static ssize_t write_pool_threads(struct
 			if (nthreads[i] < 0)
 				goto out_free;
 		}
-		rv = nfsd_set_nrthreads(i, nthreads);
+		rv = nfsd_set_nrthreads(i, nthreads, net);
 		if (rv)
 			goto out_free;
 	}
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -71,7 +71,7 @@ int		nfsd_dispatch(struct svc_rqst *rqst
 int		nfsd_nrthreads(void);
 int		nfsd_nrpools(void);
 int		nfsd_get_nrthreads(int n, int *);
-int		nfsd_set_nrthreads(int n, int *);
+int		nfsd_set_nrthreads(int n, int *, struct net *);
 
 static inline void nfsd_destroy(struct net *net)
 {
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -374,12 +374,11 @@ int nfsd_get_nrthreads(int n, int *nthre
 	return 0;
 }
 
-int nfsd_set_nrthreads(int n, int *nthreads)
+int nfsd_set_nrthreads(int n, int *nthreads, struct net *net)
 {
 	int i = 0;
 	int tot = 0;
 	int err = 0;
-	struct net *net = &init_net;
 
 	WARN_ON(!mutex_is_locked(&nfsd_mutex));
 


