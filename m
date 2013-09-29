Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab3I2T3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:29:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3I2T3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 07/71] rt2800: fix wrong TX power compensation
Date: Sun, 29 Sep 2013 12:27:19 -0700
Message-Id: <20130929192644.043167015@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 6e956da2027c767859128b9bfef085cf2a8e233b upstream.

We should not do temperature compensation on devices without
EXTERNAL_TX_ALC bit set (called DynamicTxAgcControl on vendor driver).
Such devices can have totally bogus TSSI parameters on the EEPROM,
but still threaded by us as valid and result doing wrong TX power
calculations.

This fix inability to connect to AP on slightly longer distance on
some Ralink chips/devices.

Reported-and-tested-by: Fabien ADAM <id2ndr@crocobox.org>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2790,6 +2790,13 @@ static int rt2800_get_gain_calibration_d
 	int i;
 
 	/*
+	 * First check if temperature compensation is supported.
+	 */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+	if (!rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_EXTERNAL_TX_ALC))
+		return 0;
+
+	/*
 	 * Read TSSI boundaries for temperature compensation from
 	 * the EEPROM.
 	 *


