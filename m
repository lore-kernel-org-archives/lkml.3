Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaBGMEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:04:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbaBGLwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 204/233] drm/nouveau/bios: fix offset calculation for BMPv1 bioses
Date: Fri,  7 Feb 2014 11:47:03 +0000
Message-Id: <1391773652-25214-205-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 5d2f4767c4eacab351b8450b0de4d3261fe1a957 upstream.

The only BIOS on record that needs the 14 offset has a bios major
version 2 but BMP version 1.01. Another bunch of BIOSes that need the 18
offset have BMP version 2.01 or 5.01 or higher. So instead of looking at the
bios major version, look at the BMP version. BIOSes with BMP version 0
do not contain a detectable script, so always return 0 for them.

See https://bugs.freedesktop.org/show_bug.cgi?id=68835

Reported-by: Mauro Molinari <mauromol@tiscali.it>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
index 892070a..c5c5ce1 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
@@ -365,13 +365,13 @@ static u16
 init_script(struct nouveau_bios *bios, int index)
 {
 	struct nvbios_init init = { .bios = bios };
-	u16 data;
+	u16 bmp_ver = bmp_version(bios), data;
 
-	if (bmp_version(bios) && bmp_version(bios) < 0x0510) {
-		if (index > 1)
+	if (bmp_ver && bmp_ver < 0x0510) {
+		if (index > 1 || bmp_ver < 0x0100)
 			return 0x0000;
 
-		data = bios->bmp_offset + (bios->version.major < 2 ? 14 : 18);
+		data = bios->bmp_offset + (bmp_ver < 0x0200 ? 14 : 18);
 		return nv_ro16(bios, data + (index * 2));
 	}
 
-- 
1.8.3.2

