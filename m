Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933521Ab3E1VZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113Ab3E1VZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gao feng <gaofeng@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 60/78] net: tun: release the reference of tun device in tun_recvmsg
Date: Tue, 28 May 2013 14:20:09 -0700
Message-Id: <1369776027-17859-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 3811ae76bc84e5dc1a670ae10695f046b310bee1 ]

We forget to release the reference of tun device in tun_recvmsg.
bug introduced in commit 54f968d6efdbf7dec36faa44fc11f01b0e4d1990
(tuntap: move socket to tun_file)

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/tun.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index cb95fe5..522dc0a 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1471,14 +1471,17 @@ static int tun_recvmsg(struct kiocb *iocb, struct socket *sock,
 	if (!tun)
 		return -EBADFD;
 
-	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC))
-		return -EINVAL;
+	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC)) {
+		ret = -EINVAL;
+		goto out;
+	}
 	ret = tun_do_read(tun, tfile, iocb, m->msg_iov, total_len,
 			  flags & MSG_DONTWAIT);
 	if (ret > total_len) {
 		m->msg_flags |= MSG_TRUNC;
 		ret = flags & MSG_TRUNC ? ret : total_len;
 	}
+out:
 	tun_put(tun);
 	return ret;
 }
-- 
1.8.1.2

