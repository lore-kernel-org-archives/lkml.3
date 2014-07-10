Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaGJVwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:52:30 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:55702 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbaGJVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:52:25 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 25/83] hsa/radeon: fix the OEMID assignment in kfd_topology
Date: Fri, 11 Jul 2014 00:50:25 +0300
Message-Id: <1405029027-6085-24-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

The assignment of OEMID from the CRAT table is into a 64 variable. The OEMID is 48bit wide in the CRAT.
This fix makes sure that only 48bit are assigned for the OEMID value from the CRAT table.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_crat.h     | 2 ++
 drivers/gpu/hsa/radeon/kfd_topology.c | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_crat.h b/drivers/gpu/hsa/radeon/kfd_crat.h
index 587455d..a374fa3 100644
--- a/drivers/gpu/hsa/radeon/kfd_crat.h
+++ b/drivers/gpu/hsa/radeon/kfd_crat.h
@@ -42,6 +42,8 @@
 #define CRAT_OEMTABLEID_LENGTH	8
 #define CRAT_RESERVED_LENGTH	6
 
+#define CRAT_OEMID_64BIT_MASK ((1ULL << (CRAT_OEMID_LENGTH * 8)) - 1)
+
 struct crat_header {
 	uint32_t	signature;
 	uint32_t	length;
diff --git a/drivers/gpu/hsa/radeon/kfd_topology.c b/drivers/gpu/hsa/radeon/kfd_topology.c
index 6acac25..2ee5444 100644
--- a/drivers/gpu/hsa/radeon/kfd_topology.c
+++ b/drivers/gpu/hsa/radeon/kfd_topology.c
@@ -467,10 +467,10 @@ static int kfd_parse_crat_table(void *crat_image)
 		if (!top_dev) {
 			kfd_release_live_view();
 			return -ENOMEM;
+		}
 	}
-}
 
-	sys_props.platform_id = *((uint64_t *)crat_table->oem_id);
+	sys_props.platform_id = (*((uint64_t *)crat_table->oem_id)) & CRAT_OEMID_64BIT_MASK;
 	sys_props.platform_oem = *((uint64_t *)crat_table->oem_table_id);
 	sys_props.platform_rev = crat_table->revision;
 
-- 
1.9.1

