Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab3FCWPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:15:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12159 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab3FCWM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:28 -0400
X-Authority-Analysis: v=2.0 cv=Et5QXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=tswX8LCBKZEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=nakT_YOu4zkA:10 a=jZVsG21pAAAA:8 a=hD80L64hAAAA:8 a=J1Y8HTJGAAAA:8 a=DCgKN_VYeAryVIG_oVwA:9 a=v-EnS7xDjQoA:10 a=v3rLFGiuRE8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221158.544558300@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: JerryKang <jerry.kang@samsung.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [36/65] bridge: fix race with topology change timer
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0036-bridge-fix-race-with-topology-change-timer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit 83401eb4990ff6af55aeed8f49681558544192e6 ]

A bridge should only send topology change notice if it is not
the root bridge. It is possible for message age timer to elect itself
as a new root bridge, and still have a topology change timer running
but waiting for bridge lock on other CPU.

Solve the race by checking if we are root bridge before continuing.
This was the root cause of the cases where br_send_tcn_bpdu would OOPS.

Reported-by: JerryKang <jerry.kang@samsung.com>
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/bridge/br_stp_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_stp_timer.c b/net/bridge/br_stp_timer.c
index a6747e6..acc63a4 100644
--- a/net/bridge/br_stp_timer.c
+++ b/net/bridge/br_stp_timer.c
@@ -107,7 +107,7 @@ static void br_tcn_timer_expired(unsigned long arg)
 
 	br_debug(br, "tcn timer expired\n");
 	spin_lock(&br->lock);
-	if (br->dev->flags & IFF_UP) {
+	if (!br_is_root_bridge(br) && (br->dev->flags & IFF_UP)) {
 		br_transmit_tcn(br);
 
 		mod_timer(&br->tcn_timer,jiffies + br->bridge_hello_time);
-- 
1.7.10.4


