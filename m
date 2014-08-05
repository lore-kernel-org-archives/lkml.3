Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaHESmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:42:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52286 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaHESO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 14/39] ACPI / PNP: Fix acpi_pnp_match()
Date: Tue,  5 Aug 2014 11:13:51 -0700
Message-Id: <20140805181336.477637866@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit b6328a07bd6b3d31b64f85864fe74f3b08c010ca upstream.

The acpi_pnp_match() function is used for finding the ACPI device
object that should be associated with the given PNP device.
Unfortunately, the check used by that function is not strict enough
and may cause success to be returned for a wrong ACPI device object.

To fix that, use the observation that the pointer to the ACPI
device object in question is already stored in the data field
in struct pnp_dev, so acpi_pnp_match() can simply use that
field to do its job.

This problem was uncovered in 3.14 by commit 202317a573b2 (ACPI / scan:
Add acpi_device objects for all device nodes in the namespace).

Fixes: 202317a573b2 (ACPI / scan: Add acpi_device objects for all device nodes in the namespace)
Reported-and-tested-by: Vinson Lee <vlee@twopensource.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pnp/pnpacpi/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -339,8 +339,7 @@ static int __init acpi_pnp_match(struct
 	struct pnp_dev *pnp = _pnp;
 
 	/* true means it matched */
-	return !acpi->physical_node_count
-	    && compare_pnp_id(pnp->id, acpi_device_hid(acpi));
+	return pnp->data == acpi;
 }
 
 static struct acpi_device * __init acpi_pnp_find_companion(struct device *dev)


