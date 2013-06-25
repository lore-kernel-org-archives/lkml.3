Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab3FYTEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:04:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3FYSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Eric Dumazet <edumazet@google.com>, David Ward <david.ward@ll.mit.edu>,
        Cong Wang <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>
Subject: [ 45/95] net/802/mrp: fix lockdep splat
Date: Tue, 25 Jun 2013 11:32:32 -0700
Message-Id: <20130625182158.733828365@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit faff57a92ba1d7247c5e86ecea2886d2c9d54507 ]

commit fb745e9a037895 ("net/802/mrp: fix possible race condition when
calling mrp_pdu_queue()") introduced a lockdep splat.

[   19.735147] =================================
[   19.735235] [ INFO: inconsistent lock state ]
[   19.735324] 3.9.2-build-0063 #4 Not tainted
[   19.735412] ---------------------------------
[   19.735500] inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
[   19.735592] rmmod/1840 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   19.735682]  (&(&app->lock)->rlock#2){+.?...}, at: [<f862bb5b>]
mrp_uninit_applicant+0x69/0xba [mrp]

app->lock is normally taken under softirq context, so disable BH to
avoid the splat.

Reported-by: Denys Fedoryshchenko <denys@visp.net.lb>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Ward <david.ward@ll.mit.edu>
Cc: Cong Wang <amwang@redhat.com>
Tested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/802/mrp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -871,10 +871,10 @@ void mrp_uninit_applicant(struct net_dev
 	 */
 	del_timer_sync(&app->join_timer);
 
-	spin_lock(&app->lock);
+	spin_lock_bh(&app->lock);
 	mrp_mad_event(app, MRP_EVENT_TX);
 	mrp_pdu_queue(app);
-	spin_unlock(&app->lock);
+	spin_unlock_bh(&app->lock);
 
 	mrp_queue_xmit(app);
 


