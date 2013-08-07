Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab3HGQPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:15:52 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:56815 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145Ab3HGQPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:15:49 -0400
X-Greylist: delayed 1858 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2013 12:15:49 EDT
Date: Wed, 7 Aug 2013 17:44:45 +0200
Message-Id: <201308071544.r77Fij2Y006649@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
CC: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, stigge@antcom.de
Subject: [PATCH] SPI: Set SPI bits per words in an OF DeviceTree SPI node
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to set up the bits per word together with all other SPI
parameters in the SPI Node of the OF device tree

In the node, you then have to include the 'spi-bits' property.

Exemple:
	fpga-loader@7 {
		compatible = "cs,fpga-loader";
		spi-max-frequency = <10000000>;
		reg = <7>;
		spi-cs-high;
		spi-bits = <16>;
	};

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

--- linux-3.8.13/drivers/spi/spi.c	2013-05-11 22:57:46.000000000 +0200
+++ linux/drivers/spi/spi.c	2013-08-06 18:19:30.000000000 +0200
@@ -870,6 +870,11 @@
 		if (of_find_property(nc, "spi-3wire", NULL))
 			spi->mode |= SPI_3WIRE;
 
+		/* Bits per word */
+		prop = of_get_property(nc, "spi-bits", &len);
+		if (prop && len >= sizeof(*prop))
+			spi->bits_per_word = prop[0];
+
 		/* Device speed */
 		prop = of_get_property(nc, "spi-max-frequency", &len);
 		if (!prop || len < sizeof(*prop)) {
