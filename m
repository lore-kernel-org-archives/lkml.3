Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaBGLwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42485 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaBGLwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Engelmayer <cengelma@gmx.at>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 214/233] ieee802154: Fix memory leak in ieee802154_add_iface()
Date: Fri,  7 Feb 2014 11:47:13 +0000
Message-Id: <1391773652-25214-215-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Engelmayer <cengelma@gmx.at>

commit 267d29a69c6af39445f36102a832b25ed483f299 upstream.

Fix a memory leak in the ieee802154_add_iface() error handling path.
Detected by Coverity: CID 710490.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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

