Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbaAFXut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:50:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbaAFWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 107/144] ACPI / PCI / hotplug: Avoid warning when _ADR not present
Date: Mon,  6 Jan 2014 14:37:48 -0800
Message-Id: <20140106223748.417273387@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshi Kani <toshi.kani@hp.com>

commit f26ca1d699e8b54a50d9faf82327d3c2072aaedd upstream.

acpiphp_enumerate_slots() walks ACPI namenamespace under
a PCI host bridge with callback register_slot().
register_slot() evaluates _ADR for all the device objects
and emits a warning message for any error.  Some platforms
have _HID device objects (such as HPET and IPMI), which
trigger unnecessary warning messages.

This patch avoids emitting a warning message when a target
device object does not have _ADR.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/acpiphp_glue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -279,7 +279,9 @@ static acpi_status register_slot(acpi_ha
 
 	status = acpi_evaluate_integer(handle, "_ADR", NULL, &adr);
 	if (ACPI_FAILURE(status)) {
-		acpi_handle_warn(handle, "can't evaluate _ADR (%#x)\n", status);
+		if (status != AE_NOT_FOUND)
+			acpi_handle_warn(handle,
+				"can't evaluate _ADR (%#x)\n", status);
 		return AE_OK;
 	}
 


