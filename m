Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbaBJUCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:02:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaBJTqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Engelmayer <cengelma@gmx.at>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 113/124] ieee802154: Fix memory leak in ieee802154_add_iface()
Date: Mon, 10 Feb 2014 11:40:53 -0800
Message-Id: <1392061264-28124-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Engelmayer <cengelma@gmx.at>

[ Upstream commit 267d29a69c6af39445f36102a832b25ed483f299 ]

Fix a memory leak in the ieee802154_add_iface() error handling path.
Detected by Coverity: CID 710490.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ieee802154/nl-phy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/nl-phy.c b/net/ieee802154/nl-phy.c
index 22b1a70..4efd237 100644
--- a/net/ieee802154/nl-phy.c
+++ b/net/ieee802154/nl-phy.c
@@ -224,8 +224,10 @@ static int ieee802154_add_iface(struct sk_buff *skb,
 
 	if (info->attrs[IEEE802154_ATTR_DEV_TYPE]) {
 		type = nla_get_u8(info->attrs[IEEE802154_ATTR_DEV_TYPE]);
-		if (type >= __IEEE802154_DEV_MAX)
-			return -EINVAL;
+		if (type >= __IEEE802154_DEV_MAX) {
+			rc = -EINVAL;
+			goto nla_put_failure;
+		}
 	}
 
 	dev = phy->add_iface(phy, devname, type);
-- 
1.8.3.2

