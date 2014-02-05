Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaBEUFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:22 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48089 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaBEUFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:13 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 058/213] net/core: Fix potential memory leak in dev_set_alias()
Date: Wed, 5 Feb 2014 15:00:13 -0500
Message-ID: <1391630568-49251-59-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7364e445f62825758fa61195d237a5b8ecdd06ec upstream.

Do not leak memory by updating pointer with potentially NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/dev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 253b409fe3ab..3dbbba137c93 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1034,6 +1034,8 @@ rollback:
  */
 int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 {
+	char *new_ifalias;
+
 	ASSERT_RTNL();
 
 	if (len >= IFALIASZ)
@@ -1047,9 +1049,10 @@ int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
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
1.8.5.2

