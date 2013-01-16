Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3APOoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:44:30 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:42391 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab3APOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:26 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: mporter@ti.com, =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv3 05/11] remoteproc: Parse ELF file to find resource table address
Date: Wed, 16 Jan 2013 15:43:44 +0100
Message-Id: <1358347430-9243-6-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Add function find_rsc_table_va to firmware ops. This function
returns the location of the resource table in shared memory
after loading.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_elf_loader.c |   17 ++++++++++++++++-
 drivers/remoteproc/remoteproc_internal.h   |   13 +++++++++++++
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
index 32a29b8..2ded994 100644
--- a/drivers/remoteproc/remoteproc_elf_loader.c
+++ b/drivers/remoteproc/remoteproc_elf_loader.c
@@ -312,9 +312,24 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
 	return table;
 }
 
+struct resource_table *rproc_elf_get_rsctab_addr(struct rproc *rproc,
+						 const struct firmware *fw)
+{
+	struct elf32_shdr *shdr;
+
+	shdr = find_rsc_shdr(&rproc->dev, (struct elf32_hdr *)fw->data,
+				fw->size);
+	if (!shdr)
+		return NULL;
+
+	/* Find resource table in loaded segments */
+	return rproc_da_to_va(rproc, shdr->sh_addr, shdr->sh_size);
+}
+
 const struct rproc_fw_ops rproc_elf_fw_ops = {
 	.load = rproc_elf_load_segments,
 	.find_rsc_table = rproc_elf_find_rsc_table,
 	.sanity_check = rproc_elf_sanity_check,
-	.get_boot_addr = rproc_elf_get_boot_addr
+	.get_boot_addr = rproc_elf_get_boot_addr,
+	.get_rsctab_addr = rproc_elf_get_rsctab_addr
 };
diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
index 7bb6648..3a5cb7d 100644
--- a/drivers/remoteproc/remoteproc_internal.h
+++ b/drivers/remoteproc/remoteproc_internal.h
@@ -32,6 +32,7 @@ struct rproc;
  *			expects to find it
  * @sanity_check:	sanity check the fw image
  * @get_boot_addr:	get boot address to entry point specified in firmware
+ * @get_rsctab_addr:	get resouce table address as specified in firmware
  */
 struct rproc_fw_ops {
 	struct resource_table *(*find_rsc_table) (struct rproc *rproc,
@@ -40,6 +41,8 @@ struct rproc_fw_ops {
 	int (*load)(struct rproc *rproc, const struct firmware *fw);
 	int (*sanity_check)(struct rproc *rproc, const struct firmware *fw);
 	u32 (*get_boot_addr)(struct rproc *rproc, const struct firmware *fw);
+	struct resource_table *(*get_rsctab_addr)(struct rproc *rproc,
+						const struct firmware *fw);
 };
 
 /* from remoteproc_core.c */
@@ -102,6 +105,16 @@ struct resource_table *rproc_find_rsc_table(struct rproc *rproc,
 	return NULL;
 }
 
+static inline
+struct resource_table *rproc_get_rsctab_addr(struct rproc *rproc,
+				const struct firmware *fw)
+{
+	if (rproc->fw_ops->get_rsctab_addr)
+		return rproc->fw_ops->get_rsctab_addr(rproc, fw);
+
+	return NULL;
+}
+
 extern const struct rproc_fw_ops rproc_elf_fw_ops;
 
 #endif /* REMOTEPROC_INTERNAL_H */
-- 
1.7.5.4

