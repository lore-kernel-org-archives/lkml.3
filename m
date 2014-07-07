Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaGHA6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:58:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaGGXyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Mingarelli <thomas.mingarelli@hp.com>,
        Linda Knippers <linda.knippers@hp.com>,
        Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3.15 088/122] iommu/vt-d: fix bug in handling multiple RMRRs for the same PCI device
Date: Mon,  7 Jul 2014 16:57:30 -0700
Message-Id: <20140707235736.895820719@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <jiang.liu@linux.intel.com>

commit 27e249501ca06a3010519c306206cc402b61b5ab upstream.

Function dmar_iommu_notify_scope_dev() makes a wrong assumption that
there's one RMRR for each PCI device at most, which causes DMA failure
on some HP platforms. So enhance dmar_iommu_notify_scope_dev() to
handle multiple RMRRs for the same PCI device.

Fixbug: https://bugzilla.novell.com/show_bug.cgi?id=879482

Reported-by: Tom Mingarelli <thomas.mingarelli@hp.com>
Tested-by: Linda Knippers <linda.knippers@hp.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3799,14 +3799,11 @@ int dmar_iommu_notify_scope_dev(struct d
 				((void *)rmrr) + rmrr->header.length,
 				rmrr->segment, rmrru->devices,
 				rmrru->devices_cnt);
-			if (ret > 0)
-				break;
-			else if(ret < 0)
+			if(ret < 0)
 				return ret;
 		} else if (info->event == BUS_NOTIFY_DEL_DEVICE) {
-			if (dmar_remove_dev_scope(info, rmrr->segment,
-				rmrru->devices, rmrru->devices_cnt))
-				break;
+			dmar_remove_dev_scope(info, rmrr->segment,
+				rmrru->devices, rmrru->devices_cnt);
 		}
 	}
 


