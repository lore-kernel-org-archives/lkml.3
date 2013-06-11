Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3FKUMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:12:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab3FKUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 58/79] Revert "ACPI / scan: do not match drivers against objects having scan handlers"
Date: Tue, 11 Jun 2013 13:03:24 -0700
Message-Id: <20130611195323.728572673@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit ea7f665612fcc73da6b7698f468cd5fc03a30d47 upstream.

Commit 9f29ab11ddbf ("ACPI / scan: do not match drivers against objects
having scan handlers") introduced a boot regression on Tony's ia64 HP
rx2600.  Tony says:

  "It panics with the message:

   Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or DIG kernel

   [...] my problem comes from arch/ia64/hp/common/sba_iommu.c
   where the code in sba_init() says:

        acpi_bus_register_driver(&acpi_sba_ioc_driver);
        if (!ioc_list) {

   but because of this change we never managed to call ioc_init()
   so ioc_list doesn't get set up, and we die."

Revert it to avoid this breakage and we'll fix the problem it attempted
to address later.

Reported-by: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -553,10 +553,6 @@ static int acpi_bus_match(struct device
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
-	/* Skip ACPI device objects with scan handlers attached. */
-	if (acpi_dev->handler)
-		return 0;
-
 	return acpi_dev->flags.match_driver
 		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }


