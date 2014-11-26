Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaKZGIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:08:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750731AbaKZGIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:08:13 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mst@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next] tun/macvtap: use consume_skb() instead of kfree_skb() in tun/macvtap_do_read()
Date: Wed, 26 Nov 2014 14:08:04 +0800
Message-Id: <1416982084-12212-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be more friendly with drop monitor, we should use comsume_skb() instead
of kfree_skb() in tun/macvtap_do_read(). Otherwise, the packets will be
marked as dropped.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c | 2 +-
 drivers/net/tun.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 42a80d3..74d1b23 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -862,7 +862,7 @@ static ssize_t macvtap_do_read(struct macvtap_queue *q,
 		}
 		iov_iter_init(&iter, READ, iv, segs, len);
 		ret = macvtap_put_user(q, skb, &iter);
-		kfree_skb(skb);
+		consume_skb(skb);
 		break;
 	}
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ac53a73..d7edeaf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1363,7 +1363,7 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 
 	iov_iter_init(&iter, READ, iv, segs, len);
 	ret = tun_put_user(tun, tfile, skb, &iter);
-	kfree_skb(skb);
+	consume_skb(skb);
 
 	return ret;
 }
-- 
1.9.1

