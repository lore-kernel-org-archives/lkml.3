Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbaDKQfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:35:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422850AbaDKQJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 48/65] tcp: fix get_timewait4_sock() delay computation on 64bit
Date: Fri, 11 Apr 2014 09:11:20 -0700
Message-Id: <20140411161004.297706436@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e2a1d3e47bb904082b758dec9d07edf241c45d05 ]

It seems I missed one change in get_timewait4_sock() to compute
the remaining time before deletion of IPV4 timewait socket.

This could result in wrong output in /proc/net/tcp for tm->when field.

Fixes: 96f817fedec4 ("tcp: shrink tcp6_timewait_sock by one cache line")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2629,7 +2629,7 @@ static void get_timewait4_sock(const str
 {
 	__be32 dest, src;
 	__u16 destp, srcp;
-	long delta = tw->tw_ttd - jiffies;
+	s32 delta = tw->tw_ttd - inet_tw_time_stamp();
 
 	dest  = tw->tw_daddr;
 	src   = tw->tw_rcv_saddr;


