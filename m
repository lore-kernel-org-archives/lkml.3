Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3JUIvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39393 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753376Ab3JUIvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.872497273@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 046/149] drm/radeon: fix handling of variable sized
 arrays for router objects
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -709,13 +709,16 @@ bool radeon_get_atom_connector_info_from
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
 

