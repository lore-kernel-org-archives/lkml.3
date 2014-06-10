Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628AbaFJAWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:22:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934572AbaFJAWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 55/88] nfsd: pass net to nfsd_startup() and nfsd_shutdown()
Date: Mon,  9 Jun 2014 17:25:05 -0700
Message-Id: <20140610002426.336262670@linuxfoundation.org>
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

commit db42d1a76a8dfcaba7a2dc9c591fa4e231db22b3 upstream.

Precursor patch. Hard-coded "init_net" will be replaced by proper one in
future.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[wengmeiling: backport to 3.4:
 - adjust context
 - one more parameter(int port) for nfsd_startup()
 - no net ns initialization in nfsd_shutdown()
 - pass @net to lockd_up() in nfsd_startup()
 - pass @net to lockd_down() in nfsd_shutdown()]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -203,10 +203,9 @@ static int nfsd_init_socks(int port, str
 
 static bool nfsd_up = false;
 
-static int nfsd_startup(unsigned short port, int nrservs)
+static int nfsd_startup(unsigned short port, int nrservs, struct net *net)
 {
 	int ret;
-	struct net *net = &init_net;
 
 	if (nfsd_up)
 		return 0;
@@ -221,7 +220,7 @@ static int nfsd_startup(unsigned short p
 	ret = nfsd_init_socks(port, net);
 	if (ret)
 		goto out_racache;
-	ret = lockd_up(&init_net);
+	ret = lockd_up(net);
 	if (ret)
 		goto out_racache;
 	ret = nfs4_state_start();
@@ -230,13 +229,13 @@ static int nfsd_startup(unsigned short p
 	nfsd_up = true;
 	return 0;
 out_lockd:
-	lockd_down(&init_net);
+	lockd_down(net);
 out_racache:
 	nfsd_racache_shutdown();
 	return ret;
 }
 
-static void nfsd_shutdown(void)
+static void nfsd_shutdown(struct net *net)
 {
 	/*
 	 * write_ports can create the server without actually starting
@@ -247,14 +246,14 @@ static void nfsd_shutdown(void)
 	if (!nfsd_up)
 		return;
 	nfs4_state_shutdown();
-	lockd_down(&init_net);
+	lockd_down(net);
 	nfsd_racache_shutdown();
 	nfsd_up = false;
 }
 
 static void nfsd_last_thread(struct svc_serv *serv, struct net *net)
 {
-	nfsd_shutdown();
+	nfsd_shutdown(net);
 
 	svc_rpcb_cleanup(serv, net);
 
@@ -458,7 +457,7 @@ nfsd_svc(unsigned short port, int nrserv
 
 	nfsd_up_before = nfsd_up;
 
-	error = nfsd_startup(port, nrservs);
+	error = nfsd_startup(port, nrservs, net);
 	if (error)
 		goto out_destroy;
 	error = svc_set_num_threads(nfsd_serv, NULL, nrservs);
@@ -471,7 +470,7 @@ nfsd_svc(unsigned short port, int nrserv
 	error = nfsd_serv->sv_nrthreads - 1;
 out_shutdown:
 	if (error < 0 && !nfsd_up_before)
-		nfsd_shutdown();
+		nfsd_shutdown(net);
 out_destroy:
 	nfsd_destroy(net);		/* Release server */
 out:


