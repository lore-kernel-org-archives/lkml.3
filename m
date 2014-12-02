Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaLBEsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:48:38 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3985 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaLBEsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:48:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 01 Dec 2014 20:46:49 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <pdeschrijver@nvidia.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <tbergstrom@nvidia.com>
CC: <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vince Hsu <vinceh@nvidia.com>
Subject: [V3 PATCH nouveau 2/4] volt: allow non-bios voltage scaling
Date: Tue, 2 Dec 2014 12:50:33 +0800
Message-ID: <1417495835-5556-2-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417495835-5556-1-git-send-email-vinceh@nvidia.com>
References: <1417495835-5556-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the vbios parsing out of init() and call it conditionally if the
platform has a vbios. Non-vbios platforms can use the ctor() to init the
data structures.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Martin Peres <martin.peres@free.fr> 
---

v3: steal Martin's commit message and add his Acked-by

v2: add Alex's Acked-by

 nvkm/subdev/volt/base.c | 67 ++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/nvkm/subdev/volt/base.c b/nvkm/subdev/volt/base.c
index 32794a999106..26ccd8df193f 100644
--- a/nvkm/subdev/volt/base.c
+++ b/nvkm/subdev/volt/base.c
@@ -101,6 +101,41 @@ nouveau_volt_set_id(struct nouveau_volt *volt, u8 id, int condition)
 	return ret;
 }
 
+static void nouveau_volt_parse_bios(struct nouveau_bios *bios,
+		struct nouveau_volt *volt)
+{
+	struct nvbios_volt_entry ivid;
+	struct nvbios_volt info;
+	u8  ver, hdr, cnt, len;
+	u16 data;
+	int i;
+
+	data = nvbios_volt_parse(bios, &ver, &hdr, &cnt, &len, &info);
+	if (data && info.vidmask && info.base && info.step) {
+		for (i = 0; i < info.vidmask + 1; i++) {
+			if (info.base >= info.min &&
+				info.base <= info.max) {
+				volt->vid[volt->vid_nr].uv = info.base;
+				volt->vid[volt->vid_nr].vid = i;
+				volt->vid_nr++;
+			}
+			info.base += info.step;
+		}
+		volt->vid_mask = info.vidmask;
+	} else if (data && info.vidmask) {
+		for (i = 0; i < cnt; i++) {
+			data = nvbios_volt_entry_parse(bios, i, &ver, &hdr,
+							  &ivid);
+			if (data) {
+				volt->vid[volt->vid_nr].uv = ivid.voltage;
+				volt->vid[volt->vid_nr].vid = ivid.vid;
+				volt->vid_nr++;
+			}
+		}
+		volt->vid_mask = info.vidmask;
+	}
+}
+
 int
 _nouveau_volt_init(struct nouveau_object *object)
 {
@@ -136,10 +171,6 @@ nouveau_volt_create_(struct nouveau_object *parent,
 {
 	struct nouveau_bios *bios = nouveau_bios(parent);
 	struct nouveau_volt *volt;
-	struct nvbios_volt_entry ivid;
-	struct nvbios_volt info;
-	u8  ver, hdr, cnt, len;
-	u16 data;
 	int ret, i;
 
 	ret = nouveau_subdev_create_(parent, engine, oclass, 0, "VOLT",
@@ -152,31 +183,9 @@ nouveau_volt_create_(struct nouveau_object *parent,
 	volt->set = nouveau_volt_set;
 	volt->set_id = nouveau_volt_set_id;
 
-	data = nvbios_volt_parse(bios, &ver, &hdr, &cnt, &len, &info);
-	if (data && info.vidmask && info.base && info.step) {
-		for (i = 0; i < info.vidmask + 1; i++) {
-			if (info.base >= info.min &&
-			    info.base <= info.max) {
-				volt->vid[volt->vid_nr].uv = info.base;
-				volt->vid[volt->vid_nr].vid = i;
-				volt->vid_nr++;
-			}
-			info.base += info.step;
-		}
-		volt->vid_mask = info.vidmask;
-	} else
-	if (data && info.vidmask) {
-		for (i = 0; i < cnt; i++) {
-			data = nvbios_volt_entry_parse(bios, i, &ver, &hdr,
-						      &ivid);
-			if (data) {
-				volt->vid[volt->vid_nr].uv = ivid.voltage;
-				volt->vid[volt->vid_nr].vid = ivid.vid;
-				volt->vid_nr++;
-			}
-		}
-		volt->vid_mask = info.vidmask;
-	}
+	/* Assuming the non-bios device should build the voltage table later */
+	if (bios)
+		nouveau_volt_parse_bios(bios, volt);
 
 	if (volt->vid_nr) {
 		for (i = 0; i < volt->vid_nr; i++) {
-- 
1.9.1

