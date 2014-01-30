Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbaA3QLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:11:51 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54597 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbaA3QLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:11:48 -0500
From: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 1/5] ARM CoreSight: ETM: Fix a memory allocation failure
Date: Thu, 30 Jan 2014 11:11:06 -0500
Message-Id: <1391098270-8867-2-git-send-email-adrienverge@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391098270-8867-1-git-send-email-adrienverge@gmail.com>
References: <1391098270-8867-1-git-send-email-adrienverge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an application reads the ETB buffer too often, it can be empty.
In this case, it results in a "vmalloc: allocation failure: 0 bytes",
a backtrace in dmesg and a vfree on an incorrect address.

This patch allocates and frees the trace buffer only when necessary.

Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
---
 arch/arm/kernel/etm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8ff0ecd..5192693 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -275,7 +275,7 @@ static ssize_t etb_read(struct file *file, char __user *data,
 	long length;
 	struct tracectx *t = file->private_data;
 	u32 first = 0;
-	u32 *buf;
+	u32 *buf = NULL;
 
 	mutex_lock(&t->mutex);
 
@@ -293,12 +293,14 @@ static ssize_t etb_read(struct file *file, char __user *data,
 	etb_writel(t, first, ETBR_READADDR);
 
 	length = min(total * 4, (int)len);
-	buf = vmalloc(length);
+	if (length != 0)
+		buf = vmalloc(length);
 
 	dev_dbg(t->dev, "ETB buffer length: %d\n", total);
 	dev_dbg(t->dev, "ETB status reg: %x\n", etb_readl(t, ETBR_STATUS));
-	for (i = 0; i < length / 4; i++)
-		buf[i] = etb_readl(t, ETBR_READMEM);
+	if (buf)
+		for (i = 0; i < length / 4; i++)
+			buf[i] = etb_readl(t, ETBR_READMEM);
 
 	/* the only way to deassert overflow bit in ETB status is this */
 	etb_writel(t, 1, ETBR_CTRL);
@@ -311,7 +313,8 @@ static ssize_t etb_read(struct file *file, char __user *data,
 	etb_lock(t);
 
 	length -= copy_to_user(data, buf, length);
-	vfree(buf);
+	if (buf)
+		vfree(buf);
 
 out:
 	mutex_unlock(&t->mutex);
-- 
1.8.5.3

