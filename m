Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3J2SKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:10:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59616 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3J2SJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 24/81] tuntap: correctly handle error in tun_set_iff()
Date: Tue, 29 Oct 2013 11:03:45 -0700
Message-Id: <1383069882-11437-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 662ca437e714caaab855b12415d6ffd815985bc0 upstream.

Commit c8d68e6be1c3b242f1c598595830890b65cea64a
(tuntap: multiqueue support) only call free_netdev() on error in
tun_set_iff(). This causes several issues:

- memory of tun security were leaked
- use after free since the flow gc timer was not deleted and the tfile
  were not detached

This patch solves the above issues.

Reported-by: Wannes Rombouts <wannes.rombouts@epitech.eu>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: 3.8-stable for CVE-2013-4343 ]
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/tun.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 441c987..66b4613 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1686,11 +1686,11 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		INIT_LIST_HEAD(&tun->disabled);
 		err = tun_attach(tun, file);
 		if (err < 0)
-			goto err_free_dev;
+			goto err_free_flow;
 
 		err = register_netdevice(tun->dev);
 		if (err < 0)
-			goto err_free_dev;
+			goto err_detach;
 
 		if (device_create_file(&tun->dev->dev, &dev_attr_tun_flags) ||
 		    device_create_file(&tun->dev->dev, &dev_attr_owner) ||
@@ -1734,7 +1734,12 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 	strcpy(ifr->ifr_name, tun->dev->name);
 	return 0;
 
- err_free_dev:
+err_detach:
+	tun_detach_all(dev);
+err_free_flow:
+	tun_flow_uninit(tun);
+	security_tun_dev_free_security(tun->security);
+err_free_dev:
 	free_netdev(dev);
 	return err;
 }
-- 
1.8.1.2

