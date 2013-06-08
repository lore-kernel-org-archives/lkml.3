Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3FHAqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 20:46:03 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59761 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab3FHAqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 20:46:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH, revert] ACPI / scan: Revert scan handler check in acpi_bus_match()
Date: Sat, 08 Jun 2013 02:55:07 +0200
Message-ID: <2088285.rAqoqaNkbE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CA+8MBb+NAHvTCc-NMz4+HqkDc=VUWJ8gDz7ji=HtFiDbcpWo4Q@mail.gmail.com>
References: <3863425.93Oeg2bhJF@vostro.rjw.lan> <CA+8MBb+NAHvTCc-NMz4+HqkDc=VUWJ8gDz7ji=HtFiDbcpWo4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 07, 2013 03:23:44 PM Tony Luck wrote:
> On Fri, Jun 7, 2013 at 5:51 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Aaron Lu (1):
> >       ACPI / scan: do not match drivers against objects having scan handlers
> 
> This patch showed up in linux-next tag next-20130605 and appears to be the
> cause of a boot failure on my ia64 HP rx2600 system.  It panics with
> the message:
> 
> Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or
> DIG kernel
> 
> Reverting this from next-20130605 fixes my problem and I can boot again.
> 
> So please don't pull.

Sorry about this.

I don't think we will find out what's wrong here before -rc5, so please apply
the appended revert.

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / scan: Revert scan handler check in acpi_bus_match()

Commit 9f29ab1 (ACPI / scan: do not match drivers against objects
having scan handlers) introduced a boot regression on Tony's
ia64 HP rx2600.  Tony says:

  "It panics with the message:

   Kernel panic - not syncing: Unable to find SBA IOMMU: Try a generic or DIG kernel

   [...] my problem comes from arch/ia64/hp/common/sba_iommu.c
   where the code in sba_init() says:

        acpi_bus_register_driver(&acpi_sba_ioc_driver);
        if (!ioc_list) {

   but because of this change we never managed to call ioc_init()
   so ioc_list doesn't get set up, and we die."

Revert commit 9f29ab1 to avoid this breakage and we'll fix the
problem it attempted to address later.

Reported-by: Tony Luck <tony.luck@gmail.com>
Cc: 3.9+ <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -857,10 +857,6 @@ static int acpi_bus_match(struct device
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
-	/* Skip ACPI device objects with scan handlers attached. */
-	if (acpi_dev->handler)
-		return 0;
-
 	return acpi_dev->flags.match_driver
 		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }

