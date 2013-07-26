Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab3GZV04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:26:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729Ab3GZUx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabor Juhos <juhosg@openwrt.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 06/59] rt2x00: read 5GHz TX power values from the correct offset
Date: Fri, 26 Jul 2013 13:52:30 -0700
Message-Id: <20130726205014.483949891@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit 0a6f3a8ebaf13407523c2c7d575b4ca2debd23ba upstream.

The current code uses the same index value both
for the channel information array and for the TX
power table. The index starts from 14, however the
index of the TX power table must start from zero.

Fix it, in order to get the correct TX power value
for a given channel.

The changes in rt61pci.c and rt73usb.c are compile
tested only.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4627,8 +4627,8 @@ int rt2800_probe_hw_mode(struct rt2x00_d
 		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
-			info[i].default_power1 = default_power1[i];
-			info[i].default_power2 = default_power2[i];
+			info[i].default_power1 = default_power1[i - 14];
+			info[i].default_power2 = default_power2[i - 14];
 		}
 	}
 
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2822,7 +2822,8 @@ static int rt61pci_probe_hw_mode(struct
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i - 14]);
 		}
 	}
 
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2167,7 +2167,8 @@ static int rt73usb_probe_hw_mode(struct
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i - 14]);
 		}
 	}
 


