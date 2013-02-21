Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab3BURQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:16:10 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:57129 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3BURQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:16:08 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 03/10] remoteproc: Refactor function rproc_elf_find_rsc_table
Date: Thu, 21 Feb 2013 18:15:33 +0100
Message-Id: <1361466940-6813-4-git-send-email-sjur.brandeland@stericsson.com>
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

Refactor rproc_elf_find_rsc_table and split out the scanning
for the section header named resource table. This is done to
prepare for loading firmware once.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_elf_loader.c |   75 +++++++++++++++++-----------
 1 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index 0d36f94..ed12c16 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -208,41 +208,22 @@ rproc_elf_load_segments(struct rproc *rproc, const struct firmware *fw)
 	return ret;
 }
 
-/**
- * rproc_elf_find_rsc_table() - find the resource table
- * @rproc: the rproc handle
- * @fw: the ELF firmware image
- * @tablesz: place holder for providing back the table size
- *
- * This function finds the resource table inside the remote processor's
- * firmware. It is used both upon the registration of @rproc (in order
- * to look for and register the supported virito devices), and when the
- * @rproc is booted.
- *
- * Returns the pointer to the resource table if it is found, and write its
- * size into @tablesz. If a valid table isn't found, NULL is returned
- * (and @tablesz isn't set).
- */
-static struct resource_table *
-rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
-							int *tablesz)
+static struct elf32_shdr *
+find_rsc_shdr(struct device *dev, struct elf32_hdr *ehdr, size_t fw_size)
 {
-	struct elf32_hdr *ehdr;
 	struct elf32_shdr *shdr;
+	int i;
 	const char *name_table;
-	struct device *dev = &rproc->dev;
 	struct resource_table *table = NULL;
-	int i;
-	const u8 *elf_data = fw->data;
+	const u8 *elf_data = (void *)ehdr;
 
-	ehdr = (struct elf32_hdr *)elf_data;
+	/* look for the resource table and handle it */
 	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
 	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
 
-	/* look for the resource table and handle it */
 	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
-		int size = shdr->sh_size;
-		int offset = shdr->sh_offset;
+		u32 size = shdr->sh_size;
+		u32 offset = shdr->sh_offset;
 
 		if (strcmp(name_table + shdr->sh_name, ".resource_table"))
 			continue;
@@ -250,7 +231,7 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 		table = (struct resource_table *)(elf_data + offset);
 
 		/* make sure we have the entire table */
-		if (offset + size > fw->size) {
+		if (offset + size > fw_size || offset + size < size) {
 			dev_err(dev, "resource table truncated\n");
 			return NULL;
 		}
@@ -280,10 +261,46 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 			return NULL;
 		}
 
-		*tablesz = shdr->sh_size;
-		break;
+		return shdr;
 	}
 
+	return NULL;
+}
+
+/**
+ * rproc_elf_find_rsc_table() - find the resource table
+ * @rproc: the rproc handle
+ * @fw: the ELF firmware image
+ * @tablesz: place holder for providing back the table size
+ *
+ * This function finds the resource table inside the remote processor's
+ * firmware. It is used both upon the registration of @rproc (in order
+ * to look for and register the supported virito devices), and when the
+ * @rproc is booted.
+ *
+ * Returns the pointer to the resource table if it is found, and write its
+ * size into @tablesz. If a valid table isn't found, NULL is returned
+ * (and @tablesz isn't set).
+ */
+static struct resource_table *
+rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
+							int *tablesz)
+{
+	struct elf32_hdr *ehdr;
+	struct elf32_shdr *shdr;
+	struct device *dev = &rproc->dev;
+	struct resource_table *table = NULL;
+	const u8 *elf_data = fw->data;
+
+	ehdr = (struct elf32_hdr *)elf_data;
+
+	shdr = find_rsc_shdr(dev, ehdr, fw->size);
+	if (!shdr)
+		return NULL;
+
+	table = (struct resource_table *)(elf_data + shdr->sh_offset);
+	*tablesz = shdr->sh_size;
+
 	return table;
 }
 
-- 
1.7.5.4

