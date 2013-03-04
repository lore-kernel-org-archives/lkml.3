Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3CDDoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33005 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756673Ab3CDDoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:11 -0500
Message-Id: <20130304033713.869066939@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:11 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>,
        Jason Tibbitts <tibbs@math.uh.edu>,
        =?ISO-8859-15?q?Pawe=C5=82=20Sikora?= <pawel.sikora@agmk.net>
Subject: [ 064/153] svcrpc: make svc_age_temp_xprts enqueue under sv_lock
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/svc_xprt.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -816,7 +816,6 @@ static void svc_age_temp_xprts(unsigned
 	struct svc_serv *serv = (struct svc_serv *)closure;
 	struct svc_xprt *xprt;
 	struct list_head *le, *next;
-	LIST_HEAD(to_be_aged);
 
 	dprintk("svc_age_temp_xprts\n");
 
@@ -837,25 +836,15 @@ static void svc_age_temp_xprts(unsigned
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


