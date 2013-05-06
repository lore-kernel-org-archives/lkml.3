Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3EFX6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:58:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab3EFW5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:57:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 29/63] PCI / ACPI: Dont query OSC support with all possible controls
Date: Mon,  6 May 2013 15:56:07 -0700
Message-Id: <20130506225322.121220139@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 545d6e189a41c94c11f55045a771118eccc9d9eb upstream.

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
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/pci_root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -247,8 +247,8 @@ static acpi_status acpi_pci_query_osc(st
 		*control &= OSC_PCI_CONTROL_MASKS;
 		capbuf[OSC_CONTROL_TYPE] = *control | root->osc_control_set;
 	} else {
-		/* Run _OSC query for all possible controls. */
-		capbuf[OSC_CONTROL_TYPE] = OSC_PCI_CONTROL_MASKS;
+		/* Run _OSC query only with existing controls. */
+		capbuf[OSC_CONTROL_TYPE] = root->osc_control_set;
 	}
 
 	status = acpi_pci_run_osc(root->device->handle, capbuf, &result);


