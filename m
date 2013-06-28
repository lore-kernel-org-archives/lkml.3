Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab3F1TSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:18:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41564 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3F1Sw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 013/105] net: qmi_wwan: prevent duplicate mac address on link (firmware bug workaround)
Date: Fri, 28 Jun 2013 11:50:35 -0700
Message-Id: <1372445527-24414-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit cc6ba5fdaabea7a7b28de3ba1e0fe54d92232fe5 upstream.

We normally trust and use the CDC functional descriptors provided by a
number of devices.  But some of these will erroneously list the address
reserved for the device end of the link.  Attempting to use this on
both the device and host side will naturally not work.

Work around this bug by ignoring the functional descriptor and assign a
random address instead in this case.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 31b9d45..36cb456 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -53,6 +53,9 @@ struct qmi_wwan_state {
 	struct usb_interface *data;
 };
 
+/* default ethernet address used by the modem */
+static const u8 default_modem_addr[ETH_ALEN] = {0x02, 0x50, 0xf3};
+
 /* Make up an ethernet header if the packet doesn't have one.
  *
  * A firmware bug common among several devices cause them to send raw
@@ -314,6 +317,12 @@ next_desc:
 		usb_driver_release_interface(driver, info->data);
 	}
 
+	/* Never use the same address on both ends of the link, even
+	 * if the buggy firmware told us to.
+	 */
+	if (!compare_ether_addr(dev->net->dev_addr, default_modem_addr))
+		eth_hw_addr_random(dev->net);
+
 	/* make MAC addr easily distinguishable from an IP header */
 	if (possibly_iphdr(dev->net->dev_addr)) {
 		dev->net->dev_addr[0] |= 0x02;	/* set local assignment bit */
-- 
1.8.1.2

