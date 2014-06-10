Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbaFJAaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:30:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934587AbaFJAWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 60/88] nfsd: pass proper net to nfsd_destroy() from NFSd kthreads
Date: Mon,  9 Jun 2014 17:25:10 -0700
Message-Id: <20140610002426.492757275@linuxfoundation.org>
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

commit 88c47666171989ed4c5b1a5687df09511e8c5e35 upstream.

Since NFSd service is per-net now, we have to pass proper network
context in nfsd_shutdown() from NFSd kthreads.

The simplest way I found is to get proper net from one of transports
with permanent sockets.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[wengmeiling: backport to 3.4: adjust context]
Signed-off-by: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -483,6 +483,8 @@ static int
 nfsd(void *vrqstp)
 {
 	struct svc_rqst *rqstp = (struct svc_rqst *) vrqstp;
+	struct svc_xprt *perm_sock = list_entry(rqstp->rq_server->sv_permsocks.next, typeof(struct svc_xprt), xpt_list);
+	struct net *net = perm_sock->xpt_net;
 	int err, preverr = 0;
 
 	/* Lock module and set up kernel thread */
@@ -557,7 +559,7 @@ out:
 	/* Release the thread */
 	svc_exit_thread(rqstp);
 
-	nfsd_destroy(&init_net);
+	nfsd_destroy(net);
 
 	/* Release module */
 	mutex_unlock(&nfsd_mutex);


