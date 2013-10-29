Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab3J2Orb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:47:31 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:37033 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3J2Ora (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:47:30 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andres Salomon <dilinger@queued.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mfd: Fix memory leak in mfd_add_devices()
Date: Tue, 29 Oct 2013 15:47:22 +0100
Message-Id: <1383058042-22706-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the first call to mfd_add_device() fails, no child devices have been
registered to the parent yet, and thus mfd_remove_devices() won't find
anything to remove nor free.
Hence the previously allocated array of atomic_t objects will leak.

Free the array instead of calling mfd_remove_devices() on failure during
the first loop iteration to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mfd/mfd-core.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 8736f4539bc0..968775da638a 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -187,7 +187,7 @@ int mfd_add_devices(struct device *parent, int id,
 		    int irq_base, struct irq_domain *domain)
 {
 	int i;
-	int ret = 0;
+	int ret;
 	atomic_t *cnts;
 
 	/* initialize reference counting for all cells */
@@ -200,12 +200,16 @@ int mfd_add_devices(struct device *parent, int id,
 		ret = mfd_add_device(parent, id, cells + i, cnts + i, mem_base,
 				     irq_base, domain);
 		if (ret)
-			break;
+			goto fail;
 	}
 
-	if (ret)
-		mfd_remove_devices(parent);
+	return 0;
 
+fail:
+	if (i)
+		mfd_remove_devices(parent);
+	else
+		kfree(cnts);
 	return ret;
 }
 EXPORT_SYMBOL(mfd_add_devices);
-- 
1.7.9.5

