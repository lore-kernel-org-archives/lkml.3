Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3APQ55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:57:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab3APQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 066/222] ACPI / PNP: Do not crash due to stale pointer use during system resume
Date: Wed, 16 Jan 2013 13:54:26 -0200
Message-Id: <1358351822-7675-67-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit a6b5e88c0e42093b9057856f35770966c8c591e3 upstream.

During resume from system suspend the 'data' field of
struct pnp_dev in pnpacpi_set_resources() may be a stale pointer,
due to removal of the associated ACPI device node object in the
previous suspend-resume cycle.  This happens, for example, if a
dockable machine is booted in the docking station and then suspended
and resumed and suspended again.  If that happens,
pnpacpi_build_resource_template() called from pnpacpi_set_resources()
attempts to use that pointer and crashes.

However, pnpacpi_set_resources() actually checks the device's ACPI
handle, attempts to find the ACPI device node object attached to it
and returns an error code if that fails, so in fact it knows what the
correct value of dev->data should be.  Use this observation to update
dev->data with the correct value if necessary and dump a call trace
if that's the case (once).

We still need to fix the root cause of this issue, but preventing
systems from crashing because of it is an improvement too.

Reported-and-tested-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: https://bugzilla.kernel.org/show_bug.cgi?id=51071
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pnp/pnpacpi/core.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index d21e8f5..e353788 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -95,6 +95,9 @@ static int pnpacpi_set_resources(struct pnp_dev *dev)
 		return -ENODEV;
 	}
 
+	if (WARN_ON_ONCE(acpi_dev != dev->data))
+		dev->data = acpi_dev;
+
 	ret = pnpacpi_build_resource_template(dev, &buffer);
 	if (ret)
 		return ret;
-- 
1.7.9.5

