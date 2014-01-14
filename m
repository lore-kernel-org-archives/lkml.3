Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaANA6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:58:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaANA1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Gao feng <gaofeng@cn.fujitsu.com>, Li RongQing <roy.qing.li@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 26/62] ipv6: always set the new created dsts from in ip6_rt_copy
Date: Mon, 13 Jan 2014 16:26:51 -0800
Message-Id: <20140114002711.209002032@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <roy.qing.li@gmail.com>

[ Upstream commit 24f5b855e17df7e355eacd6c4a12cc4d6a6c9ff0 ]

ip6_rt_copy only sets dst.from if ort has flag RTF_ADDRCONF and RTF_DEFAULT.
but the prefix routes which did get installed by hand locally can have an
expiration, and no any flag combination which can ensure a potential from
does never expire, so we should always set the new created dst's from.

This also fixes the new created dst is always expired since the ort, which
is created by RA, maybe has RTF_EXPIRES and RTF_ADDRCONF, but no RTF_DEFAULT.

Suggested-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Li RongQing <roy.qing.li@gmail.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1838,9 +1838,7 @@ static struct rt6_info *ip6_rt_copy(stru
 		else
 			rt->rt6i_gateway = *dest;
 		rt->rt6i_flags = ort->rt6i_flags;
-		if ((ort->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) ==
-		    (RTF_DEFAULT | RTF_ADDRCONF))
-			rt6_set_from(rt, ort);
+		rt6_set_from(rt, ort);
 		rt->rt6i_metric = 0;
 
 #ifdef CONFIG_IPV6_SUBTREES


