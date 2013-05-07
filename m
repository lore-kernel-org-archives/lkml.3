Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab3EGODL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:03:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42392 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab3EGNlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 068/118] PCI / ACPI: Don't query OSC support with all possible controls
Date: Tue,  7 May 2013 14:38:34 +0100
Message-Id: <1367933964-1564-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/pci_root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 7aff631..5b0f075 100644
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
1.8.1.2

