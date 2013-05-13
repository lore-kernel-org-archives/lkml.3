Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3EMNvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:51:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:9891 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3EMNvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:51:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="336297945"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, "Busch, Keith" <keith.busch@intel.com>,
        "Verma, Vishal L" <vishal.l.verma@intel.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] NVMe: fix error return code in nvme_submit_bio_queue()
Thread-Topic: [PATCH] NVMe: fix error return code in nvme_submit_bio_queue()
Thread-Index: AQHOT4HVlyKRpFMiukG3G7z3tanC65kDIr1L
Date: Mon, 13 May 2013 13:51:37 +0000
Message-ID: <100D68C7BA14664A8938383216E40DE027F80EA1@fmsmsx111.amr.corp.intel.com>
References: <CAPgLHd9dfox_xSu3Fb2JD_=UPC=-PVs=juiv3k408D1ns2CVJQ@mail.gmail.com>
In-Reply-To: <CAPgLHd9dfox_xSu3Fb2JD_=UPC=-PVs=juiv3k408D1ns2CVJQ@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-CA
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't apply this patch.  Instead of following what it says in MAINTAINERS, you've sent it to my Exchange address.  And now it's all mangled.

NVM EXPRESS DRIVER
M:      Matthew Wilcox <willy@linux.intel.com>
L:      linux-nvme@lists.infradead.org

________________________________________
From: Wei Yongjun [weiyj.lk@gmail.com]
Sent: May 12, 2013 7:30 PM
To: Wilcox, Matthew R; Busch, Keith; Verma, Vishal L
Cc: yongjun_wei@trendmicro.com.cn; linux-kernel@vger.kernel.org
Subject: [PATCH] NVMe: fix error return code in nvme_submit_bio_queue()

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the nvem iod alloc error handling case instead
of 0(possible overwrite to 0 by above nvme_submit_flush_data()), as done
elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/nvme-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 8efdfaa..750c337 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -629,7 +629,7 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
        struct nvme_command *cmnd;
        struct nvme_iod *iod;
        enum dma_data_direction dma_dir;
-       int cmdid, length, result = -ENOMEM;
+       int cmdid, length, result;
        u16 control;
        u32 dsmgmt;
        int psegs = bio_phys_segments(ns->queue, bio);
@@ -641,8 +641,10 @@ static int nvme_submit_bio_queue(struct nvme_queue *nvmeq, struct nvme_ns *ns,
        }

        iod = nvme_alloc_iod(psegs, bio->bi_size, GFP_ATOMIC);
-       if (!iod)
+       if (!iod) {
+               result = -ENOMEM;
                goto nomem;
+       }
        iod->private = bio;

        result = -EBUSY;

