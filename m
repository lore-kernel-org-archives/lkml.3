Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaA3MFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:05:14 -0500
Received: from relaygw3-5.mclink.it ([213.21.178.156]:53855 "EHLO
	relaygw3-5.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaA3MFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:05:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgGAG0/6lJNK3Ai/2dsb2JhbABZgwyrGwGUGhZ0glMTLRIRgUCICQHLfI8fhCIEmCiSH4MuOw
Date: Thu, 30 Jan 2014 13:05:09 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] FMC: support carriers with no mezzanine
Message-ID: <697e73820414734bd7f3a8023391652b9bd930a3.1391083417.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At registration and unregistration time, I was checking fmc->flags
for FMC_DEVICE_NO_MEZZANINE, to skip initialization and cleanup for
empty slots.  The check was wrong ("==" instead of "&") but
registration failed anyways (as expected) because we had no EEPROM.

This commit fixes one such checks and removes the other, so to
actually accept slots with no mezzanines. That's because the carrier
may offer some support anyways (the SPEC does), and working on the
carrier with no mezzanine-specific driver is common during
development.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
---
 drivers/fmc/fmc-core.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/fmc/fmc-core.c b/drivers/fmc/fmc-core.c
index 5f0a15c..b8a594c 100644
--- a/drivers/fmc/fmc-core.c
+++ b/drivers/fmc/fmc-core.c
@@ -153,7 +153,7 @@ int fmc_device_register_n(struct fmc_device **devs, int n)
 			ret = -EINVAL;
 			break;
 		}
-		if (fmc->flags == FMC_DEVICE_NO_MEZZANINE) {
+		if (fmc->flags & FMC_DEVICE_NO_MEZZANINE) {
 			dev_info(fmc->hwdev, "absent mezzanine in slot %d\n",
 				 fmc->slot_id);
 			continue;
@@ -188,9 +188,6 @@ int fmc_device_register_n(struct fmc_device **devs, int n)
 	for (i = 0; i < n; i++) {
 		fmc = devarray[i];
 
-		if (fmc->flags == FMC_DEVICE_NO_MEZZANINE)
-			continue; /* dev_info already done above */
-
 		fmc->nr_slots = n; /* each slot must know how many are there */
 		fmc->devarray = devarray;
 
@@ -262,8 +259,6 @@ void fmc_device_unregister_n(struct fmc_device **devs, int n)
 	kfree(devs[0]->devarray);
 
 	for (i = 0; i < n; i++) {
-		if (devs[i]->flags == FMC_DEVICE_NO_MEZZANINE)
-			continue;
 		sysfs_remove_bin_file(&devs[i]->dev.kobj, &fmc_eeprom_attr);
 		device_del(&devs[i]->dev);
 		fmc_free_id_info(devs[i]);
-- 
1.7.7.2
