Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab3EQWOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:14:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3EQVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gao feng <gaofeng@cn.fujitsu.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 056/102] net: tun: release the reference of tun device in tun_recvmsg
Date: Fri, 17 May 2013 14:36:11 -0700
Message-Id: <20130517213250.268121777@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Gao feng <gaofeng@cn.fujitsu.com>

[ Upstream commit 3811ae76bc84e5dc1a670ae10695f046b310bee1 ]

We forget to release the reference of tun device in tun_recvmsg.
bug introduced in commit 54f968d6efdbf7dec36faa44fc11f01b0e4d1990
(tuntap: move socket to tun_file)

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1471,14 +1471,17 @@ static int tun_recvmsg(struct kiocb *ioc
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


