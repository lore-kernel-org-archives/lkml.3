Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab3I2Tax (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:30:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3I2TaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:30:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Peres <martin.peres@labri.fr>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 32/71] drm/nv50/disp: prevent false output detection on the original nv50
Date: Sun, 29 Sep 2013 12:27:44 -0700
Message-Id: <20130929192645.702231908@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Velikov <emil.l.velikov@gmail.com>

commit 5087f51da805f53cba7366f70d596e7bde2a5486 upstream.

Commit ea9197cc323839ef3d5280c0453b2c622caa6bc7 effectively enabled the
use of an improved DAC detection code, but introduced a regression on
the original nv50 chipset, causing a ghost monitor to be detected.

v2 (Ben Skeggs): the offending line was likely a thinko, removed it for
all chipsets (tested nv50 and nve6 to cover entire range) and added
some additional debugging.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=67382
Tested-by: Martin Peres <martin.peres@labri.fr>
Signed-off-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/dacnv50.c
@@ -49,18 +49,23 @@ int
 nv50_dac_sense(struct nv50_disp_priv *priv, int or, u32 loadval)
 {
 	const u32 doff = (or * 0x800);
-	int load = -EINVAL;
+
 	nv_mask(priv, 0x61a004 + doff, 0x807f0000, 0x80150000);
 	nv_wait(priv, 0x61a004 + doff, 0x80000000, 0x00000000);
+
 	nv_wr32(priv, 0x61a00c + doff, 0x00100000 | loadval);
 	mdelay(9);
 	udelay(500);
-	nv_wr32(priv, 0x61a00c + doff, 0x80000000);
-	load = (nv_rd32(priv, 0x61a00c + doff) & 0x38000000) >> 27;
-	nv_wr32(priv, 0x61a00c + doff, 0x00000000);
+	loadval = nv_mask(priv, 0x61a00c + doff, 0xffffffff, 0x00000000);
+
 	nv_mask(priv, 0x61a004 + doff, 0x807f0000, 0x80550000);
 	nv_wait(priv, 0x61a004 + doff, 0x80000000, 0x00000000);
-	return load;
+
+	nv_debug(priv, "DAC%d sense: 0x%08x\n", or, loadval);
+	if (!(loadval & 0x80000000))
+		return -ETIMEDOUT;
+
+	return (loadval & 0x38000000) >> 27;
 }
 
 int


