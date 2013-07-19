Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700Ab3GSR00 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:26:26 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46898 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3GSR0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:26:24 -0400
Message-ID: <1374254778.26476.18.camel@edumazet-glaptop>
Subject: Re: mod_timer: list_add corruption: WARNING: CPU: 1 PID: 0 at
 lib/list_debug.c:33 __list_add+0xbe/0xd0()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Cong Wang <amwang@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        netdev@vger.kernel.org
Date: Fri, 19 Jul 2013 10:26:18 -0700
In-Reply-To: <alpine.DEB.2.02.1307191834460.4089@ionos.tec.linutronix.de>
References: <51E557C0.2060602@linux.vnet.ibm.com>
	  <alpine.DEB.2.02.1307191323150.4089@ionos.tec.linutronix.de>
	  <51E92769.7090106@linux.vnet.ibm.com>
	  <alpine.DEB.2.02.1307191523050.4089@ionos.tec.linutronix.de>
	 <1374241882.26476.5.camel@edumazet-glaptop>
	 <alpine.DEB.2.02.1307191834460.4089@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 18:38 +0200, Thomas Gleixner wrote:
> On Fri, 19 Jul 2013, Eric Dumazet wrote:
> > 
> > I guess following should help 
> 
> Applying the empty patch does not work very well. Could you try again
> after the caffeine reached your brain, please ? :)

hmm, right ;)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 69af490..4b99c9a 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -619,6 +619,9 @@ rehash:
 	mp->br = br;
 	mp->addr = *group;
 
+	setup_timer(&mp->timer, br_multicast_group_expired,
+		    (unsigned long)mp);
+
 	hlist_add_head_rcu(&mp->hlist[mdb->ver], &mdb->mhash[hash]);
 	mdb->size++;
 
@@ -1126,7 +1129,6 @@ static int br_ip4_multicast_query(struct net_bridge *br,
 	if (!mp)
 		goto out;
 
-	setup_timer(&mp->timer, br_multicast_group_expired, (unsigned long)mp);
 	mod_timer(&mp->timer, now + br->multicast_membership_interval);
 	mp->timer_armed = true;
 
@@ -1204,7 +1206,6 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 	if (!mp)
 		goto out;
 
-	setup_timer(&mp->timer, br_multicast_group_expired, (unsigned long)mp);
 	mod_timer(&mp->timer, now + br->multicast_membership_interval);
 	mp->timer_armed = true;
 


