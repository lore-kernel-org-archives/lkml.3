Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3BURQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:16:21 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:41305 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab3BURQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:16:18 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 05/10] remoteproc: Parse STE-firmware and find resource table address
Date: Thu, 21 Feb 2013 18:15:35 +0100
Message-Id: <1361466940-6813-6-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Parse the STE firmware and scan the TOC-table to find the address
of the resource table.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_elf_loader.c |    2 +-
 drivers/remoteproc/remoteproc_internal.h   |    6 ++--
 drivers/remoteproc/ste_modem_rproc.c       |   43 +++++++++++++++++++---------
 3 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index 3d6ec76..b93551f 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -323,5 +323,5 @@ const struct rproc_fw_ops rproc_elf_fw_ops = {
 	.find_rsc_table = rproc_elf_find_rsc_table,
 	.sanity_check = rproc_elf_sanity_check,
 	.get_boot_addr = rproc_elf_get_boot_addr,
-	.get_rsctab_va = rproc_elf_get_rsctab_addr
+	.get_rsctab_va = rproc_elf_get_rsctab_va
 };
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index b7372b1..91aa7ca 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -106,11 +106,11 @@ struct resource_table *rproc_find_rsc_table(struct rproc *rproc,
 }
 
 static inline
-struct resource_table *rproc_get_rsctab_addr(struct rproc *rproc,
+struct resource_table *rproc_get_rsctab_va(struct rproc *rproc,
 				const struct firmware *fw)
 {
-	if (rproc->fw_ops->get_rsctab_addr)
-		return rproc->fw_ops->get_rsctab_addr(rproc, fw);
+	if (rproc->fw_ops->get_rsctab_va)
+		return rproc->fw_ops->get_rsctab_va(rproc, fw);
 
 	return NULL;
 }
diff --git a/drivers/remoteproc/ste_modem_rproc.c b/drivers/remoteproc/ste_modem_rproc.c
index fb95c42..09f1b4e 100644
--- a/drivers/remoteproc/ste_modem_rproc.c
+++ b/drivers/remoteproc/ste_modem_rproc.c
@@ -64,26 +64,18 @@ static int sproc_load_segments(struct rproc *rproc, const struct firmware *fw)
 }
 
 /* Find the entry for resource table in the Table of Content */
-static struct ste_toc_entry *sproc_find_rsc_entry(const struct firmware *fw)
+static const struct ste_toc_entry *sproc_find_rsc_entry(const void *data)
 {
 	int i;
-	struct ste_toc *toc;
-
-	if (!fw)
-		return NULL;
-
-	toc = (void *)fw->data;
+	const struct ste_toc *toc;
+	toc = data;
 
 	/* Search the table for the resource table */
 	for (i = 0; i < SPROC_MAX_TOC_ENTRIES &&
 		    toc->table[i].start != 0xffffffff; i++) {
-
 		if (!strncmp(toc->table[i].name, SPROC_RESOURCE_NAME,
-			     sizeof(toc->table[i].name))) {
-			if (toc->table[i].start > fw->size)
-				return NULL;
+			     sizeof(toc->table[i].name)))
 			return &toc->table[i];
-		}
 	}
 
 	return NULL;
@@ -96,9 +88,12 @@ sproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 {
 	struct sproc *sproc = rproc->priv;
 	struct resource_table *table;
-	struct ste_toc_entry *entry;
+	const struct ste_toc_entry *entry;
 
-	entry = sproc_find_rsc_entry(fw);
+	if (!fw)
+		return NULL;
+
+	entry = sproc_find_rsc_entry(fw->data);
 	if (!entry) {
 		sproc_err(sproc, "resource table not found in fw\n");
 		return NULL;
@@ -149,10 +144,30 @@ sproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 	return table;
 }
 
+/* Find the resource table inside the remote processor's firmware. */
+static struct resource_table *
+sproc_get_rsctab_va(struct rproc *rproc, const struct firmware *fw)
+{
+	struct sproc *sproc = rproc->priv;
+	const struct ste_toc_entry *entry;
+
+	if (!fw || !sproc->fw_addr)
+		return NULL;
+
+	entry = sproc_find_rsc_entry(sproc->fw_addr);
+	if (!entry) {
+		sproc_err(sproc, "resource table not found in fw\n");
+		return NULL;
+	}
+
+	return sproc->fw_addr + entry->start;
+}
+
 /* STE modem firmware handler operations */
 const struct rproc_fw_ops sproc_fw_ops = {
 	.load = sproc_load_segments,
 	.find_rsc_table = sproc_find_rsc_table,
+	.get_rsctab_va = sproc_get_rsctab_va,
 };
 
 /* Kick the modem with specified notification id */
-- 
1.7.5.4

