Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3GBLIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3GBLIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 20/50] team: check return value of team_get_port_by_index_rcu() for NULL
Date: Tue,  2 Jul 2013 12:07:08 +0100
Message-Id: <1372763258-20664-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

commit 76c455decbbad31de21c727edb184a963f42b40b upstream.

team_get_port_by_index_rcu() might return NULL due to race between port
removal and skb tx path. Panic is easily triggeable when txing packets
and adding/removing port in a loop.

introduced by commit 3d249d4ca "net: introduce ethernet teaming device"
and commit 753f993911b "team: introduce random mode" (for random mode)

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: used davem's backport to 3.4:
  - adjusted context
  - dropped changes to team_mode_random.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/team/team_mode_roundrobin.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/team/team_mode_roundrobin.c b/drivers/net/team/team_mode_roundrobin.c
index 6abfbdc..d9a5e45 100644
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

