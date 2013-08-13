Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab3HMP6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758677Ab3HMP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:31 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=6kPHsaEXljEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pMa7x3SRpeAA:10 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=qJl0yQZNg3oA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155827.692457154@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [26/88] team: check return value of team_get_port_by_index_rcu() for NULL
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0026-team-check-return-value-of-team_get_port_by_index_rc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit 76c455decbbad31de21c727edb184a963f42b40b ]

team_get_port_by_index_rcu() might return NULL due to race between port
removal and skb tx path. Panic is easily triggeable when txing packets
and adding/removing port in a loop.

introduced by commit 3d249d4ca "net: introduce ethernet teaming device"
and commit 753f993911b "team: introduce random mode" (for random mode)

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/team/team_mode_roundrobin.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/team/team_mode_roundrobin.c b/drivers/net/team/team_mode_roundrobin.c
index ad7ed0e..dcbe6ba 100644
--- a/drivers/net/team/team_mode_roundrobin.c
+++ b/drivers/net/team/team_mode_roundrobin.c
@@ -52,6 +52,8 @@ static bool rr_transmit(struct team *team, struct sk_buff *skb)
 
 	port_index = rr_priv(team)->sent_packets++ % team->en_port_count;
 	port = team_get_port_by_index_rcu(team, port_index);
+	if (unlikely(!port))
+		goto drop;
 	port = __get_first_port_up(team, port);
 	if (unlikely(!port))
 		goto drop;
-- 
1.7.10.4


