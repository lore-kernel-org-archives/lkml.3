Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab3JJQKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:10:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52587 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3JJPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 013/104] tun: signedness bug in tun_get_user()
Date: Thu, 10 Oct 2013 08:41:01 -0700
Message-Id: <1381419752-29733-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 15718ea0d844e4816dbd95d57a8a0e3e264ba90e ]

The recent fix d9bf5f1309 "tun: compare with 0 instead of total_len" is
not totally correct.  Because "len" and "sizeof()" are size_t type, that
means they are never less than zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/tun.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 340cee2..441c987 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1077,8 +1077,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	u32 rxhash;
 
 	if (!(tun->flags & TUN_NO_PI)) {
-		if ((len -= sizeof(pi)) > total_len)
+		if (len < sizeof(pi))
 			return -EINVAL;
+		len -= sizeof(pi);
 
 		if (memcpy_fromiovecend((void *)&pi, iv, 0, sizeof(pi)))
 			return -EFAULT;
@@ -1086,8 +1087,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	}
 
 	if (tun->flags & TUN_VNET_HDR) {
-		if ((len -= tun->vnet_hdr_sz) > total_len)
+		if (len < tun->vnet_hdr_sz)
 			return -EINVAL;
+		len -= tun->vnet_hdr_sz;
 
 		if (memcpy_fromiovecend((void *)&gso, iv, offset, sizeof(gso)))
 			return -EFAULT;
-- 
1.8.1.2

