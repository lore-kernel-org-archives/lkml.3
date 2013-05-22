Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3EVOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:16:59 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:52326 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3EVOQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:16:57 -0400
Message-ID: <1369232215.3301.338.camel@edumazet-glaptop>
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Roman Gushchin <klamm@yandex-team.ru>,
        Dipankar Sarma <dipankar@in.ibm.com>, zhmurov@yandex-team.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Wed, 22 May 2013 07:16:55 -0700
In-Reply-To: <20130522130030.GB3431@linux.vnet.ibm.com>
References: <519B38EC.90401@yandex-team.ru>
	 <20130521120906.GD3578@linux.vnet.ibm.com>
	 <1369143885.3301.221.camel@edumazet-glaptop>
	 <519B8908.9080007@yandex-team.ru>
	 <1369150693.3301.233.camel@edumazet-glaptop>
	 <519BB90B.6080706@yandex-team.ru>
	 <1369188080.3301.268.camel@edumazet-glaptop>
	 <20130522095839.GC3578@linux.vnet.ibm.com>
	 <1369225727.3301.322.camel@edumazet-glaptop>
	 <20130522130030.GB3431@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 06:00 -0700, Paul E. McKenney wrote:

> Right, rcu_read_lock() is part of the protection, but rcu_dereference()
> is the other part.
> 
> All that aside, I can't claim that I understand what problem the various
> patches would solve.  ;-)

Problem is that rcu_dereference(expr) might be optimized by the compiler
to cache the dereferenced data in certain circumstances.

Following patch shows the difference if you look at the generated code:

This patch fixes the problem, and its not really obvious why !

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 0bf5d39..6aa8088 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -416,11 +416,12 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 	struct hlist_nulls_node *node;
 	int score, badness, matches = 0, reuseport = 0;
 	u32 hash = 0;
+	struct hlist_nulls_head *head = &hslot2->head;
 
 begin:
 	result = NULL;
 	badness = 0;
-	udp_portaddr_for_each_entry_rcu(sk, node, &hslot2->head) {
+	udp_portaddr_for_each_entry_rcu(sk, node, head) {
 		score = compute_score2(sk, net, saddr, sport,
 				      daddr, hnum, dif);
 		if (score > badness) {



