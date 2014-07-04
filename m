Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbaGDXIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 19:08:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760345AbaGDWPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:15:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.15 19/66] RDMA/cxgb4: Fix memory leaks in c4iw_alloc() error paths
Date: Fri,  4 Jul 2014 15:14:18 -0700
Message-Id: <20140704221423.700948218@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Jaeger <christophjaeger@linux.com>

commit 65b302ad31b02b0790417f4e65833af494cb35ce upstream.

c4iw_alloc() bails out without freeing the storage that 'devp' points to.

Picked up by Coverity - CID 1204241.

Fixes: fa658a98a2 ("RDMA/cxgb4: Use the BAR2/WC path for kernel QPs and T5 devices")
Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
Acked-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/cxgb4/device.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -736,6 +736,7 @@ static struct c4iw_dev *c4iw_alloc(const
 			pci_resource_len(devp->rdev.lldi.pdev, 2));
 		if (!devp->rdev.bar2_kva) {
 			pr_err(MOD "Unable to ioremap BAR2\n");
+			ib_dealloc_device(&devp->ibdev);
 			return ERR_PTR(-EINVAL);
 		}
 	} else if (ocqp_supported(infop)) {
@@ -747,6 +748,7 @@ static struct c4iw_dev *c4iw_alloc(const
 			devp->rdev.lldi.vr->ocq.size);
 		if (!devp->rdev.oc_mw_kva) {
 			pr_err(MOD "Unable to ioremap onchip mem\n");
+			ib_dealloc_device(&devp->ibdev);
 			return ERR_PTR(-EINVAL);
 		}
 	}


