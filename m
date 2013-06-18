Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab3FRQWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:22:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933266Ab3FRQSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:01 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Gerhard=20Br=C3=A4unlich?= <wippbox@gmx.net>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 32/48] drm/nv50/disp: force dac power state during load detect
Date: Tue, 18 Jun 2013 09:17:58 -0700
Message-Id: <20130618161730.543655939@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit ea9197cc323839ef3d5280c0453b2c622caa6bc7 upstream.

fdo#64904

Reported-by: Gerhard Bräunlich <wippbox@gmx.net>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

---
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |    4 ++++
 drivers/gpu/drm/nouveau/core/include/core/class.h  |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
@@ -50,11 +50,15 @@ nv50_dac_sense(struct nv50_disp_priv *pr
 {
 	const u32 doff = (or * 0x800);
 	int load = -EINVAL;
+	nv_mask(priv, 0x61a004 + doff, 0x807f0000, 0x80150000);
+	nv_wait(priv, 0x61a004 + doff, 0x80000000, 0x00000000);
 	nv_wr32(priv, 0x61a00c + doff, 0x00100000 | loadval);
 	udelay(9500);
 	nv_wr32(priv, 0x61a00c + doff, 0x80000000);
 	load = (nv_rd32(priv, 0x61a00c + doff) & 0x38000000) >> 27;
 	nv_wr32(priv, 0x61a00c + doff, 0x00000000);
+	nv_mask(priv, 0x61a004 + doff, 0x807f0000, 0x80550000);
+	nv_wait(priv, 0x61a004 + doff, 0x80000000, 0x00000000);
 	return load;
 }
 
--- a/drivers/gpu/drm/nouveau/core/include/core/class.h
+++ b/drivers/gpu/drm/nouveau/core/include/core/class.h
@@ -216,7 +216,7 @@ struct nv04_display_class {
 #define NV50_DISP_DAC_PWR_STATE                                      0x00000040
 #define NV50_DISP_DAC_PWR_STATE_ON                                   0x00000000
 #define NV50_DISP_DAC_PWR_STATE_OFF                                  0x00000040
-#define NV50_DISP_DAC_LOAD                                           0x0002000c
+#define NV50_DISP_DAC_LOAD                                           0x00020100
 #define NV50_DISP_DAC_LOAD_VALUE                                     0x00000007
 
 #define NV50_DISP_PIOR_MTHD                                          0x00030000


