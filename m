Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3FYSyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:54:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41117 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3FYSeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerry Chu <hkchu@google.com>, Wei Yongjun <weiyj.lk@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 76/95] tuntap: correct the return value in tun_set_iff()
Date: Tue, 25 Jun 2013 11:33:03 -0700
Message-Id: <20130625182202.162577566@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit e8dbad66ef56074eadb41ed5998acd2320447018 ]

commit (3be8fbab tuntap: fix error return code in tun_set_iff()) breaks the
creation of multiqueue tuntap since it forbids to create more than one queues
for a multiqueue tuntap device. We need return 0 instead -EBUSY here since we
don't want to re-initialize the device when one or more queues has been already
attached. Add a comment and correct the return value to zero.

Reported-by: Jerry Chu <hkchu@google.com>
Cc: Jerry Chu <hkchu@google.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by:  Jerry Chu <hkchu@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1600,8 +1600,12 @@ static int tun_set_iff(struct net *net,
 			return err;
 
 		if (tun->flags & TUN_TAP_MQ &&
-		    (tun->numqueues + tun->numdisabled > 1))
-			return -EBUSY;
+		    (tun->numqueues + tun->numdisabled > 1)) {
+			/* One or more queue has already been attached, no need
+			 * to initialize the device again.
+			 */
+			return 0;
+		}
 	}
 	else {
 		char *name;


