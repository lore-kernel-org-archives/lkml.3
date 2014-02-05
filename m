Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaBEUMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:12:54 -0500
Received: from mail.windriver.com ([147.11.1.11]:55685 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377AbaBEUIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:08:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dan Williams <dan.j.williams@intel.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 205/213] libsas: continue revalidation
Date: Wed, 5 Feb 2014 15:02:40 -0500
Message-ID: <1391630568-49251-206-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 26f2f199ff150d8876b2641c41e60d1c92d2fb81 upstream.

Continue running revalidation until no more broadcast devices are
discovered.  Fixes cases where re-discovery completes too early in a
domain with multiple expanders with pending re-discovery events.
Servicing BCNs can get backed up behind error recovery.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/libsas/sas_expander.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 4ee42bb48dcd..cb4964b54191 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1947,9 +1947,7 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
 	struct domain_device *dev = NULL;
 
 	res = sas_find_bcast_dev(port_dev, &dev);
-	if (res)
-		goto out;
-	if (dev) {
+	while (res == 0 && dev) {
 		struct expander_device *ex = &dev->ex_dev;
 		int i = 0, phy_id;
 
@@ -1961,8 +1959,10 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
 			res = sas_rediscover(dev, phy_id);
 			i = phy_id + 1;
 		} while (i < ex->num_phys);
+
+		dev = NULL;
+		res = sas_find_bcast_dev(port_dev, &dev);
 	}
-out:
 	return res;
 }
 
-- 
1.8.5.2

