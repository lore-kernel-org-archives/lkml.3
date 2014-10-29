Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436AbaJ2QLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:11:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17130 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbaJ2QLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:11:16 -0400
Date: Wed, 29 Oct 2014 19:10:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] Bluetooth: 6lowpan: use after free in disconnect_devices()
Message-ID: <20141029161057.GF5290@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was accidentally changed from list_for_each_entry_safe() to
list_for_each_entry() so now it has a use after free bug.  I've changed
it back.

Fixes: 90305829635d ('Bluetooth: 6lowpan: Converting rwlocks to use RCU')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 7254bdd..eef298d 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1383,7 +1383,7 @@ static const struct file_operations lowpan_control_fops = {
 
 static void disconnect_devices(void)
 {
-	struct lowpan_dev *entry, *new_dev;
+	struct lowpan_dev *entry, *tmp, *new_dev;
 	struct list_head devices;
 
 	INIT_LIST_HEAD(&devices);
@@ -1408,7 +1408,7 @@ static void disconnect_devices(void)
 
 	rcu_read_unlock();
 
-	list_for_each_entry(entry, &devices, list) {
+	list_for_each_entry_safe(entry, tmp, &devices, list) {
 		ifdown(entry->netdev);
 		BT_DBG("Unregistering netdev %s %p",
 		       entry->netdev->name, entry->netdev);
