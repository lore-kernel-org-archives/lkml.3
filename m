Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3A1Kdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:33:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3A1Kdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:33:53 -0500
Date: Mon, 28 Jan 2013 12:38:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCHv2] tun: fix carrier on/off status
Message-ID: <20130128103801.GA6648@redhat.com>
References: <5103B01D.5070303@gmx.de>
 <3592886.xagLc7Uij9@jason-thinkpad-t430s>
 <20130128101111.GB5337@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128101111.GB5337@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c8d68e6be1c3b242f1c598595830890b65cea64a removed carrier off call
from tun_detach since it's now called on queue disable and not only on
tun close.  This confuses userspace which used this flag to detect a
free tun. To fix, put this back but under if (clean).

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

Changes from v1:
	Don't set carrier off unless all queues are closed.

Note: didn't test in MQ mode - Jason, care checking this does the
right thing there?

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index af372d0..06b2723 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -434,10 +434,13 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 	}
 
 	if (clean) {
-		if (tun && tun->numqueues == 0 && tun->numdisabled == 0 &&
-		    !(tun->flags & TUN_PERSIST))
-			if (tun->dev->reg_state == NETREG_REGISTERED)
+		if (tun && tun->numqueues == 0 && tun->numdisabled == 0) {
+			netif_carrier_off(tun->dev);
+
+			if (!(tun->flags & TUN_PERSIST) &&
+			    tun->dev->reg_state == NETREG_REGISTERED)
 				unregister_netdevice(tun->dev);
+		}
 
 		BUG_ON(!test_bit(SOCK_EXTERNALLY_ALLOCATED,
 				 &tfile->socket.flags));
@@ -1644,10 +1647,10 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		    device_create_file(&tun->dev->dev, &dev_attr_owner) ||
 		    device_create_file(&tun->dev->dev, &dev_attr_group))
 			pr_err("Failed to create tun sysfs files\n");
-
-		netif_carrier_on(tun->dev);
 	}
 
+	netif_carrier_on(tun->dev);
+
 	tun_debug(KERN_INFO, tun, "tun_set_iff\n");
 
 	if (ifr->ifr_flags & IFF_NO_PI)
