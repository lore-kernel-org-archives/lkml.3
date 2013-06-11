Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab3FKUD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:03:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab3FKUDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Cassell <bluesloth600@gmail.com>, Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 31/79] ACPI / scan: do not match drivers against objects having scan handlers
Date: Tue, 11 Jun 2013 13:02:57 -0700
Message-Id: <20130611195316.549706243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 9f29ab11ddbfc12db54df5a66dab22b39ad94e8e upstream.

With the introduction of ACPI scan handlers, an ACPI device object
with an ACPI scan handler attached to it must not be bound to an ACPI
driver any more.  Therefore it doesn't make sense to match those
ACPI device objects against a newly registered ACPI driver in
acpi_bus_match(), so make that function return 0 if the device
object passed to it has an ACPI scan handler attached.

This also addresses a regression related to a broken ACPI table in
the BIOS, where it has defined a _ROM method under the PCI root
bridge object.  This causes the video module to treat that object
as a display controller device (since only display devices are
supposed to have a _ROM method defined according to the ACPI spec).
As a result, the ACPI video driver binds to the PCI root bridge
object and overwrites the previously assigned driver_data field of
it, causing subsequent calls to acpi_get_pci_dev() to fail.

[rjw: Subject and changelog]
References: https://bugzilla.kernel.org/show_bug.cgi?id=58091
Reported-by: Jason Cassell <bluesloth600@gmail.com>
Reported-and-bisected-by: Dmitry S. Demin <dmitryy.demin@gmail.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -553,6 +553,10 @@ static int acpi_bus_match(struct device
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 	struct acpi_driver *acpi_drv = to_acpi_driver(drv);
 
+	/* Skip ACPI device objects with scan handlers attached. */
+	if (acpi_dev->handler)
+		return 0;
+
 	return acpi_dev->flags.match_driver
 		&& !acpi_match_device_ids(acpi_dev, acpi_drv->ids);
 }


