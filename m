Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600Ab3E2K1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:27:53 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10711 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965412Ab3E2K1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:27:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 29 May 2013 03:27:50 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@gmail.com>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <tbergstrom@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCHv2 2/7] gpu: host1x: Check reloc table before usage
Date: Wed, 29 May 2013 13:26:03 +0300
Message-ID: <1369823168-5396-3-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firewall assumed that the user space always delivers a relocation
table when it is accessing address registers. If userspace did not
deliver a relocation table and tried to access the address registers,
the code performed bad memory accesses.

This patch modifies the firewall to check correctly that the firewall
table is available before accessing it. In addition, check_reloc() is
converted to use boolean return value (true when the reloc is valid,
false when invalid).

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/job.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index 2974ac8..83804fd 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -268,15 +268,15 @@ static unsigned int do_relocs(struct host1x_job *job, struct host1x_bo *cmdbuf)
 	return 0;
 }
 
-static int check_reloc(struct host1x_reloc *reloc, struct host1x_bo *cmdbuf,
+static bool check_reloc(struct host1x_reloc *reloc, struct host1x_bo *cmdbuf,
 		       unsigned int offset)
 {
 	offset *= sizeof(u32);
 
 	if (reloc->cmdbuf != cmdbuf || reloc->cmdbuf_offset != offset)
-		return -EINVAL;
+		return false;
 
-	return 0;
+	return true;
 }
 
 struct host1x_firewall {
@@ -307,10 +307,10 @@ static int check_mask(struct host1x_firewall *fw)
 
 		if (mask & 1) {
 			if (fw->job->is_addr_reg(fw->dev, fw->class, reg)) {
-				bool bad_reloc = check_reloc(fw->reloc,
-							     fw->cmdbuf_id,
-							     fw->offset);
-				if (!fw->num_relocs || bad_reloc)
+				if (!fw->num_relocs)
+					return -EINVAL;
+				if (!check_reloc(fw->reloc, fw->cmdbuf_id,
+						 fw->offset))
 					return -EINVAL;
 				fw->reloc++;
 				fw->num_relocs--;
@@ -335,9 +335,9 @@ static int check_incr(struct host1x_firewall *fw)
 			return -EINVAL;
 
 		if (fw->job->is_addr_reg(fw->dev, fw->class, reg)) {
-			bool bad_reloc = check_reloc(fw->reloc, fw->cmdbuf_id,
-						     fw->offset);
-			if (!fw->num_relocs || bad_reloc)
+			if (!fw->num_relocs)
+				return -EINVAL;
+			if (!check_reloc(fw->reloc, fw->cmdbuf_id, fw->offset))
 				return -EINVAL;
 			fw->reloc++;
 			fw->num_relocs--;
@@ -361,9 +361,9 @@ static int check_nonincr(struct host1x_firewall *fw)
 			return -EINVAL;
 
 		if (is_addr_reg) {
-			bool bad_reloc = check_reloc(fw->reloc, fw->cmdbuf_id,
-						     fw->offset);
-			if (!fw->num_relocs || bad_reloc)
+			if (!fw->num_relocs)
+				return -EINVAL;
+			if (!check_reloc(fw->reloc, fw->cmdbuf_id, fw->offset))
 				return -EINVAL;
 			fw->reloc++;
 			fw->num_relocs--;
-- 
1.8.1.5

