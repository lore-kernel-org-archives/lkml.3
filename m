Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3KAWR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:17:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab3KAWIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julian Anastasov <ja@ssi.bg>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 46/66] ipv6: probe routes asynchronous in rt6_probe
Date: Fri,  1 Nov 2013 15:07:22 -0700
Message-Id: <20131101220647.442033766@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit c2f17e827b419918c856131f592df9521e1a38e3 ]

Routes need to be probed asynchronous otherwise the call stack gets
exhausted when the kernel attemps to deliver another skb inline, like
e.g. xt_TEE does, and we probe at the same time.

We update neigh->updated still at once, otherwise we would send to
many probes.

Cc: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |   38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -477,6 +477,24 @@ out:
 }
 
 #ifdef CONFIG_IPV6_ROUTER_PREF
+struct __rt6_probe_work {
+	struct work_struct work;
+	struct in6_addr target;
+	struct net_device *dev;
+};
+
+static void rt6_probe_deferred(struct work_struct *w)
+{
+	struct in6_addr mcaddr;
+	struct __rt6_probe_work *work =
+		container_of(w, struct __rt6_probe_work, work);
+
+	addrconf_addr_solict_mult(&work->target, &mcaddr);
+	ndisc_send_ns(work->dev, NULL, &work->target, &mcaddr, NULL);
+	dev_put(work->dev);
+	kfree(w);
+}
+
 static void rt6_probe(struct rt6_info *rt)
 {
 	struct neighbour *neigh;
@@ -500,17 +518,23 @@ static void rt6_probe(struct rt6_info *r
 
 	if (!neigh ||
 	    time_after(jiffies, neigh->updated + rt->rt6i_idev->cnf.rtr_probe_interval)) {
-		struct in6_addr mcaddr;
-		struct in6_addr *target;
+		struct __rt6_probe_work *work;
 
-		if (neigh) {
+		work = kmalloc(sizeof(*work), GFP_ATOMIC);
+
+		if (neigh && work)
 			neigh->updated = jiffies;
+
+		if (neigh)
 			write_unlock(&neigh->lock);
-		}
 
-		target = (struct in6_addr *)&rt->rt6i_gateway;
-		addrconf_addr_solict_mult(target, &mcaddr);
-		ndisc_send_ns(rt->dst.dev, NULL, target, &mcaddr, NULL);
+		if (work) {
+			INIT_WORK(&work->work, rt6_probe_deferred);
+			work->target = rt->rt6i_gateway;
+			dev_hold(rt->dst.dev);
+			work->dev = rt->dst.dev;
+			schedule_work(&work->work);
+		}
 	} else {
 out:
 		write_unlock(&neigh->lock);


