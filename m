Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3C1E3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:29:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26706 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3C1E3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:29:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, stable@kernel.org
Subject: [PATCH] PCI, ACPI: Don't query OSC support with all possible controls
Date: Wed, 27 Mar 2013 21:28:58 -0700
Message-Id: <1364444938-19801-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found problem on system that firmware that could handle pci aer.
Firmware get error reporting after pci injecting error, before os boots.
But after os boots, firmware can not get report anymore, even pci=noaer
is passed.

Root cause: BIOS _OSC has problem with query bit checking.
It turns out that BIOS vendor is copying example code from ACPI Spec.
In ACPI Spec 5.0, page 290:

	If (Not(And(CDW1,1))) // Query flag clear?
	{	// Disable GPEs for features granted native control.
		If (And(CTRL,0x01)) // Hot plug control granted?
		{
			Store(0,HPCE) // clear the hot plug SCI enable bit
			Store(1,HPCS) // clear the hot plug SCI status bit
		}
	...
	}

When Query flag is set, And(CDW1,1) will be 1, Not(1) will return 0xfffffffe.
So it will get into code path that should be for control set only.
BIOS acpi code should be changed to "If (LEqual(And(CDW1,1), 0)))"

Current kernel code is using _OSC query to notify firmware about support
from OS and then use _OSC to set control bits.
During query support, current code is using all possible controls.
So will execute code that should be only for control set stage.

That will have problem when pci=noaer or aer firmware_first is used.
As firmware have that control set for os aer already in query support stage,
but later will not os aer handling.

We should avoid passing all possible controls, just use osc_control_set
instead.
That should workaround BIOS bugs with affected systems on the field
as more bios vendors are copying sample code from ACPI spec.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 drivers/acpi/pci_root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/pci_root.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_root.c
+++ linux-2.6/drivers/acpi/pci_root.c
@@ -201,8 +201,8 @@ static acpi_status acpi_pci_query_osc(st
 		*control &= OSC_PCI_CONTROL_MASKS;
 		capbuf[OSC_CONTROL_TYPE] = *control | root->osc_control_set;
 	} else {
-		/* Run _OSC query for all possible controls. */
-		capbuf[OSC_CONTROL_TYPE] = OSC_PCI_CONTROL_MASKS;
+		/* Run _OSC query only with existing controls. */
+		capbuf[OSC_CONTROL_TYPE] = root->osc_control_set;
 	}
 
 	status = acpi_pci_run_osc(root->device->handle, capbuf, &result);
