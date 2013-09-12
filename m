Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab3ILRtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:49:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3ILRp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 10/23] tun: signedness bug in tun_get_user()
Date: Thu, 12 Sep 2013 10:45:06 -0700
Message-Id: <20130912174452.868503548@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -615,8 +615,9 @@ static ssize_t tun_get_user(struct tun_s
 	int offset = 0;
 
 	if (!(tun->flags & TUN_NO_PI)) {
-		if ((len -= sizeof(pi)) > count)
+		if (len < sizeof(pi))
 			return -EINVAL;
+		len -= sizeof(pi);
 
 		if (memcpy_fromiovecend((void *)&pi, iv, 0, sizeof(pi)))
 			return -EFAULT;
@@ -624,8 +625,9 @@ static ssize_t tun_get_user(struct tun_s
 	}
 
 	if (tun->flags & TUN_VNET_HDR) {
-		if ((len -= tun->vnet_hdr_sz) > count)
+		if (len < tun->vnet_hdr_sz)
 			return -EINVAL;
+		len -= tun->vnet_hdr_sz;
 
 		if (memcpy_fromiovecend((void *)&gso, iv, offset, sizeof(gso)))
 			return -EFAULT;


