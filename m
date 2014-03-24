Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaCXHwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 03:52:18 -0400
Received: from m12-11.163.com ([220.181.12.11]:53588 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaCXHwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 03:52:16 -0400
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Mar 2014 03:52:14 EDT
From: Wei Zhang <asuka.com@163.com>
To: xeb@mail.ru, davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wei Zhang <asuka.com@163.com>
Subject: [PATCH] ipv4: gre: Fix null pointer dereference in gre_cisco_err()
Date: Mon, 24 Mar 2014 15:34:31 +0800
Message-Id: <1395646471-637-1-git-send-email-asuka.com@163.com>
X-Mailer: git-send-email 1.7.1
X-CM-TRANSID: C8CowEBZN0pJ4C9Tj81aAQ--.1191S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr4rKry3CFy7try8Zw1rXrb_yoWfXFg_uF
	95trWUuw48u3ZYy343Ars3C3yfK3yFkFWFgr10qrWUJas8Jry5A3Wvkr9xCrW7XFWakryI
	qw1DWrWfJr47ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1IeHJUUUUU==
X-Originating-IP: [221.237.158.191]
X-CM-SenderInfo: 5dvxytoofrzqqrwthudrp/xtbB0QpY1lEAKnLudwAAsF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When use the gre vport, openvswitch register a gre_cisco_protocol but
does not supply a err_handler with it. The gre_cisco_err() call the
err_handler without existence check, cause the kernel crash.

This patch base on v3.14-rc7. But the bug affect all kernel newer than
3.11!

Signed-off-by: Wei Zhang <asuka.com@163.com>
---
 net/ipv4/gre_demux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index 1863422..56b0d67 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -250,7 +250,7 @@ static void gre_cisco_err(struct sk_buff *skb, u32 info)
 		struct gre_cisco_protocol *proto;
 
 		proto = rcu_dereference(gre_cisco_proto_list[i]);
-		if (!proto)
+		if (!proto || !proto->err_handler)
 			continue;
 
 		if (proto->err_handler(skb, info, &tpi) == PACKET_RCVD)
-- 
1.7.1


