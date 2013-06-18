Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab3FRQU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:20:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab3FRQS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:28 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 47/48] tg3: Wait for boot code to finish after power on
Date: Tue, 18 Jun 2013 09:18:13 -0700
Message-Id: <20130618161732.770205071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1799,6 +1799,9 @@ static int tg3_poll_fw(struct tg3 *tp)
 	int i;
 	u32 val;
 
+	if (tg3_flag(tp, NO_FWARE_REPORTED))
+		return 0;
+
 	if (tg3_flag(tp, IS_SSB_CORE)) {
 		/* We don't use firmware. */
 		return 0;
@@ -10016,6 +10019,13 @@ static int tg3_reset_hw(struct tg3 *tp,
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


