Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3FDXGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:06:52 -0400
Received: from 1wt.eu ([62.212.114.60]:35571 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab3FDWms (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:48 -0400
Message-Id: <20130604172136.272782194@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:54 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 144/184] net/core: Fix potential memory leak in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 dev_set_alias()

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 7364e445f62825758fa61195d237a5b8ecdd06ec ]

Do not leak memory by updating pointer with potentially NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 46e2a29..f4a6e14 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -967,6 +967,8 @@ rollback:
  */
 int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 {
+	char *new_ifalias;
+
 	ASSERT_RTNL();
 
 	if (len >= IFALIASZ)
@@ -980,9 +982,10 @@ int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 		return 0;
 	}
 
-	dev->ifalias = krealloc(dev->ifalias, len + 1, GFP_KERNEL);
-	if (!dev->ifalias)
+	new_ifalias = krealloc(dev->ifalias, len + 1, GFP_KERNEL);
+	if (!new_ifalias)
 		return -ENOMEM;
+	dev->ifalias = new_ifalias;
 
 	strlcpy(dev->ifalias, alias, len+1);
 	return len;
-- 
1.7.12.2.21.g234cd45.dirty



