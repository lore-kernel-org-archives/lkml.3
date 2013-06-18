Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab3FRLpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:45:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab3FRLp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 86/93] tg3: Wait for boot code to finish after power on
Date: Tue, 18 Jun 2013 12:43:34 +0100
Message-Id: <1371555821-12820-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 4cb0916..8a0b948 100644
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
@@ -9451,6 +9454,13 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
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
-- 
1.8.1.2

