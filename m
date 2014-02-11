Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaBKTGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:06:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaBKTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.12 047/107] sunrpc: dont wait for write before allowing reads from use-gss-proxy file
Date: Tue, 11 Feb 2014 11:05:13 -0800
Message-Id: <20140211184749.533479904@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 1654a04cd702fd19c297c36300a6ab834cf8c072 upstream.

It doesn't make much sense to make reads from this procfile hang. As
far as I can tell, only gssproxy itself will open this file and it
never reads from it. Change it to just give the present setting of
sn->use_gss_proxy without waiting for anything.

Note that we do not want to call use_gss_proxy() in this codepath
since an inopportune read of this file could cause it to be disabled
prematurely.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/gss_rpc_upcall.c |    2 --
 net/sunrpc/auth_gss/svcauth_gss.c    |   33 ++-------------------------------
 net/sunrpc/netns.h                   |    1 -
 3 files changed, 2 insertions(+), 34 deletions(-)

--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -137,7 +137,6 @@ void init_gssp_clnt(struct sunrpc_net *s
 {
 	mutex_init(&sn->gssp_lock);
 	sn->gssp_clnt = NULL;
-	init_waitqueue_head(&sn->gssp_wq);
 }
 
 int set_gssp_clnt(struct net *net)
@@ -154,7 +153,6 @@ int set_gssp_clnt(struct net *net)
 		sn->gssp_clnt = clnt;
 	}
 	mutex_unlock(&sn->gssp_lock);
-	wake_up(&sn->gssp_wq);
 	return ret;
 }
 
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1295,34 +1295,9 @@ static int set_gss_proxy(struct net *net
 	else
 		ret = -EBUSY;
 	spin_unlock(&use_gssp_lock);
-	wake_up(&sn->gssp_wq);
 	return ret;
 }
 
-static inline bool gssp_ready(struct sunrpc_net *sn)
-{
-	switch (sn->use_gss_proxy) {
-		case -1:
-			return false;
-		case 0:
-			return true;
-		case 1:
-			return sn->gssp_clnt;
-	}
-	WARN_ON_ONCE(1);
-	return false;
-}
-
-static int wait_for_gss_proxy(struct net *net, struct file *file)
-{
-	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
-
-	if (file->f_flags & O_NONBLOCK && !gssp_ready(sn))
-		return -EAGAIN;
-	return wait_event_interruptible(sn->gssp_wq, gssp_ready(sn));
-}
-
-
 static ssize_t write_gssp(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -1355,16 +1330,12 @@ static ssize_t read_gssp(struct file *fi
 			 size_t count, loff_t *ppos)
 {
 	struct net *net = PDE_DATA(file_inode(file));
+	struct sunrpc_net *sn = net_generic(net, sunrpc_net_id);
 	unsigned long p = *ppos;
 	char tbuf[10];
 	size_t len;
-	int ret;
-
-	ret = wait_for_gss_proxy(net, file);
-	if (ret)
-		return ret;
 
-	snprintf(tbuf, sizeof(tbuf), "%d\n", use_gss_proxy(net));
+	snprintf(tbuf, sizeof(tbuf), "%d\n", sn->use_gss_proxy);
 	len = strlen(tbuf);
 	if (p >= len)
 		return 0;
--- a/net/sunrpc/netns.h
+++ b/net/sunrpc/netns.h
@@ -26,7 +26,6 @@ struct sunrpc_net {
 	unsigned int rpcb_is_af_local : 1;
 
 	struct mutex gssp_lock;
-	wait_queue_head_t gssp_wq;
 	struct rpc_clnt *gssp_clnt;
 	int use_gss_proxy;
 	int pipe_version;


