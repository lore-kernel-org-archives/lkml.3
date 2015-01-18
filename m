Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbbARCFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 21:05:18 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46505 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbbARCE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 21:04:58 -0500
From: mathieu.poirier@linaro.org
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 3/4] staging: vt6655: fix wrong parameter as reported by sparse
Date: Sat, 17 Jan 2015 19:04:25 -0700
Message-Id: <1421546666-21461-4-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
References: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

mpoirier@t430:~/work/kernel1$ make C=1 M=drivers/staging/vt6655/
  LD      drivers/staging/vt6655/built-in.o
  CHECK   drivers/staging/vt6655/device_main.c
  CC [M]  drivers/staging/vt6655/device_main.o
  CHECK   drivers/staging/vt6655/card.c
  CC [M]  drivers/staging/vt6655/card.o
  CHECK   drivers/staging/vt6655/channel.c
  CC [M]  drivers/staging/vt6655/channel.o
  CHECK   drivers/staging/vt6655/mac.c
  CC [M]  drivers/staging/vt6655/mac.o
  CHECK   drivers/staging/vt6655/baseband.c
drivers/staging/vt6655/baseband.c:2180:45: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/baseband.c:2180:45:    expected struct vnt_private *priv
drivers/staging/vt6655/baseband.c:2180:45:    got void [noderef] <asn:2>*dwIoBase
  CC [M]  drivers/staging/vt6655/baseband.o

Since
8e8a9f5133cf staging: vt6655: BBbReadEmbedded replace __iomem with vnt_private

The first parameter to @BBbReadEmbedde is a vnt_private.  The patch is changing
all occurences _except_ this one, as reported by sparse.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/staging/vt6655/baseband.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 86c72ba0a0cd..f8c5fc371c4c 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -2177,7 +2177,7 @@ bool BBbVT3253Init(struct vnt_private *priv)
 		/* Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted) */
 		/*bResult &= BBbWriteEmbedded(dwIoBase,0x0a,0x28);*/
 		/* Select VC1/VC2, CR215 = 0x02->0x06 */
-		bResult &= BBbWriteEmbedded(dwIoBase, 0xd7, 0x06);
+		bResult &= BBbWriteEmbedded(priv, 0xd7, 0x06);
 		/* }} */
 
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
-- 
1.9.1

