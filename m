Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3HPWfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:35:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51350 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3HPWfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:35:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>, Dong He <hedonghust@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 015/133] drm/radeon: fix endian issues with DP handling (v3)
Date: Fri, 16 Aug 2013 15:32:37 -0700
Message-Id: <1376692475-28413-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 34be8c9af7b8728465963740fc11136ae90dfc36 upstream.

The atom interpreter expects data in LE format, so
swap the message buffer as apprioriate.

v2: properly handle non-dw aligned byte counts.
v3: properly handle remainder

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Dong He <hedonghust@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_dp.c | 43 ++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 064023b..32501f6 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -44,6 +44,41 @@ static char *pre_emph_names[] = {
 };
 
 /***** radeon AUX functions *****/
+
+/* Atom needs data in little endian format
+ * so swap as appropriate when copying data to
+ * or from atom. Note that atom operates on
+ * dw units.
+ */
+static void radeon_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le)
+{
+#ifdef __BIG_ENDIAN
+	u8 src_tmp[20], dst_tmp[20]; /* used for byteswapping */
+	u32 *dst32, *src32;
+	int i;
+
+	memcpy(src_tmp, src, num_bytes);
+	src32 = (u32 *)src_tmp;
+	dst32 = (u32 *)dst_tmp;
+	if (to_le) {
+		for (i = 0; i < ((num_bytes + 3) / 4); i++)
+			dst32[i] = cpu_to_le32(src32[i]);
+		memcpy(dst, dst_tmp, num_bytes);
+	} else {
+		u8 dws = num_bytes & ~3;
+		for (i = 0; i < ((num_bytes + 3) / 4); i++)
+			dst32[i] = le32_to_cpu(src32[i]);
+		memcpy(dst, dst_tmp, dws);
+		if (num_bytes % 4) {
+			for (i = 0; i < (num_bytes % 4); i++)
+				dst[dws+i] = dst_tmp[dws+i];
+		}
+	}
+#else
+	memcpy(dst, src, num_bytes);
+#endif
+}
+
 union aux_channel_transaction {
 	PROCESS_AUX_CHANNEL_TRANSACTION_PS_ALLOCATION v1;
 	PROCESS_AUX_CHANNEL_TRANSACTION_PARAMETERS_V2 v2;
@@ -65,10 +100,10 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 
 	base = (unsigned char *)(rdev->mode_info.atom_context->scratch + 1);
 
-	memcpy(base, send, send_bytes);
+	radeon_copy_swap(base, send, send_bytes, true);
 
-	args.v1.lpAuxRequest = 0 + 4;
-	args.v1.lpDataOut = 16 + 4;
+	args.v1.lpAuxRequest = cpu_to_le16((u16)(0 + 4));
+	args.v1.lpDataOut = cpu_to_le16((u16)(16 + 4));
 	args.v1.ucDataOutLen = 0;
 	args.v1.ucChannelID = chan->rec.i2c_id;
 	args.v1.ucDelay = delay / 10;
@@ -102,7 +137,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 		recv_bytes = recv_size;
 
 	if (recv && recv_size)
-		memcpy(recv, base + 16, recv_bytes);
+		radeon_copy_swap(recv, base + 16, recv_bytes, false);
 
 	return recv_bytes;
 }
-- 
1.8.1.2

