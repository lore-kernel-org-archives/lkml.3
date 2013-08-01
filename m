Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3HAKsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:48:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3HAKsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:48:37 -0400
Date: Thu, 1 Aug 2013 13:50:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Patrick McHardy <kaber@trash.net>,
        netdev@vger.kernel.org
Subject: [PATCH] macvlan: handle set_promiscuity failures
Message-ID: <1375354185-7257-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's quite unlikely that dev_set_promiscuity will fail,
but worth checking just in case.

Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/macvlan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 13937f9..d0f9c2f 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -337,8 +337,11 @@ static int macvlan_open(struct net_device *dev)
 	int err;
 
 	if (vlan->port->passthru) {
-		if (!(vlan->flags & MACVLAN_FLAG_NOPROMISC))
-			dev_set_promiscuity(lowerdev, 1);
+		if (!(vlan->flags & MACVLAN_FLAG_NOPROMISC)) {
+			err = dev_set_promiscuity(lowerdev, 1);
+			if (err < 0)
+				goto out;
+		}
 		goto hash_add;
 	}
 
-- 
MST
