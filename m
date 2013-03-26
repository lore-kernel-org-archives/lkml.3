Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab3CZRuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:50:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15455 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3CZRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:19 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=W-xT8w_zcgUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=WWFH4MSF--IA:10 a=mK_AVkanAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=9xyTavCNlvEA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173606.992995320@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 44/86] sock_diag: Fix out-of-bounds access to sock_diag_handlers[]
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0044-sock_diag-Fix-out-of-bounds-access-to-sock_diag_hand.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 6e601a53566d84e1ffd25e7b6fe0b6894ffd79c0 ]

Userland can send a netlink message requesting SOCK_DIAG_BY_FAMILY
with a family greater or equal then AF_MAX -- the array size of
sock_diag_handlers[]. The current code does not test for this
condition therefore is vulnerable to an out-of-bound access opening
doors for a privilege escalation.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/core/sock_diag.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index 9d8755e..a2ad320 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -121,6 +121,9 @@ static int __sock_diag_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (nlmsg_len(nlh) < sizeof(*req))
 		return -EINVAL;
 
+	if (req->sdiag_family >= AF_MAX)
+		return -EINVAL;
+
 	hndl = sock_diag_lock_handler(req->sdiag_family);
 	if (hndl == NULL)
 		err = -ENOENT;
-- 
1.7.10.4


