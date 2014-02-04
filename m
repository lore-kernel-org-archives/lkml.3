Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183AbaBDV2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:28:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57424 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934654AbaBDVM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Wolfram Sang <wsa@the-dreams.de>,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.13 109/140] i2c: mv64xxx: Fix bus hang on A0 version of the Armada XP SoCs
Date: Tue,  4 Feb 2014 13:11:36 -0800
Message-Id: <20140204211040.088116530@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

commit 6cf70ae928bae17077efc0d528dec49bc380438b upstream.

The first variants of Armada XP SoCs (A0 stepping) have issues related
to the i2c controller which prevent to use the offload mechanism and
lead to a kernel hang during boot.

The commit introduces a new the compatible string
marvell,mv78230-a0-i2c for the i2c controller. When this compatible
string is used the driver disables the offload mechanism and the
kernel no more hangs on these SoCs.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Reported-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 930ab3d403ae (i2c: mv64xxx: Add I2C Transaction Generator support)
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-mv64xxx.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -692,6 +692,7 @@ static const struct of_device_id mv64xxx
 	{ .compatible = "allwinner,sun4i-i2c", .data = &mv64xxx_i2c_regs_sun4i},
 	{ .compatible = "marvell,mv64xxx-i2c", .data = &mv64xxx_i2c_regs_mv64xxx},
 	{ .compatible = "marvell,mv78230-i2c", .data = &mv64xxx_i2c_regs_mv64xxx},
+	{ .compatible = "marvell,mv78230-a0-i2c", .data = &mv64xxx_i2c_regs_mv64xxx},
 	{}
 };
 MODULE_DEVICE_TABLE(of, mv64xxx_i2c_of_match_table);
@@ -783,6 +784,10 @@ mv64xxx_of_config(struct mv64xxx_i2c_dat
 		drv_data->errata_delay = true;
 	}
 
+	if (of_device_is_compatible(np, "marvell,mv78230-a0-i2c")) {
+		drv_data->offload_enabled = false;
+		drv_data->errata_delay = true;
+	}
 out:
 	return rc;
 #endif


