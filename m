Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab3I2T3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:29:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab3I2T3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 06/71] rt2800: change initialization sequence to fix system freeze
Date: Sun, 29 Sep 2013 12:27:18 -0700
Message-Id: <20130929192643.977225655@linuxfoundation.org>
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

commit f4e1a4d3ecbb9e42bdf8e7869ee8a4ebfa27fb20 upstream.

My commit

commit c630ccf1a127578421a928489d51e99c05037054
Author: Stanislaw Gruszka <stf_xl@wp.pl>
Date:   Sat Mar 16 19:19:46 2013 +0100

    rt2800: rearrange bbp/rfcsr initialization

make Maxim machine freeze when try to start wireless device.

Initialization order and sending MCU_BOOT_SIGNAL request, changed in
above commit, is important. Doing things incorrectly make PCIe bus
problems, which can froze the machine.

This patch change initialization sequence like vendor driver do:
function NICInitializeAsic() from
2011_1007_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO (PCI devices) and
DPO_RT5572_LinuxSTA_2.6.1.3_20121022 (according Mediatek, latest driver
for RT8070/RT3070/RT3370/RT3572/RT5370/RT5372/RT5572 USB devices).
It fixes freezes on Maxim system.

Resolve:
https://bugzilla.redhat.com/show_bug.cgi?id=1000679

Reported-and-tested-by: Maxim Polyakov <polyakov@dexmalabs.com>
Bisected-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5404,19 +5404,20 @@ int rt2800_enable_radio(struct rt2x00_de
 		     rt2800_init_registers(rt2x00dev)))
 		return -EIO;
 
+	if (unlikely(rt2800_wait_bbp_rf_ready(rt2x00dev)))
+		return -EIO;
+
 	/*
 	 * Send signal to firmware during boot time.
 	 */
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
-	if (rt2x00_is_usb(rt2x00dev)) {
+	if (rt2x00_is_usb(rt2x00dev))
 		rt2800_register_write(rt2x00dev, H2M_INT_SRC, 0);
-		rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
-	}
+	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
 	msleep(1);
 
-	if (unlikely(rt2800_wait_bbp_rf_ready(rt2x00dev) ||
-		     rt2800_wait_bbp_ready(rt2x00dev)))
+	if (unlikely(rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EIO;
 
 	rt2800_init_bbp(rt2x00dev);


