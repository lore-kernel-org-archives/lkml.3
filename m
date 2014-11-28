Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaK1LLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:11:04 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7970 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaK1LLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:11:01 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 28 Nov 2014 03:09:24 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <pdeschrijver@nvidia.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>
CC: <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vince Hsu <vinceh@nvidia.com>
Subject: [RESEND PATCH nouveau 2/3] volt: allow non-bios voltage scaling
Date: Fri, 28 Nov 2014 19:12:59 +0800
Message-ID: <1417173180-21726-2-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417173180-21726-1-git-send-email-vinceh@nvidia.com>
References: <1417173180-21726-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---

Resend this patch with the fuse change and proper patch prefix
per Thierry's request.

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

