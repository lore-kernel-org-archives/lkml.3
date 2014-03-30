Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaCaAEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:04:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754430AbaC3Xmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mark Brown" <broonie@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.480066253@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 058/200] ACPI / init: Flag use of ACPI and ACPI idioms
 for power supplies to regulator API
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@linaro.org>

commit 49a12877d2777cadcb838981c3c4f5a424aef310 upstream.

There is currently no facility in ACPI to express the hookup of voltage
regulators, the expectation is that the regulators that exist in the
system will be handled transparently by firmware if they need software
control at all. This means that if for some reason the regulator API is
enabled on such a system it should assume that any supplies that devices
need are provided by the system at all relevant times without any software
intervention.

Tell the regulator core to make this assumption by calling
regulator_has_full_constraints(). Do this as soon as we know we are using
ACPI so that the information is available to the regulator core as early
as possible. This will cause the regulator core to pretend that there is
an always on regulator supplying any supply that is requested but that has
not otherwise been mapped which is the behaviour expected on a system with
ACPI.

Should the ability to specify regulators be added in future revisions of
ACPI then once we have support for ACPI mappings in the kernel the same
assumptions will apply. It is also likely that systems will default to a
mode of operation which does not require any interpretation of these
mappings in order to be compatible with existing operating system releases
so it should remain safe to make these assumptions even if the mappings
exist but are not supported by the kernel.

Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/bus.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -33,6 +33,7 @@
 #include <linux/proc_fs.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
+#include <linux/regulator/machine.h>
 #ifdef CONFIG_X86
 #include <asm/mpspec.h>
 #endif
@@ -917,6 +918,14 @@ void __init acpi_early_init(void)
 		goto error0;
 	}
 
+	/*
+	 * If the system is using ACPI then we can be reasonably
+	 * confident that any regulators are managed by the firmware
+	 * so tell the regulator core it has everything it needs to
+	 * know.
+	 */
+	regulator_has_full_constraints();
+
 	return;
 
       error0:

