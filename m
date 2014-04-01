Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaDAMYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:24:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42102 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaDALQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/144] mwifiex: fix cmd and Tx data timeout issue for PCIe cards
Date: Tue,  1 Apr 2014 12:13:34 +0100
Message-Id: <1396350948-29910-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

commit 1c97560f6d751a620978504a4a888c631192b71a upstream.

We are sending sleep confirm done interrupt in the middle of
sleep handshake. There is a corner case when Tx done interrupt
is received from firmware during sleep handshake due to which
host and firmware power states go out of sync causing cmd and
Tx data timeout problem.

Hence sleep confirm done interrupt is sent at the end of sleep
handshake to fix the problem.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 1662b99..801c709 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1515,6 +1515,14 @@ static int mwifiex_pcie_process_cmd_complete(struct mwifiex_adapter *adapter)
 		if (adapter->ps_state == PS_STATE_SLEEP_CFM) {
 			mwifiex_process_sleep_confirm_resp(adapter, skb->data,
 							   skb->len);
+			mwifiex_pcie_enable_host_int(adapter);
+			if (mwifiex_write_reg(adapter,
+					      PCIE_CPU_INT_EVENT,
+					      CPU_INTR_SLEEP_CFM_DONE)) {
+				dev_warn(adapter->dev,
+					 "Write register failed\n");
+				return -1;
+			}
 			while (reg->sleep_cookie && (count++ < 10) &&
 			       mwifiex_pcie_ok_to_access_hw(adapter))
 				usleep_range(50, 60);
@@ -1985,23 +1993,9 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 		adapter->int_status |= pcie_ireg;
 		spin_unlock_irqrestore(&adapter->int_lock, flags);
 
-		if (pcie_ireg & HOST_INTR_CMD_DONE) {
-			if ((adapter->ps_state == PS_STATE_SLEEP_CFM) ||
-			    (adapter->ps_state == PS_STATE_SLEEP)) {
-				mwifiex_pcie_enable_host_int(adapter);
-				if (mwifiex_write_reg(adapter,
-						      PCIE_CPU_INT_EVENT,
-						      CPU_INTR_SLEEP_CFM_DONE)
-						      ) {
-					dev_warn(adapter->dev,
-						 "Write register failed\n");
-					return;
-
-				}
-			}
-		} else if (!adapter->pps_uapsd_mode &&
-			   adapter->ps_state == PS_STATE_SLEEP &&
-			   mwifiex_pcie_ok_to_access_hw(adapter)) {
+		if (!adapter->pps_uapsd_mode &&
+		    adapter->ps_state == PS_STATE_SLEEP &&
+		    mwifiex_pcie_ok_to_access_hw(adapter)) {
 				/* Potentially for PCIe we could get other
 				 * interrupts like shared. Don't change power
 				 * state until cookie is set */
-- 
1.9.1

