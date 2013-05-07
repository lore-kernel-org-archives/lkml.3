Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692Ab3EGEod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:44:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759395Ab3EGEZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:37 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=pUFiVd-h_94A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=y_TSB6SVyxgA:10 a=uYVGJH5IAAAA:8 a=J1Y8HTJGAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=SSO-Y9H-le0A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035901.317718035@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [122/126] net: rate-limit warn-bad-offload splats.
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0122-net-rate-limit-warn-bad-offload-splats.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit c846ad9b880ece01bb4d8d07ba917734edf0324f ]

If one does do something unfortunate and allow a
bad offload bug into the kernel, this the
skb_warn_bad_offload can effectively live-lock the
system, filling the logs with the same error over
and over.

Add rate limitation to this so that box remains otherwise
functional in this case.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/core/dev.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9509394..cefd2c2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1907,6 +1907,9 @@ static void skb_warn_bad_offload(const struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	const char *driver = "";
 
+	if (!net_ratelimit())
+		return;
+
 	if (dev && dev->dev.parent)
 		driver = dev_driver_string(dev->dev.parent);
 
-- 
1.7.10.4


