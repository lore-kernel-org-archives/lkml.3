Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaHELFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 07:05:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546AbaHELFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 07:05:36 -0400
Date: Tue, 5 Aug 2014 13:05:32 +0200
From: Joerg Roedel <jroedel@suse.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] iommu/vt-d: Defer domain removal if device is assigned to a
 driver
Message-ID: <20140805110532.GB14913@suse.de>
References: <1407151386-16467-1-git-send-email-joro@8bytes.org>
 <20140804114205.GA5545@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804114205.GA5545@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 04, 2014 at 01:42:05PM +0200, Borislav Petkov wrote:
> It is always questionable when people remove BUG_ONs because relaxing
> assertions sound like a temporary fix more often than not. Sounds to me
> that the original commit which deals with BUS_NOTIFY_DEL_DEVICE needs to
> try again with the fix. :-)

Actually, as I thought about it again, there is a better fix for this
issue that does not require to remove the BUG_ON :) See attached patch:

>From 57e2519d5b6e4d8ee840a921300d201ff742c826 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Tue, 5 Aug 2014 12:55:45 +0200
Subject: [PATCH] iommu/vt-d: Defer domain removal if device is assigned to a
 driver

When the BUS_NOTIFY_DEL_DEVICE event is received the device
might still be attached to a driver. In this case the domain
can't be released as the mappings might still be in use.

Defer the domain removal in this case until we receivce the
BUS_NOTIFY_UNBOUND_DRIVER event.

Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org   # v3.15, v3.16
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d1f5caa..5619f26 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3869,6 +3869,14 @@ static int device_notifier(struct notifier_block *nb,
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
-- 
1.8.4.5

