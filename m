Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3J2JDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:03:19 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:53123 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3J2JDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:03:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andres Salomon <dilinger@queued.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH RFC] mfd: Stop setting refcounting pointers in original mfd_cell arrays
Date: Tue, 29 Oct 2013 10:03:04 +0100
Message-Id: <1383037384-30079-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1e29af62f2b285bd18685da93c3ce8c33ca2d1db ("mfd: Add refcounting
support to mfd_cells") had to drop the "const" keyword on the "cell"
parameter of mfd_add_devices(), as it added the refcounting pointers
to the objects of the passed mfd_cell array itself.

However, the mfd core code operates on copies of the mfd_cell objects,
so there's no need to modify the originally passed objects.

Hence, move the setting of the refcounting pointers from mfd_add_devices()
to mfd_platform_add_cell(), where the copy of the mfd_cell objects is made.
mfd_clone_cell() can just pass (a copy of) the original usage_count
pointer.

This allows to make the "cell" parameter of mfd_add_devices() "const"
again, and avoids future race conditions when registering multiple
instances of the same device in parallel.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Ever since this "const" keyword was removed, I was wondering what was
really going on with these reference counts. My main use case involved
multiple instances of the same device, where the registration of each
successive instance would overwrite the refcounting pointer of the
previous one.
Finally I found some time to dive into it, and create this patch.
If it is accepted, I'll create a follow-up patch to add
"const" keywords to the various mfd_cell arrays.

Note that there's another issue in mfd_add_devices(): if the first call to
mfd_add_device() fails, the array of atomic_t objects will never be freed,
as no child devices have been registered to the parent yet, and thus
mfd_remove_devices() won't find anything to remove nor free.

 drivers/mfd/mfd-core.c   |   17 +++++++++--------
 include/linux/mfd/core.h |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index f421586f29fb..8736f4539bc0 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -63,7 +63,8 @@ int mfd_cell_disable(struct platform_device *pdev)
 EXPORT_SYMBOL(mfd_cell_disable);
 
 static int mfd_platform_add_cell(struct platform_device *pdev,
-				 const struct mfd_cell *cell)
+				 const struct mfd_cell *cell,
+				 atomic_t *usage_count)
 {
 	if (!cell)
 		return 0;
@@ -72,11 +73,12 @@ static int mfd_platform_add_cell(struct platform_device *pdev,
 	if (!pdev->mfd_cell)
 		return -ENOMEM;
 
+	pdev->mfd_cell->usage_count = usage_count;
 	return 0;
 }
 
 static int mfd_add_device(struct device *parent, int id,
-			  const struct mfd_cell *cell,
+			  const struct mfd_cell *cell, atomic_t *usage_count,
 			  struct resource *mem_base,
 			  int irq_base, struct irq_domain *domain)
 {
@@ -115,7 +117,7 @@ static int mfd_add_device(struct device *parent, int id,
 			goto fail_res;
 	}
 
-	ret = mfd_platform_add_cell(pdev, cell);
+	ret = mfd_platform_add_cell(pdev, cell, usage_count);
 	if (ret)
 		goto fail_res;
 
@@ -180,7 +182,7 @@ fail_alloc:
 }
 
 int mfd_add_devices(struct device *parent, int id,
-		    struct mfd_cell *cells, int n_devs,
+		    const struct mfd_cell *cells, int n_devs,
 		    struct resource *mem_base,
 		    int irq_base, struct irq_domain *domain)
 {
@@ -195,8 +197,7 @@ int mfd_add_devices(struct device *parent, int id,
 
 	for (i = 0; i < n_devs; i++) {
 		atomic_set(&cnts[i], 0);
-		cells[i].usage_count = &cnts[i];
-		ret = mfd_add_device(parent, id, cells + i, mem_base,
+		ret = mfd_add_device(parent, id, cells + i, cnts + i, mem_base,
 				     irq_base, domain);
 		if (ret)
 			break;
@@ -259,8 +260,8 @@ int mfd_clone_cell(const char *cell, const char **clones, size_t n_clones)
 	for (i = 0; i < n_clones; i++) {
 		cell_entry.name = clones[i];
 		/* don't give up if a single call fails; just report error */
-		if (mfd_add_device(pdev->dev.parent, -1, &cell_entry, NULL, 0,
-				   NULL))
+		if (mfd_add_device(pdev->dev.parent, -1, &cell_entry,
+				   cell_entry.usage_count, NULL, 0, NULL))
 			dev_err(dev, "failed to create platform device '%s'\n",
 					clones[i]);
 	}
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index cebe97ee98b8..60ced604664f 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -98,7 +98,7 @@ static inline const struct mfd_cell *mfd_get_cell(struct platform_device *pdev)
 }
 
 extern int mfd_add_devices(struct device *parent, int id,
-			   struct mfd_cell *cells, int n_devs,
+			   const struct mfd_cell *cells, int n_devs,
 			   struct resource *mem_base,
 			   int irq_base, struct irq_domain *irq_domain);
 
-- 
1.7.9.5

