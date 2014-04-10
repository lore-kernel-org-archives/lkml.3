Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935339AbaDJDX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935131AbaDJDXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:23:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 119/134] tg3: Wait for boot code to finish after power on
Date: Wed,  9 Apr 2014 20:23:55 -0700
Message-Id: <20140410032314.578772914@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Sujir <nsujir@broadcom.com>

commit df465abfe06f7dc4f33f4a96d17f096e9e8ac917 upstream.

Some systems that don't need wake-on-lan may choose to power down the
chip on system standby. Upon resume, the power on causes the boot code
to startup and initialize the hardware. On one new platform, this is
causing the device to go into a bad state due to a race between the
driver and boot code, once every several hundred resumes. The same race
exists on open since we come up from a power on.

This patch adds a wait for boot code signature at the beginning of
tg3_init_hw() which is common to both cases. If there has not been a
power-off or the boot code has already completed, the signature will be
present and poll_fw() returns immediately. Also return immediately if
the device does not have firmware.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1631,6 +1631,9 @@ static int tg3_poll_fw(struct tg3 *tp)
 	int i;
 	u32 val;
 
+	if (tg3_flag(tp, NO_FWARE_REPORTED))
+		return 0;
+
 	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5906) {
 		/* Wait up to 20ms for init done. */
 		for (i = 0; i < 200; i++) {
@@ -9395,6 +9398,13 @@ static int tg3_reset_hw(struct tg3 *tp,
  */
 static int tg3_init_hw(struct tg3 *tp, int reset_phy)
 {
+	/* Chip may have been just powered on. If so, the boot code may still
+	 * be running initialization. Wait for it to finish to avoid races in
+	 * accessing the hardware.
+	 */
+	tg3_enable_register_access(tp);
+	tg3_poll_fw(tp);
+
 	tg3_switch_clocks(tp);
 
 	tw32(TG3PCI_MEM_WIN_BASE_ADDR, 0);


