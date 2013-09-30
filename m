Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3I3KYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:24:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3I3KM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 065/104] drm/radeon: fix endian bugs in hw i2c atom routines
Date: Mon, 30 Sep 2013 11:10:42 +0100
Message-Id: <1380535881-9239-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 4543eda52113d1e2cc0e9bf416f79597e6ef1ec7 upstream.

Need to swap the data fetched over i2c properly.  This
is the same fix as the endian fix for aux channel
transactions.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_dp.c  | 6 +++---
 drivers/gpu/drm/radeon/atombios_i2c.c | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/radeon/atombios_dp.c
index 824d03c..a672379 100644
--- a/drivers/gpu/drm/radeon/atombios_dp.c
+++ b/drivers/gpu/drm/radeon/atombios_dp.c
@@ -51,7 +51,7 @@ static char *pre_emph_names[] = {
  * or from atom. Note that atom operates on
  * dw units.
  */
-static void radeon_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le)
+void radeon_atom_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le)
 {
 #ifdef __BIG_ENDIAN
 	u8 src_tmp[20], dst_tmp[20]; /* used for byteswapping */
@@ -101,7 +101,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 
 	base = (unsigned char *)(rdev->mode_info.atom_context->scratch + 1);
 
-	radeon_copy_swap(base, send, send_bytes, true);
+	radeon_atom_copy_swap(base, send, send_bytes, true);
 
 	args.v1.lpAuxRequest = cpu_to_le16((u16)(0 + 4));
 	args.v1.lpDataOut = cpu_to_le16((u16)(16 + 4));
@@ -138,7 +138,7 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan *chan,
 		recv_bytes = recv_size;
 
 	if (recv && recv_size)
-		radeon_copy_swap(recv, base + 16, recv_bytes, false);
+		radeon_atom_copy_swap(recv, base + 16, recv_bytes, false);
 
 	return recv_bytes;
 }
diff --git a/drivers/gpu/drm/radeon/atombios_i2c.c b/drivers/gpu/drm/radeon/atombios_i2c.c
index 44d87b6..9ed94a8 100644
--- a/drivers/gpu/drm/radeon/atombios_i2c.c
+++ b/drivers/gpu/drm/radeon/atombios_i2c.c
@@ -27,6 +27,8 @@
 #include "radeon.h"
 #include "atom.h"
 
+extern void radeon_atom_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le);
+
 #define TARGET_HW_I2C_CLOCK 50
 
 /* these are a limitation of ProcessI2cChannelTransaction not the hw */
@@ -77,7 +79,7 @@ static int radeon_process_i2c_ch(struct radeon_i2c_chan *chan,
 	}
 
 	if (!(flags & HW_I2C_WRITE))
-		memcpy(buf, base, num);
+		radeon_atom_copy_swap(buf, base, num, false);
 
 	return 0;
 }
-- 
1.8.3.2

