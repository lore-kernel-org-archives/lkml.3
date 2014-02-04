Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935651AbaBDW7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:59:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120AbaBDVCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Molinari <mauromol@tiscali.it>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.10 003/104] drm/nouveau/bios: fix offset calculation for BMPv1 bioses
Date: Tue,  4 Feb 2014 13:01:06 -0800
Message-Id: <20140204210222.829655372@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
@@ -366,13 +366,13 @@ static u16
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
 


