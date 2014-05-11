Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbaEKVGH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 17:06:07 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:40229 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757777AbaEKVGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 17:06:04 -0400
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] ab8500-fg: Fix use of uninitialized variable in error path
Date: Sun, 11 May 2014 23:05:49 +0200
Message-Id: <1399842349-22395-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 2.0.0.rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the use of an uninitialized variable i as iterator (instead of j) in
function ab8500_fg_sysfs_psy_create_attrs error path.

This fixes the following compilation warning:

  drivers/power/ab8500_fg.c: In function ‘ab8500_fg_probe’:
  drivers/power/ab8500_fg.c:2989:27: warning: ‘i’ may be used uninitialized in this function [-Wuninitialized]
  drivers/power/ab8500_fg.c:2972:15: note: ‘i’ was declared here

While at it, remove j and use i instead, to stay consistent with the driver's
coding style, and split line for checkpatch.pl.

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---

Hi,

This starts from a compilation warning but is most probably a real bug.

This can be seen with e.g. mainline and x86 allyesconfig.

Best regards,

V.

 drivers/power/ab8500_fg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 3cb4178..fb65ea2 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2969,7 +2969,7 @@ static struct device_attribute ab8505_fg_sysfs_psy_attrs[] = {
 
 static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
 {
-	unsigned int i, j;
+	unsigned int i;
 	struct power_supply *psy = dev_get_drvdata(dev);
 	struct ab8500_fg *di;
 
@@ -2978,14 +2978,15 @@ static int ab8500_fg_sysfs_psy_create_attrs(struct device *dev)
 	if (((is_ab8505(di->parent) || is_ab9540(di->parent)) &&
 	     abx500_get_chip_id(dev->parent) >= AB8500_CUT2P0)
 	    || is_ab8540(di->parent)) {
-		for (j = 0; j < ARRAY_SIZE(ab8505_fg_sysfs_psy_attrs); j++)
-			if (device_create_file(dev, &ab8505_fg_sysfs_psy_attrs[j]))
+		for (i = 0; i < ARRAY_SIZE(ab8505_fg_sysfs_psy_attrs); i++)
+			if (device_create_file(dev,
+						&ab8505_fg_sysfs_psy_attrs[i]))
 				goto sysfs_psy_create_attrs_failed_ab8505;
 	}
 	return 0;
 sysfs_psy_create_attrs_failed_ab8505:
 	dev_err(dev, "Failed creating sysfs psy attrs for ab8505.\n");
-	while (j--)
+	while (i--)
 		device_remove_file(dev, &ab8505_fg_sysfs_psy_attrs[i]);
 
 	return -EIO;
-- 
2.0.0.rc0

