Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaGJV67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:58:59 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48660 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbaGJV5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:57:33 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 78/83] hsa/radeon: Don't verify cksum when parsing CRAT table
Date: Fri, 11 Jul 2014 00:54:34 +0300
Message-Id: <1405029279-6894-50-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the checksum verification done when
parsing a CRAT table. The verification was both erronous and
redundant, as it is done by another piece of kernel code.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_topology.c | 29 ++---------------------------
 1 file changed, 2 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/hsa/radeon/kfd_topology.c b/drivers/gpu/hsa/radeon/kfd_topology.c
index d3aaad1..b686b7e 100644
--- a/drivers/gpu/hsa/radeon/kfd_topology.c
+++ b/drivers/gpu/hsa/radeon/kfd_topology.c
@@ -38,21 +38,6 @@ static struct kfd_system_properties sys_props;
 
 static DECLARE_RWSEM(topology_lock);
 
-
-static uint8_t checksum_image(const void *buf, size_t len)
-{
-	uint8_t *p = (uint8_t *)buf;
-	uint8_t sum = 0;
-
-	if (!buf)
-		return 0;
-
-	while (len-- > 0)
-		sum += *p++;
-
-	return sum;
-		}
-
 struct kfd_dev *radeon_kfd_device_by_id(uint32_t gpu_id)
 {
 	struct kfd_topology_device *top_dev;
@@ -97,9 +82,9 @@ static int kfd_topology_get_crat_acpi(void *crat_image, size_t *size)
 	if (!size)
 		return -EINVAL;
 
-/*
+	/*
 	 * Fetch the CRAT table from ACPI
- */
+	 */
 	status = acpi_get_table(CRAT_SIGNATURE, 0, &crat_table);
 	if (status == AE_NOT_FOUND) {
 		pr_warn("CRAT table not found\n");
@@ -111,16 +96,6 @@ static int kfd_topology_get_crat_acpi(void *crat_image, size_t *size)
 		return -EINVAL;
 	}
 
-	/*
-	 * The checksum of the table should be verified
-	 */
-	if (checksum_image(crat_table, crat_table->length) ==
-		crat_table->checksum) {
-		pr_err("Bad checksum for the CRAT table\n");
-		return -EINVAL;
-}
-
-
 	if (*size >= crat_table->length && crat_image != 0)
 		memcpy(crat_image, crat_table, crat_table->length);
 
-- 
1.9.1

