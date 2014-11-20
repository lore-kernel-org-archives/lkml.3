Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbaKTLZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:25:35 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:57098 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKTLZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:25:33 -0500
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Alex Williamson <alex.williamson@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Zefan Li <lizefan@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        "Tianhong Ding" <dingtianhong@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] vfio: put off the allocation of "minor" in vfio_create_group
Date: Thu, 20 Nov 2014 19:25:02 +0800
Message-ID: <1416482702-10820-1-git-send-email-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 1.8.4.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.142]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.546DCFA9.0168,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: bb8afcf09c407c032735d983d62b5599
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next code fragment "list_for_each_entry" is not depend on "minor". With this
patch, the free of "minor" in "list_for_each_entry" can be reduced, and there is
no functional change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/vfio/vfio.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index f018d8d..737eb468 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -225,22 +225,21 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group)

 	mutex_lock(&vfio.group_lock);

-	minor = vfio_alloc_group_minor(group);
-	if (minor < 0) {
-		vfio_group_unlock_and_free(group);
-		return ERR_PTR(minor);
-	}
-
 	/* Did we race creating this group? */
 	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
 		if (tmp->iommu_group == iommu_group) {
 			vfio_group_get(tmp);
-			vfio_free_group_minor(minor);
 			vfio_group_unlock_and_free(group);
 			return tmp;
 		}
 	}

+	minor = vfio_alloc_group_minor(group);
+	if (minor < 0) {
+		vfio_group_unlock_and_free(group);
+		return ERR_PTR(minor);
+	}
+
 	dev = device_create(vfio.class, NULL,
 			    MKDEV(MAJOR(vfio.group_devt), minor),
 			    group, "%d", iommu_group_id(iommu_group));
--
1.8.0


