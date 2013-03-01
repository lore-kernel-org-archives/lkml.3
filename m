Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab3CAULy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:11:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab3CATpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Tibbitts <tibbs@math.uh.edu>,
        =?UTF-8?q?Pawe=C5=82=20Sikora?= <pawel.sikora@agmk.net>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 55/77] svcrpc: make svc_age_temp_xprts enqueue under sv_lock
Date: Fri,  1 Mar 2013 11:44:40 -0800
Message-Id: <20130301194357.786996695@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svc_xprt.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -856,7 +856,6 @@ static void svc_age_temp_xprts(unsigned
 	struct svc_serv *serv = (struct svc_serv *)closure;
 	struct svc_xprt *xprt;
 	struct list_head *le, *next;
-	LIST_HEAD(to_be_aged);
 
 	dprintk("svc_age_temp_xprts\n");
 
@@ -877,25 +876,15 @@ static void svc_age_temp_xprts(unsigned
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


