Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3LSMSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:18:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45173 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3LSL67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 154/208] drm/radeon: atombios hw i2c fixes
Date: Thu, 19 Dec 2013 11:54:12 +0000
Message-Id: <1387454106-19326-155-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d1e3b5564834ea24dee6b364a172365f64865fe5 upstream.

These fixes make writes work properly.  Previously
only reads worked.  Note that this feature is off
by default.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: 3.11.y prereq for:
  - ffd3d336 drm/radeon/atom: fix bus probes when hw_i2c is set (v2) ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atombios_i2c.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_i2c.c b/drivers/gpu/drm/radeon/atombios_i2c.c
index 2ca389d..deaf98c 100644
--- a/drivers/gpu/drm/radeon/atombios_i2c.c
+++ b/drivers/gpu/drm/radeon/atombios_i2c.c
@@ -32,7 +32,7 @@ extern void radeon_atom_copy_swap(u8 *dst, u8 *src, u8 num_bytes, bool to_le);
 #define TARGET_HW_I2C_CLOCK 50
 
 /* these are a limitation of ProcessI2cChannelTransaction not the hw */
-#define ATOM_MAX_HW_I2C_WRITE 2
+#define ATOM_MAX_HW_I2C_WRITE 3
 #define ATOM_MAX_HW_I2C_READ  255
 
 static int radeon_process_i2c_ch(struct radeon_i2c_chan *chan,
@@ -52,20 +52,24 @@ static int radeon_process_i2c_ch(struct radeon_i2c_chan *chan,
 
 	if (flags & HW_I2C_WRITE) {
 		if (num > ATOM_MAX_HW_I2C_WRITE) {
-			DRM_ERROR("hw i2c: tried to write too many bytes (%d vs 2)\n", num);
+			DRM_ERROR("hw i2c: tried to write too many bytes (%d vs 3)\n", num);
 			return -EINVAL;
 		}
-		memcpy(&out, buf, num);
+		args.ucRegIndex = buf[0];
+		if (num > 1)
+			memcpy(&out, &buf[1], num - 1);
 		args.lpI2CDataOut = cpu_to_le16(out);
 	} else {
 		if (num > ATOM_MAX_HW_I2C_READ) {
 			DRM_ERROR("hw i2c: tried to read too many bytes (%d vs 255)\n", num);
 			return -EINVAL;
 		}
+		args.ucRegIndex = 0;
+		args.lpI2CDataOut = 0;
 	}
 
+	args.ucFlag = flags;
 	args.ucI2CSpeed = TARGET_HW_I2C_CLOCK;
-	args.ucRegIndex = 0;
 	args.ucTransBytes = num;
 	args.ucSlaveAddr = slave_addr << 1;
 	args.ucLineNumber = chan->rec.i2c_id;
-- 
1.8.3.2

