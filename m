Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbbATXVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:21:23 -0500
Received: from nacho.alt.net ([208.90.169.18]:53078 "EHLO nacho.alt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbbATXVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:21:21 -0500
Comment: DKIM? See http://www.dkim.org
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
	s=default; d=alt.net;
	h=Received:Received:Received:Date:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:Content-Type:X-Delivery-Agent:From:Reply-To;
	b=cZ6gPis6Ys37qhNZfJiNwa2civOO8p0sGGqJ8L9bAXDjjUR5aAsdGZp7x1yPPi
	NVyBg3KpGkEpSxqmNmU//d1ycK6doZFJkNwIMuBEu+RIXgs0dCbIjaOIYYzp4TOB
	M3uVvgQ4/Q+9MchwLa8PesW+PKINRKjT0N99yO1LM062E=;
Date: Tue, 20 Jan 2015 23:21:18 +0000 (UTC)
To: Julian Anastasov <ja@ssi.bg>
cc: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] IPVS: add wlib & wlip schedulers
In-Reply-To: <alpine.LFD.2.11.1501192342190.2687@ja.home.ssi.bg>
Message-ID: <Pine.LNX.4.64.1501200137310.8217@nacho.alt.net>
References: <Pine.LNX.4.44.0501260832210.17893-100000@nacho.alt.net>
	<Pine.LNX.4.61.0502010007060.1148@penguin.linux-vs.org>
	<Pine.LNX.4.64.1501172217420.8217@nacho.alt.net>
	<alpine.LFD.2.11.1501192342190.2687@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Delivery-Agent: TMDA/1.1.12 (Macallan)
From: Chris Caputo <ccaputo@alt.net>
Reply-To: Chris Caputo <ccaputo-dated-1432164079.8f5661@alt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Julian Anastasov wrote:
> On Sat, 17 Jan 2015, Chris Caputo wrote:
> > From: Chris Caputo <ccaputo@alt.net> 
> > 
> > IPVS wlib (Weighted Least Incoming Byterate) and wlip (Weighted Least Incoming 
> > Packetrate) schedulers, updated for 3.19-rc4.

Hi Julian,

Thanks for the review.

> 	The IPVS estimator uses 2-second timer to update
> the stats, isn't that a problem for such schedulers?
> Also, you schedule by incoming traffic rate which is
> ok when clients mostly upload. But in the common case
> clients mostly download and IPVS processes download
> traffic only for NAT method.

My application consists of incoming TCP streams being load balanced to 
servers which receive the feeds. These are long lived multi-gigabyte 
streams, and so I believe the estimator's 2-second timer is fine. As an 
example:

# cat /proc/net/ip_vs_stats
   Total Incoming Outgoing         Incoming         Outgoing
   Conns  Packets  Packets            Bytes            Bytes
     9AB  58B7C17        0      1237CA2C325                0

 Conns/s   Pkts/s   Pkts/s          Bytes/s          Bytes/s
       1     387C        0          B16C4AE                0

> 	May be not so useful idea: use sum of both directions
> or control it with svc->flags & IP_VS_SVC_F_SCHED_WLIB_xxx
> flags, see how "sh" scheduler supports flags. I.e.
> inbps + outbps.

I see a user-mode option as increasing complexity. For example, 
keepalived users would need to have keepalived patched to support the new 
algorithm, due to flags, rather than just configuring "wlib" or "wlip" and 
it just working.

I think I'd rather see a wlob/wlop version for users that want to 
load-balance based on outgoing bytes/packets, and a wlb/wlp version for 
users that want them summed.

> 	Another problem: pps and bps are shifted values,
> see how ip_vs_read_estimator() reads them. ip_vs_est.c
> contains comments that this code handles couple of
> gigabits. May be inbps and outbps in struct ip_vs_estimator
> should be changed to u64 to support more gigabits, with
> separate patch.

See patch below to convert bps in ip_vs_estimator to 64-bits.

Other patches, based on your feedback, to follow.

Thanks,
Chris

From: Chris Caputo <ccaputo@alt.net> 

