Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaIOT06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:26:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbaIOT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3.16 013/158] iommu/vt-d: Defer domain removal if device is assigned to a driver
Date: Mon, 15 Sep 2014 12:24:12 -0700
Message-Id: <20140915192543.280737055@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <jroedel@suse.de>

commit e7f9fa5498d91fcdc63d93007ba43f36b1a30538 upstream.

When the BUS_NOTIFY_DEL_DEVICE event is received the device
might still be attached to a driver. In this case the domain
can't be released as the mappings might still be in use.

Defer the domain removal in this case until we receivce the
BUS_NOTIFY_UNBOUND_DRIVER event.

Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3891,6 +3891,14 @@ static int device_notifier(struct notifi
 	    action != BUS_NOTIFY_DEL_DEVICE)
 		return 0;
 
+	/*
+	 * If the device is still attached to a device driver we can't
+	 * tear down the domain yet as DMA mappings may still be in use.
+	 * Wait for the BUS_NOTIFY_UNBOUND_DRIVER event to do that.
+	 */
+	if (action == BUS_NOTIFY_DEL_DEVICE && dev->driver != NULL)
+		return 0;
+
 	domain = find_domain(dev);
 	if (!domain)
 		return 0;


