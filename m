Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaFEAQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:16:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbaFDXWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 156/228] memory: mvebu-devbus: fix the conversion of the bus width
Date: Wed,  4 Jun 2014 16:23:05 -0700
Message-Id: <20140604232353.026562452@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit ce965c3d2e68c5325dd5624eb101d70423022fef upstream.

According to the Armada 370 and Armada XP datasheets, the part of the
Device Bus register that configure the bus width should contain 0 for
a 8 bits bus width, and 1 for a 16 bits bus width (other values are
unsupported/reserved).

However, the current conversion done in the driver to convert from a
bus width in bits to the value expected by the register leads to
setting the register to 1 for a 8 bits bus, and 2 for a 16 bits bus.

This mistake was compensated by a mistake in the existing Device Tree
files for Armada 370/XP platforms: they were declaring a 8 bits bus
width, while the hardware in fact uses a 16 bits bus width.

This commit fixes that by adjusting the conversion logic.

This patch fixes a bug that was introduced in
3edad321b1bd2e6c8b5f38146c115c8982438f06 ('drivers: memory: Introduce
Marvell EBU Device Bus driver'), which was merged in v3.11.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397489361-5833-2-git-send-email-thomas.petazzoni@free-electrons.com
Fixes: 3edad321b1bd ('drivers: memory: Introduce Marvell EBU Device Bus driver')
Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/mvebu-devbus.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/memory/mvebu-devbus.c
+++ b/drivers/memory/mvebu-devbus.c
@@ -108,8 +108,19 @@ static int devbus_set_timing_params(stru
 			node->full_name);
 		return err;
 	}
-	/* Convert bit width to byte width */
-	r.bus_width /= 8;
+
+	/*
+	 * The bus width is encoded into the register as 0 for 8 bits,
+	 * and 1 for 16 bits, so we do the necessary conversion here.
+	 */
+	if (r.bus_width == 8)
+		r.bus_width = 0;
+	else if (r.bus_width == 16)
+		r.bus_width = 1;
+	else {
+		dev_err(devbus->dev, "invalid bus width %d\n", r.bus_width);
+		return -EINVAL;
+	}
 
 	err = get_timing_param_ps(devbus, node, "devbus,badr-skew-ps",
 				 &r.badr_skew);


