Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3IKE32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab3IKE27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:28:59 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=M5ZwzUtB9nkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=LIElYT9whvQA:10 a=jdP34snFAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=vmLDa1wCAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=9mtjllxcxZAA:10 a=MSl-tDqOz04A:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=E3W7nrUojk6Hpo32:21 a=O3W7pL5FoV78xYUW:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042855.273753939@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Gabor Juhos <juhosg@openwrt.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [019/251] rt2x00: read 5GHz TX power values from the correct offset
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0019-rt2x00-read-5GHz-TX-power-values-from-the-correct-of.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

[ Upstream commit 0a6f3a8ebaf13407523c2c7d575b4ca2debd23ba ]

The current code uses the same index value both
for the channel information array and for the TX
power table. The index starts from 14, however the
index of the TX power table must start from zero.

Fix it, in order to get the correct TX power value
for a given channel.

The changes in rt61pci.c and rt73usb.c are compile
tested only.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Cc: stable@vger.kernel.org
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c   |    3 ++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6c85ba5..fe0e278 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4980,8 +4980,8 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
-			info[i].default_power1 = default_power1[i];
-			info[i].default_power2 = default_power2[i];
+			info[i].default_power1 = default_power1[i - 14];
+			info[i].default_power2 = default_power2[i - 14];
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index b8ec961..7e475a9 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2822,7 +2822,8 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i - 14]);
 		}
 	}
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 248436c..55d30ba 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2167,7 +2167,8 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		tx_power = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A_START);
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].max_power = MAX_TXPOWER;
-			info[i].default_power1 = TXPOWER_FROM_DEV(tx_power[i]);
+			info[i].default_power1 =
+					TXPOWER_FROM_DEV(tx_power[i - 14]);
 		}
 	}
 
-- 
1.7.10.4


