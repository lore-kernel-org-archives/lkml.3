Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3EQWFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:05:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab3EQVrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 24/50] net: qmi_wwan: prevent duplicate mac address on link (firmware bug workaround)
Date: Fri, 17 May 2013 14:46:59 -0700
Message-Id: <20130517213845.257880684@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit cc6ba5fdaabea7a7b28de3ba1e0fe54d92232fe5 ]

We normally trust and use the CDC functional descriptors provided by a
number of devices.  But some of these will erroneously list the address
reserved for the device end of the link.  Attempting to use this on
both the device and host side will naturally not work.

Work around this bug by ignoring the functional descriptor and assign a
random address instead in this case.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/qmi_wwan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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
@@ -342,6 +345,12 @@ static int qmi_wwan_bind_shared(struct u
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


