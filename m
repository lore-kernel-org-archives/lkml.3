Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688AbaCDU1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:27:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243AbaCDUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 32/97] ipv4: fix counter in_slow_tot
Date: Tue,  4 Mar 2014 12:03:45 -0800
Message-Id: <20140304200347.109950362@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

[ Upstream commit a6254864c08109c66a194612585afc0439005286 ]

since commit 89aef8921bf("ipv4: Delete routing cache."), the counter
in_slow_tot can't work correctly.

The counter in_slow_tot increase by one when fib_lookup() return successfully
in ip_route_input_slow(), but actually the dst struct maybe not be created and
cached, so we can increase in_slow_tot after the dst struct is created.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1544,6 +1544,7 @@ static int __mkroute_input(struct sk_buf
 	rth->rt_gateway	= 0;
 	rth->rt_uses_gateway = 0;
 	INIT_LIST_HEAD(&rth->rt_uncached);
+	RT_CACHE_STAT_INC(in_slow_tot);
 
 	rth->dst.input = ip_forward;
 	rth->dst.output = ip_output;
@@ -1645,8 +1646,6 @@ static int ip_route_input_slow(struct sk
 	if (err != 0)
 		goto no_route;
 
-	RT_CACHE_STAT_INC(in_slow_tot);
-
 	if (res.type == RTN_BROADCAST)
 		goto brd_input;
 
@@ -1715,6 +1714,7 @@ local_input:
 	rth->rt_gateway	= 0;
 	rth->rt_uses_gateway = 0;
 	INIT_LIST_HEAD(&rth->rt_uncached);
+	RT_CACHE_STAT_INC(in_slow_tot);
 	if (res.type == RTN_UNREACHABLE) {
 		rth->dst.input= ip_error;
 		rth->dst.error= -err;


