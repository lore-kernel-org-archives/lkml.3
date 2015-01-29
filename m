Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbbA2BUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:20:42 -0500
Received: from blu004-omc1s34.hotmail.com ([65.55.116.45]:52947 "EHLO
	BLU004-OMC1S34.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873AbbA2BUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:20:38 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jan 2015 20:20:37 EST
X-TMN: [dCflKkDWFoJkbMvlTt6xbGBaIfJxo1tX]
X-Originating-Email: [junjie.mao@hotmail.com]
Message-ID: <BLU436-SMTP25291B6B612942A212AEBFE95300@phx.gbl>
From: Junjie Mao <junjie.mao@hotmail.com>
To: Doug Thompson <dougthompson@xmission.com>
CC: Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Junjie Mao <junjie.mao@hotmail.com>
Subject: [PATCH v2] edac: fix the leak of mci->bus->name when bus_register fails
Date: Thu, 29 Jan 2015 09:13:55 +0800
X-Mailer: git-send-email 1.9.3
X-OriginalArrivalTime: 29 Jan 2015 01:14:15.0312 (UTC) FILETIME=[E5DD2900:01D03B60]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also use goto labels for all failure paths in edac_create_sysfs_mci_device and
update meaningless labels.

Signed-off-by: Junjie Mao <junjie.mao@hotmail.com>
---
 drivers/edac/edac_mc_sysfs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 670d2829c547..8e48d32efe37 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -989,7 +989,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)

 	err = bus_register(mci->bus);
 	if (err < 0)
-		return err;
+		goto fail_free_name;

 	/* get the /sys/devices/system/edac subsys reference */
 	mci->dev.type = &mci_attr_type;
@@ -1005,9 +1005,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 	err = device_add(&mci->dev);
 	if (err < 0) {
 		edac_dbg(1, "failure: create device %s\n", dev_name(&mci->dev));
-		bus_unregister(mci->bus);
-		kfree(mci->bus->name);
-		return err;
+		goto fail_unregister_bus;
 	}

 	if (mci->set_sdram_scrub_rate || mci->get_sdram_scrub_rate) {
@@ -1023,7 +1021,7 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 					 &dev_attr_sdram_scrub_rate);
 		if (err) {
 			edac_dbg(1, "failure: create sdram_scrub_rate\n");
-			goto fail2;
+			goto fail_unregister_dev;
 		}
 	}
 	/*
@@ -1048,14 +1046,14 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 		err = edac_create_dimm_object(mci, dimm, i);
 		if (err) {
 			edac_dbg(1, "failure: create dimm %d obj\n", i);
-			goto fail;
+			goto fail_unregister_dimm;
 		}
 	}

 #ifdef CONFIG_EDAC_LEGACY_SYSFS
 	err = edac_create_csrow_objects(mci);
 	if (err < 0)
-		goto fail;
+		goto fail_unregister_dimm;
 #endif

 #ifdef CONFIG_EDAC_DEBUG
@@ -1063,16 +1061,18 @@ int edac_create_sysfs_mci_device(struct mem_ctl_info *mci)
 #endif
 	return 0;

-fail:
+fail_unregister_dimm:
 	for (i--; i >= 0; i--) {
 		struct dimm_info *dimm = mci->dimms[i];
 		if (dimm->nr_pages == 0)
 			continue;
 		device_unregister(&dimm->dev);
 	}
-fail2:
+fail_unregister_dev:
 	device_unregister(&mci->dev);
+fail_unregister_bus:
 	bus_unregister(mci->bus);
+fail_free_name:
 	kfree(mci->bus->name);
 	return err;
 }
--
1.9.3
