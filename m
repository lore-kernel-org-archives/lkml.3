Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3I3KMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab3I3KMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 048/104] tun: signedness bug in tun_get_user()
Date: Mon, 30 Sep 2013 11:10:25 +0100
Message-Id: <1380535881-9239-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 15718ea0d844e4816dbd95d57a8a0e3e264ba90e upstream.

The recent fix d9bf5f1309 "tun: compare with 0 instead of total_len" is
not totally correct.  Because "len" and "sizeof()" are size_t type, that
means they are never less than zero.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/tun.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 21c33f2..f21bcef 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -615,8 +615,9 @@ static ssize_t tun_get_user(struct tun_struct *tun,
 	int offset = 0;
 
 	if (!(tun->flags & TUN_NO_PI)) {
-		if ((len -= sizeof(pi)) > count)
+		if (len < sizeof(pi))
 			return -EINVAL;
+		len -= sizeof(pi);
 
 		if (memcpy_fromiovecend((void *)&pi, iv, 0, sizeof(pi)))
 			return -EFAULT;
@@ -624,8 +625,9 @@ static ssize_t tun_get_user(struct tun_struct *tun,
 	}
 
 	if (tun->flags & TUN_VNET_HDR) {
-		if ((len -= tun->vnet_hdr_sz) > count)
+		if (len < tun->vnet_hdr_sz)
 			return -EINVAL;
+		len -= tun->vnet_hdr_sz;
 
 		if (memcpy_fromiovecend((void *)&gso, iv, offset, sizeof(gso)))
 			return -EFAULT;
-- 
1.8.3.2

