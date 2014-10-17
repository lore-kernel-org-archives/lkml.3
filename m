Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaJQHGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:06:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:55098 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaJQHGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:06:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,737,1406617200"; 
   d="scan'208";a="606870629"
Date: Fri, 17 Oct 2014 15:06:20 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, rui.zhang@intel.com,
        edubezval@gmail.com, linux-pm@vger.kernel.org
Subject: [PATCH v2] Thermal: int3406_thermal: solve the dependency build error
Message-ID: <20141017070620.GA1538@aaronlu.sh.intel.com>
References: <CA+r1ZhhoskOXaRSmcrnbdgapi-FsaKf+dnPHTXGkDvkYbvwQ8Q@mail.gmail.com>
 <543F88BE.4090307@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543F88BE.4090307@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim found that the current kernel may trigger a build error with some
config: drivers/built-in.o: In function `int3406_thermal_probe':
int3406_thermal.c:(.text+0x1d10b8): undefined reference to
`acpi_video_get_levels'. The problem happens when CONFIG_THERMAL=y and
CONFIG_ACPI_VIDEO=m. Solve the problem by separating a kernel config for
int3406 thermal driver and add dependency on ACPI video for it.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
v2: v1 still has a problem so please ignore the last patch.

 drivers/thermal/Kconfig                  | 22 +++------------------
 drivers/thermal/int340x_thermal/Kconfig  | 34 ++++++++++++++++++++++++++++++++
 drivers/thermal/int340x_thermal/Makefile |  2 +-
 3 files changed, 38 insertions(+), 20 deletions(-)
 create mode 100644 drivers/thermal/int340x_thermal/Kconfig

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 9b012ff65220..3bca14d86482 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -229,25 +229,9 @@ config INTEL_SOC_DTS_THERMAL
 	  notification methods.The other trip is a critical trip point, which
 	  was set by the driver based on the TJ MAX temperature.
 
-config INT340X_THERMAL
-	tristate "ACPI INT340X thermal drivers"
-	depends on X86 && ACPI
-	select THERMAL_GOV_USER_SPACE
-	select ACPI_THERMAL_REL
-	select ACPI_FAN
-	help
-	  Newer laptops and tablets that use ACPI may have thermal sensors and
-	  other devices with thermal control capabilities outside the core
-	  CPU/SOC, for thermal safety reasons.
-	  They are exposed for the OS to use via the INT3400 ACPI device object
-	  as the master, and INT3401~INT340B ACPI device objects as the slaves.
-	  Enable this to expose the temperature information and cooling ability
-	  from these objects to userspace via the normal thermal framework.
-	  This means that a wide range of applications and GUI widgets can show
-	  the information to the user or use this information for making
-	  decisions. For example, the Intel Thermal Daemon can use this
-	  information to allow the user to select his laptop to run without
-	  turning on the fans.
+menu "ACPI INT340X thermal drivers"
+source drivers/thermal/int340x_thermal/Kconfig
+endmenu
 
 config ACPI_THERMAL_REL
 	tristate
diff --git a/drivers/thermal/int340x_thermal/Kconfig b/drivers/thermal/int340x_thermal/Kconfig
new file mode 100644
index 000000000000..9a58520d24a4
--- /dev/null
+++ b/drivers/thermal/int340x_thermal/Kconfig
@@ -0,0 +1,34 @@
+#
+# ACPI INT340x thermal drivers configuration
+#
+
+config INT340X_THERMAL
+	tristate "ACPI INT340X thermal drivers"
+	depends on X86 && ACPI
+	select THERMAL_GOV_USER_SPACE
+	select ACPI_THERMAL_REL
+	select ACPI_FAN
+	help
+	  Newer laptops and tablets that use ACPI may have thermal sensors and
+	  other devices with thermal control capabilities outside the core
+	  CPU/SOC, for thermal safety reasons.
+	  They are exposed for the OS to use via the INT3400 ACPI device object
+	  as the master, and INT3401~INT340B ACPI device objects as the slaves.
+	  Enable this to expose the temperature information and cooling ability
+	  from these objects to userspace via the normal thermal framework.
+	  This means that a wide range of applications and GUI widgets can show
+	  the information to the user or use this information for making
+	  decisions. For example, the Intel Thermal Daemon can use this
+	  information to allow the user to select his laptop to run without
+	  turning on the fans.
+
+config INT3406_THERMAL
+	tristate "ACPI INT3406 display thermal driver"
+	depends on INT340X_THERMAL
+	depends on ACPI_VIDEO
+	help
+	  The display thermal device represents the LED/LCD display panel
+	  that may or may not include touch support. The main function of
+	  the display thermal device is to allow control of the display
+	  brightness in order to address a thermal condition or to reduce
+	  power consumed by display device.
diff --git a/drivers/thermal/int340x_thermal/Makefile b/drivers/thermal/int340x_thermal/Makefile
index e3e2eb20da94..a9d0429be412 100644
--- a/drivers/thermal/int340x_thermal/Makefile
+++ b/drivers/thermal/int340x_thermal/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_INT340X_THERMAL)	+= int3400_thermal.o
 obj-$(CONFIG_INT340X_THERMAL)	+= int3402_thermal.o
 obj-$(CONFIG_INT340X_THERMAL)	+= int3403_thermal.o
-obj-$(CONFIG_INT340X_THERMAL)	+= int3406_thermal.o
+obj-$(CONFIG_INT3406_THERMAL)	+= int3406_thermal.o
 obj-$(CONFIG_ACPI_THERMAL_REL)	+= acpi_thermal_rel.o
-- 
1.9.3

