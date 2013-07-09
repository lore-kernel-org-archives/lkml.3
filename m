Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3GIAOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:14:25 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35137 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab3GIANW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:13:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 3/8] ACPI / hotplug / PCI: Always return success after adding a function
Date: Tue, 09 Jul 2013 02:17:34 +0200
Message-ID: <3387129.165JytWxXq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <26431283.HJCKsss0rt@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

When a new ACPIPHP function is added by register_slot() and the
notify handler cannot be installed for it, register_slot() returns an
error status without cleaning up, which causes the entire namespace
walk in acpiphp_enumerate_slots() to be aborted, although it still
may be possible to successfully install the function notify handler
for other device objects under the given brigde.

To address this issue make register_slot() return success after
a new function has been added, even if the addition of the notify
handler for it has failed.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -335,10 +335,9 @@ register_slot(acpi_handle handle, u32 lv
 
 		if (ACPI_FAILURE(status))
 			err("failed to register interrupt notify handler\n");
-	} else
-		status = AE_OK;
+	}
 
-	return status;
+	return AE_OK;
 
  err_exit:
 	bridge->nr_slots--;

