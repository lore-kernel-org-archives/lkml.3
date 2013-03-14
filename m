Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab3CNKgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:36:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51698 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3CNKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 04/88] svcrpc: make svc_age_temp_xprts enqueue under sv_lock
Date: Thu, 14 Mar 2013 10:34:57 +0000
Message-Id: <1363257381-15900-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit e75bafbff2270993926abcc31358361db74a9bc2 upstream.

svc_age_temp_xprts expires xprts in a two-step process: first it takes
the sv_lock and moves the xprts to expire off their server-wide list
(sv_tempsocks or sv_permsocks) to a local list.  Then it drops the
sv_lock and enqueues and puts each one.

I see no reason for this: svc_xprt_enqueue() will take sp_lock, but the
sv_lock and sp_lock are not otherwise nested anywhere (and documentation
at the top of this file claims it's correct to nest these with sp_lock
inside.)

Tested-by: Jason Tibbitts <tibbs@math.uh.edu>
Tested-by: Paweł Sikora <pawel.sikora@agmk.net>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/svc_xprt.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index bac973a..3e74e01 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -814,7 +814,6 @@ static void svc_age_temp_xprts(unsigned long closure)
 	struct svc_serv *serv = (struct svc_serv *)closure;
 	struct svc_xprt *xprt;
 	struct list_head *le, *next;
-	LIST_HEAD(to_be_aged);
 
 	dprintk("svc_age_temp_xprts\n");
 
@@ -835,25 +834,15 @@ static void svc_age_temp_xprts(unsigned long closure)
 		if (atomic_read(&xprt->xpt_ref.refcount) > 1 ||
 		    test_bit(XPT_BUSY, &xprt->xpt_flags))
 			continue;
-		svc_xprt_get(xprt);
-		list_move(le, &to_be_aged);
+		list_del_init(le);
 		set_bit(XPT_CLOSE, &xprt->xpt_flags);
 		set_bit(XPT_DETACHED, &xprt->xpt_flags);
-	}
-	spin_unlock_bh(&serv->sv_lock);
-
-	while (!list_empty(&to_be_aged)) {
-		le = to_be_aged.next;
-		/* fiddling the xpt_list node is safe 'cos we're XPT_DETACHED */
-		list_del_init(le);
-		xprt = list_entry(le, struct svc_xprt, xpt_list);
-
 		dprintk("queuing xprt %p for closing\n", xprt);
 
 		/* a thread will dequeue and close it soon */
 		svc_xprt_enqueue(xprt);
-		svc_xprt_put(xprt);
 	}
+	spin_unlock_bh(&serv->sv_lock);
 
 	mod_timer(&serv->sv_temptimer, jiffies + svc_conn_age_period * HZ);
 }
-- 
1.8.1.2

