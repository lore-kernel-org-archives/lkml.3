Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3K0Ns0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:48:26 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:56874 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3K0NsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:48:23 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: omap: raw read and write endian fix
Date: Wed, 27 Nov 2013 15:48:08 +0200
Message-Id: <1385560088-22339-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131126124238.GC7427@katana>
References: <20131126124238.GC7427@katana>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Kamensky <victor.kamensky@linaro.org>

All OMAP IP blocks expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
Posting this as a saparate patch out of RFC series.
RFC: http://patchwork.ozlabs.org/patch/291726/
Only minor comment change is done since RFC patch.

Based on v3.13-rc1

 drivers/i2c/busses/i2c-omap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index d76228d..90dcc2e 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -266,13 +266,13 @@ static const u8 reg_map_ip_v2[] = {
 static inline void omap_i2c_write_reg(struct omap_i2c_dev *i2c_dev,
 				      int reg, u16 val)
 {
-	__raw_writew(val, i2c_dev->base +
+	writew_relaxed(val, i2c_dev->base +
 			(i2c_dev->regs[reg] << i2c_dev->reg_shift));
 }
 
 static inline u16 omap_i2c_read_reg(struct omap_i2c_dev *i2c_dev, int reg)
 {
-	return __raw_readw(i2c_dev->base +
+	return readw_relaxed(i2c_dev->base +
 				(i2c_dev->regs[reg] << i2c_dev->reg_shift));
 }
 
@@ -1162,9 +1162,9 @@ omap_i2c_probe(struct platform_device *pdev)
 	 * Read the Rev hi bit-[15:14] ie scheme this is 1 indicates ver2.
 	 * On omap1/3/2 Offset 4 is IE Reg the bit [15:14] is 0 at reset.
 	 * Also since the omap_i2c_read_reg uses reg_map_ip_* a
-	 * raw_readw is done.
+	 * readw_relaxed is done.
 	 */
-	rev = __raw_readw(dev->base + 0x04);
+	rev = readw_relaxed(dev->base + 0x04);
 
 	dev->scheme = OMAP_I2C_SCHEME(rev);
 	switch (dev->scheme) {
-- 
1.7.9.5

