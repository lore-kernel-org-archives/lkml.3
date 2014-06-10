Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbaFJAbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:31:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566AbaFJAWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 54/88] nfsd: pass net to nfsd_init_socks()
Date: Mon,  9 Jun 2014 17:25:04 -0700
Message-Id: <20140610002426.302802697@linuxfoundation.org>
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

commit db6e182c17cb1a7069f7f8924721ce58ac05d9a3 upstream.

Precursor patch. Hard-coded "init_net" will be replaced by proper one in
future.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[wengmeiling: backport to 3.4:
 - adjust context
 - one more parameter(int port) for nfsd_init_socks()
 - net initialization in nfsd_startup()]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -182,18 +182,18 @@ int nfsd_nrthreads(void)
 	return rv;
 }
 
-static int nfsd_init_socks(int port)
+static int nfsd_init_socks(int port, struct net *net)
 {
 	int error;
 	if (!list_empty(&nfsd_serv->sv_permsocks))
 		return 0;
 
-	error = svc_create_xprt(nfsd_serv, "udp", &init_net, PF_INET, port,
+	error = svc_create_xprt(nfsd_serv, "udp", net, PF_INET, port,
 					SVC_SOCK_DEFAULTS);
 	if (error < 0)
 		return error;
 
-	error = svc_create_xprt(nfsd_serv, "tcp", &init_net, PF_INET, port,
+	error = svc_create_xprt(nfsd_serv, "tcp", net, PF_INET, port,
 					SVC_SOCK_DEFAULTS);
 	if (error < 0)
 		return error;
@@ -206,6 +206,7 @@ static bool nfsd_up = false;
 static int nfsd_startup(unsigned short port, int nrservs)
 {
 	int ret;
+	struct net *net = &init_net;
 
 	if (nfsd_up)
 		return 0;
@@ -217,7 +218,7 @@ static int nfsd_startup(unsigned short p
 	ret = nfsd_racache_init(2*nrservs);
 	if (ret)
 		return ret;
-	ret = nfsd_init_socks(port);
+	ret = nfsd_init_socks(port, net);
 	if (ret)
 		goto out_racache;
 	ret = lockd_up(&init_net);


