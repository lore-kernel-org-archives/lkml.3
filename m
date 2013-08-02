Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3HBKTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:19:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3HBKTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:19:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Dong He <hedonghust@gmail.com>
Subject: [ 25/39] drm/radeon: fix endian issues with DP handling (v3)
Date: Fri,  2 Aug 2013 18:18:35 +0800
Message-Id: <20130802101500.384366002@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 34be8c9af7b8728465963740fc11136ae90dfc36 upstream.

The atom interpreter expects data in LE format, so
swap the message buffer as apprioriate.

v2: properly handle non-dw aligned byte counts.
v3: properly handle remainder

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Dong He <hedonghust@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_dp.c |   43 +++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

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
@@ -66,10 +101,10 @@ static int radeon_process_aux_ch(struct
 
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
@@ -103,7 +138,7 @@ static int radeon_process_aux_ch(struct
 		recv_bytes = recv_size;
 
 	if (recv && recv_size)
-		memcpy(recv, base + 16, recv_bytes);
+		radeon_copy_swap(recv, base + 16, recv_bytes, false);
 
 	return recv_bytes;
 }


