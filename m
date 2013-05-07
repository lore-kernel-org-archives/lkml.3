Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab3EGNla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab3EGNlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Greear <greearb@candelatech.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 056/118] net: rate-limit warn-bad-offload splats.
Date: Tue,  7 May 2013 14:38:22 +0100
Message-Id: <1367933964-1564-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

commit c846ad9b880ece01bb4d8d07ba917734edf0324f upstream.

If one does do something unfortunate and allow a
bad offload bug into the kernel, this the
skb_warn_bad_offload can effectively live-lock the
system, filling the logs with the same error over
and over.

Add rate limitation to this so that box remains otherwise
functional in this case.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 196bc5f..ba9d7a7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1893,6 +1893,9 @@ static void skb_warn_bad_offload(const struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	const char *driver = "";
 
+	if (!net_ratelimit())
+		return;
+
 	if (dev && dev->dev.parent)
 		driver = dev_driver_string(dev->dev.parent);
 
-- 
1.8.1.2

