Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3F1S5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41841 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3F1S46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 046/105] tg3: Wait for boot code to finish after power on
Date: Fri, 28 Jun 2013 11:51:08 -0700
Message-Id: <1372445527-24414-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 133169f..929a092 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1779,6 +1779,9 @@ static int tg3_poll_fw(struct tg3 *tp)
 	int i;
 	u32 val;
 
+	if (tg3_flag(tp, NO_FWARE_REPORTED))
+		return 0;
+
 	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5906) {
 		/* Wait up to 20ms for init done. */
 		for (i = 0; i < 200; i++) {
@@ -9901,6 +9904,13 @@ static int tg3_reset_hw(struct tg3 *tp, int reset_phy)
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

