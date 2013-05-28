Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab3E1VZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59745 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab3E1VZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 67/78] bridge: fix race with topology change timer
Date: Tue, 28 May 2013 14:20:16 -0700
Message-Id: <1369776027-17859-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_stp_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_stp_timer.c b/net/bridge/br_stp_timer.c
index c3530a8..950663d 100644
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
1.8.1.2

