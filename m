Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbbATPrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:47:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbbATPpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:45:18 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v3 1/3] Drivers: hv: check vmbus_device_create() return value in vmbus_process_offer()
Date: Tue, 20 Jan 2015 16:45:04 +0100
Message-Id: <1421768706-5363-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmbus_device_create() result is not being checked in vmbus_process_offer() and
it can fail if kzalloc() fails. Add the check and do minor cleanup to avoid
additional duplication of "free_channel(); return;" block.

Reported-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/channel_mgmt.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 2c59f03..01f2c2b 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -341,11 +341,10 @@ static void vmbus_process_offer(struct work_struct *work)
 			if (channel->sc_creation_callback != NULL)
 				channel->sc_creation_callback(newchannel);
 
-			return;
+			goto out;
 		}
 
-		free_channel(newchannel);
-		return;
+		goto err_free_chan;
 	}
 
 	/*
@@ -364,6 +363,8 @@ static void vmbus_process_offer(struct work_struct *work)
 		&newchannel->offermsg.offer.if_type,
 		&newchannel->offermsg.offer.if_instance,
 		newchannel);
+	if (!newchannel->device_obj)
+		goto err_free_chan;
 
 	/*
 	 * Add the new device to the bus. This will kick off device-driver
@@ -379,9 +380,12 @@ static void vmbus_process_offer(struct work_struct *work)
 		list_del(&newchannel->listentry);
 		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 		kfree(newchannel->device_obj);
-
-		free_channel(newchannel);
+		goto err_free_chan;
 	}
+out:
+	return;
+err_free_chan:
+	free_channel(newchannel);
 }
 
 enum {
-- 
1.9.3

