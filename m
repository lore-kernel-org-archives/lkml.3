Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3I2T2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:28:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3I2T2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 31/49] drm/radeon: fix handling of variable sized arrays for router objects
Date: Sun, 29 Sep 2013 12:27:05 -0700
Message-Id: <20130929191605.123906721@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -715,13 +715,16 @@ bool radeon_get_atom_connector_info_from
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
 


