Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3ETLCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:02:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56324 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab3ETKxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 084/115] net: qmi_wwan: prevent duplicate mac address on link (firmware bug workaround)
Date: Mon, 20 May 2013 11:51:24 +0100
Message-Id: <1369047116-9378-85-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 83a2a14..7589509 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -175,6 +175,9 @@ err:
 	return status;
 }
 
+/* default ethernet address used by the modem */
+static const u8 default_modem_addr[ETH_ALEN] = {0x02, 0x50, 0xf3};
+
 /* Make up an ethernet header if the packet doesn't have one.
  *
  * A firmware bug common among several devices cause them to send raw
@@ -342,6 +345,12 @@ static int qmi_wwan_bind_shared(struct usbnet *dev, struct usb_interface *intf)
 	/* save subdriver struct for suspend/resume wrappers */
 	dev->data[0] = (unsigned long)subdriver;
 
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

