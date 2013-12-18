Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3LRVb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:31:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3LRVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 066/118] drm/radeon/atom: fix bus probes when hw_i2c is set (v2)
Date: Wed, 18 Dec 2013 13:11:43 -0800
Message-Id: <20131218211221.325294171@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ffd3d3361d583cb73fa65a5fed3a196ba6f261bb upstream.

When probing the bus, we need to set the byte count
to 0 rather than 1.

v2: Don't count the first byte.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=66241

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_i2c.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_i2c.c
+++ b/drivers/gpu/drm/radeon/atombios_i2c.c
@@ -44,7 +44,7 @@ static int radeon_process_i2c_ch(struct
 	PROCESS_I2C_CHANNEL_TRANSACTION_PS_ALLOCATION args;
 	int index = GetIndexIntoMasterTable(COMMAND, ProcessI2cChannelTransaction);
 	unsigned char *base;
-	u16 out;
+	u16 out = cpu_to_le16(0);
 
 	memset(&args, 0, sizeof(args));
 
@@ -55,11 +55,14 @@ static int radeon_process_i2c_ch(struct
 			DRM_ERROR("hw i2c: tried to write too many bytes (%d vs 3)\n", num);
 			return -EINVAL;
 		}
-		args.ucRegIndex = buf[0];
-		if (num > 1) {
+		if (buf == NULL)
+			args.ucRegIndex = 0;
+		else
+			args.ucRegIndex = buf[0];
+		if (num)
 			num--;
+		if (num)
 			memcpy(&out, &buf[1], num);
-		}
 		args.lpI2CDataOut = cpu_to_le16(out);
 	} else {
 		if (num > ATOM_MAX_HW_I2C_READ) {
@@ -96,14 +99,14 @@ int radeon_atom_hw_i2c_xfer(struct i2c_a
 	struct radeon_i2c_chan *i2c = i2c_get_adapdata(i2c_adap);
 	struct i2c_msg *p;
 	int i, remaining, current_count, buffer_offset, max_bytes, ret;
-	u8 buf = 0, flags;
+	u8 flags;
 
 	/* check for bus probe */
 	p = &msgs[0];
 	if ((num == 1) && (p->len == 0)) {
 		ret = radeon_process_i2c_ch(i2c,
 					    p->addr, HW_I2C_WRITE,
-					    &buf, 1);
+					    NULL, 0);
 		if (ret)
 			return ret;
 		else


