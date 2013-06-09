Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3FIJaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:30:55 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:25466 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3FIJay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:30:54 -0400
X-Greylist: delayed 2501 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jun 2013 05:30:53 EDT
Date: Sun, 9 Jun 2013 10:10:03 +0200
Message-Id: <201306090810.r598A3D1013107@localhost.localdomain>
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] Fix regression on spi-fsl-spi.c following modification on spi.c
X-Antivirus: avast! (VPS 130608-1, 08/06/2013), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spi-fsl-spi.c made the assumption that t->bits_per_word and t->speed_hz were
set only when wanting to change the setting.
Since commit e6811d1d7a6a38ee637fe219c3b67dbfe17e8b3f, t->bits_per_word has
been set in all transfers, therefore the assumption made by the driver leads to
failure. This patch fixes the issue by comparing the t->new bits_per_word and
t->speed_hz with the previous one in order to determine if one of them changed.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

--- linux-3.8.13/drivers/spi/spi-fsl-spi.c	2013-05-11 22:57:46.000000000 +0200
+++ linux/drivers/spi/spi-fsl-spi.c	2013-06-09 00:13:30.000000000 +0200
@@ -476,11 +476,14 @@
 	unsigned int cs_change;
 	const int nsecs = 50;
 	int status;
+	u32 prev_speed_hz = 0;
+	u8 prev_bits_per_word = 0;
 
 	cs_change = 1;
 	status = 0;
 	list_for_each_entry(t, &m->transfers, transfer_list) {
-		if (t->bits_per_word || t->speed_hz) {
+		if (prev_bits_per_word != t->bits_per_word
+				|| prev_speed_hz != t->speed_hz) {
 			/* Don't allow changes if CS is active */
 			status = -EINVAL;
 
@@ -488,6 +491,8 @@
 				status = fsl_spi_setup_transfer(spi, t);
 			if (status < 0)
 				break;
+			prev_bits_per_word = t->bits_per_word;
+			prev_speed_hz = t->speed_hz;
 		}
 
 		if (cs_change) {
