Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3IKFXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:23:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3IKE51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:27 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=khyODgoyewwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iNMsibccEXMA:10 a=zd2uoN0lAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=wu_e27o_rKQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=aorlVPonjIq9gQjV:21 a=fCNQTF9U6W4P9zzK:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042910.442433441@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>, Dong He <hedonghust@gmail.com>
Subject: [109/251] drm/radeon: fix endian issues with DP handling (v3)
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0109-drm-radeon-fix-endian-issues-with-DP-handling-v3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 34be8c9af7b8728465963740fc11136ae90dfc36 ]

The atom interpreter expects data in LE format, so
swap the message buffer as apprioriate.

v2: properly handle non-dw aligned byte counts.
v3: properly handle remainder

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Dong He <hedonghust@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/atombios_dp.c |   43 ++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 3623b98..a0b5e1e 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -45,6 +45,41 @@ static char *pre_emph_names[] = {
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
@@ -66,10 +101,10 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 
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
@@ -103,7 +138,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 		recv_bytes = recv_size;
 
 	if (recv && recv_size)
-		memcpy(recv, base + 16, recv_bytes);
+		radeon_copy_swap(recv, base + 16, recv_bytes, false);
 
 	return recv_bytes;
 }
-- 
1.7.10.4


