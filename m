Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab3ITUO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41603 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3ITUOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 51/93] drm/radeon: fix handling of variable sized arrays for router objects
Date: Fri, 20 Sep 2013 13:08:46 -0700
Message-Id: <1379707768-1804-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit fb93df1c2d8b3b1fb16d6ee9e32554e0c038815d upstream.

The table has the following format:

typedef struct _ATOM_SRC_DST_TABLE_FOR_ONE_OBJECT         //usSrcDstTableOffset pointing to this structure
{
  UCHAR               ucNumberOfSrc;
  USHORT              usSrcObjectID[1];
  UCHAR               ucNumberOfDst;
  USHORT              usDstObjectID[1];
}ATOM_SRC_DST_TABLE_FOR_ONE_OBJECT;

usSrcObjectID[] and usDstObjectID[] are variably sized, so we
can't access them directly.  Use pointers and update the offset
appropriately when accessing the Dst members.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 1105876..6048f2b 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -715,13 +715,16 @@ bool radeon_get_atom_connector_info_from_object_table(struct drm_device *dev)
 								(ATOM_SRC_DST_TABLE_FOR_ONE_OBJECT *)
 								(ctx->bios + data_offset +
 								 le16_to_cpu(router_obj->asObjects[k].usSrcDstTableOffset));
+							u8 *num_dst_objs = (u8 *)
+								((u8 *)router_src_dst_table + 1 +
+								 (router_src_dst_table->ucNumberOfSrc * 2));
+							u16 *dst_objs = (u16 *)(num_dst_objs + 1);
 							int enum_id;
 
 							router.router_id = router_obj_id;
-							for (enum_id = 0; enum_id < router_src_dst_table->ucNumberOfDst;
-							     enum_id++) {
+							for (enum_id = 0; enum_id < (*num_dst_objs); enum_id++) {
 								if (le16_to_cpu(path->usConnObjectId) ==
-								    le16_to_cpu(router_src_dst_table->usDstObjectID[enum_id]))
+								    le16_to_cpu(dst_objs[enum_id]))
 									break;
 							}
 
-- 
1.8.1.2

