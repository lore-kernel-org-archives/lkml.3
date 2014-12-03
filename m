Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaLCO0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:26:50 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42707 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaLCO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:26:49 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: oded.gabbay@amd.com
Cc: airlied@linux.ie, alexander.deucher@amd.com, j.glisse@gmail.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John.Bridgman@amd.com, Andrew.Lewycky@amd.com, joro@8bytes.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] amdkfd: use sizeof(long) granularity for the pasid bitmask
Date: Wed,  3 Dec 2014 09:26:25 -0500
Message-Id: <1417616785-5143-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the bit operations (such as find_first_zero_bit()) read sizeof(long) bytes
at a time. If we allocated less than sizeof(long) bytes for the bitmask we
would be accessing invalid memory when working with the bitmask.

Change the allocator to allocate sizeof(long) multiples for the bitmask.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_pasid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c b/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
index 2458ab7..71699ad 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_pasid.c
@@ -32,8 +32,7 @@ int kfd_pasid_init(void)
 {
 	pasid_limit = max_num_of_processes;
 
-	pasid_bitmap = kzalloc(DIV_ROUND_UP(pasid_limit, BITS_PER_BYTE),
-				GFP_KERNEL);
+	pasid_bitmap = kzalloc(BITS_TO_LONGS(pasid_limit), GFP_KERNEL);
 	if (!pasid_bitmap)
 		return -ENOMEM;
 
-- 
2.1.0

