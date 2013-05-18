Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3ERCUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:20:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab3ERCQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:57 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=shadTm2mtMsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=blLi1_f1S_8A:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=LI9Vle30uBYA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021647.914743224@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 038/136 ] PCI / ACPI: Dont query OSC support with all possible controls
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0038-PCI-ACPI-Don-t-query-OSC-support-with-all-possible-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

[ Upstream commit 545d6e189a41c94c11f55045a771118eccc9d9eb ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/pci_root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 72a2c98..ef0690e 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -247,8 +247,8 @@ static acpi_status acpi_pci_query_osc(struct acpi_pci_root *root,
 		*control &= OSC_PCI_CONTROL_MASKS;
 		capbuf[OSC_CONTROL_TYPE] = *control | root->osc_control_set;
 	} else {
-		/* Run _OSC query for all possible controls. */
-		capbuf[OSC_CONTROL_TYPE] = OSC_PCI_CONTROL_MASKS;
+		/* Run _OSC query only with existing controls. */
+		capbuf[OSC_CONTROL_TYPE] = root->osc_control_set;
 	}
 
 	status = acpi_pci_run_osc(root->device->handle, capbuf, &result);
-- 
1.7.10.4


