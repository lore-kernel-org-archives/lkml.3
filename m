Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240Ab3AOXN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:13:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:47655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933956Ab3AOWyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:54:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gabor Juhos <juhosg@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 07/71] ath9k: ar9003: fix OTP register offsets for AR9340
Date: Tue, 15 Jan 2013 14:54:04 -0800
Message-Id: <20130115225340.942288845@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit b3cd8021379306c0be6932e4d3b4b01efc681769 upstream.

Trying to access the OTP memory on the AR9340
causes a data bus error like this:

  Data bus error, epc == 86e84164, ra == 86e84164
  Oops[#1]:
  Cpu 0
  $ 0   : 00000000 00000061 deadc0de 00000000
  $ 4   : b8115f18 00015f18 00000007 00000004
  $ 8   : 00000001 7c7c3c7c 7c7c7c7c 7c7c7c7c
  $12   : 7c7c3c7c 001f0041 00000000 7c7c7c3c
  $16   : 86ee0000 00015f18 00000000 00000007
  $20   : 00000004 00000064 00000004 86d71c44
  $24   : 00000000 86e6ca00
  $28   : 86d70000 86d71b20 86ece0c0 86e84164
  Hi    : 00000000
  Lo    : 00000064
  epc   : 86e84164 ath9k_hw_wait+0x58/0xb0 [ath9k_hw]
      Tainted: G           O
  ra    : 86e84164 ath9k_hw_wait+0x58/0xb0 [ath9k_hw]
  Status: 1100d403    KERNEL EXL IE
  Cause : 4080801c
  PrId  : 0001974c (MIPS 74Kc)
  Modules linked in: ath9k(O+) ath9k_common(O) ath9k_hw(O) ath(O) ar934x_nfc
  mac80211(O) usbcore usb_common scsi_mod nls_base nand nand_ecc nand_ids
  crc_ccitt cfg80211(O) compat(O) arc4 aes_generic crypto_blkcipher cryptomgr
  aead crypto_hash crypto_algapi ledtrig_timer ledtrig_default_on leds_gpio
  Process insmod (pid: 459, threadinfo=86d70000, task=87942140, tls=779ac440)
  Stack : 802fb500 000200da 804db150 804e0000 87816130 86ee0000 00010000 86d71b88
          86d71bc0 00000004 00000003 86e9fcd0 80305300 0002c0d0 86e74c50 800b4c20
          000003e8 00000001 00000000 86ee0000 000003ff 86e9fd64 80305300 80123938
          fffffffc 00000004 000058bc 00000000 86ea0000 86ee0000 000001ff 878d6000
          99999999 86e9fdc0 86ee0fcc 86e9e664 0000c0d0 86ee0000 0000700000007000
          ...
  Call Trace:
  [<86e84164>] ath9k_hw_wait+0x58/0xb0 [ath9k_hw]
  [<86e9fcd0>] ath9k_hw_setup_statusring+0x16b8/0x1c7c [ath9k_hw]

  Code: 0000a812  0040f809  00000000 <00531024> 1054000b  24020001  0c05b5dc  2404000a  26520001

The cause of the error is that the OTP register
offsets are different on the AR9340 than the
actually used values.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -69,13 +69,13 @@
 #define AR9300_BASE_ADDR 0x3ff
 #define AR9300_BASE_ADDR_512 0x1ff
 
-#define AR9300_OTP_BASE			0x14000
-#define AR9300_OTP_STATUS		0x15f18
+#define AR9300_OTP_BASE			(AR_SREV_9340(ah) ? 0x30000 : 0x14000)
+#define AR9300_OTP_STATUS		(AR_SREV_9340(ah) ? 0x30018 : 0x15f18)
 #define AR9300_OTP_STATUS_TYPE		0x7
 #define AR9300_OTP_STATUS_VALID		0x4
 #define AR9300_OTP_STATUS_ACCESS_BUSY	0x2
 #define AR9300_OTP_STATUS_SM_BUSY	0x1
-#define AR9300_OTP_READ_DATA		0x15f1c
+#define AR9300_OTP_READ_DATA		(AR_SREV_9340(ah) ? 0x3001c : 0x15f1c)
 
 enum targetPowerHTRates {
 	HT_TARGET_RATE_0_8_16,


