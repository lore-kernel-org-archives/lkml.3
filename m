Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3JKUMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:12:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab3JKTlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wannes Rombouts <wannes.rombouts@epitech.eu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 019/135] tuntap: correctly handle error in tun_set_iff()
Date: Fri, 11 Oct 2013 12:38:20 -0700
Message-Id: <20131011193947.318056163@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 662ca437e714caaab855b12415d6ffd815985bc0 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1691,11 +1691,11 @@ static int tun_set_iff(struct net *net,
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
@@ -1739,7 +1739,12 @@ static int tun_set_iff(struct net *net,
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