IPVS: Change inbps and outbps to 64-bits so that estimator handles faster
flows. Also increases maximum viewable at user level from ~2.15Gbits/s to
~34.35Gbits/s.

Signed-off-by: Chris Caputo <ccaputo@alt.net>
---
diff -uprN linux-3.19-rc5-stock/include/net/ip_vs.h linux-3.19-rc5/include/net/ip_vs.h
--- linux-3.19-rc5-stock/include/net/ip_vs.h	2015-01-18 06:02:20.000000000 +0000
+++ linux-3.19-rc5/include/net/ip_vs.h	2015-01-20 08:01:15.548177969 +0000
@@ -390,8 +390,8 @@ struct ip_vs_estimator {
 	u32			cps;
 	u32			inpps;
 	u32			outpps;
-	u32			inbps;
-	u32			outbps;
+	u64			inbps;
+	u64			outbps;
 };
 
 struct ip_vs_stats {
diff -uprN linux-3.19-rc5-stock/net/netfilter/ipvs/ip_vs_est.c linux-3.19-rc5/net/netfilter/ipvs/ip_vs_est.c
--- linux-3.19-rc5-stock/net/netfilter/ipvs/ip_vs_est.c	2015-01-18 06:02:20.000000000 +0000
+++ linux-3.19-rc5/net/netfilter/ipvs/ip_vs_est.c	2015-01-20 08:01:34.369840704 +0000
@@ -45,10 +45,12 @@
 
   NOTES.
 
-  * The stored value for average bps is scaled by 2^5, so that maximal
-    rate is ~2.15Gbits/s, average pps and cps are scaled by 2^10.
+  * Average bps is scaled by 2^5, while average pps and cps are scaled by 2^10.
 
-  * A lot code is taken from net/sched/estimator.c
+  * All are reported to user level as 32 bit unsigned values. Bps can
+    overflow for fast links : max speed being ~34.35Gbits/s.
+
+  * A lot of code is taken from net/core/gen_estimator.c
  */
 
 
@@ -98,7 +100,7 @@ static void estimation_timer(unsigned lo
 	u32 n_conns;
 	u32 n_inpkts, n_outpkts;
 	u64 n_inbytes, n_outbytes;
-	u32 rate;
+	u64 rate;
 	struct net *net = (struct net *)arg;
 	struct netns_ipvs *ipvs;
 
@@ -118,23 +120,24 @@ static void estimation_timer(unsigned lo
 		/* scaled by 2^10, but divided 2 seconds */
 		rate = (n_conns - e->last_conns) << 9;
 		e->last_conns = n_conns;
-		e->cps += ((long)rate - (long)e->cps) >> 2;
+		e->cps += ((s64)rate - (s64)e->cps) >> 2;
 
 		rate = (n_inpkts - e->last_inpkts) << 9;
 		e->last_inpkts = n_inpkts;
-		e->inpps += ((long)rate - (long)e->inpps) >> 2;
+		e->inpps += ((s64)rate - (s64)e->inpps) >> 2;
 
 		rate = (n_outpkts - e->last_outpkts) << 9;
 		e->last_outpkts = n_outpkts;
-		e->outpps += ((long)rate - (long)e->outpps) >> 2;
+		e->outpps += ((s64)rate - (s64)e->outpps) >> 2;
 
+		/* scaled by 2^5, but divided 2 seconds */
 		rate = (n_inbytes - e->last_inbytes) << 4;
 		e->last_inbytes = n_inbytes;
-		e->inbps += ((long)rate - (long)e->inbps) >> 2;
+		e->inbps += ((s64)rate - (s64)e->inbps) >> 2;
 
 		rate = (n_outbytes - e->last_outbytes) << 4;
 		e->last_outbytes = n_outbytes;
-		e->outbps += ((long)rate - (long)e->outbps) >> 2;
+		e->outbps += ((s64)rate - (s64)e->outbps) >> 2;
 		spin_unlock(&s->lock);
 	}
 	spin_unlock(&ipvs->est_lock);
