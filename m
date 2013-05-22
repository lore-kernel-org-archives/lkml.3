Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3EVWLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:11:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab3EVWKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: [ 20/21] NTB: Multiple NTB client fix
Date: Wed, 22 May 2013 15:10:38 -0700
Message-Id: <20130522205234.982721856@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Mason <jon.mason@intel.com>

commit 8b19d450ad188d402a183ff4a4d40f31c3916fbf upstream.

Fix issue with adding multiple ntb client devices to the ntb virtual
bus.  Previously, multiple devices would be added with the same name,
resulting in crashes.  To get around this issue, add a unique number to
the device when it is added.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_transport.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -300,7 +300,7 @@ int ntb_register_client_dev(char *device
 {
 	struct ntb_transport_client_dev *client_dev;
 	struct ntb_transport *nt;
-	int rc;
+	int rc, i = 0;
 
 	if (list_empty(&ntb_transport_list))
 		return -ENODEV;
@@ -318,7 +318,7 @@ int ntb_register_client_dev(char *device
 		dev = &client_dev->dev;
 
 		/* setup and register client devices */
-		dev_set_name(dev, "%s", device_name);
+		dev_set_name(dev, "%s%d", device_name, i);
 		dev->bus = &ntb_bus_type;
 		dev->release = ntb_client_release;
 		dev->parent = &ntb_query_pdev(nt->ndev)->dev;
@@ -330,6 +330,7 @@ int ntb_register_client_dev(char *device
 		}
 
 		list_add_tail(&client_dev->entry, &nt->client_devs);
+		i++;
 	}
 
 	return 0;


