Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3F1TEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:04:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab3F1S5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 085/105] team: check return value of team_get_port_by_index_rcu() for NULL
Date: Fri, 28 Jun 2013 11:51:47 -0700
Message-Id: <1372445527-24414-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/team/team_mode_roundrobin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/team/team_mode_roundrobin.c b/drivers/net/team/team_mode_roundrobin.c
index 105135a..041cc0a 100644
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
1.8.1.2

