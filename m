Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaBGLZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:25:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41139 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaBGLZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:25:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 68/88] ACPI / init: Flag use of ACPI and ACPI idioms for power supplies to regulator API
Date: Fri,  7 Feb 2014 11:23:05 +0000
Message-Id: <1391772205-22239-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/bus.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 54a5732..bb5aab4 100644
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
@@ -957,6 +958,14 @@ void __init acpi_early_init(void)
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
-- 
1.8.3.2

