Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3KTSYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:24:03 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:62494 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab3KTSX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:23:58 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, patches@linaro.org,
        linaro-networking@linaro.org, linaro-kernel@lists.linaro.org,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: davinci: raw read and write endian fix
Date: Wed, 20 Nov 2013 20:23:44 +0200
Message-Id: <1384971824-7707-1-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I2C IP block expect LE data, but CPU may operate in BE mode.
Need to use endian neutral functions to read/write h/w registers.
I.e instead of __raw_read[lw] and __raw_write[lw] functions code
need to use read[lw]_relaxed and write[lw]_relaxed functions.
If the first simply reads/writes register, the second will byteswap
it if host operates in BE mode.

Changes are trivial sed like replacement of __raw_xxx functions
with xxx_relaxed variant.

Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
Based on Linus' master tip (b4789b8).
Tested on Keystone2 EVM.

 drivers/i2c/busses/i2c-davinci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 132369f..a629447 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -125,12 +125,12 @@ static struct davinci_i2c_platform_data davinci_i2c_platform_data_default = {
 static inline void davinci_i2c_write_reg(struct davinci_i2c_dev *i2c_dev,
 					 int reg, u16 val)
 {
-	__raw_writew(val, i2c_dev->base + reg);
+	writew_relaxed(val, i2c_dev->base + reg);
 }
 
 static inline u16 davinci_i2c_read_reg(struct davinci_i2c_dev *i2c_dev, int reg)
 {
-	return __raw_readw(i2c_dev->base + reg);
+	return readw_relaxed(i2c_dev->base + reg);
 }
 
 /* Generate a pulse on the i2c clock pin. */
-- 
1.7.9.5

