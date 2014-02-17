Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBQI7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:59:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48157 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbaBQI7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:59:39 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH 7/8] phy-core: Don't allow building phy-core as a module
Date: Mon, 17 Feb 2014 14:29:24 +0530
Message-ID: <1392627565-1829-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392627565-1829-1-git-send-email-kishon@ti.com>
References: <1392627565-1829-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

include/phy/phy.h has stub code in there for when building without the
phy-core enabled. This is useful for generic drivers such as ahci-platform,
ehci-platoform and ohci-platform which have support for driving an optional
phy passed to them through the devicetree.

Since on some boards this phy functionality is not needed, being able to
disable the phy subsystem without needing a lot of #ifdef magic in the
driver using it is quite useful.

However this breaks when the module using the phy subsystem is build-in and
the phy-core is not, which leads to the build failing with missing symbol
errors in the linking stage of the zImage.

Which leads to gems such as this being added to the Kconfig for achi_platform:

	depends on GENERIC_PHY || !GENERIC_PHY

Rather then duplicating this code in a lot of places using the phy-core,
I believe it is better to simply not allow the phy-core to be built as a
module. The phy core is quite small and has no external dependencies, so
always building it in when enabling it should not be an issue.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Roger Quadros <rogerq@ti.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 79e3c70..c7a551c 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -5,7 +5,7 @@
 menu "PHY Subsystem"
 
 config GENERIC_PHY
-	tristate "PHY Core"
+	bool "PHY Core"
 	help
 	  Generic PHY support.
 
-- 
1.7.10.4

